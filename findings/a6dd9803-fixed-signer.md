---
id: a6dd9803-fixed-signer
title: "0xa6dd9803: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa6dd98031551c23bb4a2fbe2c4d524e8f737c6f7"
  family: "9e30282a2d4b2c4f36573dc62dfdb696"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 188
  last_active: 2026-11-17
fix:
  layer: new-deployment
  who_acts: "Owner: turn off claims with setClaimLive(false), then call transferToTreasury and hand out the tokens by another route"
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
  note: "The study note calls this a presale with deposits. The code has no deposits: claim mints new tokens. The signer address was inferred as the one bytecode address that does not match a named constant. Even if that inference is wrong, every address pushed in the bytecode is an EOA."
---

## Summary

The claim signer is an immutable address with no setter and no ERC-1271 path, and it has no code today. If that key's account gets real code, claims stop working. Only unminted airdrop supply is affected, and the owner can mint that remainder to the treasury, so nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable signerAddress` is assigned only in the constructor
- signerValid returns `ecrecover(digest, v, r, s) == signerAddress`
- the only address pushed in the bytecode that is not a named constant is 0xb6614ef9e2797043273d22c898b63bc524e68389, which is an EOA with no code
- transferToTreasury mints `AIRDROP_AMOUNT + REFERRALS_AMOUNT - claimedAmount - rewardsAmount` to the treasury (onlyOwner, requires !claimLive)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 188 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Use the owner's transferToTreasury fallback to mint the unclaimed supply and distribute it some other way, or deploy a new claim contract whose signer can be replaced.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
