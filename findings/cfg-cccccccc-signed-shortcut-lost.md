---
id: cfg-cccccccc-signed-shortcut-lost
title: "CFG: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xcccccccccc111a3d376dacad7da330fe751cd9ea"
  family: "10b244a115438bcd51ac5d5a56c2b713"
  copies: 3
  name: "CFG"
  label: "deployed by Centrifuge: Deployer"
  upgradeable: "no"
  rating: LOW
  txs_90d: 72807
  last_active: 2026-11-18
  recoveries_14d: 4
fix:
  layer: offchain
  who_acts: "token holder (calls approve itself)"
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
  note: "permit survives via ERC-1271; delegateWithSig is lost but delegate stays open → LOW."
---

## Summary

CFG: permit needs the holder's ECDSA signature; under EIP-8151 a holder whose address has code can no longer use it, but keeps approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Centrifuge SignatureLib: ECDSA first; a signer with code is then asked through ERC-1271 / Centrifuge delegateWithSig: whoever signed delegates. Read from source. Executed: a real transaction reverts with code at the signer.
- permit(v,r,s) with an ERC-1271 owner succeeds: SignatureLib falls back to ERC-1271, permit is not lost
- DelegationToken.delegateWithSig: delegator = ecrecover(...) with no ERC-1271 (dossier source line 45); delegate(address) at line 33 is direct
- bytecode at block 26438999 (proxy + implementation) holds direct selectors approve 0x095ea7b3, transfer 0xa9059cbb, delegate 0x5c19a95c

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 72,807 transactions called it in the 90 days before that block; last on 2026-11-18.
- 4 signature recoveries in the study's two-week trace window.

## Remediation

holder calls approve directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
