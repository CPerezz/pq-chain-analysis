---
id: captainzreserve-da7fb915-rotate-signer-before-migrating
title: "CaptainzReserve: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xda7fb91545545d044a9fd118f85a4f10a8d4c6b5"
  family: "18a9cecdf2b951c9acabf06a03e09402"
  copies: 2
  name: "CaptainzReserve"
  label: "deployed by Memeland: Deployer"
  upgradeable: "yes"
  rating: LOW
  value_usd: 15519
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner (EOA 0x1c593c36…)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Setter with a live EOA owner (the proxy is also upgradeable)."
---

## Summary

CaptainzReserve checkValidity requires ECDSA.recover == signer. Reserve actions stop if the signer key holds code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- CaptainzReserve.sol:49-63: recover(...) == signer
- CaptainzReserve.sol:117 setSigner onlyOwner (OwnableUpgradeable)
- owner() 0x1c593c36…: EOA, nonce 1930; signer 0x069e8e09…, nonce 0

## Impact and exposure

- Value held at block 26,438,999: $15,519 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner calls setSigner with a fresh EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
