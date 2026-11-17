---
id: zkgarden-groth16-verifier
title: "zkGarden (inferred) shielded pool 0x31981405: a recovered BN254 Groth16 setup trapdoor lets a quantum attacker forge withdrawal proofs and drain the pool ($30 of test-sized DAI deposits)"
project: zkgarden
status: candidate
severity: LOW
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x319814051b9520ddd58a8269362f1e283866441a"
  implementation: "0x32504034b3622d1459e9d5d55d93c2439ac17ea1"
  name: PausableUpgradableProxy (shielded pool; implementation unverified)
  upgradeable: "yes"
  admin: "EIP-1967 admin 0x7288b0132bbfce7eaa7361330319e1ec7a859059 (unverified), owner() EOA 0x0105290a57f8c700a4d14ce0b4155b7bcab8789c; read at block 26431624"
  value_usd: 30
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-05-03
  txs_30d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: "deployer/owner EOA 0x0105290a57f8c700a4d14ce0b4155b7bcab8789c upgrades the implementation through admin 0x7288b0132bbfce7eaa7361330319e1ec7a859059 (or pauses the pool)"
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zkgarden-groth16-verifier
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review23 (finding review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zkgarden-groth16-verifier/notes.md
  date: 2026-11-17
  verdict: reported
  rating: LOW
related: []
---

## Summary

`0x31981405…` is a small shielded pool (Railgun-style `PausableUpgradableProxy` in front of an unverified
implementation) that verifies Groth16 proofs on BN254 (PQ-7). A quantum attacker who recovers the trapdoor of its
trusted setup can prove a false spend and withdraw what the pool holds: $30 of DAI on 2026-11-17, from a handful of
test-sized deposits; it was last used on 2026-05-03. The owner, a single EOA, can upgrade the implementation. Rated
LOW: MEDIUM by the fix (step 4, an upgrade by one owner), lowered one level for under $50k exposed (step 5). The
operator is most likely the team behind `ZkGardenPriceOracle` (same deployer); not confirmed.

## Mechanism

- Users call the proxy (`0xa495f6a1` and `0x032e0530`, both taking arrays of proof tuples); the implementation checks
  each Groth16 proof against a stored verification key with BN254 pairings and then moves the pool's tokens. The pool
  holds deposits itself (DAI transfers in and out of `0x31981405…`).
- The owner has set 20+ verification keys (`setVerificationKey`, May 2025). Changing keys does not help: any key from
  a pairing-based setup is forgeable with a CRQC; the implementation must change to a hash-based proof system.
- Implementation source is not verified; the mechanism is read from bytecode (BN254 base- and scalar-field constants,
  proof-tuple selectors) and the census precompile trace (BN254 calls from this proxy). Pattern PQ-7.

## Evidence

- CHECKED (verified source, Sourcify): the proxy is `src/proxy/PausableProxy.sol:PausableUpgradableProxy`.
- CHECKED (on-chain read, block 26,431,624): implementation `0x32504034…`, admin `0x7288b013…`, whose `owner()` is
  EOA `0x0105290a…` ([`notes.md`](#review-notes-review23-2026-11-17)).
- CHECKED (bytecode): implementation contains both BN254 moduli; selectors listed in notes.
- CHECKED (precompile trace, all mainnet transactions to March 2026): BN254 precompile calls.
- CHECKED (on-chain read, block 26,431,214): holds $30 (DAI, USDS)
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zkgarden-groth16-verifier/onchain.json)).
- CHECKED (Blockscout): 113 transactions in total, last 2026-05-03; deposits and withdrawals of 0.1–13 DAI.
- INFERRED: that the implementation's user functions gate withdrawals on the proof (bytecode, unverified), and the
  zkGarden attribution (same deployer deployed verified `ZkGardenPriceOracle` `0x429df520…` on 2025-05-09).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x31981405…` PausableUpgradableProxy (shielded pool) | yes (owner EOA) | $30 (held; the pool is its own escrow) | 2026-05-03 | 0 |

The pool keeps deposits in the proxy, so its holdings are the exposure. The deployer's second
`PausableUpgradableProxy` (`0x48894a2a…`) fronts the price oracle and holds nothing; no other pool by this deployer
was found.

## Remediation

- The owner EOA `0x0105290a…` upgrades the implementation (through admin `0x7288b013…`) to a hash-based proof system
  (STARK/FRI or similar) with matching circuits, or pauses and retires the pool.
- Depositors can withdraw their funds now; nothing else is needed from them.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review23): MEDIUM -> LOW, step 5: the pool holds its own deposits, $30 measured (under $50k); step 4 alone gives MEDIUM (upgrade by one owner EOA). Project set to zkgarden (inferred from the deployer's verified `ZkGardenPriceOracle`); status stays candidate (implementation unverified).
- 2026-11-17 integration: id renamed from `unidentified-31981405-snark-verifier` (project identified).

# Source excerpts: zkgarden-groth16-verifier

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x319814051b9520ddd58a8269362f1e283866441a` — PausableUpgradableProxy (verified source via sourcify)

## Implementation `0x32504034b3622d1459e9d5d55d93c2439ac17ea1`

No verified source on Sourcify or Blockscout.

# Review notes (Review23, 2026-11-17)

Reads at block 26,431,624 (https://ethereum-rpc.publicnode.com):

- Proxy `0x319814051b9520ddd58a8269362f1e283866441a` (verified: `src/proxy/PausableProxy.sol:PausableUpgradableProxy`):
  EIP-1967 implementation = `0x32504034b3622d1459e9d5d55d93c2439ac17ea1` (unverified, 22,467 bytes);
  EIP-1967 admin = `0x7288b0132bbfce7eaa7361330319e1ec7a859059` (unverified); `0x7288b013….owner()` =
  `0x0105290a57f8c700a4d14ce0b4155b7bcab8789c`, no code (EOA, nonce 104).
- Implementation bytecode contains the BN254 base-field modulus `0x30644e72…fd47` and scalar-field modulus
  `0x30644e72…0001`; 34 selectors (none resolve to Railgun's verified names; `0xa495f6a1` and `0x032e0530` take
  arrays of proof tuples and are the user entry points seen in transactions). The census precompile trace shows the
  proxy calling BN254 precompiles.
- Holdings: $30 (DAI 29, USDS 1, block 26,431,214, onchain.json). Token transfers (Blockscout): DAI deposits and
  withdrawals of 0.1–13 DAI from a handful of EOAs (2025-12-01 and 2026-05-02/03); the pool holds deposits itself.
- Activity: 113 transactions in total (Blockscout counters); last 2026-05-03.

Attribution (INFERRED): the deployer/owner EOA `0x0105290a…` deployed, in the same session (2025-05-09), a verified
`ZkGardenPriceOracle` (`0x429df520c0eb7a96b7afbb07c2bf4d64918694ba`) behind a second PausableUpgradableProxy
(`0x48894a2ab926797e1e602ecfdf25b5b70d6a34e1`, holds nothing, `addTokenV3/V4` calls = oracle configuration) and
whitelist contracts `0x5c926a47…`, and set 20+ verification keys (`setVerificationKey`) on this pool in May 2025.
The same team ("zkGarden") is the most likely operator; no public project page was found.
