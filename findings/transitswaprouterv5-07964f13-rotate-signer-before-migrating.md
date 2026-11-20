---
id: transitswaprouterv5-07964f13-rotate-signer-before-migrating
title: "TransitSwapRouterV5: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x07964f135f276412b3182a3b2407b8dd45000000"
  family: "3d3d2bfaf10b786c377669bba71a9413"
  name: "TransitSwapRouterV5"
  label: "Transit Finance: Transit Swap Router V5"
  upgradeable: "no"
  rating: LOW
  value_usd: 71100
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 128892
  last_active: 2026-11-18
  recoveries_14d: 1073
fix:
  layer: onchain-config
  who_acts: "executor Safe 0x7b57…0711"
evidence:
  level: source-read
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
  note: "Executor-gated setter; executor is a live Safe."
---

## Summary

TransitSwapRouterV5: fee signatures must recover to _fee_signer. A fee signer with code makes signed-fee swaps revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: TransitSwap router: the fee signature must come from _fee_signer, which a function of the contract replaces (assignment read in the source). Read by hand. Executed: a real transaction reverts with code at the signer.
- BaseCore.sol:160-167 changeTransitProxy(aggregator, signer, vault) is onlyExecutor and replaces _fee_signer
- executor() = 0x7b570fec…0711, a Safe 2-of-3 with owner EOAs at nonces 60/623/12
- current fee signer 0x01C54379…8849 is an EOA with nonce 0

## Impact and exposure

- Value held at block 26,438,999: $71,100 (ETH and 49 priced tokens).
- Activity: 128,892 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,073 signature recoveries in the study's two-week trace window.

## Remediation

Executor Safe calls changeTransitProxy with a new fee signer before the current one migrates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
