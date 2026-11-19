---
id: b6169553-wallets-fixed-signers
title: "0xb6169553: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb61695537801cdb6ada7390d44e887c9db7dd87d"
  family: "29604666b40451f1783453750caae470"
  copies: 7
  upgradeable: "no"
  rating: HIGH
  value_usd: 1804599
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the owners move funds before their signers take code"
evidence:
  level: bytecode
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
  note: "signers read; EOAs today; dormant"
---

## Summary

Contract `0xb61695537801cdb6ada7390d44e887c9db7dd87d`, with 6 more addresses running its code. A wallet whose signers are fixed in code; once enough of them take code, it can no longer move anything.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo pattern (isSigner, sendMultiSig), 1,000 ETH: no function name that changes signers. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode and names: the BitGo pattern (isSigner, sendMultiSig); no function changes signers; no proxy, no upgrade.
- State: 3 signers, all EOAs today; it locks once all three have code.
- 1,000 ETH; no transaction in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $1.8M (ETH and 49 priced tokens, over 7 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Each owner group moves its funds before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
