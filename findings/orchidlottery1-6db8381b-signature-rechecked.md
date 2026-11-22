---
id: orchidlottery1-6db8381b-signature-rechecked
title: "OrchidLottery1: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x6db8381b2b41b74e17f5d4eb82e8d5b04dda0a82"
  family: "69f4295e801cf8a63b6e8c01e6366d39"
  name: "OrchidLottery1"
  label: "deployed by Orchid: Deployer"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 5609
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 11
  last_active: 2026-11-12
fix:
  layer: new-deployment
  who_acts: "Orchid (new lottery contract); funders whose signer may take code"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signature-rechecked"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: "The recipient who relied on signed tickets loses them while the funder keeps a timeout exit; no update path."
---

## Summary

Orchid OrchidLottery1: a recipient serves bandwidth for probabilistic tickets signed by the funder's signer key and claims a winning ticket later from the funder's escrow. If the signer address takes code, ecrecover returns nothing, the escrow key no longer matches, and the recipient's winning tickets pay nothing. Meanwhile the funder can still pull the escrow through edit() after the warn delay.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Orchid lottery claim: a ticket signed by the signer of a funder's account pays the recipient out of that account's deposit. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- lottery1.sol:298 claim_: signer = ecrecover(digest, …); 301: key = keccak(token, funder, signer) selects the escrow
- edit()/edit_ (62-170): the funder (msg.sender) withdraws with warn/unlock after day_, with no signature
- no proxy, no upgrade function; 11 txs in 90 days, last 2026-11-12

## Impact and exposure

- Value held at block 26,438,999: $5,609 (ETH and 49 priced tokens).
- Activity: 11 transactions called it in the 90 days before that block; last on 2026-11-12.

## Remediation

None on chain: recipients should stop accepting tickets from signers that may take code; a new lottery would have to accept ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry.
