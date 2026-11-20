---
id: dd233d87-rotate-signer-before-migrating
title: "0xdd233d87: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdd233d8721f92c80fc29fe683dbd9e326207a6bf"
  family: "8791bc2c55394dec3a8aa766eb240133"
  copies: 2
  upgradeable: "no"
  rating: LOW
  txs_90d: 4485
  last_active: 2026-11-18
  recoveries_14d: 806
fix:
  layer: onchain-config
  who_acts: "owner EOA 0xfFeA…c01a"
evidence:
  level: bytecode
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
  note: "Setter exists and the owner is a live EOA, so LOW holds."
---

## Summary

Contract checks signatures against a single stored signer (store_c). Under EIP-8151 those signatures fail once the signer key's account holds code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (changeSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- changeSigner(address) (0xaad2b723) writes the signer slot, gated by require(owner == msg.sender, 'Ownable: caller is not the owner') (decompile)
- owner() = 0xfFeAea321cf9A7a606B33351073fCc92f1eac01a, an EOA with nonce 9, at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 4,485 transactions called it in the 90 days before that block; last on 2026-11-18.
- 806 signature recoveries in the study's two-week trace window.

## Remediation

The owner calls changeSigner to set a new EOA before the current signer migrates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
