---
id: pimlico-paymaster-signer
title: "Pimlico singleton paymasters: a quantum attacker who recovers a sponsorship signer key can spend the paymasters' EntryPoint gas deposits (≈ $14.5k)"
project: pimlico
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x777777777777aec03fd955926dbf81597e66834c"
  implementation: null
  name: SingletonPaymasterV7
  upgradeable: config-only
  admin: DEFAULT_ADMIN_ROLE 0x4337aa1cb877d55fecf1f70110aed8c1d2ade2c9 (EOA); MANAGER_ROLE 0xf1c9671104b48961807228cc0fad914c73aa2340 (SimpleAccount); either can add/remove signers
  value_usd: 7123
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 349721
- address: "0x888888888888ec68a58ab8094cc1ad20ba3d2402"
  implementation: null
  name: SingletonPaymasterV8
  upgradeable: config-only
  admin: DEFAULT_ADMIN_ROLE 0x4337aa1cb877d55fecf1f70110aed8c1d2ade2c9 (EOA); MANAGER_ROLE 0xf1c9671104b48961807228cc0fad914c73aa2340 (SimpleAccount)
  value_usd: 4146
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 55899
- address: "0x6666666666667849c56f2850848ce1c4da65c68b"
  implementation: null
  name: SingletonPaymasterV6
  upgradeable: config-only
  admin: DEFAULT_ADMIN_ROLE 0x4337aa1cb877d55fecf1f70110aed8c1d2ade2c9 (EOA); MANAGER_ROLE 0xf1c9671104b48961807228cc0fad914c73aa2340 (SimpleAccount)
  value_usd: 3189
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 10138
families: []
fix:
  layer: new-deployment
  who_acts: Pimlico (admin 0x4337aa1cb877d55fecf1f70110aed8c1d2ade2c9) deploys paymasters that verify sponsorship through ERC-1271 or a post-quantum scheme, moves its deposits and points its API at them
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/pimlico-paymaster-signer/classification.jsonl
  - evidence/pimlico-paymaster-signer/onchain.json
  - evidence/pimlico-paymaster-signer/activity.json
  - evidence/pimlico-paymaster-signer/source-excerpts.md
  - evidence/pimlico-paymaster-signer/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl,out_3.jsonl,out_4.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review07 (registry review)
  ref: evidence/pimlico-paymaster-signer/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Pimlico's singleton ERC-4337 paymasters (EntryPoint v0.6, v0.7, v0.8) sponsor a user operation when it carries an
ECDSA signature from a key in their `signers` set (PQ-4). A quantum attacker who recovers a signer key (its public key
follows from any sponsored operation) can sponsor its own operations without limit and spend each paymaster's
EntryPoint deposit as gas, which a bundler it runs collects. The deposits total ≈ $14.5k (2026-11-17); Pimlico
refills them, so each loss is bounded by the running balance. Rotating signers does not help because any ECDSA signer
is recoverable; the scheme needs a new deployment. Rated LOW: a fix by new deployment (MEDIUM, step 4), lowered for
under $50k exposed (step 5).

## Mechanism

`SingletonPaymasterV7._validateVerifyingMode` (lines 159–177) and `_validateERC20Mode` (lines 186–) compute
`ECDSA.recover(toEthSignedMessageHash(getHash(mode, userOp)), signature)` and accept if `signers[recovered]`; the
EntryPoint then pays the operation's gas from the paymaster's deposit. V6 and V8 have the same path. Signers are added
and removed by `addSigner`/`removeSigner` (`onlyAdminOrManager`). In ERC-20 mode the signed config also sets the token
exchange rate, but tokens come from the operation's own sender, so a forged rate only lets the attacker pay less for
its own gas, again from the deposit. Lines: [`notes.md`](../evidence/pimlico-paymaster-signer/notes.md).

## Evidence

- CHECKED (verified source, Sourcify): the paths above.
- CHECKED (creation receipts and `cast hasRole` at block 26,431,569): admin `0x4337aa1c…` (EOA) and manager
  `0xf1c96711…` (SimpleAccount) on all three.
- CHECKED (`cast` EntryPoint `balanceOf` at block 26,431,527): deposits 1.76 (v0.6), 3.93 (v0.7) and 2.29 (v0.8) ETH.
- CHECKED (precompile trace to March 2026): 418,403 transactions with `ecrecover` across the three in the last year;
  Xatu: 415,758 transactions called them in 2026-10-16 to 2026-11-16.
- CHECKED (Blockscout): deployed 2025-03-18/27 by `0x4337001f…` / `0x433704c4…` through Pimlico's singleton
  factories.

## Impact and exposure

| Contract | Upgradeable | Exposure (EntryPoint deposit) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x77777777…` SingletonPaymasterV7 | config-only | $7.1k (escrow) | 2026-11-16 | 349,721 |
| `0x88888888…` SingletonPaymasterV8 | config-only | $4.1k (escrow) | 2026-11-16 | 55,899 |
| `0x66666666…` SingletonPaymasterV6 | config-only | $3.2k (escrow) | 2026-11-15 | 10,138 |

The escrow is each paymaster's deposit in its EntryPoint (v0.6 `0x5ff137d4…`, v0.7 `0x00000000…a032`, v0.8
`0x4337084d…`), $14,458 in total. The $576 of tokens held by `0x7777…` is not reachable through the signature. Users'
funds are not at risk through this check. Two Shielded verifying paymasters drafted here are not Pimlico's and moved to
`thirdweb-paymaster-signer`.

## Remediation

- Pimlico deploys paymasters that verify sponsorship through ERC-1271 (a signer contract with a post-quantum key) or a
  post-quantum scheme, withdraws the old deposits (`withdrawTo`, admin `0x4337aa1c…`) and serves the new addresses from
  its API; dapps using the API need no change.
- Until then, keeping deposits small limits each loss. The admin and manager are themselves ECDSA keys and should move
  to post-quantum accounts. No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review07): MEDIUM -> LOW, step 5: the exposure is the paymasters' EntryPoint deposits, under
  $50k. Admin roles read from chain.
- 2026-11-17 review (Review07): `ShieldedVerifyingPaymasterV6` `0x6442f472…` and `V7` `0x5fa66dfe…` moved to
  `thirdweb-paymaster-signer` (deployed by `0xfirekeeper.eth`, thirdweb-style sponsorship tags); deposits here now
  $14,458.
