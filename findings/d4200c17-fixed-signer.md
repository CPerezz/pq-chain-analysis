---
id: d4200c17-fixed-signer
title: "0xd4200c17: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd4200c17a05c9330d350e3c6f333f30158a85b61"
  family: "e4f2363315bd46b023cfc739ef3ce614"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 3
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
  note: "No update path and no direct-call path, so it is not LOW like the sibling 0xe921…, which has an owner-direct execute. Nothing is held (balance swept to the caller, outputs paid to the owner), so the function dies but nothing is locked: MEDIUM. The claimOf/voucher CRITICAL precedent does not apply: the 'claimOf' exit was a mislabel."
---

## Summary

This is not a claim or voucher contract: it is a private trading executor (UniversalRouter-style execute 0x3593564c, V4 unlockCallback, nonceUsed, DOMAIN, OWNER). Every trade needs an EIP-712 order signed by the constant OWNER 0x4c078f5c…58d5, and outputs are taken from the V4 PoolManager to that owner. If the owner key takes real code, the executor dies; it holds no funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a signer that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode: PUSH32 0x…4c078f5c… is compared to the ecrecover result at 0x9b5. It is also the `to` of PoolManager.take (0x0b0d9c09) at 0x1a7f, and the value returned by OWNER(). No CALLER==owner guard exists: CALLER is compared only with WETH and PoolManager, and is otherwise used as the recipient of the ETH sweep.
- execute with empty commands succeeds from any address (cast call --from 0x1111…); commands must be the signed-order type 0x10. There are no setters or upgrade functions, and the selector set has no claimOf.
- At block 26438999: ETH balance 0, WETH 0. Owner 0x4c078f5c… is a 7702-delegated EOA (0xef0100595481…), nonce 4. Scanner tx 0xdd96…ae6 recovered that address.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-11-16.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

The owner deploys a new executor with a replaceable key, or keeps the account free of real code (7702 delegation is fine).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
