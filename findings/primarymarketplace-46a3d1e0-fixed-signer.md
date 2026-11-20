---
id: primarymarketplace-46a3d1e0-fixed-signer
title: "PrimaryMarketplace: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x46a3d1e012c83f92722f67368073d810dac6b9d6"
  family: "74d7cc42d0481b27c3edf2de75cc9367"
  copies: 2
  name: "PrimaryMarketplace"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 677
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "marketplace owner"
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
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "No update path; one function dies, funds stay withdrawable by direct calls → MEDIUM."
---

## Summary

payForBid requires a signature by the private owner, set in the constructor with no transfer function. buyEdition, transferEdition, withdraw and closeMarket are direct calls, so only bid settlement dies.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: PrimaryMarketplace payForBid: the owner, set in the constructor with no transfer, signs each winning price; buyEdition and withdraw are direct calls, so only bid payments stop (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- PrimaryMarketplace.sol: owner = msg.sender in constructor; no setter
- payForBid: recoverSignerAddress(...) == owner
- owner (slot 6) = 0x4297cd9f411cf116251549abbdf5b5a52487b7cb, code 0x today
- withdraw(receiver) by owner/creators and transferEdition by owner need no signature

## Impact and exposure

- Value held at block 26,438,999: $677 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner settles auctions via transferEdition or stops auctions.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
