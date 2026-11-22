---
id: e4edf643-fixed-signer
title: "0xe4edf643: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe4edf643884a5e0ddfe9d3bc30be2e760504bbb5"
  family: "33a4a6d0af37dfed264b332228417183"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 746
  last_active: 2026-11-18
  recoveries_14d: 161
fix:
  layer: new-deployment
  who_acts: "owner 0x9c693fe208bd74ce79973879e5a3ffae3bbabe13 (EOA)"
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
  note: "No update path; only operator money is at stake and the owner can still withdraw it, so MEDIUM."
---

## Summary

Verifying paymaster that accepts sponsorship signatures only from the constant 0xcb5c3016…, with no setter, so sponsorship dies for good. The 0.62 ETH EntryPoint deposit is the operator's and stays withdrawable by the owner.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: verifying paymaster: a signer that is a constant in the code. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Disassembly: PUSH32 0xcb5c3016b3a7d7911e56cacad0bdf69cc9bc2ee4 at pc 300/2416 (signer, no code); EntryPoint v0.7 constant
- getDeposit() = 619720468515282891 wei
- cast call --from owner withdrawTo(owner, full deposit) succeeds
- owner 0x9c69… is an EOA with nonce 73

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 746 transactions called it in the 90 days before that block; last on 2026-11-18.
- 161 signature recoveries in the study's two-week trace window.

## Remediation

Owner withdraws the deposit and deploys a paymaster with a fresh signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
