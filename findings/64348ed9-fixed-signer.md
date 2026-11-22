---
id: 64348ed9-fixed-signer
title: "0x64348ed9: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x64348ed96c8b9fc4a254efc2f2f5d54567a47565"
  family: "113d2124f7d68ca7983875042b87cc46"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 7218
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator 0xb3bd6aaa… (EOA)"
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
  note: "No update path; operator's own money, which leaves through the owner path with no signature."
---

## Summary

Hand-written trading bot (fallback dispatch by calldata length; tx.origin checked against five operator EOAs) whose order paths verify an ecrecover signature against a constant. If the signing key takes code, those paths stop; the owner path sends the WETH/ETH to 0xb3bd6aaa… without a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: no selectors; a signer that is a constant in the code. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode: tx.origin (0x32) compared with 5 constant EOAs (0x44e05b25…, 0x5a289646…, 0xc533a4e3…, 0xa045e11f…, 0x55ae3f67…); ecrecover in the 0xfd and 0x1a2 calldata paths (scanner eq_const)
- Calldata-length 0x24 path: WETH withdraw(amount) then CALL value to PUSH20 0xb3bd6aaac41efd58adc9a6b3b867a16316d13bc6, guarded by tx.origin == 0xb3bd… (pc 0x9d5-0xa5b)
- All constants cast code 0x; balance 4 ETH at 26438999; no EIP-1967 slot

## Impact and exposure

- Value held at block 26,438,999: $7,218 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The operator withdraws through the 0x24 path and redeploys.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
