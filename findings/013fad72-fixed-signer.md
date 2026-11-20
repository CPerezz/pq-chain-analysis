---
id: 013fad72-fixed-signer
title: "0x013fad72: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x013fad72c26f4491b49719000c119c4eff93f089"
  family: "70a2ceefb056344b4bb114c114c13c27"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "Nobody needs to act. Holders keep moving tokens with transfer/transferFrom. Only the hidden burn-by-signature path would stop working."
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
  note: "MEDIUM (main reviewer's LOW/MEDIUM rule): the signed function dies for good; other parties' assets leave by separate paths (owner/depositor withdraw, rescue, timeout), not by the same act. The study note's 'presale' description does not match this code: it is a honeypot token with a hidden burn function. I rated LOW because users' tokens stay movable without any signature."
---

## Summary

The signer is a fixed constant and the address is a 7702-delegated EOA today, so the claim holds. But the signature only powers a hidden burn/freeze of holders' balances. If ecrecover stopped recovering for this key, no user funds would be locked; one attack path would stop, and the signer could still call launch(address) directly.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- AUTH_SIGNER is a constant: 0x2fe358821842976cf280969F6525F382a84B935f. On-chain it has code_bytes=23 and delegated=true, so it is a 7702-delegated EOA.
- launch(address,uint256,uint8,bytes32,bytes32): ecrecover(digest,v,r,s) must equal AUTH_SIGNER. It then sets _balances[victim]=0, adds the balance to _balances[dead], and sets transferAllowed[victim]=true.
- _transferAllowed returns false when transferAllowed[from] is true, so a launched victim cannot transfer.
- transfer and transferFrom need no signature.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Nothing needed for users. Losing the signature path would only switch off a malicious burn.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
