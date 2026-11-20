---
id: 1ef58c5a-rotate-signer-before-migrating
title: "0x1ef58c5a: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x1ef58c5ac86e688ca6319015b9ebc5b058c812f6"
  family: "046605583de0bdfdcee1649812f243ae"
  copies: 4
  upgradeable: "yes"
  rating: NONE
  value_usd: 722
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  verdict: refuted
  rating: NONE
  note: "An unused implementation: owner and signer are zero at this address, so no signature it checks can matter here; any effect sits in the proxies that run this code, which are rows of their own."
---

## Summary

Deposit/withdraw vault: withdrawERC20/withdrawERC721 need an oracle signature; changeOracle is owner-only.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (changeOracle). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- changeOracle: require msg.sender == owner (heimdall decompile)
- owner() at 26438999 = 0x0 (node); oracle() = 0x0 and slots 0-7 zero (publicnode latest ~26452944)

## Impact and exposure

- Value held at block 26,438,999: $722 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
