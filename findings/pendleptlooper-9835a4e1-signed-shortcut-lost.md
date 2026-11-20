---
id: pendleptlooper-9835a4e1-signed-shortcut-lost
title: "PendlePTLooper: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x9835a4e15fd34f8d3217beffaa011fab9b8bea0b"
  family: "1518210329a706bb66515747c1b388ec"
  copies: 4
  name: "PendlePTLooper"
  label: "deployed by Pendle: Deployer 1"
  upgradeable: "no"
  rating: LOW
  txs_90d: 12891
  last_active: 2026-11-18
  recoveries_14d: 700
fix:
  layer: none
  who_acts: "the affected signer, by calling directly"
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
  note: "LOW: the owner can call approveRequest itself; checker is replaceable by the owner; 1271 already handled for contracts."
---

## Summary

Pendle PT looper: execute needs the stored checker's signature and approveRequest the owner's, both via OZ SignatureChecker (ECDSA, else ERC-1271).

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: SignatureChecker on a signer kept in storage (ECDSA, or its ERC-1271 if it is a contract) / the owner calls itself, or its signature is checked by SignatureChecker. Read from source. Executed: a real transaction reverts with code at the signer.
- PTLooperBase.sol:58 execute uses SignatureChecker.isValidSignatureNow(checker,...); l.93 setChecker onlyOwner
- PTLooperBase.sol:137 approveRequest accepts msg.sender == owner directly, or the owner's signature
- ERC-1271 fallback covers contract signers that implement it; a code-bearing signer without 1271 fails

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 12,891 transactions called it in the 90 days before that block; last on 2026-11-18.
- 700 signature recoveries in the study's two-week trace window.

## Remediation

affected party uses the direct call

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
