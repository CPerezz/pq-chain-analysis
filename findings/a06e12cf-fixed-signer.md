---
id: a06e12cf-fixed-signer
title: "0xa06e12cf: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa06e12cf1a6bc589d71eb908b7469886c003cf1f"
  family: "0d3bb5f5506aa507027bb56e5613bb76"
  upgradeable: "no"
  rating: LOW
  value_usd: 239
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6
  last_active: 2026-11-06
  recoveries_14d: 1
fix:
  layer: offchain
  who_acts: "admin 0x8ca6…64e9"
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
  rating: LOW
  note: "The same acts stay open to the same party by direct call; only the relayed signed shortcut is lost → LOW."
---

## Summary

Signed functions (8fbbd3c8, 93d18354, f73984b3) recover the constant 0x8ca6ccc4…64e9 and change lot state. Matching direct-call functions (0fdb68af, 22a7a289, 5dceaac8) do the same writes when msg.sender == 0x8ca6…, and retirer/0599bd91 withdraw directly.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a signer that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: 8fbbd3c8 and 0fdb68af both set storage_map_a[arg0] = 2 and emit Event_5ba75a4f; 93d18354 and 22a7a289 both set status 1 and emit Event_f3283bd2
- retirer(address,uint256) and 0x0599bd91 are require(msg.sender == 0x8ca6…) transfers of tokens/ETH
- 0x8ca6…64e9 has code 0x today; the account keeps call ability after taking code

## Impact and exposure

- Value held at block 26,438,999: $239 (ETH and 49 priced tokens).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-11-06.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

Admin submits the direct-call versions itself instead of relaying signatures.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
