---
id: 4a0febaa-fixed-signer
title: "0x4a0febaa: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4a0febaa503b3395c9bcf70230a957c3d8e80266"
  family: "4226be165e797dfed129c5fa02ad1f63"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 14
  last_active: 2026-11-17
  recoveries_14d: 9
fix:
  layer: new-deployment
  who_acts: "paymaster operator"
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
  note: "Only operator money is at stake, and EIP-8151 does not lock it (it is already stuck via the owner): MEDIUM."
---

## Summary

VerifyingPaymaster (EntryPoint v0.6) whose immutable verifyingSigner 0x67575eF3… sponsors ops. If that key takes code, sponsorship dies. The 0.045 ETH deposit is the operator's own money, and it is already unreachable today: owner() is the CREATE2 deployer 0x4e59b448…, which cannot call withdrawTo.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: verifying paymaster: a signer that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- verifyingSigner()=0x67575eF3…, no code; the only setter is transferOwnership (heimdall ABI, cast).
- owner()=0x4e59b44847b379578588920cA78FbF26c0B4956C (the deterministic deployment proxy, which has code); getDeposit()=4.509e16 wei.
- Recent validatePaymasterUserOp calls recovered 0x67575ef3… (txs.json).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 14 transactions called it in the 90 days before that block; last on 2026-11-17.
- 9 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new paymaster. The deposit is stranded regardless of EIP-8151.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
