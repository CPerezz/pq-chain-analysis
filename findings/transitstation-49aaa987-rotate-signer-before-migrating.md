---
id: transitstation-49aaa987-rotate-signer-before-migrating
title: "TransitStation: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x49aaa987b1a7e9e4ae091dcd8332c39f322d7d28"
  family: "9dfa848db54fd7f30b6f1f1c5bffa865"
  name: "TransitStation"
  label: "deployed by Paxos Labs: Deployer 1"
  upgradeable: "no"
  rating: LOW
  txs_90d: 3690
  last_active: 2026-11-18
  recoveries_14d: 75
fix:
  layer: onchain-config
  who_acts: "owner 0x0000000000417626Ef34D62C4DC189b021603f2F"
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
  note: "A live owner can call the setter, so a config call fixes it: LOW."
---

## Summary

TransitStation checks signatures from a stored signer key with ecrecover; once that key's account holds code that is not a 7702 delegation, recovery returns nothing and the signed path stops until the key is replaced.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here / the recovered address must be the stored signer, or be in a stored set or…. Read from source. Executed: a real transaction reverts with code at the signer.
- setter setQuoteSigner(address) requiresAuth (solmate Auth: owner or authority) in verified source (9dfa848db54fd7f30b6f1f1c5bffa865/source)
- owner() at block 26438999 = 0x0000000000417626Ef34D62C4DC189b021603f2F Safe 3-of-[0x41431e315A84659012B5622627b8f9e9Bf79652C, 0x6Be51156C578414E7893B91FDE1627E8741D526E, 0xFBf73C3622668cfE655fAFF8fCb9876015001A5e, 0x317eEbf4B4a2ceE0e9a73f276628986Ab254A024, 0x1D607E4eb747f1294AE632D3490f121B00Db9312]
- txs_90d=3690, last_active=2026-11-18

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3,690 transactions called it in the 90 days before that block; last on 2026-11-18.
- 75 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the signer to a new EOA (or a key the signature check accepts) through the setter before the signing account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
