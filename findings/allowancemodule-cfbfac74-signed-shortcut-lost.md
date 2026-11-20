---
id: allowancemodule-cfbfac74-signed-shortcut-lost
title: "AllowanceModule: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134"
  family: "7c7cca9024a5bbd73a85e2c37860cd23"
  name: "AllowanceModule"
  label: "deployed by Safe: Deployer 3"
  upgradeable: "no"
  rating: LOW
  value_usd: 9925
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2179
  last_active: 2026-11-18
  recoveries_14d: 6
fix:
  layer: offchain
  who_acts: "allowance delegate with code"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Direct path, same party. Value $9925, txs_90d 2179 (not rating inputs)."
---

## Summary

Safe AllowanceModule: executeAllowanceTransfer needs the delegate's signature, or the delegate as caller. A delegate with code calls it itself with an empty signature (or v=1).

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Safe AllowanceModule: the delegate must have signed, or be the caller / Safe AllowanceModule recoverSignature: the caller itself (v 0 or 1), eth_sign or ECDSA / old Safe SignatureDecoder.recoverKey:…. Read from source.
- source AllowanceModule recoverSignature: signature.length == 0 → return msg.sender; v == 1 → msg.sender
- checkSignature requires signer == delegate, so the delegate calling directly passes

## Impact and exposure

- Value held at block 26,438,999: $9,925 (ETH and 49 priced tokens).
- Activity: 2,179 transactions called it in the 90 days before that block; last on 2026-11-18.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

The delegate calls executeAllowanceTransfer directly with an empty signature.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
