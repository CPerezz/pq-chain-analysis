---
id: tornado-groth16-verifier
title: "Tornado Cash: a quantum attacker who recovers the Groth16 setup trapdoor can forge withdraw proofs and drain all 19 classic pools (about $577M) through Verifier 0xce172ce1"
project: tornado-cash
status: confirmed
severity: CRITICAL
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xce172ce1f20ec0b3728c9965470eaf994a03557a"
  implementation: null
  name: Verifier
  upgradeable: "no"
  admin: none (no proxy, no owner; the 19 pools hold it as `verifier`, immutable or behind an operator set to 0x0)
  value_usd: 577264563
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 7048
families: []
fix:
  layer: new-deployment
  who_acts: nobody can change the pools; each depositor must withdraw with a valid note before a CRQC exists, and new pools would need a post-quantum proof system
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/tornado-groth16-verifier/classification.jsonl
  - evidence/tornado-groth16-verifier/onchain.json
  - evidence/tornado-groth16-verifier/activity.json
  - evidence/tornado-groth16-verifier/source-excerpts.md
  - evidence/tornado-groth16-verifier/escrow.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review03 (registry review)
  ref: evidence/tornado-groth16-verifier/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: CRITICAL
related: []
---

## Summary

Every classic Tornado Cash pool (4 ETH, 4 DAI, 4 cDAI, 2 USDC, 2 USDT, 3 WBTC) releases its fixed denomination to
whoever presents a Groth16 proof that `Verifier` 0xce172ce1 accepts (PQ-7). A quantum attacker who recovers the
trapdoor of the BN254 trusted setup from the verifying key can forge proofs for unspent nullifiers and empty every
pool: about $577M at block 26,431,528, of which $564M is the 310,260 ETH in the ETH pools. Rated CRITICAL (step 4): pooled
funds are released by a forged proof, the pools are immutable with no operator, and the many anonymous depositors
cannot all move.

## Mechanism

- Each pool's `withdraw(bytes _proof, bytes32 _root, bytes32 _nullifierHash, address _recipient, address _relayer,
  uint256 _fee, uint256 _refund)` checks the nullifier is unspent and the root known, then
  `require(verifier.verifyProof(_proof, [root, nullifierHash, recipient, relayer, fee, refund]))`, marks the
  nullifier spent and calls `_processWithdraw`, which sends `denomination` to `_recipient` (verified source of
  `TornadoCash_eth` 0xa160cd…, solc 0.5.11).
- `Verifier.verifyProof(bytes proof, uint256[6] input)` (excerpt lines 187–220) builds `vk_x` from the hard-coded
  `IC` points with `ecadd`/`ecmul` (precompiles 6 and 7) and runs the pairing check (precompile 8) against the
  hard-coded `alfa1`, `beta2`, `gamma2`, `delta2` (lines 168–181). Whoever knows the setup trapdoor can produce a proof
  for any public input, so any nullifier hash not yet spent can be withdrawn to any recipient.
- No other check guards the funds: the Merkle root only has to be one of the recent known roots, which are public.

## Evidence

- CHECKED (verified source, Sourcify): `Verifier.sol` Groth16 verifier with hard-coded verifying key
  ([`source-excerpts.md`](../evidence/tornado-groth16-verifier/source-excerpts.md)).
- CHECKED (verified source, Blockscout): `TornadoCash_eth` 0xa160cd… `withdraw` calls `verifier.verifyProof`;
  `verifier` is a storage variable changeable only through `updateVerifier` by `operator`. `ERC20Tornado` 0x23773e…
  and 0xbb93e5… (solc 0.7.6) declare `IVerifier public immutable verifier` with no update function.
- CHECKED (on-chain read, block 26,431,528): InstanceRegistry 0xb20c66c4… `getAllInstanceAddresses()` returns 19
  pools; `verifier()` of every one is 0xce172ce1…; `operator()` returns 0x0 on the 11 pools that have it and reverts
  on the 8 that do not; EIP-1967 implementation and admin slots are empty on all 19; balances and DefiLlama prices
  ([`escrow.json`](../evidence/tornado-groth16-verifier/escrow.json)).
- CHECKED (on-chain read, block 26,431,214): the verifier is not a proxy and has no owner and no holdings
  ([`onchain.json`](../evidence/tornado-groth16-verifier/onchain.json)).
- CHECKED (Xatu call frames, 72 sampled partitions between blocks 24,700,000 and 26,423,999): every contract that
  called the verifier is one of the registry pools ([`escrow.json`](../evidence/tornado-groth16-verifier/escrow.json)).
- CHECKED (Xatu, any function): 7,048 transactions reached the verifier in 2026-10-16 to 2026-11-16, last on
  2026-11-16 ([`activity.json`](../evidence/tornado-groth16-verifier/activity.json)); the yearly pre-quantum count in
  `curated_contracts.csv` is `txs_y1` = 52,703 calls.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xce172ce1…` Verifier | no | $0 (escrow: $577.3M in the 19 pools) | 2026-11-16 | 7,048 |

Escrow (the pools that call the verifier), block 26,431,528, DefiLlama prices at that time:

| Asset | Pools (denominations) | Held | USD |
|---|---|---|---|
| ETH | 0x12d66f… 0.1, 0x47ce0c… 1, 0x910cbd… 10, 0xa160cd… 100 | 310,259.9 ETH | $563.7M |
| DAI | 0xd4b88d… 100, 0xfd8610… 1k, 0x07687e… 10k, 0x23773e… 100k | 8,065,400 DAI | $8.06M |
| WBTC | 0x178169… 0.1, 0x610b71… 1, 0xbb93e5… 10 | 83.3 WBTC | $5.38M |
| USDT | 0x169ad2… 100, 0x083622… 1k | 40,403 USDT | $40.4k |
| USDC | 0xd96f2b… 100, 0x4736dc… 1k | 30,600 USDC | $30.6k |
| cDAI | 0x22aaa7… 5k, 0x03893a… 50k, 0x2717c5… 500k, 0xd21be7… 5M | 1,010,000 cDAI | $25.3k |

The 100 ETH pool alone holds $510.7M. The ETH and DAI/USDC/USDT 100/1k pools have the operator-controlled verifier
slot, but their operator is 0x0, so it can no longer be changed. Tornado governance (TORN) controls the router and
registry, not the pools.

## Remediation

- Post-quantum replacement: new pools whose withdraw proof uses a hash-based proof system (STARK/FRI or similar) and
  a hash-only commitment tree. That does not protect the existing pools: their verifier cannot be changed by anyone.
- Who acts: each depositor, by withdrawing with their note (to a fresh address) before a CRQC exists. Notes that are
  lost or never withdrawn stay forgeable. Tornado governance can only steer new deposits (router, UI) to new pools.
- Protocol change: none would help here; the pools have no account key to protect, and only the setup trapdoor
  is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated CRITICAL (step 4: pooled funds released by a forged proof or attestation, and the verification cannot change).
- 2026-11-17 review (Review03): CRITICAL unchanged (step 4). Escrow measured: 19 registry pools, all pointing at this verifier, $577.3M at block 26,431,528; operators 0x0 or absent, verifier immutable; callers checked in Xatu.
