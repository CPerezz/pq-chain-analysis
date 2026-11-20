---
id: c4ff9e14-fixed-signer
title: "0xc4ff9e14: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc4ff9e14824c78d5d55889b3177980f18b30d5e2"
  family: "f6ef04e8fd94d7818524fde7a7c1d414"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 2
  last_active: 2026-11-16
  recoveries_14d: 1
fix:
  layer: new-deployment
  who_acts: "owner 0x4c078f5c…"
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
  note: "No update path and no owner-direct path, but no money is held by design: MEDIUM (function dies, nothing locked)."
---

## Summary

Same private trading executor as 0xd4200c17, with the same constant OWNER 0x4c078f5c…58d5. The signed-order check 0x60b9af76 also requires msg.sender to be the order's relayer, and V4 take() pays the owner. If the owner key takes real code, every trade fails; the contract holds nothing.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a signer that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode: the owner constant is compared to the ecrecover result (0x326/0x34a: SUB then JUMPI), is the `to` of PoolManager.take (0x1b64), and is returned by OWNER(). No CALLER==owner guard.
- execute with empty commands succeeds from any address (cast call --from 0x1111…). No setters, no upgrades, no claimOf selector.
- At block 26438999: ETH 0, WETH 0. Owner is a 7702-delegated EOA (nonce 4). Scanner tx 0x0d6f…f414: relayer EOA 0x3a0623… called 0x60b9af76 directly, and the recovered signer was 0x4c078f5c….

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-11-16.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

The owner redeploys with a replaceable key, or keeps the account free of real code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
