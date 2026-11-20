---
id: verifyingpaymaster-ac758eaf-fixed-signer
title: "VerifyingPaymaster: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xac758eaf83906d0677254fd8fbf6ca19ce5b7e7c"
  family: "c24b5a05c34850eed31fc7c31f4a893f"
  copies: 27
  name: "VerifyingPaymaster"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 6
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 58
  last_active: 2026-11-17
  recoveries_14d: 2
fix:
  layer: none
  who_acts: "owner 0xEcbC…4479"
evidence:
  level: executed
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
  note: "The sponsorship function dies and the operator's deposit still leaves, so MEDIUM. The row's HIGH is not supported."
---

## Summary

This is a VerifyingPaymaster (EntryPoint v0.7) whose verifyingSigner has no setter. Sponsorship stops once that signer has code. The 0.041 ETH EntryPoint deposit is the paymaster owner's and leaves by withdrawTo, a direct onlyOwner call.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: VerifyingPaymaster: the signer must be verifyingSigner, fixed in the code. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- verifyingSigner() = owner() = 0xEcbC…4479, an EOA with no code (nonce 7). The bytecode has no 1626ba7e.
- EntryPoint getDepositInfo: deposit 0.04108 ETH, not staked; withdrawTo/withdrawStake are owner calls.
- The only setter is transferOwnership, which does not touch verifyingSigner.

## Impact and exposure

- Value held at block 26,438,999: $6 (ETH and 49 priced tokens, over 27 addresses).
- Activity: 58 transactions called it in the 90 days before that block; last on 2026-11-17.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

Owner withdraws the deposit and deploys a new paymaster.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
