---
id: vault-d315a9c3-signed-shortcut-lost
title: "Vault: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xd315a9c38ec871068fec378e4ce78af528c76293"
  family: "7a4ca040d8266401d1acc20558377a7a"
  name: "Vault"
  label: "Swaap Finance: Vault"
  upgradeable: "no"
  rating: LOW
  value_usd: 1028
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 14939
  last_active: 2026-11-01
fix:
  layer: offchain
  who_acts: "the user (calls setRelayerApproval or the Vault function itself)"
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
  note: "signed shortcut lost, same act open by a direct call to the same party → LOW."
---

## Summary

Balancer V2 Vault: relayer approval / user actions by signature (EOASignaturesValidator, ecrecover must equal the account). An account with code can no longer sign.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit or an approval by signature: the owner named in the call must equal the recovered address; the holder can call approve itself. Read (function text).
- EOASignaturesValidator._isValidSignature: plain ecrecover == account, no ERC-1271 (dossier source)
- setRelayerApproval 0xfa6e671d present in bytecode: the user can approve relayers or call the Vault directly

## Impact and exposure

- Value held at block 26,438,999: $1,028 (ETH and 49 priced tokens).
- Activity: 14,939 transactions called it in the 90 days before that block; last on 2026-11-01.

## Remediation

the affected party uses the direct call instead of the signed path

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
