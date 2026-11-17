---
id: degate-groth16-verifier
title: "DeGate (shut down): a recovered BN254 Groth16 setup trapdoor would let forged block proofs pass the exchange's BlockVerifier; the exchange stopped in June 2025 and its deposit contract holds about $160"
project: degate
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xe3b7fe3ce0fa54c5ac7f48e7ed9e52da045be4d6"
  implementation: null
  name: BlockVerifier
  upgradeable: "no"
  admin: "owner() EOA 0xacd3a62f3eed1bfe4ff0ec8240d645c1f5477f82; verification keys hard-coded; set once as blockVerifier of exchange 0x9c07a72177c5a05410ca338823e790876e79d73b (proxy owned by Timelock 0x0d2ec0a5858730e7d49f5b4ae6f2c665e46c1d9d)"
  value_usd: 160
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2025-06-27
  txs_30d: 0
families: []
fix:
  layer: none
  who_acts: "none needed while the exchange stays shut down; a restart would need DeGate (Timelock 0x0d2ec0a5858730e7d49f5b4ae6f2c665e46c1d9d) to upgrade ExchangeV3, since the verifier cannot be repointed"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/degate-groth16-verifier/classification.jsonl
  - evidence/degate-groth16-verifier/onchain.json
  - evidence/degate-groth16-verifier/activity.json
  - evidence/degate-groth16-verifier/source-excerpts.md
  - evidence/degate-groth16-verifier/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review23 (finding review)
  ref: evidence/degate-groth16-verifier/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

`BlockVerifier` `0xe3b7fe3c…` checks Groth16 proofs on BN254 (PQ-7) for DeGate's exchange `0x9c07a721…`, a Loopring
fork. With the setup trapdoor, a block that steals balances would verify, and the deposit contract would pay out.
But the exchange is shut down (`isShutdown()` = true), its last block was submitted on 2025-06-27, more than 12 months
ago, and the deposit contract `0x54d7ae42…` holds about $160. Rated LOW (step 1): no activity in 12 months and nothing
of value held.

## Mechanism

- `ExchangeBlocks.submitBlocks` (called by the exchange owner `LoopringIOExchangeOwner` `0x9b93e47b…`) batches blocks
  and requires `blockVerifier.verifyProofs(blockType, blockSize, blockVersion, publicInputs, proofs)`; the verifier
  runs the Groth16 pairing check with hard-coded verification keys (`VerificationKeys.sol`, `Verifier.sol`).
- Verified blocks update balances and approve withdrawals that `DefaultDepositContract` `0x54d7…` pays out.
- The verifier is set once at genesis from `LoopringV3.blockVerifierAddress()`; ExchangeV3 has no function to change
  it, so only an upgrade of the exchange proxy could swap it.
- Pattern PQ-7. Excerpts: [`source-excerpts.md`](../evidence/degate-groth16-verifier/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify, ExchangeV3 `0xc56c1dfe…` bundle): `submitBlocks` → `verifyProofs`, genesis
  verifier assignment, `BlockVerifier` functions ([`notes.md`](../evidence/degate-groth16-verifier/notes.md)).
- CHECKED (on-chain read, block ~26,431,700): exchange `0x9c07…` storage `blockVerifier` = `0xe3b7fe3c…`,
  `depositContract` = `0x54d7…`; `isShutdown()` = true, `isInWithdrawalMode()` = false; BlockVerifier `owner()` =
  EOA `0xacd3a62f…`; exchange and deposit proxies owned by Timelocks `0x0d2ec0a5…` and `0xf2991507…`.
- CHECKED (Blockscout): last `submitBlocks` 2025-06-27, last exchange transaction 2025-06-28.
- CHECKED (Blockscout tokens + ETH balance): deposit contract holds $159.57 (USDC 147.9, USDT 10.0, dust).
- CHECKED (block 26,431,214): verifier holds nothing ([`onchain.json`](../evidence/degate-groth16-verifier/onchain.json)).

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xe3b7fe3c…` BlockVerifier | no | $160 escrow in DepositContract `0x54d7ae42…` | 2025-06-27 | 0 |

The escrow is DeGate's `DefaultDepositContract` `0x54d7ae423edb07282645e740c046b9373970a168` (`value_basis:
escrow`). No other DeGate deployment points at this verifier in the registry.

## Remediation

- Nothing is needed while the exchange stays shut down. If DeGate restarted it, the exchange proxy owner (Timelock
  `0x0d2ec0a5…`) would have to upgrade ExchangeV3 to a hash-based (STARK/FRI) verifier, since the verifier address
  cannot be changed.
- Remaining users can withdraw their dust balances.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1 reach: no activity in 12 months (last 2025-06-27) and nothing held).
- 2026-11-17 review (Review23): LOW kept, step 1: exchange `0x9c07…` shut down, last block 2025-06-27, escrow `0x54d7…` holds $160. Corrected `upgradeable` config-only -> no and `alternative` configurable-verifier -> sole (keys hard-coded; the exchange cannot repoint the verifier); owner read as EOA `0xacd3a62f…` (not a DAO).
