---
id: pair-5c47c9ab-signed-shortcut-lost
title: "Pair: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x5c47c9ab05716d26d6e339eb19d2be3a0b0b097e"
  family: "029dd84e708de49a39113be1b533ccda"
  copies: 69
  name: "Pair"
  upgradeable: "no"
  rating: LOW
  value_usd: 22918
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3
  last_active: 2026-10-26
fix:
  layer: offchain
  who_acts: "holders; Caviar owner (EOA)"
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $22918, txs_90d 3."
---

## Summary

Caviar NFT AMM pair: solmate permit on the LP token, and wrap() checks a Reservoir oracle signature via an external filter contract.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Caviar pair: the price message must be signed by the Reservoir oracle address (text cut; fixed in the oracle contract by design) / solmate permit: the recovered address must be the owner named in the…. Read from source.
- LP token is solmate ERC20 with permit and approve (lib/solmate ERC20.sol:68)
- wrap() calls caviar.stolenNftFilterOracle().validateTokensAreNotStolen(...) (Pair.sol:264-277, 563-573); the oracle address is replaceable by updateReservoirOracleAddress (onlyOwner) and the filter by Caviar.setStolenNftFilterOracle (onlyOwner)
- caviar() = 0xa964D6E8d90E5Cd12592a8EF2b1735daE9Ba0840; its owner at block 26438999 = 0x6E1696C2f1Ab89f9C2f8275fC48C8D5BE9522180, EOA, nonce 25

## Impact and exposure

- Value held at block 26,438,999: $22,918 (ETH and 49 priced tokens, over 69 addresses).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-10-26.

## Remediation

Holders approve directly; the Caviar owner can rotate the oracle or filter.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
