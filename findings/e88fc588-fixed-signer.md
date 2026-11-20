---
id: e88fc588-fixed-signer
title: "0xe88fc588: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe88fc588ea54cc568d263b2fb6934a20138346f3"
  family: "7796c0f4a1541de759a4eb0d37bd3cd9"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "deployer/treasury (sale liveness only)"
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
  note: "Quote-gated settlement stops (liveness); funds route straight to a separate treasury constant rather than accumulating here, so nothing is locked by this defect specifically."
---

## Summary

A sale/settlement contract that executes signed price quotes (`MAX_QUOTE_TTL`, `saleId`, `treasury`, `cancelled`/`consumed` tracking) only if ecrecover(quote) equals a hardcoded quoteSigner; EIP-8151 stops every settlement once that address gets code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompile shows `uint256 public constant quoteSigner = 1196946047123494226698076691043522283171691970395;` i.e. 0xd1a8eac394f34d54a5f368ab6d78cbf0ec893f5b
- `cast code` on that address today -> 0x (EOA)
- facts.setters = [transferOwnership] only, facts.upgrades = [] -> no way to rotate quoteSigner
- no accumulation of user funds visible: settlement pays a separate `treasury` constant directly, this contract does not hold a running balance in the functions decompiled

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No on-chain fix; redeploy with a replaceable quoteSigner (e.g. a role the owner can rotate) before EIP-8151 activates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
