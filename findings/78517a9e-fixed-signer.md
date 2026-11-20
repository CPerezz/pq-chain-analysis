---
id: 78517a9e-fixed-signer
title: "0x78517a9e: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x78517a9e0eda44742873304536071bf410628a07"
  family: "205072c2c6fbfc979a765b3c837e65a1"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator holding the key for 0x81f7…6393 must not give that account real code. If it does, a new contract would be needed, but the ETH already held cannot be moved."
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
  note: "The study note's 'presale, deposit and claim need a signature' is wrong. Only claim needs a signature; participate does not. Rated HIGH because participants' deposits can only leave through claim(), which needs the fixed signer's signature, and there is no rescue function."
---

## Summary

The signer is a hardcoded constant that has no code today (0 bytes, not delegated). It cannot be replaced, and the contract cannot be upgraded. The only way ETH leaves the contract is claim(), which needs this signer's signature. If the signer account gets real code, ecrecover stops matching and every participant's pooled entry fee is locked for good.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- verifySignature compares ecrecover to the literal 0x81f755788e49dCe5E47c1a99369296Ff15736393
- Row facts: constants[0].code_bytes=0, delegated=false; upgradeable=no
- participate() is payable and adds msg.value to totalPool/pricePool, forwarding only royalties
- claim() is the only function that transfers pool ETH (payable(tx.origin).transfer(_voucher.ammount)) and requires verifySignature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the signer key as a plain EOA, or at most a 7702 delegation. Do not deploy real code to that account. Future pools should use a replaceable signer and include an owner refund/rescue path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
