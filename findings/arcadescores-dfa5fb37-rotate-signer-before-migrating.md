---
id: arcadescores-dfa5fb37-rotate-signer-before-migrating
title: "ArcadeScores: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdfa5fb3727e417015d6fefacee0144c85626c667"
  family: "cea382196540347908173f937045c4bc"
  name: "ArcadeScores"
  upgradeable: "no"
  rating: LOW
  txs_90d: 14
  last_active: 2026-11-09
  recoveries_14d: 2
fix:
  layer: onchain-config
  who_acts: "owner (EOA)"
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
  note: "Setter exists, owner is a live EOA."
---

## Summary

ArcadeScores: score submissions need a signature whose recovered address is in isVerifier; under EIP-8151 the signed path fails if the stored signer gets code, until the owner replaces it.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source. Executed: a real transaction reverts with code at the signer.
- setVerifier(address,bool) is onlyOwner (Sourcify verified source (line 405))
- owner() at 26438999 = 0x6CB431889cbD828256c216B25d49B632F62848f8, no code, nonce 1187 (node)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 14 transactions called it in the 90 days before that block; last on 2026-11-09.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

Owner calls the setter to replace the signer with an EOA key before the current signer account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
