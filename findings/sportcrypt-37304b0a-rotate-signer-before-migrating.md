---
id: sportcrypt-37304b0a-rotate-signer-before-migrating
title: "SportCrypt: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x37304b0ab297f13f5520c523102797121182fb5b"
  family: "bca8e068aa339616f9e84780d1f28fa0"
  name: "SportCrypt"
  upgradeable: "no"
  rating: LOW
  value_usd: 38978
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-09-24
fix:
  layer: onchain-config
  who_acts: "owner (addAdmin) or any user via recoverFunds after the timeout"
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
  note: "Same act stays open without the admin signature: recoverFunds finalizes matches after the timeout, and withdraw is direct, so funds are never locked even if the owner were dead (owner liveness unread: node timed out). Order makers sign their own orders (signed shortcut; their account, their choice)."
---

## Summary

SportCrypt: claim requires a final price signed by an admin in admins[]; order makers sign their own orders (signed-shortcut part).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: SportCrypt order: the maker named must have signed / SportCrypt claim: the final price must be signed by an admin. Read from source.
- SportCrypt.sol:214-215 claim: ecrecover then require(admins[signer]); addAdmin/removeAdmin/changeOwner onlyOwner (lines 16-26); getOwner() at block = 0x83C748303929E6b28cEB1d0D3B052d6Ec7317722
- SportCrypt.sol:244-262 recoverFunds(matchId): anyone, no signature, finalizes an unfinalized match after firstTradeTimestamp + (matchId&0xFF)*7 days at the price encoded in matchId
- SportCrypt.sol:139-151 withdraw(amount): direct, no signature

## Impact and exposure

- Value held at block 26,438,999: $38,978 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-24.

## Remediation

owner adds an admin key without code; otherwise users wait for the recoverFunds timeout, then claim and withdraw

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
