---
id: moduletradesadvanced-9a1d0089-rotate-signer-before-migrating
title: "ModuleTradesAdvanced: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9a1d00899099d06fe50fb31f03db5345c45abb36"
  family: "d4da0da59d3456e4a9b264fc8e862e53"
  copies: 2
  name: "ModuleTradesAdvanced"
  label: "Limit Break: Payment Processor (V2)"
  upgradeable: "no"
  rating: LOW
  txs_90d: 24241
  last_active: 2026-11-18
  recoveries_14d: 572
fix:
  layer: offchain
  who_acts: "order maker (names a new codeless cosigner on new orders)"
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
  note: "For makers the claim is refuted (ERC-1271 fallback). For cosigners it holds, and the fix is per order and offchain (the key holder picks a new cosigner), so LOW. The executed revert is the cosigner or a maker without 1271."
---

## Summary

Limit Break Payment Processor V2 ModuleTradesAdvanced. The maker is checked by ECDSA, and a maker with code goes through ERC-1271, so makers are handled. The cosigner, named per order, is checked by ECDSA only.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Payment Processor (advanced trades): the maker is checked by ECDSA, then, having code, through ERC-1271; a cosigner is named by each order. Read by hand.
- src/modules/PaymentProcessorModule.sol _verifyMakerSignature (~line same function): if the recovered address is not the maker and maker.code.length > 0, it calls _verifyEIP1271Signature. A maker that migrates is handled.
- _verifyCosignature: cosignature.signer != _ecdsaRecover(...) reverts. ECDSA only, no 1271, no code check. A cosigner whose key takes code fails.
- The cosigner is chosen per order (cosignature.signer, set by the maker and its cosigning service). No stored key and no admin are involved. Makers can sign new orders naming a fresh codeless cosigner, or leave cosigner = 0.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 24,241 transactions called it in the 90 days before that block; last on 2026-11-18.
- 572 signature recoveries in the study's two-week trace window.

## Remediation

Cosigning services rotate to a codeless key before migrating. Makers re-sign open cosigned orders.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
