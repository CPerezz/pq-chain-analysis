---
id: thirdweb-paymaster-signer
title: "thirdweb (inferred) Shielded verifying paymasters: a quantum attacker who recovers the sponsorship signer key can spend the paymasters' EntryPoint gas deposits (≈ $430)"
project: thirdweb
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x6442f4729ee8c890d310ef92845d43184a12ee6a"
  implementation: null
  name: ShieldedVerifyingPaymasterV6
  upgradeable: config-only
  admin: owner 0x6dd80d80dad8a7b687ac4d3bfde4cbd85954fc01 (EOA; signers and bundler allowlist)
  value_usd: 176
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 11878
- address: "0x5fa66dfe8a3983e55071e8c4631ab43b5f33a4ab"
  implementation: null
  name: ShieldedVerifyingPaymasterV7
  upgradeable: config-only
  admin: owner 0x6dd80d80dad8a7b687ac4d3bfde4cbd85954fc01 (EOA; signers and bundler allowlist)
  value_usd: 254
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 134
families: []
fix:
  layer: new-deployment
  who_acts: the paymasters' operator (inferred thirdweb; owner 0x6dd80d80dad8a7b687ac4d3bfde4cbd85954fc01) deploys paymasters that verify sponsorship through ERC-1271 or a post-quantum scheme and moves its deposits
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/thirdweb-paymaster-signer/classification.jsonl
  - evidence/thirdweb-paymaster-signer/onchain.json
  - evidence/thirdweb-paymaster-signer/activity.json
  - evidence/thirdweb-paymaster-signer/source-excerpts.md
  - evidence/thirdweb-paymaster-signer/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl,out_3.jsonl,out_4.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review07 (registry review)
  ref: evidence/thirdweb-paymaster-signer/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [thirdweb-signature-mint-signer]
---

## Summary

Two ERC-4337 verifying paymasters, `ShieldedVerifyingPaymasterV6` and `V7`, sponsor a user operation when it carries
an ECDSA signature from a key in their `signers` set (PQ-4). A quantum attacker who recovers that key (its public key
follows from any sponsored operation) can sponsor its own operations and spend the paymasters' EntryPoint deposits as
gas, collected by a bundler it runs (the signed config can allow any bundler). The deposits are ≈ $430
(2026-11-17). The operator is inferred to be thirdweb. Rated LOW: a fix by new deployment (MEDIUM, step 4), lowered
for under $50k exposed (step 5).

## Mechanism

`ShieldedVerifyingPaymasterV6._validatePaymasterUserOp` parses `(allowAllBundlers, validUntil, validAfter, extraData,
signature)` from `paymasterAndData`, enforces the bundler allowlist unless `allowAllBundlers` is set, and accepts the
operation if `ECDSA.recover(toEthSignedMessageHash(getHash(userOp)), signature)` is in `signers`; the hash covers the
`allowAllBundlers` flag, so the signer decides it. The EntryPoint then charges the paymaster's deposit; `_postOp`
emits `TransactionSponsored(userOpHash, extraData)`. V7 is the same for EntryPoint v0.7. The owner adds and removes
signers (`MultiSigner`) but any signer is an ECDSA key. Lines:
[`source-excerpts.md`](../evidence/thirdweb-paymaster-signer/source-excerpts.md),
[`notes.md`](../evidence/thirdweb-paymaster-signer/notes.md).

## Evidence

- CHECKED (verified source: Sourcify for V6, Blockscout for V7): the path above.
- CHECKED (`cast` at block 26,431,569): `owner()` = `0x6dd80d80…` (EOA) on both; signer `0x2454…86f` active on both.
- CHECKED (`cast` EntryPoint `balanceOf` at block 26,431,527): deposits 0.0974 ETH (v0.6) and 0.1400 ETH (v0.7).
- CHECKED (precompile trace to March 2026): 195,023 and 35,243 transactions with `ecrecover` in the last year; Xatu:
  11,878 and 134 transactions in 2026-10-16 to 2026-11-16.
- CHECKED (Blockscout): deployed by `0xdaabdaac…` (ENS `0xfirekeeper.eth`); `TransactionSponsored` `extraData` in the
  latest 50 events of V6 decodes to `team_…-prj_…` identifiers.
- INFERRED: the operator is thirdweb: the deployer name is that of a thirdweb SDK maintainer (NuGet `Thirdweb`
  package author) and the sponsorship tags have the form of thirdweb dashboard team and project ids. No thirdweb
  document listing these addresses was found.

## Impact and exposure

| Contract | Upgradeable | Exposure (EntryPoint deposit) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x6442f472…` ShieldedVerifyingPaymasterV6 | config-only | $176 (escrow) | 2026-11-16 | 11,878 |
| `0x5fa66dfe…` ShieldedVerifyingPaymasterV7 | config-only | $254 (escrow) | 2026-11-15 | 134 |

The escrow is each paymaster's deposit in EntryPoint v0.6 `0x5ff137d4…` and v0.7 `0x00000000…a032`, $430 together;
the operator refills it, so each loss is bounded by the running balance. Users' funds are not at risk through this
check.

## Remediation

- The operator deploys paymasters that verify sponsorship through ERC-1271 (a signer contract with a post-quantum key)
  or a post-quantum scheme, withdraws the old deposits and points its sponsorship service at the new addresses. The
  owner `0x6dd80d80…` is itself an ECDSA key and should move to a post-quantum account.
- No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: drafted by `scripts/15_findings.py` inside `pimlico-paymaster-signer` (rated MEDIUM there, step 4).
- 2026-11-17 review (Review07): split out of `pimlico-paymaster-signer`: deployed by `0xfirekeeper.eth`, not Pimlico's
  deployers, with thirdweb-style sponsorship tags; project set to `thirdweb` (inferred). MEDIUM -> LOW, step 5:
  EntryPoint deposits $430.
