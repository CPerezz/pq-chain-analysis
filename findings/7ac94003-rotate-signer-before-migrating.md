---
id: 7ac94003-rotate-signer-before-migrating
title: "0x7ac94003: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7ac940038125796a7819652136c3f16db9b5568c"
  family: "b73d68ac4c75ae47568200cb37f96ec0"
  copies: 5
  upgradeable: "no"
  rating: LOW
  txs_90d: 14486
  last_active: 2026-10-07
fix:
  layer: onchain-config
  who_acts: "Balancer-style Authorizer admin Safe 0xD6Ff…20F8"
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
  note: "A working Safe governs the Authorizer, so a live path to setSigner exists (via grant)."
---

## Summary

Custom Balancer-vault pool with a signed-quote signer. setSigner (0x6c19e783) and setFlexibleOracleStates use Balancer authentication (getOwner = 0xBA1BA1… delegate, so the Authorizer decides).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setFlexibleOracleStates, setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- setSigner checks msg.sender==owner else Authorizer.canPerform(actionId 0x85d8…9e78) (heimdall x7ac9)
- Vault 0xd315…8293 getAuthorizer=0xCA19…123c; no grantee yet for the setSigner action
- Authorizer DEFAULT_ADMIN member 0xD6Ff6aBb…20F8 = Safe 4/6, nonce 1; it can grant the action

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 14,486 transactions called it in the 90 days before that block; last on 2026-10-07.

## Remediation

The Authorizer admin Safe grants the setSigner action and replaces the signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
