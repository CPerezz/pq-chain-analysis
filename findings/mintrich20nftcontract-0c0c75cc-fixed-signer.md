---
id: mintrich20nftcontract-0c0c75cc-fixed-signer
title: "MintRich20NFTContract: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x0c0c75cc2e7a157ed22232044a4007fac8070fc3"
  family: "f156689abcea35e180b070976a99163a"
  copies: 25
  name: "MintRich20NFTContract"
  upgradeable: "no"
  rating: HIGH
  value_usd: 4432
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 10
  last_active: 2026-11-09
fix:
  layer: new-deployment
  who_acts: "MintRich (no on-chain remedy)"
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
  note: "No update path, and the fee pool owed to reward claimants has no exit other than signed claims."
---

## Summary

MintRich20 NFT-token clone: accumulated trading fees (totalFees - claimedFees) leave only through claimRewards, which needs a signature from the constant REWARDS_SIGNER. If that key takes code, the fee pool is stuck.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: MintRich: rewards claims are signed by a signer the scanner sees as a constant; plus a permit. Read by hand.
- Update path, read at block 26,438,999: delegates to a fixed address.
- EIP-1167 clone of 0x8daaebb56a513bf51b87749a69f8a9fe8c5a34f7; no EIP-1967 slot; implementation fixed
- MintRichCommonStorage.sol:23 REWARDS_SIGNER = 0xD23430aA3546c245c03eC1d3a2ab5D80CD98607E (constant), cast code 0x; claimRewards requires recover == REWARDS_SIGNER (MintRich20NFTContract.sol:242)
- At 26438999: totalFees 0.3417 ETH, claimedFees 0.0216 ETH, balance 0.3201 ETH; processSaleClosed (admin) uses saleBalance() only, never the fee pool

## Impact and exposure

- Value held at block 26,438,999: $4,432 (ETH and 49 priced tokens, over 25 addresses).
- Activity: 10 transactions called it in the 90 days before that block; last on 2026-11-09.

## Remediation

None on-chain; MintRich can only deploy new contracts; fees here stay locked once the signer has code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
