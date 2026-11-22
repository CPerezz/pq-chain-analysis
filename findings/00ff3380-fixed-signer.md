---
id: 00ff3380-fixed-signer
title: "0x00ff3380: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x00ff33802cb62bf8fa7ee8c5ba61e6d8f5477382"
  family: "9bbe35d9b6ea792485d48d9c77e5033f"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 3
  last_active: 2026-10-28
fix:
  layer: new-deployment
  who_acts: "The deployer would need to deploy a new contract with a different signer. The existing contract cannot be changed."
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
  note: "The study note's description (\"presale with deposit and claim\") does not match this source. The signature gates only rug(). I rated MEDIUM, not HIGH, because a failed signature leaves the pool liquidity tradable rather than locked."
---

## Summary

The signer is a hard-coded constant, it is an EOA today, and nothing can replace it. If its key's account gets real code, rug() can never run, so the refund path never opens. Funds are not locked: the liquidity stays in the pool, holders can still sell their tokens there, and the owner can still collect trading fees. Only the rug/refund function stops working.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address constant private RUG_SIGNER = 0x00F01dA987bab23Cfe2DCe67FE527631f108fb7c`; the bytecode scan shows this address as an EOA with no code at block 26438999.
- rug(): `require(ecrecover(...) == RUG_SIGNER)` has no code check and no ERC-1271 fallback.
- setOwner only writes info.owner, and no other function writes the signer. The row facts list no upgrade path ('no').
- refund() starts with `require(rugged())`, and only rug() sets rugged=true.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-10-28.

## Remediation

Keep the RUG_SIGNER key on a plain EOA or on a 7702 delegation, never on an account with real code. Otherwise, deploy a new version with a signer that can be rotated or that also accepts ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
