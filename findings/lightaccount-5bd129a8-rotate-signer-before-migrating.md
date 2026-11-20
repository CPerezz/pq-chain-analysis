---
id: lightaccount-5bd129a8-rotate-signer-before-migrating
title: "LightAccount: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5bd129a87533f2902fbd4e68576aa844626b7f59"
  family: "03bf1fb08f1025093ad7a25c39bf99b8"
  copies: 5603
  name: "LightAccount"
  label: "created by Alchemy: Light Account Factory V2"
  upgradeable: "yes"
  rating: LOW
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 86203
  last_active: 2026-11-18
  recoveries_14d: 17460
fix:
  layer: onchain-config
  who_acts: "owner / account itself"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Owner key holder can rotate itself; an ERC-1271 path also exists."
---

## Summary

Alchemy LightAccount v2; userOps signed by the owner key (type EOA) or via ERC-1271 (type CONTRACT). Under EIP-8151 a signer that takes non-delegation code stops recovering, so this path stops until the key is rotated.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: LightAccount: ECDSA of the stored owner, or ERC-1271 when the owner is a contract; transferOwnership (read) by the owner or the account itself. Read (same text as a family read). Executed: a real transaction reverts with code at the signer.
- LightAccount.sol: transferOwnership onlyAuthorized (owner or self); signature type CONTRACT uses isValidERC1271SignatureNow(owner)
- owner() = 0xABbd5ED3…, no code, nonce 0 (acts through userOps), at block 26438999
- UUPS proxy (implementation 0x8e8e658e…) upgradable by the owner/self

## Impact and exposure

- Value held at block 26,438,999: $902 (ETH and 49 priced tokens, over 5,603 addresses).
- Activity: 86,203 transactions called it in the 90 days before that block; last on 2026-11-18.
- 17,460 signature recoveries in the study's two-week trace window.

## Remediation

Owner transfers ownership, or signs with the type CONTRACT signature if its new code implements ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
