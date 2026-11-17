---
id: shielder-halo2-verifier
title: "Shielder (Cardinal Cryptography): forged Halo2-KZG withdraw proofs can drain the privacy pool (USD 859); owner Safe can upgrade the verifiers"
project: cardinal-cryptography
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x957cc1ff4e27b400a53139516b66b6739d4905a8"
  implementation: "0x52aff19891c7d882e14353b4fc0ae25cca810812"
  name: ERC1967Proxy → Shielder
  upgradeable: "yes"
  admin: UUPS upgrade by owner() Safe 0x9dc4e0e4f6d9693e5760227469c0b8cf9a432165 (2 of 5, Ownable2Step; read at block 26,431,454)
  value_usd: 859
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-02-04
  txs_30d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: Shielder owner Safe 0x9dc4e0e4f6d9693e5760227469c0b8cf9a432165 (2 of 5) upgrades the UUPS proxy 0x957cc1ff4e27b400a53139516b66b6739d4905a8 to an implementation with post-quantum proofs; it can pause() withdrawals meanwhile
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/shielder-halo2-verifier
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review02 (registry review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/shielder-halo2-verifier/onchain-review.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Shielder is a privacy pool: deposits become notes in a Merkle tree, and `withdrawNative`/`withdrawERC20` pay out
against Halo2 proofs verified with a KZG pairing check on BN254 (PQ-7). With the KZG setup trapdoor, a quantum
attacker can forge withdraw proofs for notes that do not exist and drain the pool, which holds USD 859 (block
26,431,454). The verifiers are linked libraries of a UUPS implementation that the owner Safe (2 of 5) can upgrade, and
the owner can pause withdrawals. Rated LOW: step 4 gives MEDIUM (fix by contract upgrade), step 5 lowers it because
under USD 50k is exposed.

## Mechanism

- `Shielder.withdrawNative(...)` / `withdrawERC20(...)` (`whenNotPaused`) → `_withdraw` checks that the Merkle root
  exists and the nullifier is unused, builds the public inputs (root, old nullifier hash, new note, amount, token, hash
  of recipient/relayer/fee/chain id, MAC) and requires
  `WithdrawVerifier.verifyProof(proof, publicInputs)` (`contracts/Shielder.sol` lines 675–705), then transfers `amount`
  minus fees to `withdrawalAddress`.
- `newAccount*` and `deposit*` use `NewAccountVerifier` and `DepositVerifier` the same way (lines 372 and 521).
- Each verifier is a generated `library Halo2Verifier` whose `verifyProof(bytes, uint256[])` ends in `ec_pairing`
  (precompile 0x08) against a hard-coded G2 point from the KZG setup (e.g. `contracts/WithdrawVerifier.sol` lines
  69–2749). Linked library addresses (Sourcify compilation settings): Deposit `0x37aa4f68…`, Withdraw `0xd03dd8d2…`,
  NewAccount `0x04ebcacd…`.
- Excerpts: [`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/shielder-halo2-verifier/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify, implementation `0x52aff198…`): the path above; `_authorizeUpgrade` is
  `onlyOwner`; `pause()` is `onlyOwner` and both withdraw functions are `whenNotPaused`.
- CHECKED (on-chain read at block 26,431,454, [`onchain-review.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/shielder-halo2-verifier/onchain-review.json)):
  EIP-1967 implementation slot = `0x52aff198…`; `owner()` = Safe `0x9dc4e0e4…`, `pendingOwner()` = 0; Safe threshold 2
  of 5 owners; `paused()` = false.
- CHECKED (same block): the proxy holds 0.1254 ETH, 606.81 USDT, 25.57 USDC = USD 859 at ETH USD 1,811.62.
- CHECKED (Xatu, [`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/shielder-halo2-verifier/activity.json)): no transactions 2026-10-16 to
  2026-11-16; last 2026-02-04. 72 pre-quantum transactions in the last year (`txs_y1`,
  `studies/top-callers-classification/results/curated_contracts.csv`).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x957cc1ff…` ERC1967Proxy → Shielder | yes | $859 | 2026-02-04 | 0 |

The pool holds its own deposits, so the held value is what a forged withdraw proof releases. No other mainnet
Shielder deployment was found in the census data.

## Remediation

- Replacement: an implementation whose deposit, new-account and withdraw circuits are proven with a hash-based system
  (STARK/FRI or WHIR) instead of Halo2-KZG, deployed via `upgradeToAndCall` on the proxy; existing notes would need a
  migration circuit or a withdrawal window before the switch.
- Who acts: owner Safe `0x9dc4e0e4f6d9693e5760227469c0b8cf9a432165` (2 of 5). It can `pause()` withdrawals at once if
  the setup is threatened. No protocol change is needed.
- Users: withdraw to a post-quantum account.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review02): MEDIUM -> LOW, step 5: the pool itself holds what a forged withdraw releases, USD 859 at block 26,431,454 (under USD 50k); step 4 gives MEDIUM (UUPS upgrade by the 2-of-5 owner Safe).
