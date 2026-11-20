---
id: semimodularaccount7702-0cfabe8a-7702-own-key-only
title: "SemiModularAccount7702: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x0cfabe8a8a5cd4ceee2baaa850cfb92f7391f47e"
  family: "dda3e769e166291d5abdffe6b25e08a7"
  copies: 98841
  name: "SemiModularAccount7702"
  label: "Alchemy: SemiModularAccount 7702"
  upgradeable: "yes"
  rating: LOW
  value_usd: 88055490
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 612987
  last_active: 2026-11-18
  recoveries_14d: 45867
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
  note: "With the fallback signer = the account itself, ERC-1271 points back to the account, so the account can't sign for itself once it holds real code. Fix: keep or re-delegate, or rotate the fallback signer / install a validation module. Upgradeable by the account itself (UUPS self-call)"
---

## Summary

SemiModularAccount7702 (98,841 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: Alchemy SemiModularAccount: the fallback signer (the account itself until it is changed) signs with ECDSA, or, flagged as a contract owner, is asked through ERC-1271. Read from source. Executed: a real transaction reverts once the account holds this logic as real code.
- Alchemy SemiModularAccount7702: the fallback signer defaults to the account itself; _checkSignature has an EOA type (tryRecover == owner) and a CONTRACT_OWNER type (ERC-1271 on owner); updateFallbackSignerData(address,bool) is callable through the account's own validation/source (dossier dda3e769e166291d5abdffe6b25e08a7)
- Study note: Alchemy SemiModularAccount: the fallback signer (the account itself until it is changed) signs with ECDSA, or, flagged as a contract owner, is asked through ERC-1271. Read from source. Executed: a real transaction revert
- Activity (measured): txs_90d 612,987, last_active 2026-11-18, value_usd 88055490

## Impact and exposure

- Value held at block 26,438,999: $88.1M (ETH and 49 priced tokens, over 98,841 addresses).
- Activity: 612,987 transactions called it in the 90 days before that block; last on 2026-11-18.
- 45,867 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
