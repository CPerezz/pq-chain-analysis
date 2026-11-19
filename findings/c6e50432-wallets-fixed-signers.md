---
id: c6e50432-wallets-fixed-signers
title: "0xc6e50432: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc6e50432a79674e9b8ca0c158246302a658a067c"
  family: "a3cb30ad17931c09b42a95d4917bba72"
  copies: 2
  upgradeable: "no"
  rating: HIGH
  value_usd: 624170
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6
  last_active: 2026-11-17
  recoveries_14d: 3
fix:
  layer: new-deployment
  who_acts: "the owners move funds before their signers take code"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "signers read; EOAs today"
---

## Summary

Contract `0xc6e50432a79674e9b8ca0c158246302a658a067c`, with 1 more addresses running its code. A wallet whose signers are fixed in code; once enough of them take code, it can no longer move anything.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo pattern (isSigner, sendMultiSig), 346 ETH. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode and names: the BitGo pattern (isSigner, sendMultiSig); no function changes signers; no proxy, no upgrade.
- State: 3 signers, all EOAs today; it locks once all three have code.
- Executed: a real transaction reverts once its second signer has code. 6 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $624,170 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-11-17.
- 3 signature recoveries in the study's two-week trace window.

## Remediation

Each owner group moves its funds before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
