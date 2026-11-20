---
id: mergedadapterwithoutroundsrsweth-91456c45-signer-upgrade-only
title: "MergedAdapterWithoutRoundsRswethethV2: signer replaceable only by an upgrade"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: none
contracts:
- address: "0x91456c45856bcd134398c5fabe855470b022f533"
  family: "2928114af8c506400d77f2d0969160a7"
  copies: 5
  name: "MergedAdapterWithoutRoundsRswethethV2"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody — no update path exists"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "A price-feed oracle adapter holds no money by design; no update path and nothing locked falls to MEDIUM per the rating scale's own oracle-feed example, not HIGH."
---

## Summary

RedStone MergedAdapterWithoutRoundsRswethethV2: requireAuthorisedUpdater checks a fixed list of updater constants; no proxy was found live at this address (unlike 0x8d6d4... and 0x90d4d7... in this same batch) and no setter/upgrade exists.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- node, block 26438999: the dossier's candidate proxy 0xbc1f356dfa55555bd81bd2eff712b7e0cbd32fdf has eip1967 implementation slot = 0 — no live proxy points at this address
- batch facts: setters=[], upgrades=[]

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on-chain.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
