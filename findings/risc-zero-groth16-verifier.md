---
id: risc-zero-groth16-verifier
title: "RISC Zero: a quantum attacker who recovers the Groth16 setup trapdoor can forge receipts accepted by RiscZeroVerifierRouter 0x8eab2d97 for Boundless, Anoma, Taiko and other consumers"
project: risc-zero
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x2a098988600d87650fb061ffaff08b97149fa84d"
  implementation: null
  name: RiscZeroGroth16Verifier (v3.0.0, selector 0x73c457ba)
  upgradeable: config-only
  admin: none on the verifier; RiscZeroVerifierRouter 0x8eab2d97dfce405a1692a21b3ff3a172d593d319 routes 0x73c457ba to it through RiscZeroVerifierEmergencyStop 0x9f9994eb4cb5200198fefb470f8b50301662e696 (owner EOA 0xf616a4f81857cfee54a4a049ec187172574bd412 can stop it); router owner TimelockController 0x0b144e07a0826182b6b59788c34b32bfa86fb711 (3-day delay, proposer and executor EOA 0xf616a4f8…)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 1447
- address: "0x48e32efbe22e180a3ffe617f4955cd83b983dd98"
  implementation: null
  name: RiscZeroGroth16Verifier (v2.0.0, selector 0x9f39696c)
  upgradeable: "no"
  admin: none; not routed by the RISC Zero router (selector 0x9f39696c routes to a paused e-stop wrapping 0x20ff7c2c…); deployed by 0x56706f118e42ae069f20c5636141b844d1324ae1, callers unknown
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-06-03
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: RISC Zero, through TimelockController 0x0b144e07a0826182b6b59788c34b32bfa86fb711 adding a post-quantum verifier to the router and the e-stop owner 0xf616a4f81857cfee54a4a049ec187172574bd412 stopping the Groth16 route; consumers' provers must then submit receipts for the new selector
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/risc-zero-groth16-verifier/classification.jsonl
  - evidence/risc-zero-groth16-verifier/onchain.json
  - evidence/risc-zero-groth16-verifier/activity.json
  - evidence/risc-zero-groth16-verifier/source-excerpts.md
  - evidence/risc-zero-groth16-verifier/escrow.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl,out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review03 (registry review)
  ref: evidence/risc-zero-groth16-verifier/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

