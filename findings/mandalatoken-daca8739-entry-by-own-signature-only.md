---
id: mandalatoken-daca8739-entry-by-own-signature-only
title: "MandalaToken: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: none
contracts:
- address: "0xdaca87395f3b1bbc46f3fa187e996e03a5dcc985"
  family: "21fbac0f329155e890e7e93d37487515"
  name: "MandalaToken"
  label: "Mandala Tokens: MANDALA Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 24362
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 7
  last_active: 2026-11-14
fix:
  layer: none
  who_acts: "the would-be minter"
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
  note: "Entry only; nothing held is gated. value_usd 24362, txs_90d 7."
---

## Summary

MandalaToken (upgradeable ERC-721): an address mints its own token (id = signer) by signature. An address with real code can't mint its own.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: MandalaToken mint: the token's id is the address that signed; an address must sign to mint its own. Read from source.
- source exits: standard transferFrom/safeTransferFrom; transferCreatorship needs oldCreator == msg.sender (MandalaToken.sol:58)
- the signature only gates minting a new token for the signer; minted tokens move by direct ERC-721 calls

## Impact and exposure

- Value held at block 26,438,999: $24,362 (ETH and 49 priced tokens).
- Activity: 7 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

none needed; minting an address's own token is optional

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
