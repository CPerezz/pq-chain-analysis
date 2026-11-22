---
id: luckyelephantdao-28cb27e0-7702-own-key-only
title: "LuckyElephantDAO: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x28cb27e0039a2f85821e4ba3498679528c9ddbfa"
  family: "57411d0f47e95101e93115f573244308"
  name: "LuckyElephantDAO"
  upgradeable: "no"
  rating: LOW
  value_usd: 7
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "the voter (sign from a key without code)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-7702-own-key-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Mechanism is really entry-by-own-signature (recovered == msg.sender), not 7702 self-only; nothing the voter owns is locked behind the signature, so LOW holds either way. Main reviewer: consider moving to eip-8151-entry-by-own-signature-only."
---

## Summary

LuckyElephantDAO NFT-holder DAO: a signed vote is accepted only if the recovered address equals msg.sender; under EIP-8151 a voter whose account holds real code cannot cast a signed vote.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: as its template 20317d72: Opinion (NFT names): a purchase needs a message signed by the caller itself (recovered == msg.sender); a buyer whose account has code cannot buy. No funds wait on it. Template.
- heimdall: signed-vote function requires msg.sender == ecrecover(...) ("Invalid signature"), then emits SignedVoteSubmitted
- fund movement (withdrawFund/executeProposal) and collection setters are owner-gated (msg.sender == owner, Ownable 118cdaa7), not signature-gated
- ETH at block 26438999: 0.004000000000000000

## Impact and exposure

- Value held at block 26,438,999: $7 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

voter uses a key without code (or a 7702 delegation, which is exempt)

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
