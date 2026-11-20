---
id: 985ed8da-fixed-signer
title: "0x985ed8da: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x985ed8dad51072edbba17ead71128e2c00f0a5bf"
  family: "3cd39e7a452035e27f68ed93613b1bc3"
  copies: 3
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "owner redeploys; users exit with withdrawAll"
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
  note: "MEDIUM (main reviewer's LOW/MEDIUM rule): the signed function dies for good; other parties' assets leave by separate paths (owner/depositor withdraw, rescue, timeout), not by the same act. The ecrecover call and the address it compares against are not shown in the decompilation. Either candidate address is fixed and has no real code today, so the verdict is the same either way."
---

## Summary

The oracle signer is fixed in bytecode with no setter, and both candidate addresses have no real code today (one plain account, one 7702-delegated). If the key's account gets real code, deposits and buys stop, but users can still recover their NFTs with withdrawAll.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 0xca4ab560 and 0xe33b6d68 self-call 0xa007a3f6 with the message and store the result as floorPrice (store_a)
- The only setters are transferOwnership, renounceOwnership (0x715018a6) and updateRescuer; none changes a signer
- withdrawAll (0x853828b6) clears the caller's listings and calls safeTransferFrom(this, msg.sender) on 0x57f1887a… with no signature
- 0x32da57e7… is 7702-delegated and 0x00001340… has no code (block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a signer the owner can rotate, or accept ERC-1271 signatures; users can leave the current contract with withdrawAll.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
