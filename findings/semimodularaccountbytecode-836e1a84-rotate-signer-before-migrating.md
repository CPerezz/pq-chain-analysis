---
id: semimodularaccountbytecode-836e1a84-rotate-signer-before-migrating
title: "SemiModularAccountBytecode: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: none
contracts:
- address: "0x836e1a843e6240211cf1a7b75511dd44543aff7f"
  family: "e51591bf69e315d65e34b21cafa00c64"
  copies: 3924
  name: "SemiModularAccountBytecode"
  label: "created by Alchemy: Account Factory"
  upgradeable: "yes"
  rating: LOW
  value_usd: 1416399
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 14207
  last_active: 2026-11-18
  recoveries_14d: 2064
fix:
  layer: onchain-config
  who_acts: "account owner"
evidence:
  level: executed
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
  note: "LOW."
---

## Summary

Alchemy SemiModularAccountBytecode. EOA-type owner signatures have no ERC-1271 fall-through.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Alchemy SemiModularAccount: the fallback signer (the account itself until it is changed) signs with ECDSA, or, flagged as a contract owner, is asked through ERC-1271. Read from source. Executed: a real transaction reverts with code at the signer.
- reading e51591bf: the owner keeps direct calls, the CONTRACT_OWNER signature type, or rotates the fallback signer
- family e51591bf: 3,924 addresses, 6.9 ETH total; least spare gas traced 16,537, so no in-window gas failures

## Impact and exposure

- Value held at block 26,438,999: $1.4M (ETH and 49 priced tokens, over 3,924 addresses).
- Activity: 14,207 transactions called it in the 90 days before that block; last on 2026-11-18.
- 2,064 signature recoveries in the study's two-week trace window.

## Remediation

The owner rotates or uses CONTRACT_OWNER.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
