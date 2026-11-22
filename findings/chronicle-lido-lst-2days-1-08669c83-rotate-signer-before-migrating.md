---
id: chronicle-lido-lst-2days-1-08669c83-rotate-signer-before-migrating
title: "Chronicle_LIDO_LST_2DAYS_1: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x08669c836f41aead03e3ef81a59f3b8e72ec417a"
  family: "63b9cd889ec03dac3dd225b1a688a5cb"
  name: "Chronicle_LIDO_LST_2DAYS_1"
  upgradeable: "no"
  rating: LOW
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 8425
  last_active: 2026-11-18
  recoveries_14d: 40
fix:
  layer: onchain-config
  who_acts: "auth (timelock) can drop/lift feeds"
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
  note: "Live auth path (timelock with 7-day delay) can rotate feed keys."
---

## Summary

Chronicle ScribeOptimistic LST oracle; feed keys are registered by lift() with an ECDSA proof of key ownership, so a feed key with code cannot be lifted/proven. Under EIP-8151 a signer that takes non-delegation code stops recovering, so this path stops until the key is rotated.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Chronicle Scribe lift: a feed proves once that it holds the key of the public key being registered; later price updates are Schnorr checks on the stored public keys / Chronicle optimistic poke:…. Read from source. Executed: a real transaction reverts with code at the signer.
- Scribe.sol: lift(...)/drop(...) are `auth`
- authed() at block 26438999 = 5 addresses incl. 0x40C33e79… (timelock, getMinDelay=604800) and 4 other contracts, all deployed
- Feeds can be dropped and re-lifted with fresh EOA keys by an authed party

## Impact and exposure

- Value held at block 26,438,999: $1,805 (ETH and 49 priced tokens).
- Activity: 8,425 transactions called it in the 90 days before that block; last on 2026-11-18.
- 40 signature recoveries in the study's two-week trace window.

## Remediation

Authed governance drops the affected feed and lifts a new EOA key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
