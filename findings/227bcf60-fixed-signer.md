---
id: 227bcf60-fixed-signer
title: "0x227bcf60: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x227bcf60e399a2b70f2c059a865d2bdcc60d3cfd"
  family: "8678f1e52e8df95861b0b3fa490e7728"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  verdict: refuted
  rating: NONE
  note: "An implementation with an empty configuration; no fixed signer here."
---

## Summary

A FixedPricePool implementation (9888 bytes, no appended args): called directly, every immutable arg reads as zero (delegateSigner 0, antiSnipeEnabled false, owner 0), so no fixed signer is checked at this address.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: FixedPricePool: buys must carry a signature of delegateSigner(), a value fixed in each pool's code. Same code idiom as template e96f4137, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Selectors match BasePool/FixedPricePool (delegateSigner, antiSnipeEnabled, buy, close, redeem, cancelSale)
- At 26438999: delegateSigner()=0x0, antiSnipeEnabled()=false, owner()=0x0, status()=0, assetToken()=0x0
- The anti-snipe check is never reached, and recover can never equal 0x0 anyway (OZ reverts on a zero signer)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
