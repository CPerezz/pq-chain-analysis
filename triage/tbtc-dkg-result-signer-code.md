---
id: tbtc-dkg-result-signer-code
title: "tBTC v2: under EIP-8151 a DKG result signed by an operator whose address has code is rejected and its honest submitter slashed"
project: tbtc
status: confirmed
severity: LOW
patterns: [PQ-15]
impact: liveness
contracts:
- address: "0x46d52e41c2f300bc82217ce22b920c34995204eb"
  implementation: "0x14fad0c11c83ac736e5929d5661bba7e6bb9c0d6"
  name: WalletRegistry (EIP-1967 proxy, implementation V2.1)
  upgradeable: "yes"
  admin: "ProxyAdmin 0x7affa05f726d293eb1193807a91617318292008e; governance Safe 0x9f6e831c8f8939dc0c830c6e492e7cef4f9c2f5f"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-14
  txs_30d: 4
- address: "0x1a5f4f753bd071c907714aefb6e0bcee32401406"
  implementation: null
  name: EcdsaDkgValidator (the one in use at the pinned block)
  upgradeable: "no"
  admin: "none; the registry can be pointed to another validator by upgrade"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
families: []
fix:
  layer: offchain
  who_acts: "operator client maintainers (keep-core): drop signatures of members whose address has code before submitting"
evidence:
  level: executed
  block: 26438999
  raw: null
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (verified source and state read, run on the exact engine; not reviewed by a person)"
  ref: "studies/eip-8151-impact, family c7877dc4"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
reviews: []
---

## Summary

The registry re-checks DKG members' signatures at challenge and approval. Under EIP-8151 a member whose operator
address has code makes the honest result invalid: approval rejects it and anyone can challenge it, slashing the
submitter. Nothing moves today (`seize` only emits an event); liveness until clients drop such signatures.

## Mechanism

PQ-15. `EcdsaDkg.isResultValid` (try/catch around the validator) → `rejectResultAtApproval`;
`WalletRegistry._punishMaliciousDkgResultSubmitter` → `staking.seize(400 T)`. A member can sign, then migrate within
the 11,520-block challenge period.

## Evidence

- Validator `0x1a5f4f75…` (Sourcify exact match) L289–297: `tryRecover`, `return false` on any mismatch; ≥51 of
  100 signatures needed.
- TokenStaking implementation `0x5a444db12705706bd7b24393f823f3a8c67d71fb`, `seize` (L486–498): emits
  `NotificationReceived` only.
- Executed (exact engine, one byte of code at operator `0xb71c49e11048bf3d2bc0bab81252334295dee012`, 3 seats), on
  the last real result: approval `0xdad127784152301e0be04a5d5bd40d676ab85f4a707331f0b82bd2323d9eab28` reverts; a
  challenge or an approval sent by an outsider succeeds with `DkgMaliciousResultSlashed(400 T, submitter)`. Without
  the code: approval succeeds and the challenge reverts ("unjustified challenge"), as on chain.

## Impact and exposure

No value held; it gates tBTC wallet creation (about two rounds a month). If slashing is restored, each rejected
result costs its honest submitter up to 400 T.

## Remediation

Client: leave out signatures of members whose address has code. Operators: rotate to a fresh address instead of
putting code at the signing one.

## History

- 2026-11-19: reported from study `eip-8151-impact`.
- 2026-11-19: moved to `triage/`; rating unchanged: the registry is upgradeable and nothing moves.
