---
id: launchpadcurve-b65b67e9-entry-by-own-signature-only
title: "LaunchpadCurve: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: none
contracts:
- address: "0xb65b67e986d7b097652920d72202f2c78319bc2c"
  family: "1af951f76578f2f9850d3710bcd6f9f4"
  copies: 2
  name: "LaunchpadCurve"
  upgradeable: "yes"
  rating: LOW
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 18696
  last_active: 2026-11-18
fix:
  layer: none
  who_acts: "the token creator"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Signed shortcut; the direct launch path exists for the same party. value_usd 2165, txs_90d 18696."
---

## Summary

LaunchpadCurve (UUPS): buyWithIntent launches a token from the creator's signed intent. A creator with real code can't sign an intent.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: LaunchpadCurve buyWithIntent: the creator named in the launch intent must have signed. Read from source.
- LaunchpadCurve.sol:965 ECDSA.recover(launchIntentDigest(intent)) must equal intent.creator
- LaunchpadCurve.sol:842 launch(...) lets the creator launch directly as msg.sender; buy (l.1135) and buyPve are direct

## Impact and exposure

- Value held at block 26,438,999: $2,165 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 18,696 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Creator calls launch() directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
