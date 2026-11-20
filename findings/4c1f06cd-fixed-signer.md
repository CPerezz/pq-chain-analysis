---
id: 4c1f06cd-fixed-signer
title: "0x4c1f06cd: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x4c1f06cdc59dd46f6d763d995e938605c0d9e8f0"
  family: "2b1798f5400b05301b6de43d244818b1"
  upgradeable: "no"
  rating: HIGH
  value_usd: 509
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator (redeploy); players cannot act"
evidence:
  level: source-read
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
  rating: HIGH
  note: "HIGH: no update path, and players' pot money has no exit (selfdestruct needs balance 0). The claimed owner/refund exit does not exist."
---

## Summary

Unverified lottery holding 0.282 ETH of players' ticket money (round pot storage_map_a). Winning numbers are set only in the Oraclize callback, and winners claim via ticket(). With every proof failing, no round settles, and nothing moves the pot out.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a…. Same code idiom as template 0fa7b998, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- ETH balance 0.282104 ETH at block 26438999; owner (slot 7 >> 24) = 0xd50abd2a32787d33804dd6e64e064e4950d8c3e2, round getStatus = 4 [cast balance/storage]
- ticket(uint256) (0xc129ff32, body at 0x11e5) does CALLER.transfer(prize) at 0x14e1, after 'no match num found' checks against the winning number set by the callback [heimdall disassemble]
- Only owner exit is 0x41c0e1b5 selfdestruct with require(balance==0); other owner functions only change settings; 0x3b7104f2 just re-queries Oraclize [heimdall decompile]
- Callback emits 'Proof Verification Failed' and does not settle on proof failure [decompile + code strings]

## Impact and exposure

- Value held at block 26,438,999: $509 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Operator redeploys with a working randomness source. Funds already in the pot cannot be recovered.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
