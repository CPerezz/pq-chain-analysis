---
id: airswap-v4-maker-sig-ecdsa-only
title: "AirSwap SwapERC20 v4 (0xd82fa167, dormant): a quantum attacker who recovers a maker's ECDSA key can sign orders that spend any approvals makers left on it"
project: airswap
status: confirmed
severity: LOW
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xd82fa167727a4dc6d6f55830a2c47abbb4b3a0f8"
  implementation: null
  name: SwapERC20 (v4)
  upgradeable: "no"
  admin: "owner Safe 0xf8bb149f9525875fa47b8cc632d368eb600faba3 (2 of 3, block 26431214): fee, rebate and staking settings only; no upgrade path"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-11-17
  txs_30d: 0
families: []
fix:
  layer: account-migration
  who_acts: "makers revoke token approvals to 0xd82fa167 (the contract cannot change; AirSwap has moved to SwapERC20 0xd82e10b9)"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/airswap-v4-maker-sig-ecdsa-only/classification.jsonl
  - evidence/airswap-v4-maker-sig-ecdsa-only/onchain.json
  - evidence/airswap-v4-maker-sig-ecdsa-only/activity.json
  - evidence/airswap-v4-maker-sig-ecdsa-only/source-excerpts.md
  - evidence/airswap-v4-maker-sig-ecdsa-only/review-notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review17 (full Sourcify source and on-chain reads)
  ref: evidence/airswap-v4-maker-sig-ecdsa-only/review-notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [airswap-maker-sig-ecdsa-first]
---

## Summary

The older AirSwap SwapERC20 (v4) accepts a maker's order only if `ecrecover` returns the maker or the maker's
registered delegate, then pulls the maker's tokens with `transferFrom`. A quantum attacker who recovers a maker's
secp256k1 key could sign orders that spend any allowance the maker left on this contract; a post-quantum maker cannot
use it at all. The contract is immutable, holds nothing, and its order path has not been used since 2025-09-17, so the
rating is LOW (step 1: dormant and holds nothing).

## Mechanism

- `swap`, `swapAnySender` and `swapLight` verify the order with `ECDSA.tryRecover(orderHash, v, r, s)` (`_check`,
  `contracts/SwapERC20.sol` 648-699; `swapLight` 236-330). The result must equal `authorized[signerWallet]` if the maker
  set a delegate with `authorize()`, else `signerWallet`. There is no ERC-1271 path (PQ-1).
- On success `IERC20(signerToken).safeTransferFrom(signerWallet, recipient, signerAmount)` moves the maker's tokens.
- The signer is the maker (an end user or market maker), not a protocol operator: the draft's PQ-4/operator-key
  classification was wrong.

## Evidence

- CHECKED (Sourcify full source, 2026-11-17): `_check`, `swapLight`, the `safeTransferFrom` calls and the owner-only
  setters ([`review-notes.md`](../evidence/airswap-v4-maker-sig-ecdsa-only/review-notes.md),
  [`source-excerpts.md`](../evidence/airswap-v4-maker-sig-ecdsa-only/source-excerpts.md)).
- CHECKED (on-chain read at block 26,431,214): no proxy; `owner()` = Safe `0xf8bb149f…` (2 of 3); ETH 0, tokens $0
  ([`onchain.json`](../evidence/airswap-v4-maker-sig-ecdsa-only/onchain.json)).
- CHECKED (precompile trace and Xatu): last `ecrecover` use 2025-09-17; no transactions 2026-10-16 to 2026-11-16
  ([`activity.json`](../evidence/airswap-v4-maker-sig-ecdsa-only/activity.json)).
- CHECKED (Blockscout transaction list, 2026-11-17): last direct call `cancel` on 2025-11-17, last `swap` 2025-07-16.
- CHECKED (`data/report/curated_contracts.csv`): 20,820 `ecrecover` transactions in the yearly window (`txs_y1`),
  $0.99M transferred in them (`usd_tx_y1`); that window ends before the 12 months used in step 1.
- INFERRED: some makers may still have allowances to this contract; not measured.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xd82fa167…` SwapERC20 (v4) | no | $0 | 2025-11-17 (`cancel`); order path 2025-09-17 | 0 |

The exposure is makers' remaining allowances to `0xd82fa167…`, which were not measured. The current SwapERC20
`0xd82e10b9…` is in [`airswap-maker-sig-ecdsa-first`](airswap-maker-sig-ecdsa-first.md).

## Remediation

- Nothing on this contract can change. Makers who ever traded on it revoke token approvals to `0xd82fa167…`; AirSwap
  can point its makers at that step and remove the contract from its tooling.
- The post-quantum replacement belongs in the current SwapERC20 (see the related finding).

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1 reach: no activity in 12 months (last 2025-09-17) and nothing held).
- 2026-11-17 review (Review17): LOW kept, step 1: order path unused since 2025-09-17 and nothing held. Pattern corrected from PQ-4 (operator key) to PQ-1 (the signer is the maker; ECDSA only); trigger user-key; fix layer account-migration (makers revoke approvals).
