---
id: chimpers-80336ad7-rotate-signer-before-migrating
title: "Chimpers: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x80336ad7a747236ef41f47ed2c7641828a480baa"
  family: "e74235866bd230d71de0420c793084d2"
  copies: 2
  name: "Chimpers"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1162
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x6Cc4…16b5"
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
  note: "Signer is the owner, which a live EOA can hand over."
---

## Summary

Chimpers NFT (Manifold-style AdminControl) checks signed claims against its owner. If the owner gets code, those checks fail.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one address in storage and the only such address the code names is its owner, which can be handed over (renounceOwnership, transferOwnership). Rule: stored-key (the owner).
- decompile: transferOwnership 0xf2fde38b requires msg.sender == owner (store_m, 'Ownable: caller is not the owner')
- owner at block 26438999 = 0x6Cc435F6…16b5, EOA nonce 1699
- signer = owner per the row's reading; heimdall did not surface the recover site

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,162 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Owner calls transferOwnership to a fresh EOA before migrating.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
