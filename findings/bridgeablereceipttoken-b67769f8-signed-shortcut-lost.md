---
id: bridgeablereceipttoken-b67769f8-signed-shortcut-lost
title: "BridgeableReceiptToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xb67769f8d77b9b302f897c6dc521ed5cce764bd4"
  family: "bca2bab536c16007a03840c8b182e7ef"
  copies: 58
  name: "BridgeableReceiptToken"
  label: "deployed by Upshift Finance: Deployer"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 15372
  last_active: 2026-11-18
  recoveries_14d: 6
fix:
  layer: none
  who_acts: "the affected holder, by calling approve itself"
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
  note: "LOW: same act open by approve to the same party; only a signing convenience is lost."
---

## Summary

BridgeableReceiptToken: EIP-2612 permit require the holder's ECDSA signature; EIP-8151 fails it for a holder with code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit or an approval by signature: the owner named in the call must equal the recovered address; the holder can call approve itself / returns the recovered signer; rejects high s and zero. Read from source. Executed: a real transaction reverts with code at the signer.
- approve(address,uint256) is the holder's direct path (selector 0x095ea7b3 in deployed code)
- row note: permit or an approval by signature: the owner named in the call must equal the recovered address; the holder can call approve itself / returns the recovered signer; rejects high s and zero. Read from source. Executed: a

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 58 addresses).
- Activity: 15,372 transactions called it in the 90 days before that block; last on 2026-11-18.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

holder calls approve directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
