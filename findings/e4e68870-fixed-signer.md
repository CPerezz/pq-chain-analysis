---
id: e4e68870-fixed-signer
title: "0xe4e68870: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe4e688706efdb0c544c46a25b025b34fd6826457"
  family: "deda0007486168ed000b809d9c8b446c"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 44
  last_active: 2026-11-12
  recoveries_14d: 11
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
  note: "No update path and the function dies, but the money still leaves: the owner withdraws (MEDIUM)."
---

## Summary

A verifying paymaster (EntryPoint v0.8). verifyingSigner 0x4f07…9aa8 is an EOA with no setter and no upgrade. If its key gets code, sponsorship stops. The owner still withdraws the deposit (0.0037 ETH).

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: verifying paymaster: a signer that is a constant in the code. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- verifyingSigner() = 0x4F07…9Aa8, no code; no setter or upgrade selector
- cast call --from owner 0x656c… withdrawTo(owner, 3663618764536524) succeeds

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 44 transactions called it in the 90 days before that block; last on 2026-11-12.
- 11 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new paymaster and withdraw the deposit.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
