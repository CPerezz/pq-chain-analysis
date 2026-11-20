---
id: numeraistaking-c1f46adf-rotate-signer-before-migrating
title: "NumeraiStaking: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc1f46adf341145369eee9fbe0d84fa1cb0c24706"
  family: "c04de2677852c06df586ec7696b9b94c"
  copies: 6
  name: "NumeraiStaking"
  upgradeable: "yes"
  admin: "ProxyAdmin 0x931aabec2b600eabb3863e14e8f6295c1522ef60"
  rating: LOW
  txs_90d: 10047
  last_active: 2026-11-18
  recoveries_14d: 10948
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x1105…b0ea"
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
  note: "setter callable by a live EOA."
---

## Summary

NumeraiStaking (proxy): stake authorisations recover to the stored authorizationSigner.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: stake authorisations must recover to the stored authorizationSigner (lines read); setAuthorizationSigner replaces it. Read by hand. Executed: a real transaction reverts with code at the signer.
- NumeraiStaking.sol:432 setAuthorizationSigner onlyOwner; eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0x1105afaf… EOA, nonce 153158; proxy admin 0x931aabec… (owner 0xb1544c7f…)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 10,047 transactions called it in the 90 days before that block; last on 2026-11-18.
- 10,948 signature recoveries in the study's two-week trace window.

## Remediation

Owner calls setAuthorizationSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
