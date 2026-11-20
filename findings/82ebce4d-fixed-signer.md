---
id: 82ebce4d-fixed-signer
title: "0x82ebce4d: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x82ebce4d425971feff6aff3119d9436ac508eea3"
  family: "aaf4750d94c80856d879d75328f9d7f6"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator, who would deploy a new reward contract with a new signer."
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
  note: "The decompiled claim is cut off, so I can't tell whether the rewards are paid from a token balance the contract holds or minted through the fly or pilot contracts. If the contract holds an operator-funded fly balance, there is no rescue function, so that balance would also be locked. That would argue for HIGH. The rating is MEDIUM on the mechanism visible in the code: only reward claims stop."
---

## Summary

The signer is the hardcoded address 0xc90a5663326637d6c852258400ca9643ca4aef5f, which has no code today (an EOA). No setter can change it and the contract has no upgrade path. If that account ever gets code, every claim fails. Users lose no deposits. Only the operator's rewards stop being paid.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- claim: require(recovered == 0xc90a5663326637d6c852258400ca9643ca4aef5f, "Invalid signature")
- constant signer = 1147737677799113653774564405151370472984620494687 = 0xc90a5663326637d6c852258400ca9643ca4aef5f
- Verified facts: 0xc90a5663326637d6c852258400ca9643ca4aef5f has no code at block 26438999
- The only owner functions are transferOwnership, renounceOwnership, pause, unpause and setEmissionMul. None of them touches the signer.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new reward contract that takes a replaceable signer or accepts ERC-1271 signatures, and point users to it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
