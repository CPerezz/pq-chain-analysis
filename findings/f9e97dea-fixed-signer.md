---
id: f9e97dea-fixed-signer
title: "0xf9e97dea: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf9e97dea52d98c80042644497e6370f9b444cc60"
  family: "810c479cfe93ad18ae3a6fba1706ebd9"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "downstream price consumers affected if quorum drops below 3; this contract holds no funds"
evidence:
  level: bytecode
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
  note: "No update path for the 5 hardcoded signers, but this contract holds no money; worst case is a liveness/quorum degradation passed on to whatever protocol reads its prices, not a fund loss at this address."
---

## Summary

RedStone-style price oracle (getUniqueSignersThreshold=3 of 5 fixed authorised signers, 'redstone-primary-prod' data feed id). Each of the 5 authorised signer addresses is a hardcoded literal with no setter (getAuthorisedSignerIndex is a plain if/else chain against 5 constants). If any of those keys gets code, its signed price reports stop counting toward the 3-of-5 quorum; the contract itself holds no funds (price oracles don't custody money).

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Heimdall decompile shows getAuthorisedSignerIndex(address) as a literal chain of 5 hardcoded addresses (0x8bb8f32d.../0xdeb22f54.../0x51ce04be.../0xdd682dae.../0x9c5ae89c...) with no storage read.
- getUniqueSignersThreshold constant = 3; this is the standard RedStone oracle quorum pattern.
- cast balance on this contract is 0 and it is a price-feed consumer (getUnderlyingPrice), not an escrow.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

redeploy/reconfigure the oracle's authorised-signer set if quorum risk materializes

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
