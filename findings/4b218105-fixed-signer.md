---
id: 4b218105-fixed-signer
title: "0x4b218105: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x4b218105035fac7d81de9f0f78e7bd3ae1cc1a0a"
  family: "daf5ec1bb3a7eb03f4e1c605ffeb3671"
  copies: 24
  upgradeable: "no"
  rating: HIGH
  value_usd: 1083
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "holder of key 0x557f…02c7"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "No update path. The owner's own funds leave only on that key's signature; once the key's address has code, nothing gets them out → HIGH."
---

## Summary

Single-key wallet: the only ETH exit (selector 0x6de725a3) transfers value only when ecrecover returns the constant 0x557fa19371f9786704e9767f25839047da1602c7. No function changes it, and there is no other way out.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: callTx: calls run only when signed by a constant key (0x557f…02c7) across 24 copies; no function changes it (decompiled). Bytecode and names (no source).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall decompile: ecrecover result compared to the constant 0x557f…02c7, then payable(arg1).transfer(arg2)
- the other functions are view-only (nonce, hash); no proxy, no setter
- 0x557f…02c7 has code 0x today; balance 0.025 ETH now

## Impact and exposure

- Value held at block 26,438,999: $1,083 (ETH and 49 priced tokens, over 24 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The key holder empties the wallet while the key is an EOA, before giving it code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
