---
id: 9978b9fb-fixed-signer
title: "0x9978b9fb: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9978b9fb078cba8727a3a7d832114839a3ee9f54"
  family: "63ef76e41b4363ab5fc7340ed7359091"
  upgradeable: "no"
  rating: LOW
  txs_90d: 8
  last_active: 2026-11-09
  recoveries_14d: 1
fix:
  layer: none
  who_acts: "signer EOA"
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
  note: "Assets leave by the signer's direct call (the same key acting as caller), and nothing is held: LOW."
---

## Summary

ERC-1271 order signer for CoW (GPv2 0x9008d19f… is a constant): isValidSignature accepts ecrecover == constant signer 0xE316e0af…. If that key takes code, its CoW orders stop validating, but the same key calls withdrawToken/approveToken directly, and the contract holds no funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ERC-1271 contract answering for a signer that is a constant in its code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- signer()=0xE316e0af… (EOA), authority()=0x247Cc97F…; no setter (cast, heimdall).
- Simulated withdrawToken: from a stranger it reverts 0x813daa50; from the signer it succeeds (cast call --from).
- Balance 0 ETH; four tokens received in 200k blocks, all at balance 0.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 8 transactions called it in the 90 days before that block; last on 2026-11-09.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

None; the signer moves anything out directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
