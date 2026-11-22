---
id: 148eafdc-fixed-signer
title: "0x148eafdc: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x148eafdc990c86a7b5deabb6aea07c10cb4dbfe7"
  family: "00857a5b8fcff9aa8a54de3253289849"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 3
  last_active: 2026-09-18
fix:
  layer: new-deployment
  who_acts: "The operator deploys a new contract with a new signer."
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
  note: "Rated MEDIUM because only new payments stop; the contract holds no user balances."
---

## Summary

The payment function accepts signatures only from the constant authorizer 0x68b3…7f48, which has no code today. If that account gets real code, new signed payments stop. No funds are locked, because payments go straight to the treasury EOA.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Unresolved_c5fc4dd1: require(0 == 0x68b3eaed7305ab80140a9b5ebc06a028acb87f48) after the signature-recovery branch (errors f645eedf/fce698f7/d78bce0c are the ECDSA errors)
- authorizer constant 597747338630935943661720556626588286799775825736 = 0x68b3eaed7305ab80140a9b5ebc06a028acb87f48, EOA (no code) at block 26438999
- transferFrom of token 0x104e…febe6 from msg.sender, with a balance check on treasury 0xae29…1e1a (EOA)
- No function writes the signer; the only setters are transferOwnership and acceptOwnership (owner), plus setPaused

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-09-18.

## Remediation

Deploy a new payment contract with a replaceable signer or ERC-1271 support, and keep the authorizer key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
