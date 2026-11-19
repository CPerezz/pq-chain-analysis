---
id: bitget-swap-router-signer
title: "Bitget swap router 0xb141f554 (attribution from explorer label): one ECDSA signer key authorises every order, including payouts from the vault EOA; the router has been paused since 2026-11-12 and almost nothing is approved to it"
project: bitget
status: confirmed
severity: MEDIUM
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0xb141f554188cf306fde443f6e991949636f80e49"
  implementation: null
  name: unverified swap/order router (selectors signer, manageSigner, vault, safe, operator, pause, unpause, orderStatus)
  upgradeable: config-only
  admin: owner() = safe() = Safe 0x9287b8e84d972dd02f618bbed45b9a6d7ed16384 (3 of 5) via manageSigner/setOperator/setSafe; operator() = 0x5db8606f2927e7173b3cab5a4c512d9f00bbf193 (paused the contract) (read at block 26431523)
  value_usd: 2
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-12
  txs_30d: 2
families: []
fix:
  layer: new-deployment
  who_acts: Bitget (owner Safe 0x9287b8e84d972dd02f618bbed45b9a6d7ed16384, 3 of 5); keeping the router paused, or revoking the vault's approvals, removes the exposure
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/bitget-swap-router-signer
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review22)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/bitget-swap-router-signer/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Every order function of this unverified router, labelled "Bitget: Swap" on Etherscan, requires an `ecrecover` of the
order hash to equal `signer()` = EOA `0x28d50aee…`. Some of these functions pull tokens from the vault EOA
`0x11235534…` to a recipient named in the order. A quantum attacker who recovers the signer key could sign payouts
from the vault for everything the vault has approved. The operator paused the router on 2026-11-12 and swept its ETH,
and the vault's approvals now cover about $1, so almost nothing is exposed. Rated LOW (step 4: MEDIUM, new deployment;
step 5: about $2 exposed).

## Mechanism

- Traced (no verified source): user swap `0xb1a6602a…`, vault payouts `0x3dddee1f…` and `0x01bbd2e2…`, and user
  deposit `0x396fc311…` each start with `ecrecover(orderHash, v, r, s)`, which returns `0x28d50aee…` = `signer()`.
  They then call `transferFrom` from the user or from the vault EOA `0x11235534…` (= `vault()`). For example, tx
  `0x6498162c…` moved 35,891 USDT from the vault to `0x6a62e6f9…`. PQ-4: one operator key authorises the transfer of
  value.
- `manageSigner(address)` (owner) only replaces the ECDSA signer address. The scheme is fixed in the bytecode; there is
  no proxy.
- `pause()` and `unpause()` exist. `paused()` = true since tx `0x64139d14…` (2026-11-12, sent by `operator()`
  `0x5db8606f…`), followed by `rescueETH` to the owner Safe.

## Evidence

- CHECKED (bytecode selectors; `cast run` traces of txs `0x6353016f…`, `0x6498162c…`, `0xdfa1fd3e…`, `0x4b892a74…`): the
  `ecrecover` == `signer()` check before each transfer
  ([`review-reads.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/bitget-swap-router-signer/review-reads.json)).
- CHECKED (RPC at block 26,431,523): `signer()` = `0x28d50aee…` (EOA); `owner()` = `safe()` = Safe `0x9287b8e8…`
  (threshold 3; owners `0xba430e78…`, `0xc7f81b58…`, `0xa52bb0be…`, `0xbd5bbf1e…`, `0x27f05308…`); `operator()` =
  `0x5db8606f…` (proxy contract); `vault()` = `0x11235534…` (EOA); `paused()` = true; no EIP-1967 implementation.
- CHECKED (allowances and balances via RPC; Blockscout token balances): the vault has given an unlimited USDT approval
  but holds 0.59 USDT; it holds $1,050 USDC with 0 approval and 0.006 ETH. The router holds about $1 in dust tokens.
- CHECKED (Blockscout): created 2025-07-30 by EOA `0x8bce4b09…` through factory `0xd7061474…`.
- CHECKED (Xatu): 1,842 transactions since block 24,700,000; 2 in 2026-10-16 to 2026-11-16 (pause and rescue). There
  were 114,826 pre-quantum calls in the year to March 2026 (`curated_contracts.csv` `txs_y1`).
- INFERRED: the attribution to Bitget rests on Etherscan's public name tag ("Bitget: Swap"; the ETH leg goes to
  `0x47ebcf27…`, tagged "Bitget: Swap 2"), not on verified source. Which roles may call `unpause` was not established
  from bytecode. Approvals that users left to the router were not measured.

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0xb141f554…` router | config-only (signer, operator, safe) | $2 (escrow: vault approvals + router dust) | 2026-11-12 | 2 |

While the router is paused, a forged signer alone cannot act; it would also need the owner Safe or the operator to
unpause. Grouping: if the label is right, this belongs to Bitget's swap infrastructure; the `id` is kept.

## Remediation

- Keep the router paused (or have the vault revoke its approvals) until retirement. Any successor should verify order
  approvals with a post-quantum signature (an ERC-7913 verifier or an ERC-1271 signer contract), not
  `ecrecover == signer`.
- The owner Safe's 3-of-5 ECDSA owners and the vault EOA are separate PQ-12 exposures of the same operator.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review22): MEDIUM -> LOW, step 5: exposure measured as escrow (vault approvals and router dust, about $2); the router has been paused since 2026-11-12. Status candidate -> confirmed (`ecrecover` == `signer()` seen in traces; state read). Project set to bitget from the Etherscan public name tag (id kept).
- 2026-11-17 integration: id renamed from `unidentified-b141f554-signer-key` (project identified).
- 2026-11-19: LOW -> MEDIUM, step 5 removed (value no longer lowers a rating); step 4 gives MEDIUM.

# Source excerpts: bitget-swap-router-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xb141f554188cf306fde443f6e991949636f80e49`

No verified source on Sourcify or Blockscout.
