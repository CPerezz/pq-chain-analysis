---
id: n2merc721a-0eb7c84b-fixed-signer
title: "N2MERC721A: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0eb7c84b565196cedfe8c20a7e9510916d58ca6e"
  family: "83c3b9236b0cc3253d4035eb6c3258bc"
  copies: 9022
  name: "N2MERC721A"
  upgradeable: "no"
  rating: LOW
  value_usd: 309
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 694
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "collection owner"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Whitelist mint stays open via the replaceable owner key; the only lost act is an auxiliary fee waiver → LOW, not HIGH."
---

## Summary

In this N2M clone (fixed delegate 0x0000000000a248a99f797ec03160a76b18415074), only removeProtocolFee is tied to the constant N2M_SIGNER. That is an optional fee waiver. mintWhitelist also accepts owner(), which transferOwnership can replace, and withdraw/withdrawERC20 are owner direct calls.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: N2M removeProtocolFee: signed by N2M_SIGNER, fixed in the code / N2M mintWhitelist: signed by N2M_SIGNER or the owner. Read from source.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Storage.sol l.99: N2M_SIGNER = 0x00000000156D…cBc9 (code 0x today)
- ConsecutiveMinting.sol l.299: signer != N2M_SIGNER && signer != owner() → revert
- Common.sol l.97 transferOwnership(onlyOwner); l.296-312 removeProtocolFee only sets _feesRemoved; l.369/406 withdraw paths need no signature
- owner() = 0xb918…750a, code 0x today

## Impact and exposure

- Value held at block 26,438,999: $309 (ETH and 49 priced tokens, over 9,022 addresses).
- Activity: 694 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Owner signs whitelist vouchers itself, or rotates ownership to a fresh EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
