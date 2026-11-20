---
id: 89154bc5-fixed-signer
title: "0x89154bc5: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x89154bc5d5f9dfb574d51f5092103275a50c83c4"
  family: "ddaaadb15883549e969ca756052fef7a"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "Owner (store_a)"
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
  note: "MEDIUM (main reviewer's LOW/MEDIUM rule): the signed function dies for good; other parties' assets leave by separate paths (owner/depositor withdraw, rescue, timeout), not by the same act. The code does not look like a presale. It looks like an operator-run transfer or drainer contract. The only effect is that the two signature-checked functions would stop working."
---

## Summary

The constant EOA signer only gates two owner-only transferFrom functions. Owner functions without a signature (batchTransfer, 871c87f8) and store_b's withdraw functions can move the same assets, so nothing gets locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Unresolved_f03ea4f5 and Unresolved_19210419: require(address(var_k) == 0x933e5a768e631ca3d8f61d2b52353d103a4e1626, "v9"), then transferFrom(store_b, ...)
- Both functions also require msg.sender == store_a ("o")
- The constant 0x933e... has code_bytes 0 and is not delegated (an EOA)
- No function writes the signer; it is pushed in the bytecode as a literal

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Nothing needs fixing in the contract. The owner can use the transferFrom paths that need no signature.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
