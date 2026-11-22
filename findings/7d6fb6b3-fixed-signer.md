---
id: 7d6fb6b3-fixed-signer
title: "0x7d6fb6b3: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7d6fb6b38cbb6b893a49984caebe4e7441592ede"
  family: "98a58ac3593db4358fe0434e66b41260"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 1923
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3
  last_active: 2026-09-30
fix:
  layer: new-deployment
  who_acts: "token team"
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
  note: "MEDIUM: no update path; the claim function dies, but nothing is locked: the tokens stay in the owner's balance and the ETH leaves through the team withdrawals."
---

## Summary

BallerX token: claimTokens(address,uint256,uint256,bytes) pays reward claims from the owner's balance on a signature from the signer in slot 0x11 (0x88b9…6132), with no setter. Ordinary transfers and the team's ETH withdrawals need no signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a fee token whose guarded transfers need a stored signer's signature (1.1 ETH). Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: claimTokens requires recovered == address(slot 0x11 >> 32) ('Invalid Signature'); verify() uses the same check
- No function writes slot 0x11's signer field; TeamWithdraw*BNB send ETH directly
- Signer 0x88b93a33…6132 has no code; owner 0x56fb…102a

## Impact and exposure

- Value held at block 26,438,999: $1,923 (ETH and 49 priced tokens).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-09-30.

## Remediation

The team pays rewards by direct transfer, or redeploys the claim logic.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
