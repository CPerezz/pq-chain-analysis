---
id: musd-37a30961-signed-shortcut-lost
title: "MUSD: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x37a309611e1d278cddc341e479957ec8bc6256ce"
  family: "95e33c698adb6bd2f09101f3fefefd45"
  copies: 2
  name: "MUSD"
  label: "MetaMask: mUSD Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 142060
  last_active: 2026-11-18
  recoveries_14d: 13
fix:
  layer: offchain
  who_acts: "the affected holder (signer with code)"
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
  note: "Partly handled by 1271; the direct twins make it LOW either way. Value $1985, txs_90d 142060 (not rating inputs)."
---

## Summary

MetaMask mUSD (M0 extension): the (v,r,s) permit and transferWithAuthorization variants are ECDSA-only; the bytes-signature variants try ECDSA, then ERC-1271. A holder with code can use the 1271 variant if its code supports it, or approve/transfer directly.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: ECDSA first; if it fails the signer's ERC-1271 is asked / returns the recovered signer to its caller / permit: the owner named in the call must equal the recovered address; the holder can call…. Read from source. Executed: a real transaction reverts with code at the signer.
- source ERC712ExtendedUpgradeable.sol: _revertIfInvalidSignature(signer,digest,bytes) falls back to isValidERC1271Signature; the (v,r,s) and (r,vs) overloads are pure ECDSA
- approve/transfer present

## Impact and exposure

- Value held at block 26,438,999: $1,985 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 142,060 transactions called it in the 90 days before that block; last on 2026-11-18.
- 13 signature recoveries in the study's two-week trace window.

## Remediation

Use approve/transfer, or the bytes-signature overload with ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
