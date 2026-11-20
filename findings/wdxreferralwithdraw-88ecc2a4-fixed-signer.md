---
id: wdxreferralwithdraw-88ecc2a4-fixed-signer
title: "WdxReferralWithdraw: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x88ecc2a47b10ae79307e08bc06bbae7f0429906f"
  family: "918aec5e55bef1c71624d9fd54ff31b8"
  copies: 2
  name: "WdxReferralWithdraw"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Wdx operator"
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
  rating: MEDIUM
  note: "Operator-funded payout stock only: MEDIUM."
---

## Summary

WdxReferralWithdraw: get_wdx pays referral rewards from the contract's own token stock, and each payout needs a signature from the constant admin key 0x3f31…b677. If that key took code, the remaining stock would be stuck.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: WdxReferralWithdraw get_wdx: a constant admin key (0x3f31…b677) must sign each referral payout the contract makes. Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source line 20: require(ecrecover(...) == 0x3f3140632657b79FB3716e9852F6697bda9db677)
- 891 bytes, no setter, no proxy (state.json at block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Pay out before migrating; deploy a new contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
