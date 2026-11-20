---
id: dogecoin-42069313-signed-shortcut-lost
title: "Dogecoin: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
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
  note: "LOW: approve covers permit; minter signer is rotatable by a live EOA owner."
---

## Summary

Dogecoin bridge token: permit (raw ecrecover == owner) with approve; joinParty/multiJoinParty mint on a minter's signature, minters set by setMinter.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers / permit: the owner named must equal the recovered address. Read from source.
- ERC20.sol:133-140 permit requires ecrecover == _owner; approve (l.47) is the direct path
- Dogecoin.sol:17 setMinter(address,bool) ownerOnly replaces minter keys; l.27-28 joinParty requires minters[signer]
- owner() at 26438999 = 0x35AE5a983217f52652D038611c28ea7303fC8143, nonce 1, no code (EOA)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 16,535 transactions called it in the 90 days before that block; last on 2026-11-18.
- 26 signature recoveries in the study's two-week trace window.

## Remediation

affected party uses the direct call

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
