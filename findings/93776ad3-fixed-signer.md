---
id: 93776ad3-fixed-signer
title: "0x93776ad3: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x93776ad37af2c9eb25f42024963563caf8846169"
  family: "e2ef51e8c1f5faf9afd1f23645a54f0c"
  copies: 87
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 704
  last_active: 2026-11-18
  recoveries_14d: 266
fix:
  layer: new-deployment
  who_acts: "the feed's operator deploys a new feed; consumers switch to it"
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
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "A price feed whose only updater is a fixed key with no setter: once that key has code the feed stops for good, and the feed itself holds nothing, so only a function stops: MEDIUM. Whether its consumers can switch feeds, or lock funds on a stale price, was not traced and belongs to the consumer."
---

## Summary

Signed WETH/USD price oracle (read(address), signerA/signerB) whose two signers are PUSH32 constants 0xd477e076… and 0x7b3d934d… (neither has code). The oracle holds no funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: 87 contracts checking two signers (signerA, signerB) that are constants in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: IMPLEMENTATION_VERSION(), but owner() is zero or absent. 87 with an upgrade function whose caller was not read.
- Disassembly: PUSH32 0xd477e0762f8821388280fb353bef4150d7174beb and 0x7b3d934da7a73e7aeb5fe69963c311f702ab248c; WETH constant
- selectors usdPerToken, signerA, signerB, read(address), IMPLEMENTATION_VERSION; no setter or owner
- traced update tx 0x22fad571…: Multicall3 batch-updates several copies (0xf345…, 0xca63…, 0x7e96…)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 87 addresses).
- Activity: 704 transactions called it in the 90 days before that block; last on 2026-11-18.
- 266 signature recoveries in the study's two-week trace window.

## Remediation

Consumer switches to a new oracle with fresh signers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
