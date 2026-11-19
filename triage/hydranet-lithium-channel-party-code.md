---
id: hydranet-lithium-channel-party-code
title: "Lithium payment channels: under EIP-8151 a channel whose party has code can no longer be updated or settled"
project: hydranet
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-locked
contracts:
- address: "0xcc4c47cf0175aa8108e78679c2586a0a6abb242a"
  implementation: null
  name: Lithium (Hydranet, Sourcify)
  upgradeable: "no"
  admin: "none: no owner, no proxy"
  value_usd: 12359
  value_basis: held
  value_as_of: 2026-11-18
  last_active: 2026-11-18
  txs_30d: 226
families: []
fix:
  layer: new-deployment
  who_acts: "Hydranet: accept ERC-1271 from a party; until then close channels before a party migrates"
evidence:
  level: executed
  block: 26438999
  raw: null
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (verified source and state read, replayed on the exact engine; not reviewed by a person)"
  ref: "studies/eip-8151-impact, family c3b241e8"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

Every state that moves channel money needs both parties' ECDSA signatures, checked when submitted. Under
EIP-8151, once one party's address has code no state verifies: both balances stay locked. Immutable.

## Mechanism

PQ-15. `LithiumVerification.verifyAssetChannelStateSignatures` (OpenZeppelin `ECDSA.recover`, reverts on no
address) guards `updateChannel`, `unilateralSettleChannel` and the dispute override; `penalizeRevokedChannel` needs
the revoker's signature too. Read, not executed: a party that opens a dispute with an old state and then migrates
can be neither overridden nor penalised.

## Evidence

- Verified source (Sourcify) `src/libraries/LithiumVerification.sol` L57–62: `ECDSA.recover(...) != alice` /
  `!= bob` revert.
- Executed (exact engine, 300,000 gas added because both senders' limits were already too tight under the EIP):
  updates `0x5c9d200171ba634ec878f8481a311a42b452742aba30ec3de9f48b761fc52e9b` (block 26,401,193) and
  `0x9278bf51b908461e2d432b6d0bf2550517f0d0cc437eed3feb4190c9dc9026ea` (block 26,409,235) succeed as on chain;
  with code at the counterparty both revert.

## Impact and exposure

5.40 ETH and 2,614.67 USDC held at block 26,438,999 (USD 12,359); 226 transactions in 30 days.

## Remediation

New deployment. Until then: close channels cooperatively before migrating a channel address.

## History

- 2026-11-19: reported from study `eip-8151-impact`.
- 2026-11-19: moved to `triage/`; proposed rating LOW → CRITICAL: value and activity no longer lower a rating.
