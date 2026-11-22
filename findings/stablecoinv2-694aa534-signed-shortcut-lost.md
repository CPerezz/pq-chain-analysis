---
id: stablecoinv2-694aa534-signed-shortcut-lost
title: "StablecoinV2: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x694aa534bdef8ed63244eb902e7914e527891f08"
  family: "3ad5c9cbfb4ed95e1fdf9accd606d904"
  copies: 2
  name: "StablecoinV2"
  label: "WLFI: USD1 Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 27249
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 52582
  last_active: 2026-11-18
  recoveries_14d: 22
fix:
  layer: offchain
  who_acts: "the holder"
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $27249, txs_90d 52582."
---

## Summary

StablecoinV2: OZ4 permit and EIP-3009 transfer/cancel authorisations recover to the holder; under EIP-8151 a holder with code cannot use them.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 4 upgradeable permit / a transfer authorisation: the holder named must equal the recovered address; the holder can call transfer itself. Read from source. Executed: a real transaction reverts with code at the signer.
- _isValidSignature: tryRecover == _authorizer, no ERC-1271 (StablecoinV2.sol:431-441); the ERC-1271 hits are OZ library files only
- transfer/approve are ordinary direct calls for the holder (dossier source)
- Same party in both paths

## Impact and exposure

- Value held at block 26,438,999: $27,249 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 52,582 transactions called it in the 90 days before that block; last on 2026-11-18.
- 22 signature recoveries in the study's two-week trace window.

## Remediation

The holder calls transfer / approve itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
