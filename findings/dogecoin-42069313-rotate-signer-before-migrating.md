---
id: dogecoin-42069313-rotate-signer-before-migrating
title: "Dogecoin: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4206931337dc273a630d328da6441786bfad668f"
  family: "1c6a77350507377e989f29f53276398b"
  name: "Dogecoin"
  upgradeable: "no"
  rating: LOW
  txs_90d: 16535
  last_active: 2026-11-18
  recoveries_14d: 26
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x35ae…8143"
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
  note: "setter callable by an EOA (nonce 1: it has sent a transaction, but its last use is unknown)."
---

## Summary

Dogecoin bridge token: joinParty mints need a minter's signature; a minter with code fails. permit also present (approve stays open).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers / permit: the owner named must equal the recovered address. Read from source.
- Dogecoin.sol:17 setMinter(address,bool) ownerOnly; eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0x35ae5a98… EOA, nonce 1

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 16,535 transactions called it in the 90 days before that block; last on 2026-11-18.
- 26 signature recoveries in the study's two-week trace window.

## Remediation

Owner adds a new minter key and removes the old.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