RISC Zero's mainnet router accepts zkVM receipts whose STARK is wrapped in a Groth16 proof on BN254, checked by
`RiscZeroGroth16Verifier` 0x2a098988 (PQ-7). A quantum attacker who recovers the setup trapdoor can forge a receipt
for any image ID and journal, and every consumer that calls the router trusts it: Boundless (PovwMint mints ZKC
rewards, PovwAccounting, the set verifier), Anoma's ProtocolAdapter (its ERC20Forwarder holds about $4.0k), Taiko's
Risc0Verifier, a Kaspa relay and two unverified contracts. The total value behind these consumers was not
measured (ZKC minting and Taiko's bridge are not bounded here). Rated MEDIUM (step 4): RISC Zero can stop the
Groth16 route and add a new verifier through its router; consumers' provers must move to the new receipt format.

## Mechanism

- `RiscZeroGroth16Verifier.verify(bytes seal, bytes32 imageId, bytes32 journalDigest)` (excerpt line 145) calls
  `_verifyIntegrity(seal, ReceiptClaimLib.ok(imageId, journalDigest).digest())`, which checks the seal's selector
  and calls `this.verifyProof(...)` (line 166) in the snarkjs-style `Groth16Verifier` (line 69) with `ecpairing`
  against the hard-coded verifying key. With the trapdoor, a seal for any claim verifies.
- Consumers call `RiscZeroVerifierRouter.verify(seal, imageId, journalDigest)` on 0x8eab2d97; the router takes the
  first 4 bytes of `seal` and forwards to `getVerifier(selector)`. Selector 0x73c457ba points at
  `RiscZeroVerifierEmergencyStop` 0x9f9994eb, which forwards to 0x2a098988 unless `estop()` has been called.
- What a forged receipt releases depends on the consumer: `PovwMint.mint(journalBytes, seal)` calls
  `VERIFIER.verify(seal, MINT_CALCULATOR_ID, sha256(journalBytes))` and then
  `TOKEN.mintPoVWRewardsForRecipient(recipient, value)` for each mint in the journal; Anoma's
  `ProtocolAdapter.execute` verifies compliance, logic and aggregation receipts through its immutable
  `_TRUSTED_RISC_ZERO_VERIFIER_ROUTER` and then executes forwarder calls that move tokens out of the ERC20Forwarder.
- 0x48e32efb is an older v2.0.0 build of the same verifier deployed by another address; the router's 0x9f39696c
  route goes to a different, paused wrapper, so it is reachable only by contracts that call it directly.

## Evidence

- CHECKED (verified source, Sourcify): both verifiers, `verify` → `_verifyIntegrity` → `verifyProof`
  ([`source-excerpts.md`](../evidence/risc-zero-groth16-verifier/source-excerpts.md)); `PovwMint.sol` and
  `ProtocolAdapter.sol` read on Blockscout for the consumer paths above.
- CHECKED (on-chain read, block 26,431,539): router `owner()` = TimelockController 0x0b144e07… with
  `getMinDelay()` = 259,200 s; `hasRole(PROPOSER_ROLE)` and `hasRole(EXECUTOR_ROLE)` true for 0xf616a4f8… (no code)
  and false for the previous holder 0x2e5bcc99…; `getVerifier(0x73c457ba)` = e-stop 0x9f9994eb (`paused()` false,
  `verifier()` 0x2a098988, `owner()` 0xf616a4f8…); `getVerifier(0x9f39696c)` = e-stop 0x68dc2cb4 (paused, wraps
  0x20ff7c2c…); `SELECTOR()`/`VERSION()` of both verifiers
  ([`escrow.json`](../evidence/risc-zero-groth16-verifier/escrow.json)).
- CHECKED (on-chain read, block 26,431,214): neither verifier is a proxy or holds anything
  ([`onchain.json`](../evidence/risc-zero-groth16-verifier/onchain.json)).
- CHECKED (Xatu call frames, 73 sampled partitions between blocks 24,700,000 and 26,423,999): all 705 sampled calls
  to 0x2a098988 came through router → e-stop; router callers listed in the table below
  ([`escrow.json`](../evidence/risc-zero-groth16-verifier/escrow.json)).
- CHECKED (Blockscout, 2026-11-17): consumer and escrow holdings.
- CHECKED (Xatu, any function): 1,447 transactions reached 0x2a098988 in 2026-10-16 to 2026-11-16; none reached
  0x48e32efb since 2026-03-18 ([`activity.json`](../evidence/risc-zero-groth16-verifier/activity.json)).
  `txs_y1` = 34,072 (0x2a098988) and 4,306 (0x48e32efb) pre-quantum calls in `curated_contracts.csv`.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x2a098988…` RiscZeroGroth16Verifier v3.0.0 | config-only (router route, e-stop) | $0; escrow not fully measured | 2026-11-15 | 1,447 |
| `0x48e32efb…` RiscZeroGroth16Verifier v2.0.0 | no | $0 | 2025-06-03 | 0 |

Router consumers seen in the sample, and what stands behind them (Blockscout, 2026-11-17):

| Consumer | What a forged receipt reaches | Measured |
|---|---|---|
| `0xbfce7c2d…` Boundless PovwMint (UUPS proxy) | ZKC reward minting | not measured |
| `0x319bd405…` Boundless PovwAccounting (ERC-1967 proxy) | work-log accounting feeding PovwMint | — |
| `0x5005aba3…` RiscZeroSetVerifier | aggregated receipts for its users | not measured |
| `0x0ea3b55b…` Anoma ProtocolAdapter | ERC20Forwarder `0x775c81a4…` | $3,974 (USDT, USDC, sUSDS, WETH, XAN) |
| `0x059daf31…` Taiko Risc0Verifier | one of Taiko's proof types (see taiko-zk-verifiers) | rated there |
| `0x6e128377…` KaspaRelayV2 | Kaspa header relay | holds $0 |
| `0x11d883d8…` unverified relay (RelayFactoryV3) | vault `0xf7a50098…` | $0.50 USDC |
| `0x920b729c…` unverified | — | holds $0 |

The measured escrows add up to about $4.0k, but ZKC minting, the set verifier's users and Taiko are not bounded, so
`value_usd` stays null and the value step lowers nothing.

## Remediation

- Post-quantum replacement: route consumers to a verifier for RISC Zero's native STARK (FRI) receipts, or another
  hash-based wrapper, under a new selector, and stop the Groth16 route with `estop()`.
- Who acts: RISC Zero, through TimelockController 0x0b144e07… (proposer/executor 0xf616a4f8…, an EOA; 3-day delay)
  for `addVerifier`, and the e-stop owner 0xf616a4f8… for `estop()`. Consumers that hold the router as an immutable
  (Anoma, PovwMint) follow automatically but their provers must produce the new receipts; Taiko's owner sets
  trusted image IDs on its own wrapper. Callers of 0x48e32efb, if any remain, must repoint themselves.
- Protocol change: not needed. The router, timelock and e-stop are themselves controlled by one ECDSA key.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review03): MEDIUM unchanged (step 4: router owner adds a new verifier, e-stop owner stops the Groth16 route; consumer value not fully measured, so step 5 does not apply). Router owner read as TimelockController 0x0b144e07… (proposer/executor EOA 0xf616a4f8…); 0x48e32efb found not routed; consumers identified from Xatu frames.
