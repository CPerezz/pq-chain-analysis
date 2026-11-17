---
id: megaeth-sale-permit-signer
title: "MegaETH token sale (MegaSale): a recovered Sonar permit-signer key would let any wallet bid without KYC or allocation limits; the auction is closed and nothing can be taken"
project: megaeth
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: none
alternative: key-rotation-only
role: core
contracts:
- address: "0xab02bf85a7a851b6a379ea3d5bd3b9b4f5dd8461"
  implementation: null
  name: MegaSale
  upgradeable: config-only
  admin: DEFAULT_ADMIN_ROLE Safe 0xcb264def50d166d4ae7cf60188ec0038819fb719 (4 of 6); PURCHASE_PERMIT_SIGNER_ROLE EOA 0x9a1964e04d10ccfe1a9ce300d943f71c6e3ae24c
  value_usd: 20
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-09-16
  txs_30d: 0
families: []
fix:
  layer: none
  who_acts: "MegaETH: DEFAULT_ADMIN_ROLE Safe 0xcb264def50d166d4ae7cf60188ec0038819fb719 keeps the sale in stage Done (or revokes PURCHASE_PERMIT_SIGNER_ROLE from 0x9a1964e04d10ccfe1a9ce300d943f71c6e3ae24c); a future sale needs a contract that verifies a post-quantum permit signer"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/megaeth-sale-permit-signer/classification.jsonl
  - evidence/megaeth-sale-permit-signer/onchain.json
  - evidence/megaeth-sale-permit-signer/activity.json
  - evidence/megaeth-sale-permit-signer/source-excerpts.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review14 (MegaSale source, stage and role reads)
  ref: Sourcify source of 0xab02bf85 and cast reads at block 26,431,595 (Evidence section)
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

MegaSale ran MegaETH's USDT auction; each bid needed a purchase permit signed by Sonar's permit-signer key (ECDSA). With
that key a quantum attacker could let any wallet bid, skipping KYC and the per-entity caps and price limits, but the
bidder still pays its own USDT, so nothing is taken from others. The sale is in stage `Done`, the bid path is closed,
and the contract holds USD 20. Rated LOW (step 4: the check guards a path through which nothing can be taken, now
dormant).

## Mechanism

- `replaceBidWithApproval(bid, purchasePermit, signature)` is `onlyStage(Stage.Auction)`; `_processBid` →
  `_validatePurchasePermit`: checks `saleUUID`, expiry, `permit.wallet == msg.sender`, then
  `PurchasePermitWithAllocationLib.recoverSigner(permit, signature)` (`ECDSA.recover` over
  `toEthSignedMessageHash(abi.encode(permit))`) must hold `PURCHASE_PERMIT_SIGNER_ROLE` (MegaSale.sol lines 440–460).
- The permit sets `minAmount`, `maxAmount`, `maxPrice` and `forcedLockup`; the bid's USDT is pulled from `msg.sender`
  with `usdt.safeTransferFrom`. Refunds and withdrawals (`processRefunds`, `withdraw`) do not use the signer.
- The signer can only be replaced by another ECDSA key (role grant). Pattern PQ-4.

## Evidence

- CHECKED (Sourcify verified source, read 2026-11-17): the functions above
  ([`source-excerpts.md`](../evidence/megaeth-sale-permit-signer/source-excerpts.md)).
- CHECKED (cast via eth.drpc.org at block 26,431,595): `stage()` = 5 (`Done`), `paused()` = false;
  `getRoleMember(DEFAULT_ADMIN_ROLE, 0)` = Safe `0xcb26…b719` (threshold 4, 6 owners); `getRoleMember(
  PURCHASE_PERMIT_SIGNER_ROLE, 0)` = `0x9a19…e24c` (no code); USDT balance 19.83.
- CHECKED (precompile trace): 60,788 `ecrecover` calls, blocks 23,668,932–23,690,360 (2025-10-27 to 2025-10-30).
- CHECKED (Xatu, any function): last transaction 2026-09-16, none in 2026-10-16 to 2026-11-16
  ([`activity.json`](../evidence/megaeth-sale-permit-signer/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xab02bf85…` MegaSale | config-only (roles, stage) | USD 20 | 2026-09-16 | 0 |

A forged permit only admits a bid paid by the attacker. Reopening the path needs the admin Safe to call
`setManualStage(Auction)`.

## Remediation

- Keep the sale in `Done` or revoke `PURCHASE_PERMIT_SIGNER_ROLE`; nothing else is needed for this contract.
- Future sales: verify permits from a post-quantum signer (ERC-7913 verifier) or use an on-chain allowlist / Merkle
  root. No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review14): MEDIUM -> LOW, step 4: a forged permit only admits a bid the attacker pays for (impact funds-loss -> none), and the auction stage is closed (`stage()` = Done).
