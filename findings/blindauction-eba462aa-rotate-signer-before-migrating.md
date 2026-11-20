---
id: blindauction-eba462aa-rotate-signer-before-migrating
title: "BlindAuction: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xeba462aa6b835ef0f4a85f9b0a2beb3b1ce6bfe7"
  family: "a5b088a139b02d0c58c3de512382adb7"
  copies: 3
  name: "BlindAuction"
  upgradeable: "yes"
  rating: LOW
  value_usd: 21655
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner"
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
  note: "There is a setter and a live EOA owner."
---

## Summary

BlindAuction (proxy) checks refunds against a stored signer with OZ ECDSA.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- BlindAuction.sol:103 setSigner onlyOwner; :53 ECDSA.recover compared to signer
- owner 0x21ee…5d is an EOA, nonce 44; signer 0x5599…d0 is an EOA, nonce 0

## Impact and exposure

- Value held at block 26,438,999: $21,655 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls setSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
