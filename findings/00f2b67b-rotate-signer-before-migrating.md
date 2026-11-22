---
id: 00f2b67b-rotate-signer-before-migrating
title: "0x00f2b67b: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x00f2b67b5a5ec2ff88b2be7d5a8d1a39d5929237"
  family: "d17fa1b5532ecc5cfa75b5f16398977f"
  copies: 2
  upgradeable: "no"
  rating: LOW
  value_usd: 431470
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 911
  last_active: 2026-11-14
  recoveries_14d: 12
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x23e8…d666"
evidence:
  level: bytecode
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
  note: "Live EOA owner holds setter."
---

## Summary

Custodial exchange vault: withdrawals need user signature plus a whitelisted matching-engine signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a two-address custody bridge (239 ETH with tokens): user withdrawals also need signatures from addresses flagged in a map that admins change. A signer with code is replaced by the admins. Bytecode and names.
- owner adds/removes engine keys (addWhitelistAdmin/removeWhitelistAdmin, whitelist mapping slot 2)
- owner()=0x23e8bbee…d666 EOA, nonce 53 at block
- timelocked emergency withdrawal needs no signature (reading.what)

## Impact and exposure

- Value held at block 26,438,999: $431,470 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 911 transactions called it in the 90 days before that block; last on 2026-11-14.
- 12 signature recoveries in the study's two-week trace window.

## Remediation

Owner whitelists a new EOA engine key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
