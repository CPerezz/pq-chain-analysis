---
id: 41ddcc04-fixed-signer
title: "0x41ddcc04: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x41ddcc0495015186f76065b69881061a92f7906e"
  family: "7408c6482f670fb509ccc2e0052c1128"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Operator redeploys with a new signer. Depositors call withdrawAll."
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
  note: "MEDIUM (main reviewer's LOW/MEDIUM rule): the signed function dies for good; other parties' assets leave by separate paths (owner/depositor withdraw, rescue, timeout), not by the same act. The exact ecrecover comparison does not appear in the decompilation, so which candidate is the signer is inferred. Neither candidate has non-delegation code today, so the verdict holds either way."
---

## Summary

The oracle signer is hardcoded in the bytecode, and no function can replace it. Both candidate signers have no contract code today: one is an EOA and the other is a 7702-delegated account. If the signer account gets real code, deposits and buys stop working. Depositors can still take their ENS names back through withdrawAll, which needs no signature, so nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Deposit 0xca4ab560 and buy 0xe33b6d68 both make a self-call to 0xa007a3f6 for signed-data decoding, then set store_a (floorPrice)
- No storage setter for a signer. The only owner functions are transferOwnership, renounceOwnership and updateRescuer
- Address constants pushed in the bytecode: 0x00001340… has no code (EOA); 0x32da57e7… is 7702-delegated
- withdrawAll() clears the caller's listings and calls 0x57f1…safeTransferFrom(this, msg.sender, id), with no signature check

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract with a replaceable signer or ERC-1271 support. Depositors withdraw their names with withdrawAll.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
