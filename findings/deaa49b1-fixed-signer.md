---
id: deaa49b1-fixed-signer
title: "0xdeaa49b1: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdeaa49b13cbde5a8d1af1f2f382b45bb48cf34df"
  family: "b8537f4487ffd2b5bed78832fe9276d3"
  copies: 6
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 102
  last_active: 2026-11-17
  recoveries_14d: 6
fix:
  layer: new-deployment
  who_acts: "paymaster owner"
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
  rating: MEDIUM
  note: "No update path and the sponsorship function dies, but the money still leaves: the owner withdraws the deposit (MEDIUM)."
---

## Summary

A v0.6 verifying paymaster. verifyingSigner 0xcb64…ee84 is an EOA with no setter and no upgrade. If its key gets code, no user operation can be sponsored. The deposit (0.78 ETH) is the operator's own, and the owner withdraws it without a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a verifying paymaster (v0.6): its signer looks immutable; the owner withdraws the deposit directly. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- verifyingSigner() = 0xCb64…EE84, no code; no setVerifyingSigner/setSigner/upgradeTo selector in the bytecode
- cast call --from owner 0x10e6… withdrawTo(owner, 781887044748838517) succeeds at block 26438999
- owner is a 7702-delegated EOA (0xef0100…)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 102 transactions called it in the 90 days before that block; last on 2026-11-17.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new paymaster and move the deposit with withdrawTo.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
