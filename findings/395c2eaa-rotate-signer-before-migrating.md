---
id: 395c2eaa-rotate-signer-before-migrating
title: "0x395c2eaa: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x395c2eaa45865870d735074093720819359b6d0a"
  family: "417567538bb971c51767842e2b41b9ec"
  copies: 2
  upgradeable: "yes"
  admin: "ProxyAdmin 0x63d572d7… owned by ChainPort Congress 0xB6b4C7aC…"
  rating: LOW
  txs_90d: 1255
  last_active: 2026-11-17
  recoveries_14d: 138
fix:
  layer: onchain-config
  who_acts: "ChainPort Congress 0xB6b4C7aC240b1f176c5589d064733066a83884a1"
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
  note: "The setter exists and is guarded by ChainPort's governance contract → LOW. Whether the Congress still runs (its activity) was not read because the node stalled."
---

## Summary

ChainPort signature validator (implementation behind proxy 0x8637d273285faa6794e3d4d1ca180ad52575dce6). verifySignature recovers and compares with signatoryAddress; a signatory with code fails bridge verifications.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setSignatoryAddress). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- Selectors: setSignatoryAddress(address), verifySignature(bytes32,bytes), signatoryAddress(), chainportCongress(). Decompiled setSignatoryAddress requires msg.sender == slot0>>16 ('M1').
- Proxy slot0 at 26438999 = chainportCongress 0xB6b4C7aC… (contract, 12.6k bytes); signatoryAddress=0x75187213…. The proxy's ProxyAdmin 0x63d572d7… is also owned by the Congress.
- Window traces show ~10 recent verifications through the proxy.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,255 transactions called it in the 90 days before that block; last on 2026-11-17.
- 138 signature recoveries in the study's two-week trace window.

## Remediation

The Congress calls setSignatoryAddress with a fresh EOA before the signatory takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
