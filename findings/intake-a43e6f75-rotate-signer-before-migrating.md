---
id: intake-a43e6f75-rotate-signer-before-migrating
title: "Intake: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa43e6f75ee006411f79ac1c84120606c2330de82"
  family: "a0071b91da0e4d01a37ce40ad440e68d"
  name: "Intake"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1886
  last_active: 2026-11-18
  recoveries_14d: 13
fix:
  layer: onchain-config
  who_acts: "owner 0x047F606fD5b2BaA5f5C6c4aB8958E45CB6B054B7"
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

Intake checks signatures from a stored signer key with ecrecover; once that key's account holds code that is not a 7702 delegation, recovery returns nothing and the signed path stops until the key is replaced.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: SignatureChecker on a signer kept in storage (ECDSA, or its ERC-1271 if it is a contract). Read from source. Executed: a real transaction reverts with code at the signer.
- setter setSigner(address) onlyOwner in verified source (a0071b91da0e4d01a37ce40ad440e68d/source)
- owner() at block 26438999 = 0x047F606fD5b2BaA5f5C6c4aB8958E45CB6B054B7 EOA nonce=2935
- txs_90d=1886, last_active=2026-11-18

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,886 transactions called it in the 90 days before that block; last on 2026-11-18.
- 13 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the signer to a new EOA (or a key the signature check accepts) through the setter before the signing account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
