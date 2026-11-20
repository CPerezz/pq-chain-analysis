---
id: 33d71bca-fixed-signer
title: "0x33d71bca: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x33d71bca7a80aa5b9c8e8f681e239dfe6ac36e14"
  family: "5bdf8099cf3b954c5f038559e2bec484"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Operator redeploys with a new signer"
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
  note: "The decompiled payout in claim is cut off, so it is unclear whether rewards are minted or sent from tokens the contract holds. If the contract holds FLY, that balance has no rescue function and would be stuck, which would raise the rating to HIGH. MEDIUM assumes claims of new emissions simply stop."
---

## Summary

claim() only accepts signatures from the hard-coded signer 0xc90a…ef5f, which has no code today and cannot be replaced. If that key's account gets code under EIP-8151, reward claims stop. No user deposits are held, so only the reward function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- signer() is a constant equal to 0xc90a5663326637d6c852258400ca9643ca4aef5f; claim compares the recovered address to this literal ('Invalid signature')
- transferOwnership writes only the owner slot (store_d); renounceOwnership/pause/unpause/setEmissionMul do not touch the signer
- Verified at block 26438999: 0xc90a…ef5f has no code (plain account)
- There is no deposit function and no withdraw or rescue function; upgradeable: no

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new reward contract whose signer can be rotated or that accepts smart-contract (ERC-1271) signatures. Keep 0xc90a…ef5f as a plain account or a 7702-delegated account.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
