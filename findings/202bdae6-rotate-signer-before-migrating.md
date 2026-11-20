---
id: 202bdae6-rotate-signer-before-migrating
title: "0x202bdae6: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x202bdae6ea5cb576c916cf2d2a83d5a21ea2624d"
  family: "524da18b38f1a5261cf4c076d74ae838"
  copies: 2
  upgradeable: "yes"
  admin: "ProxyAdmin 0xd6ac916b9cb091d2ea1f83d810ba292758830b3d owned by EOA 0x5F7A4c11bde4f218f0025Ef444c369d838ffa2aD"
  rating: LOW
  txs_90d: 5301
  last_active: 2026-11-18
  recoveries_14d: 852
fix:
  layer: onchain-config
  who_acts: "proxy owner 0x5F7A4c11…a2aD"
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
  note: "A live EOA owner holds both the setter and the upgrade."
---

## Summary

Unverified contract with a stored signer replaceable by setSigner. It is the implementation behind a TransparentUpgradeableProxy at 0x837e5a6e…a932, which carries the activity.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- heimdall (L013/hc_202b): setSigner 0x6c19e783 requires owner() == msg.sender, non-zero arg, emits SignerUpdated
- proxy 0x837e5a6e45f5f16c7306b591994dbd2adf09a932: impl = this address; owner() = 0x5F7A4c11bde4f218f0025Ef444c369d838ffa2aD, an EOA with nonce 39599; signer() = 0x48D01dA9…Ba4a, at block 26438999
- ProxyAdmin 0xd6ac916b…0b3d, owner() = 0x5F7A… (same EOA)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 5,301 transactions called it in the 90 days before that block; last on 2026-11-18.
- 852 signature recoveries in the study's two-week trace window.

## Remediation

The owner calls setSigner with a new EOA before the old signer takes code (or upgrades through ProxyAdmin).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
