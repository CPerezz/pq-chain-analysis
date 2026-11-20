---
id: firstbloodtoken-0f600992-fixed-signer
title: "FirstBloodToken: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x0f600992da5dbbe0aebf01ba1da0daef1c912bbf"
  family: "8502312a77c835b634c14a4fd703035d, de3f85f5f5e340d0ffb372758494c7f0, f773d24caa20dbd8fd4d4aa3bda01534"
  copies: 16
  name: "FirstBloodToken"
  label: "FirstBlood"
  upgradeable: "no"
  rating: NONE
  value_usd: 77
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 7
  last_active: 2026-10-10
fix:
  layer: none
  who_acts: "none"
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
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "No callable fixed-signer gate exists at this address; the row inherited the name of a family member reached through the delegatecall tree. Refuted for this address."
---

## Summary

This address does not run FirstBloodToken. Its 3,002-byte code has no function dispatcher: it is a fixed chain of DELEGATECALLs with empty calldata to 99 hard-coded contracts, which fan out to thousands of 2015-16 contracts. No signed purchase function (buyRecipient) can be called here, and it holds 0 ETH.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: FirstBloodToken buyRecipient: purchases need the presale signer set in the constructor, with no setter; a crowdsale purchase gate only (MEDIUM). Read.
- Code starts 0x6000808080736fcf…602b5a03f415…: repeated `delegatecall(gas-43, addr, 0,0,0,0)` and nothing else; `cast selectors` returns none.
- Walking the tree (3,000+ addresses) reaches many unrelated legacy contracts, all entered only through their fallback with empty calldata.
- Etherscan shows it as unverified; balance at block 26438999 is 0.

## Impact and exposure

- Value held at block 26,438,999: $77 (ETH and 49 priced tokens, over 16 addresses).
- Activity: 7 transactions called it in the 90 days before that block; last on 2026-10-10.

## Remediation

The operator keeps the signing key without code, or moves users to a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
