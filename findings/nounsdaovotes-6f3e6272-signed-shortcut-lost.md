---
id: nounsdaovotes-6f3e6272-signed-shortcut-lost
title: "NounsDAOVotes: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x6f3e6272a167e8accb32072d08e0957f9c79223d"
  family: "115dce779a8eb0b063546df74c8b7d61, a4923384906bba6a534039787ea18586"
  copies: 3
  name: "NounsDAOVotes"
  label: "Nouns DAO: Nouns DAO Proxy"
  upgradeable: "yes"
  rating: LOW
  value_usd: 16061
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 310
  last_active: 2026-11-17
fix:
  layer: offchain
  who_acts: "voters"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $16061, txs_90d 310."
---

## Summary

Nouns DAO proxy: proposals by signatures use SignatureChecker (ERC-1271 accepted); castVoteBySig and token delegateBySig recover the signer.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Nouns proposal by signatures: each signer named is checked with SignatureChecker (ECDSA, then ERC-1271) / Nouns castVoteBySig: whoever signed is the voter / Nouns token delegateBySig: whoever signed…. Read from source.
- proposeBySigs checks signers with SignatureChecker (ECDSA, then ERC-1271), so a code signer with 1271 passes (dossier source)
- castVote and propose are direct calls for the voter; delegate() direct on the token
- Same party in each pair

## Impact and exposure

- Value held at block 26,438,999: $16,061 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 310 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Voters call castVote / delegate directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
