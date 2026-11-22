---
id: 232628c7-rotate-signer-before-migrating
title: "0x232628c7: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x232628c79982337ad0e576759d218640b382f230"
  family: "73455ae268ddc22b6c8228568b7554cb"
  copies: 2
  upgradeable: "yes"
  admin: "ProxyAdmin 0xb07796fe75f32d7057ade0701e4a817268076da7, owner EOA 0x1403a95b6311B156434d1204A32d50037C53e0cd"
  rating: LOW
  txs_90d: 1349
  last_active: 2026-11-18
  recoveries_14d: 85
fix:
  layer: onchain-config
  who_acts: "configurator 0xe41e290c76E6c8bC57E1909891516F368d554d8F / owner 0xEa731bc0c57e62407fC6EC903De1Fafb16641382 of proxy 0x7fb8c7260b63934d8da38af902f87ae6e284a845"
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
  note: "LOW: setters exist and their gate parties are EOAs. Heimdall aliases the guard variables, so exactly which EOA gates add/removeSigner is not certain; both are EOAs. Upgradeable via the transparent proxy, unlike the row's 'no'."
---

## Summary

Multi-signer implementation (unverified) behind transparent proxy 0x7fb8c726…a845, with a set of signers and a threshold of 2. Under EIP-8151 signers with real code stop counting.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (addSigner, removeConfigurator, removeSigner, setSignerThreshold). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- Proxy 0x7fb8c726… implementation slot = 0x232628c7…; admin slot = ProxyAdmin 0xb07796fe… (owner 0x1403a95b…, EOA nonce 1)
- Decompiled addSigner (0xeb12d61e)/removeSigner (0x0e316ab7) gated by a role check (error 0x00f9db10, likely onlyConfigurator); setSignerThreshold, removeConfigurator gated by OwnableUnauthorizedAccount
- At block: configurator() = 0xe41e290c… (EOA, nonce 2); owner() = 0xEa731bc0… (EOA, nonce 1); signerThreshold = 2, signerCount = 2

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,349 transactions called it in the 90 days before that block; last on 2026-11-18.
- 85 signature recoveries in the study's two-week trace window.

## Remediation

The configurator adds a replacement signer and removes the old one before a signer takes code; the owner can reassign the configurator.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
