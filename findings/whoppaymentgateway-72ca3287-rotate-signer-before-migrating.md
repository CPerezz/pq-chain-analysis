---
id: whoppaymentgateway-72ca3287-rotate-signer-before-migrating
title: "WhopPaymentGateway: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x72ca32879941a51b089f6ace3dd8f13dd8bf6c14"
  family: "2d0a18e032c4d7c7c37f6e6159b1b590"
  name: "WhopPaymentGateway"
  upgradeable: "no"
  rating: LOW
  value_usd: 22557
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
  note: "There is a setter and a live EOA owner, so LOW holds. Value $22,557; 0 txs in 90d."
---

## Summary

WhopPaymentGateway checks payments against a stored signer with OZ ECDSA. If that signer key gets code, payments stop validating.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- source WhopPaymentGateway.sol:60 setSigner(address) onlyOwner; :124 ECDSA recover compared to signer
- owner() 0xb8b5e97c…fbc is an EOA, nonce 32280 at 26438999

## Impact and exposure

- Value held at block 26,438,999: $22,557 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls setSigner with a key that has no code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
