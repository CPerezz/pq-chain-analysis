---
id: d1b1c2c1-fixed-signer
title: "0xd1b1c2c1: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd1b1c2c12f44530ac44dabd41f37eb69e792a18e"
  family: "f041fae186ad4317ce59966afa4fe746"
  upgradeable: "no"
  rating: HIGH
  value_usd: 14
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "no one — bidders cannot recover escrowed ETH"
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
  rating: HIGH
  note: "No update path (SIGNER is a literal, not storage) and bidders' ETH has no path out except the two signature-gated functions."
---

## Summary

ETH bid escrow: makeBid/upBid take deposits; the only two ways ETH ever leaves (cancelBid, claimBid) each require an ECDSA signature matching a SIGNER hardcoded as a PUSH20 literal (0x51d8...08b), with no setter. No owner rescue/withdraw function exists.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode at 0xe4d: STATICCALL to address 1, return value masked and EQ'd against PUSH20 0x51d87492c2fef5a0edf6e23208d9a02c61b0d08b (matches owner() at deploy time, but is a separate compiled-in literal, not the mutable owner slot).
- Selector list: feep, upBid, cancelBid, setFee, renounceOwnership, owner, makeBid, claimBid, transferOwnership — no withdraw/rescue selector exists.
- cast code on 0x51d87492... at the pinned block returns empty — signer has no code today, so the signature is still obtainable now but breaks once the key gets any non-7702 code.

## Impact and exposure

- Value held at block 26,438,999: $14 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

redeploy with a replaceable signer (e.g. a role the owner can rotate), or let bidders self-exit without needing the SIGNER's co-signature

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
