---
id: bb623896-fixed-signer
title: "0xbb623896: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbb623896fa9fa698dc0706f1cd62a26d217b1f7c"
  family: "fb9619b51b18d4f3337a43f160806e44"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator (redeploy)"
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
  rating: MEDIUM
  note: "MEDIUM: the random number only decides payouts from the operator's prize float, players risk nothing, and earned prizes stay claimable. Only operator money is at stake (currently none)."
---

## Summary

Unverified HEX jackpot: tryWin() is free (non-payable, no transferFrom) and sends a random query. The callback decides whether the caller wins pot()=10 HEX-units from the operator's HEX float. Players stake nothing. HEX and ETH balances are both 0.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a…. Same code idiom as template 0fa7b998, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Token slot 5 = HEX 0x2b591e99...; HEX.balanceOf(contract)=0; ETH balance 0 at block 26438999 [cast]
- Bytecode has no transferFrom selector (only balanceOf/transfer); tryWin is non-payable; pot()=0x0a (slot 10), cost()=0x14 [cast code grep, storage, 4byte]
- claim() pays already-credited unclaimedPrizes regardless of the callback; flushDevFees pays dev fees to slot-6 dev 0x252cab6e... [decompile]

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy if the game is wanted; nothing to recover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
