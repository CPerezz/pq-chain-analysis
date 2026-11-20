---
id: piratelottery-aeb12b5a-own-signature-only-exit
title: "PirateLottery: funds released only by the party's own signature"
status: confirmed
severity: HIGH
patterns: [PQ-16]
impact: funds-loss
contracts:
- address: "0xaeb12b5ab62a49c14e72fb3ad2c0e809a9b446b3"
  family: "5868423f7f310a6d8f152c403d2e95c4"
  copies: 2
  name: "PirateLottery"
  upgradeable: "no"
  rating: HIGH
  value_usd: 234
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "winning ticket holders"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-own-signature-only-exit"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "Winner's own prize unreachable, locked contract, no update path -> HIGH."
---

## Summary

Lottery: a winner claims the prize only with an ECDSA signature that recovers to the ticket's recorded owner. A winner whose account has code cannot claim, and after MAX_CLAIM_DURATION another participant takes the prize through claimAbondonedPrize.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: PirateLottery claimPrize: the winning ticket's recorded owner must sign the claim; no claim without the signature. Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source/PirateLottery.sol claimPrizeForTicket L302-308: ecrecover(domain hash) must equal ticketOwners[ticket]; claimPrize/claimAbondonedPrize both go through it
- The only other ETH paths are withdraw() of credited balances and killContract() (ownerOnly + unlockedOnly); isLocked()=true at block 26438999, so the owner has no rescue
- owner()=0x707b..9f9b (EOA); roundCount()=6; balance 0.1 ETH (row value $234); txs_90d=0
- No proxy, no upgrade function

## Impact and exposure

- Value held at block 26,438,999: $234 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Winners must keep their ticket-buying key as an EOA or 7702 account; a fix needs a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-own-signature-only-exit` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
