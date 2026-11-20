---
id: hydro-241e82c7-entry-by-own-signature-only
title: "Hydro: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0x241e82c79452f51fbfc89fac6d912e021db1a3b7"
  family: "417509362bfecbe56da77353f3af2217"
  name: "Hydro"
  label: "DDEX: Margin"
  upgradeable: "no"
  rating: LOW
  value_usd: 244337
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 71
  last_active: 2026-11-10
  recoveries_14d: 2
fix:
  layer: account-migration
  who_acts: "the trader"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Only trading via signed orders is lost; funds stay reachable by direct calls from the owner, so LOW holds. value_usd 244337, txs_90d 71."
---

## Summary

DDEX Hydro margin exchange: matched orders need the trader's ECDSA signature. A trader whose address holds real code can't have orders matched, but every balance action is a direct msg.sender call.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: Hydro order: the trader named must have signed (eth_sign or EIP-712); there is no on-chain order and no contract signature. Read from source. Executed: a real transaction reverts with code at the signer.
- source BatchActions ActionType: Deposit, Withdraw, Transfer, Borrow, Repay, Supply, Unsupply are run through batch() for msg.sender (withdraw ~l.1708, repay ~l.1819 pass msg.sender)
- source l.762 cancelOrder requires order.trader == msg.sender (direct)
- signature is checked only on orders (Signature.isValidSignature, no ERC-1271)

## Impact and exposure

- Value held at block 26,438,999: $244,337 (ETH and 49 priced tokens).
- Activity: 71 transactions called it in the 90 days before that block; last on 2026-11-10.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

The trader keeps a 7702 delegation to trade, or exits balances and margin debt directly via batch() (withdraw, repay, transfer).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
