---
id: redstonecoreoracle-fb8f0449-fixed-signer
title: "RedstoneCoreOracle: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xfb8f044995655fef33a49f3ff39ca33e5eefc14a"
  family: "b639103ee66c8b71089ee96280b214d6"
  copies: 5
  name: "RedstoneCoreOracle"
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
  note: "No update path, oracle holds no funds by design -> MEDIUM."
---

## Summary

Euler RedstoneCoreOracle: a single-feed RedStone consumer (threshold 3 of 5), no setter, not a proxy at this address. It is a price oracle read by Euler vaults via base()/quote(); it holds no funds itself, so a broken signer set stalls price reads but locks nothing here.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone: the recovered address is looked up in getAuthorisedSignerIndex, a list of addresses fixed in the adapter's code; a threshold of distinct signers is needed. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- RedstoneCoreOracle.sol via RedstoneConsumerBase/SignatureLib.recover: getAuthorisedSignerIndex over fixed list (dossier source)
- cast call base()==0x2D1F7226Bd1F780AF6B9A49DCC0aE00E8Df4bDEE, quote()==0x...0348 (USD), feedId==NVDA, maxStaleness=300 at block 26438999 -- confirms this is a pure price-oracle contract
- facts.json: who_depends_on_it shows 5 vault-like dependent codes reading this oracle's price, not funds held by the oracle itself

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy a new oracle with fresh signers; Euler vaults repoint their oracle reference.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
