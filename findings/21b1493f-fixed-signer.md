---
id: 21b1493f-fixed-signer
title: "0x21b1493f: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x21b1493fcf71b200d5f2ede6ea01b9a57ee00e97"
  family: "94dc0a75019ca415e9483448cbce677e"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "The owner (sets the payer) and the payer, or the creators, who can reclaim their own deposits."
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
  note: "MEDIUM (main reviewer's LOW/MEDIUM rule): the signed function dies for good; other parties' assets leave by separate paths (owner/depositor withdraw, rescue, timeout), not by the same act. The study note calls this a presale. The code shows a red-envelope giveaway. In finalWithdraw the decompiler shows two contradicting amount checks (arg1 != field_3 and then arg1 == field_3). This is most likely a decompiler error, and the intended check is probably arg1 == field_3."
---

## Summary

The grab signature must come from a constant EOA (0x8a4d...112a), and the code has no setter for it and no ERC-1271 check, so the claim is confirmed. If that key's account gets real code, only signed grabs stop. Grabbers can still be paid through the payer path (77a6c25a), and the owner can change the payer. Creators can take back the remainder with finalWithdraw after 1 day, which needs no signature. Nobody's funds get locked, so the rating is LOW.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Unresolved_a007964e: require(address(var_v) == 0x8a4dc3aacabe67fc6d1231b884ccb283f54a112a, "Grab: Not eligible for grab"); the verified facts show this address has no code (EOA)
- No function writes the signer: it is a value pushed in the bytecode
- Unresolved_77a6c25a: require(msg.sender == store_f, "only call by signer") pays arg2 without any signature
- setPayer(address): onlyOwner, writes store_d/store_f (slot 2)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No contract change is needed. If signed grabs break, the owner sets a working payer with setPayer and pays grabbers through 77a6c25a, or creators take back their remainder with finalWithdraw.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
