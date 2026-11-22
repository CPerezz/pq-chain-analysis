---
id: ethereummergedadapterwithroundse-4b2c406f-fixed-signer
title: "EthereumMergedAdapterWithRoundsEurspkccNavV1: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4b2c406f0dbf7624a32971277da7b4c43a7a942b"
  family: "566ee5477c2dffbcc79c9c56d07e3c58"
  copies: 3
  name: "EthereumMergedAdapterWithRoundsEurspkccNavV1"
  upgradeable: "yes"
  admin: "ProxyAdmin 0x8223a6271d1e0bda019ee55d545d7b86eff1f573 owned by Safe 0x6906f3a09bcc1b7cd3b0c8626724299618df4472 (2/3)"
  rating: LOW
  txs_90d: 1003
  last_active: 2026-11-17
  recoveries_14d: 210
fix:
  layer: contract-upgrade
  who_acts: "RedStone 2-of-3 Safe 0x6906f3a0… via ProxyAdmin 0x8223a627…"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "A live Safe-controlled upgrade exists: LOW. The note's implementation address is stale."
---

## Summary

A RedStone price adapter (EURSPKCC NAV) behind a proxy. Its signer list is fixed in the code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone: the recovered address is looked up in getAuthorisedSignerIndex, a list of addresses fixed in the adapter's code; a threshold of distinct signers is needed. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: proxy to 0x14449cc3185dec0421c3cb37074215f1aacb97f9, admin 0x8223a6271d1e0bda019ee55d545d7b86eff1f573.
- EIP-1967 admin slot at 26438999 = 0x8223a627…; owner() = Safe 0x6906f3a0… (threshold 2, three EOA owners with nonces 71/65/18)
- the implementation slot reads 0xa219348b…, not the 0x14449cc3… named in the row note (the facts.json implementation agrees with 0xa219…)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 1,003 transactions called it in the 90 days before that block; last on 2026-11-17.
- 210 signature recoveries in the study's two-week trace window.

## Remediation

Upgrade to an implementation with a new signer list.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
