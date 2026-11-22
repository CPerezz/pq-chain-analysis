---
id: semimodularaccount7702-a79692b6-7702-own-key-only
title: "SemiModularAccount7702: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0xa79692b65bad10d7d2fe9de309a646fbe311d6a2"
  family: "8554540d6b65a7c2598143cb0037076a"
  copies: 30422
  name: "SemiModularAccount7702"
  upgradeable: "yes"
  rating: LOW
  value_usd: 2794361
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 237508
  last_active: 2026-11-18
  recoveries_14d: 17088
fix:
  layer: account-migration
  who_acts: "each account owner"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-7702-own-key-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Same as the other SMA7702 row; upgradeable by the account itself"
---

## Summary

SemiModularAccount7702 (30,422 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: Alchemy SemiModularAccount7702 ERC-1271: the signature must recover to the account itself / Alchemy SemiModularAccount (variant): the fallback signer, the account itself until changed, signs with…. Read from source.
- Alchemy SemiModularAccount7702 (variant): same _checkSignature (EOA tryRecover == fallback signer, or CONTRACT_OWNER ERC-1271); fallback signer is the account itself until changed via updateFallbackSignerData/source (dossier 8554540d6b65a7c2598143cb0037076a)
- Study note: Alchemy SemiModularAccount7702 ERC-1271: the signature must recover to the account itself / Alchemy SemiModularAccount (variant): the fallback signer, the account itself until changed, signs with…. Read from source.
- Activity (measured): txs_90d 237,508, last_active 2026-11-18, value_usd 2794361

## Impact and exposure

- Value held at block 26,438,999: $2.8M (ETH and 49 priced tokens, over 30,422 addresses).
- Activity: 237,508 transactions called it in the 90 days before that block; last on 2026-11-18.
- 17,088 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
