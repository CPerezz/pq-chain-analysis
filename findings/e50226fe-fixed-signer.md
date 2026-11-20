---
id: e50226fe-fixed-signer
title: "0xe50226fe: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe50226fefcc9ccbd3a216b5256679f9df1e37132"
  family: "c25530ab34591deaf0b2fc6479ee3693"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner or operator would need to deploy a new redeemer with a new signer, and the registry 0x3fb1… would need to accept that redeemer."
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
  note: "The study note calls this a presale with deposit and claim. The code shows NFT/1155 redemption with payment taken at call time. Whether the registry 0x3fb1… lets other redeemers in was not checked, so it is unknown whether there is a fallback path."
---

## Summary

Confirmed. The signer is the hard-coded constant 0x3f93…e105, and that address has no code today. No function can replace it, and the code has no code-check or ERC-1271 fallback. If that account ever gets real code, redemptions stop. Nothing is locked: users only pay ETH when they redeem, and the owner can withdraw any balance with withdraw(). Rated MEDIUM because only a function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Both redeem functions (0x6d63fe94 and 0x9429cf0e) contain: require(recovered == 0x3f93dbe17b6ebeb073759288b52504d92192e105, "Signature invalid or unauthorized")
- Verified facts: 0x3f93…e105 is an EOA with no code (code_bytes 0, not delegated)
- transferOwnership/renounceOwnership write only the owner (slot 0), not the signer
- The code shows no extcodesize check on the signer and no isValidSignature call

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new redeemer with a signer that can be replaced, or with ERC-1271 support, and have the registry 0x3fb1… authorize it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
