---
id: exampleredstoneshowroom-f5839a9e-fixed-signer
title: "ExampleRedstoneShowroom: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf5839a9ef554ad59453d78867e3d7de2cd7e80aa"
  family: "1c18891ab059e872a90cf2535228bbea"
  name: "ExampleRedstoneShowroom"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "RedStone (no owner action; feed just stalls)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "No update path, no funds by design -> MEDIUM."
---

## Summary

RedStone showroom demo: getAuthorisedSignerIndex over a single fixed signer (threshold 1), no setter. Demo contract, holds no funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- ExampleRedstoneShowroom.sol:576,592,967,971: getAuthorisedSignerIndex/getUniqueSignersThreshold over a fixed single address (dossier source)
- facts.json constants: 1 RedStone address 0xf786a909d559f5dee2dc6706d8e5a81728a39ae9, code_bytes=0
- txs_90d=0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Not production-relevant; redeploy with fresh signer if it were.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
