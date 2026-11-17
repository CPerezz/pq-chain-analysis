---
id: lido-steth-permit-code-first
title: "Lido stETH: permit forwards only a 65-byte (v, r, s) signature to ERC-1271, so post-quantum smart accounts cannot use permit; nothing is forgeable beyond each account's own key"
project: lido
status: confirmed
severity: LOW
patterns: [PQ-3]
primitives: [ecrecover]
trigger: none
impact: liveness
alternative: alternative-exists
role: auxiliary
contracts:
- address: "0xae7ab96520de3a18e5e111b5eaab095312d7fe84"
  implementation: "0x028271e30a695c0527a0c50ca30603fed004cdb0"
  name: AppProxyUpgradeable -> Lido (stETH)
  upgradeable: "yes"
  admin: Lido DAO (Aragon Kernel 0xb8ffc3cd6e7cf5a098a1c92f48009765b24088dc; APP_MANAGER_ROLE managed by Agent 0x3e40d73eb977dc6a537af587d48316fee66e9c8c, which Dual Governance executor 0x23e0b465633ff5178808f4a75186e2f2f9537021 controls)
  value_usd: null
  value_basis: null
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 77736
families: []
fix:
  layer: contract-upgrade
  who_acts: Lido DAO governance (Aragon Voting with Dual Governance) through Agent 0x3e40d73eb977dc6a537af587d48316fee66e9c8c, upgrading the Lido app in Kernel 0xb8ffc3cd6e7cf5a098a1c92f48009765b24088dc
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/lido-steth-permit-code-first/classification.jsonl
  - evidence/lido-steth-permit-code-first/onchain.json
  - evidence/lido-steth-permit-code-first/activity.json
  - evidence/lido-steth-permit-code-first/source-excerpts.md
  - evidence/lido-steth-permit-code-first/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review07 (registry review)
  ref: evidence/lido-steth-permit-code-first/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [lido-wsteth-permit, lido-predeposit-bls12-381]
---

## Summary

stETH's `permit` checks account code first, but it takes the signature as `(v, r, s)` and forwards only those 65
bytes to the account's ERC-1271 `isValidSignature` (PQ-3). A smart account with a post-quantum signer cannot produce a
valid 65-byte signature, so post-quantum accounts cannot use `permit`; they can still use on-chain `approve`.
Nothing is forgeable beyond each account's own key: code-less addresses use `ecrecover` (as safe as their own key) and
accounts with code are asked through ERC-1271. Rated LOW (step 4): an alternative path (`approve`) exists, nothing can
be taken through the check, and the permit is an auxiliary feature of the token.

## Mechanism

`StETHPermit.permit(_owner, _spender, _value, _deadline, _v, _r, _s)` (StETHPermit.sol lines 99–112, in the Lido
implementation `0x028271e3…`) builds the EIP-712 hash through the `EIP712StETH` helper and calls
`SignatureUtils.isValidSignature(_owner, hash, _v, _r, _s)`. That function (SignatureUtils.sol lines 29–57) calls
ERC-1271 `isValidSignature(hash, abi.encodePacked(r, s, v))` when `_owner` has code, and
`ECDSA.recover(hash, v, r, s) == _owner` otherwise. The interface fixes the signature to 65 bytes, so the ERC-1271
branch cannot carry a post-quantum signature (0.7–17 KB). Pattern PQ-3, not PQ-13 as drafted. Source lines:
[`notes.md`](../evidence/lido-steth-permit-code-first/notes.md).

## Evidence

- CHECKED (verified source, Sourcify full match of the implementation): code check, then ERC-1271 with
  `abi.encodePacked(r, s, v)`; else `ECDSA.recover`.
- CHECKED (`cast` at blocks 26,431,457–26,431,458): `implementation()` = `0x028271e3…`; Kernel
  `0xb8ffc3cd…`; ACL `0x9895f0f1…`; the manager of `APP_MANAGER_ROLE` on the Kernel is Agent `0x3e40d73e…`; Agent
  `RUN_SCRIPT_ROLE`/`EXECUTE_ROLE` are held by the Dual Governance executor `0x23e0b465…`.
- CHECKED (precompile trace to March 2026; `data/report/curated_contracts.csv`): 29,674 transactions with `ecrecover`
  in the last year.
- CHECKED (Xatu, any function): 77,736 transactions called stETH in 2026-10-16 to 2026-11-16; last 2026-11-16.
- INFERRED: an EIP-7702-delegated EOA has code, so it is sent to ERC-1271; whether its old ECDSA key still signs
  there is decided by its delegate, not by stETH.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xae7ab965…` AppProxyUpgradeable -> Lido (stETH) | yes | none (liveness only) | 2026-11-16 | 77,736 |

No funds are exposed through this check: post-quantum users lose only the gasless `permit` convenience. For scale,
stETH's market cap is $17.69B (9,753,965 stETH × $1,813.23, 2026-11-17), but it is not the exposure here and is not
put in `value_usd`. wstETH's `permit` is ECDSA-only and is rated separately (`lido-wsteth-permit`).

## Remediation

- Lido DAO adds a `permit(owner, spender, value, deadline, bytes signature)` overload that passes the full signature
  to ERC-1271 for accounts with code (the current OpenZeppelin `SignatureChecker` pattern), through an upgrade of the
  Lido app: Aragon vote under Dual Governance, executed by Agent `0x3e40d73e…` on Kernel `0xb8ffc3cd…`.
- Until then, post-quantum accounts use `approve`, or Permit2 (code check first, full signature to ERC-1271).
- No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated NONE (code checked first: no exposure beyond the account's own key).
- 2026-11-17 review (Review07): NONE -> LOW, step 4: the ERC-1271 branch receives only `abi.encodePacked(r, s, v)`, so
  this is PQ-3 (post-quantum accounts locked out of `permit`, `approve` remains), not PQ-13. Status not-affected ->
  confirmed; impact none -> liveness; fix layer none -> contract-upgrade; market cap removed from `value_usd` (not the
  exposure; stale $22.21B in the draft).
