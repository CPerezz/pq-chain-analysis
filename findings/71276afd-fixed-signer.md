---
id: 71276afd-fixed-signer
title: "0x71276afd: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x71276afd922f48721035b2b112413215a2627f6e"
  family: "dda01156e68ad88f74f01b74ccad9e21"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 1
  last_active: 2026-09-26
fix:
  layer: new-deployment
  who_acts: "The project owner would need to deploy a new contract, or hand out tokens through reserveMint"
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
  note: "The study note calls this a presale with deposit and claim. The code shows an NFT mint with a signed coupon and no deposit/claim functions. The decompiled mint body is cut off, so I can't tell from it whether mint takes ETH. No withdraw function is visible either way, so any ETH held does not depend on the signature."
---

## Summary

The coupon signer is the constant 0x96113cec…caf, an EOA today, and no function can change it. If that key's account gets code, coupon mints stop. Tokens already minted stay transferable and nothing is locked, so this is a liveness problem rated MEDIUM.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- mint (0x8395dab9): require(address(var_q) == 0x96113cec2defde1b6d8e7050cbe4d9b17e620caf, "Invalid coupon")
- Verified facts: 0x96113cec2defde1b6d8e7050cbe4d9b17e620caf has no code (EOA) at block 26438999
- The only setters are transferOwnership and renounceOwnership, which write the owner slot and not the signer
- There is no code-size check and no ERC-1271 path for the signer

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-26.

## Remediation

Deploy a new mint contract with a signer that can be rotated, or one that accepts ERC-1271. Alternatively, the owner can distribute tokens through reserveMint.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
