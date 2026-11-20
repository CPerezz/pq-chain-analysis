---
id: f74928c2-fixed-signer
title: "0xf74928c2: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf74928c22132e904302d71a70666500b88031e6a"
  family: "398e53d180d4f102f167cb0e8d2f63db"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 1
  last_active: 2026-11-15
  recoveries_14d: 1
fix:
  layer: new-deployment
  who_acts: "operator 0x5de5c0ac…"
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
  note: "Yes, users can refund without the signature, through the permissionless timeout paths. No update path, but the money still leaves through cancel/refund/fallback/claim: MEDIUM. Attention: fallbackSettleGroup settles at the stored values (fields 30/31), not at the operator's later certified result, so outcomes could differ from a signed settlement. Event logs could not be fetched (RPC timeouts), so there was no live dry-run on a real group."
---

## Summary

Operator-certified group and position market. createGroup, activate, openPosition, closePosition, liquidatePosition and settleGroup each require a certificate recovered to the constant operator 0x5de5c0ac…d931. If that key takes code, those functions die, but users still get their money out without it: cancel and refund for groups that were never activated, and fallbackSettleGroup then claim for active groups, all permissionless after block deadlines.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: claims checked against an operator that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode: the six ecrecover sites (0x974, 0xf3a, 0x13e5, 0x1c79, 0x22a2, 0x2737) all sit in the signed functions (settleGroup, liquidatePosition, openPosition, closePosition, activate, createGroup). None is in cancel (0x19bd), claim (0x1ecc), fallbackSettleGroup (0x2ebf) or refund (0x30d6). The operator is inlined as a constant compared to the recovered address. There is no setter (operator() getter only) and no upgrade.
- cancel(bytes32) and refund(bytes32) have no caller check. A state-1 group past block field+3/+4 is cancelled, and refund returns each position's stake (ETH or ERC-20 transfer) to the position owner.
- fallbackSettleGroup(bytes32) has no caller check: a state-2 group past block field+6, with field+0x1a non-zero (written in activate), gets state 4 (SSTORE of 0x04 at 0x3032-0x303c). claim(bytes32) then pays on state 4.
- Operator 0x5de5c0ac… has no code (nonce 0). Balance 0 at block 26438999; one createGroup recovery in the traced window (tx 0xe73d…f2c7).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-11-15.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

The operator deploys a new market with a rotatable operator or ERC-1271 support. Existing groups unwind through cancel/refund or fallbackSettleGroup/claim.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
