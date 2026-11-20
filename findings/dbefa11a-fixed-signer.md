---
id: dbefa11a-fixed-signer
title: "0xdbefa11a: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdbefa11a2b2104dd345fc85cc473e3472a9561a3"
  family: "f5f44e6839db99dfb61ab471a1b198f1"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator/owner redeploys with a new signer and calls withdraw() to move the remaining tokens."
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
  note: "The study note calls this a presale with deposit and claim, but the code only has a signed airdrop claim. There is no user deposit. The signer's current code size is not in the row facts. The constructor checked that the signer had no code at deploy time, so I am treating it as an EOA, but its code size today should be checked."
---

## Summary

The signer is immutable and has no setter. If the signer's account gets real code, claims stop working. The owner can still pull all tokens with withdraw(), so nothing is locked. Only the claim function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable signer`; the constructor assigns `signer = signer_`
- The constructor requires `!signer_.isContract()`. This is checked only at deploy time, and there is no code check or ERC-1271 path when claims are verified
- claim(): ECDSA.recover(...) followed by `if (_signer != signer) revert InvalidSignature()`
- withdraw() onlyOwner transfers the full token balance to the owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new distributor with a signer that can be rotated or that is checked through ERC-1271, then move the funds out of this one with withdraw().

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
