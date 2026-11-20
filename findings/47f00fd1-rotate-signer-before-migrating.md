---
id: 47f00fd1-rotate-signer-before-migrating
title: "0x47f00fd1: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x47f00fd16ccfdcec08617373f524a5e68ac8a29a"
  family: "b5fb6a6d9910488ea214e291f1d815d1"
  copies: 2
  upgradeable: "yes"
  admin: "owner EOA 0xA07Ae4BD… of proxy 0xa9215f1a… (UUPS)"
  rating: LOW
  txs_90d: 2560
  last_active: 2026-11-18
  recoveries_14d: 147
fix:
  layer: onchain-config
  who_acts: "owner EOA 0xA07Ae4BD… of proxy 0xa9215f1a…"
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
  note: "An Ownable setter is held by a live EOA. The row says upgradeable=no, but this code is a UUPS implementation in live use behind a proxy."
---

## Summary

Unverified UUPS implementation behind the ERC-1967 proxy 0xa9215f1a… (the address seen in the transactions). Signatures must recover to the stored `authority`. Under EIP-8151 an authority that takes non-7702 code fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setAuthority). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction loses its effect with code at the signer.
- Decompile: setAuthority requires owner()==msg.sender (Ownable error 0x118cdaa7) and writes `authority`; there is also upgradeToAndCall
- Proxy 0xa9215f1a… has its implementation slot at 0x47f00fd1… (block 26438999). txs.json context is 0xa921… and the recovered signer is the authority 0xa0083f4c…
- At block 26438999 the proxy's owner()=0xA07Ae4BD… (EOA, nonce 60) and authority()=0xa0083f4C… (EOA, nonce 0). The implementation's own storage reads owner 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,560 transactions called it in the 90 days before that block; last on 2026-11-18.
- 147 signature recoveries in the study's two-week trace window.

## Remediation

The owner calls setAuthority(newKey) on the proxy before the authority key takes code; the owner can also upgrade.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
