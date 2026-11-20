---
id: 2d78b8b6-fixed-signer
title: "0x2d78b8b6: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2d78b8b69de2bac331fc5aabddc1516af5ab6a95"
  family: "9bfb5c42dc45e6b96c0a56be619b403f"
  copies: 3
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 4253
  last_active: 2026-11-18
  recoveries_14d: 2625
fix:
  layer: new-deployment
  who_acts: "operator"
evidence:
  level: executed
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
  rating: MEDIUM
  note: "No update path. Nothing is locked."
---

## Summary

KyberSwapSwapper accepts swaps only with a signature from its immutable signer, which for this address is 0x32b2…1772 (the reading's 0x3214… belongs to another copy). If that key gets code, swaps die for good. Pause and release are direct calls, and nothing is held.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: swap helper: a signer that is a constant in the code. Bytecode and names. Executed: a real transaction is unaffected by code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- cast call signer() = 0x32b2…1772; the address appears once in this bytecode, and 0x3214… appears 0 times
- cast code 0x32b2… = 0x; ETH balance 0
- release-to-vault, pause and blacklist are direct calls gated by the vault (reading.first.json)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 4,253 transactions called it in the 90 days before that block; last on 2026-11-18.
- 2,625 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new swapper.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
