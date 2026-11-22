---
id: archetype-fed18c82-fixed-signer
title: "ArchetypeLogic: signer fixed in code"
project: archetype
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xfed18c828277e3bd8610f9bae432e65a651706f7"
  family: "3ef193336628dc0d89735dec220df758"
  copies: 12
  name: "ArchetypeLogic"
  label: "Very Internet Person: VIP Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 3289
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 474
  last_active: 2026-11-17
fix:
  layer: none
  who_acts: "none (mint without affiliate)"
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
  rating: LOW
  note: "LOW: the same mint stays open by a direct call with affiliate = 0; only the affiliate discount and commission path dies. Nothing is locked: the owner withdraws, and affiliates withdraw their balances without a signature."
---

## Summary

An Archetype NFT clone (impl 0x4f855a…ce3d) using ArchetypeLogic.validateAffiliate: mints that name an affiliate need a signature from config.affiliateSigner 0x1f285dd5…9383, which no function can change. Mints without an affiliate skip the check.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Archetype (older): affiliate signer of the fixed configuration. Read by hand.
- Update path, read at block 26,438,999: delegates to a fixed address.
- ArchetypeLogic.sol:177-181: the check runs only if affiliate != address(0); :306-308: recover(...) == affiliateSigner
- The impl bytecode has setAffiliateFee and lockAffiliateFee but no affiliate-signer setter (selector scan against _selectors.json)
- config() at 26438999: affiliateSigner = 0x1f285dd528cf4cde3081c6d48d9df7a4f8fa9383, which has no code; owner withdraw() is direct

## Impact and exposure

- Value held at block 26,438,999: $3,289 (ETH and 49 priced tokens, over 12 addresses).
- Activity: 474 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Nothing to fix in the contract. Minting stays open without an affiliate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
