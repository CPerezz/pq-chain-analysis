---
id: cfea9a25-fixed-signer
title: "0xcfea9a25: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xcfea9a256f1f96269d848cabf1ecb00fd2dd6a28"
  family: "7d636c5751b55d4a4f3bfe5d78094daf"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 23
  last_active: 2026-11-03
fix:
  layer: new-deployment
  who_acts: "The owner and the holder of the governance signer key. The contract has to be redeployed and the funds migrated, but the locked funds cannot be moved without the signature."
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
  note: "The study note calls this a presale, but the decompiled code is a deposit pool with Merkle-root claims. Each signature also has to come together with an owner call."
---

## Summary

The governance signer is a hardcoded constant, the address is an EOA today, and nothing in the contract can replace it. If that account gets real code, ecrecover stops matching. Then no new roots, no maxEpochDelta change and no rescue can be proposed. Deposited tokens not covered by roots already posted stay locked, because the operator's 15% withdrawal cap is also frozen.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 0x1f27734a / 0x4d15c753 / 0xa01ed07e: require(recovered == 0x199e54a7dfe9dcfd4567fd635a298e2902d0f8b3, "bad governance signature")
- Verified facts: 0x199e…f8b3 is an EOA with no code
- transferOwnership: require(arg0 != 0x199e…f8b3, "owner=governance signer"), so it changes the owner, not the signer
- claim() requires storage_map_g[epoch] to be set, and only 0x51303620 sets it, from a signed pending root

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 23 transactions called it in the 90 days before that block; last on 2026-11-03.

## Remediation

Before the signer key's account gets code, use the signer to post final roots and/or a rescue for the remaining balance. Then redeploy with a signer that can be rotated, or with ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
