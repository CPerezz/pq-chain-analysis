---
id: 67c408ec-fixed-signer
title: "0x67c408ec (tagged deployed by Blockparty: Deployer 1): signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x67c408ec6aafa34f3d6a5eda72244779be7d91b9"
  family: "be18686174f5f9e1082a86e39d91f06b"
  label: "deployed by Blockparty: Deployer 1"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "no one — bidders cannot recover escrowed ETH"
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
  rating: HIGH
  note: "No update path for the literal SIGNER, and bidders' ETH has no path out except the two signature-gated functions."
---

## Summary

ETH bid escrow, same template as 0xd1b1c2c1...: makeBid/upBid deposit ETH; cancelBid/claimBid (the only two exits) each require an ECDSA signature matching a hardcoded PUSH20 SIGNER with no setter. No owner rescue/withdraw selector exists.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode: STATICCALL to address 1, return EQ'd against PUSH20 0xf3f78a32b36299364aca311adf3b9eb91fddabe6.
- cast code on 0xf3f78a32b36299364aca311adf3b9eb91fddabe6 at the pinned block is empty — no code today.
- Selector list: feep/upBid/cancelBid/setFee/renounceOwnership/owner/makeBid/claimBid/transferOwnership only — no withdraw/rescue.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

redeploy with a replaceable signer, or let bidders self-exit without the SIGNER's co-signature

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
