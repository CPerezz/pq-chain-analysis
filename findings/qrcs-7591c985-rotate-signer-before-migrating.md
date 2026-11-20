---
id: qrcs-7591c985-rotate-signer-before-migrating
title: "QRCs: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7591c9855cbd54fea59252f8ba6cdfde06afab36"
  family: "eb5c95dd007ac250c8a61e09f96398ec"
  copies: 2
  name: "QRCs"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 1226
  last_active: 2026-11-16
  recoveries_14d: 77
fix:
  layer: onchain-config
  who_acts: "owner 0x0A0A2B62F8D2BC0f3Cc04591a062978516D18c51"
evidence:
  level: source-read
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
  note: "A live owner can call the setter, so a config call fixes it: LOW."
---

## Summary

QRCs checks signatures from a stored signer key with ecrecover; once that key's account holds code that is not a 7702 delegation, recovery returns nothing and the signed path stops until the key is replaced.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- setter setClaimSigner(address) onlyOwner in verified source (eb5c95dd007ac250c8a61e09f96398ec/source)
- owner() at block 26438999 = 0x0A0A2B62F8D2BC0f3Cc04591a062978516D18c51 EOA nonce=385
- txs_90d=1226, last_active=2026-11-16

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,226 transactions called it in the 90 days before that block; last on 2026-11-16.
- 77 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the signer to a new EOA (or a key the signature check accepts) through the setter before the signing account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
