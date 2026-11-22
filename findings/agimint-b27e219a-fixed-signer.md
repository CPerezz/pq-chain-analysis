---
id: agimint-b27e219a-fixed-signer
title: "AGIMint: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb27e219a28dcde18278355e41c5bdc8828eec459"
  family: "0f8a21842505beec1ed6ac7be389278f"
  copies: 2
  name: "AGIMint"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 3447
  last_active: 2026-11-07
  recoveries_14d: 3428
fix:
  layer: new-deployment
  who_acts: "operator"
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
  note: "No update path. Nothing is held for users after open; only the operator's sale dies."
---

## Summary

AGIMint's mint and mintFree require a voucher from the immutable gateSigner 0x5e20…28f1. If that key gets code, sales stop for good. The pool has opened, so refund is closed, and the contract holds no WETH or ETH.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: AGIMint: the signer must be the address the caller passes, which is gateSigner, fixed in the code. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- AGIMint.sol:68 `address public immutable gateSigner`; cast call = 0x5e20…28f1, cast code = 0x
- opened() = true, so refund() reverts RefundClosed; WETH balanceOf(contract) = 0
- no setter or proxy; paused() = false

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 3,447 transactions called it in the 90 days before that block; last on 2026-11-07.
- 3,428 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new sale contract (the token accepts one minter).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
