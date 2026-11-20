---
id: 0bdbad7f-fixed-signer
title: "0x0bdbad7f: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0bdbad7f19a99c4cc289fa765bf2b9f8b47a4f9e"
  family: "681a43625acf9dc717e8b632a45c3797"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 2327
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator (store_d admin)"
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
  note: "MEDIUM: no update path, and the swaps die; the inventory is the operator's and leaves through withdrawErc20."
---

## Summary

A USDC↔aDAI swap desk: both swap functions need a signature from store_a 0xc60d…49b2, which no function changes. The admin 0xa36d…adc4 can withdraw any ERC20 directly.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a signed-withdrawal contract (1.3 ETH). Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: 3745c653/e2e8ef1f require recovered == store_a ('Signature validation failed.'); withdrawErc20 needs msg.sender == store_d
- Only 3 selectors, no setter; slots 0-3: admin 0xa36d…, signer 0xc60d…, USDC, aDAI (0xfc1e…)
- Signer and admin have no code; ETH balance 0

## Impact and exposure

- Value held at block 26,438,999: $2,327 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a new signer; the admin withdraws the inventory.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
