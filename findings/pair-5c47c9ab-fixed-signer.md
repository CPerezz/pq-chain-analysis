---
id: pair-5c47c9ab-fixed-signer
title: "Pair: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5c47c9ab05716d26d6e339eb19d2be3a0b0b097e"
  family: "029dd84e708de49a39113be1b533ccda"
  copies: 69
  name: "Pair"
  upgradeable: "no"
  rating: LOW
  value_usd: 22835
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3
  last_active: 2026-10-26
fix:
  layer: onchain-config
  who_acts: "the filter contract's owner points it at a new Reservoir oracle address"
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
  rating: LOW
  note: "oracle address replaceable; liquidity exits unaffected"
---

## Summary

`Pair` (Caviar) at `0x5c47c9ab05716d26d6e339eb19d2be3a0b0b097e`, with 68 more pairs. Wrapping NFTs needs a Reservoir oracle message, checked by a separate filter contract whose owner can replace the oracle address; nothing else needs it.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Caviar pair: the price message must be signed by the Reservoir oracle address (text cut; fixed in the oracle contract by design) / solmate permit: the recovered address must be the owner named in the…. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read: only wrap (and nftSell through it) passes messages to StolenNftFilterOracle.validateTokensAreNotStolen; that contract's updateReservoirOracleAddress (onlyOwner) replaces the oracle key.
- remove, nftRemove, nftBuy, close and withdraw do not use the oracle.
- No proxy, no upgrade. 3 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $22,835 (ETH and 49 priced tokens, over 69 addresses).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-10-26.

## Remediation

The filter owner updates the oracle address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
