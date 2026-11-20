---
id: simpleaccount-e9a02ce2-signed-shortcut-lost
title: "SimpleAccount: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xe9a02ce2319bbc263baab66f8f6b74305cf42777"
  family: "c43fd5ca18cb64065bcadf7c2d1c4bf4"
  copies: 613
  name: "SimpleAccount"
  label: "deployed by Pimlico: ERC-4337 Bundler 2"
  upgradeable: "yes"
  rating: LOW
  value_usd: 7940
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 808
  last_active: 2026-11-18
  recoveries_14d: 87
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code"
evidence:
  level: executed
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025)"
---

## Summary

`SimpleAccount` at `0xe9a02ce2319bbc263baab66f8f6b74305cf42777` (Etherscan tag: deployed by Pimlico: ERC-4337 Bundler 2), with 612 more addresses running its code. It lets a user act through an ECDSA signature or by a direct call; a user whose account has code loses the signed path only.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: SimpleAccount: user operations need the owner's ECDSA signature and the owner has no setter; execute also accepts a direct call from the owner (read), and the owner may upgrade the code. Read (same text as a family read). Executed: a real transaction reverts with code at the signer.
- Reviewed through the root issue's mechanism (D-025): the reading states a direct path for the signed act (approve next to permit, delegate next to delegateBySig, castVote next to castVoteBySig, a direct call next to a meta-transaction, or an order the maker can place or approve on chain), so a holder whose account has code keeps the act: LOW
- Mechanical checks: where the reading names permit, delegateBySig or castVoteBySig, this address's code holds that function and its direct twin; the scanner finds an ecrecover call in the code
- A random sample of 25 of the 18,891 rows below Anon's thresholds: 24 held at LOW, 1 (an NFT exchange whose orders can only be signed) was MEDIUM; readings of that kind were sent to one-by-one checks

## Impact and exposure

- Value held at block 26,438,999: $7,940 (ETH and 49 priced tokens, over 613 addresses).
- Activity: 808 transactions called it in the 90 days before that block; last on 2026-11-18.
- 87 signature recoveries in the study's two-week trace window.

## Remediation

None needed for funds; add ERC-1271 to keep gasless flows.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
