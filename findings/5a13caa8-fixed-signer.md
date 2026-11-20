---
id: 5a13caa8-fixed-signer
title: "0x5a13caa8: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x5a13caa82851342e14cd2ad0257707cddb8a31b7"
  family: "0261295d12cad4757c99a608b47afff3"
  upgradeable: "no"
  rating: HIGH
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
  note: "HIGH: stakes in any pot have no exit without the callback; the owner has no withdraw. Today's balance is only 50 wei, but value never lowers the rating."
---

## Summary

EthereumPot: players' stakes enter the pot; the winner and fee are credited only in the __callback, which uses the oraclize_randomDS_proofVerify modifier. withdrawBalance() pays only credited balances. No owner or refund path exists. Currently potSize=3, endTime passed, balance 50 wei.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a…. Same code idiom as template 0fa7b998, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- withdrawBalance() pays only balances[msg.sender], which is credited only inside __callback; there is no owner withdraw or selfdestruct [sourcify source]
- joinPot throws once now > endTime; the pot reopens only via openPot() inside __callback (rewardWinner calls update() when potSize>0) [source]
- potSize()=3, locked=false, endTime 1752311543 < block time 1794969479, owner 0x14ce9458...; ETH balance 50 wei at block 26438999 [cast]

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a working randomness source. Stakes in an unsettled pot cannot be recovered.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
