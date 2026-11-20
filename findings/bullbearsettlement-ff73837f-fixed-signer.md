---
id: bullbearsettlement-ff73837f-fixed-signer
title: "BullBearSettlement: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xff73837f97f43be5b05c20ae71fdeb11487e2d1a"
  family: "031b425de2253b4554b5fd7593d52330"
  name: "BullBearSettlement"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 5
  last_active: 2026-09-18
fix:
  layer: new-deployment
  who_acts: "operator (BullBear)"
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
  note: "No update path. Users keep the same act by a direct call, and the only money at stake is the operator's fee: MEDIUM, matching the BullBear precedents 0xaacb…/0x1287… (0x0db4… was rated LOW for the same mechanism)."
---

## Summary

BullBearSettlement (verified source) has an immutable BENCHMARK_ATTESTOR 0xa7001d0c…3cd4. It must co-sign relayed routes (executeRelayed reverts RouteNotAttested), and it signs fee benchmarks: when that attestation fails, the fee is zero and the swap does not revert. Users keep execute() directly, so if the attestor takes code, only the operator's fee and the relayed convenience path die.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: BullBear _recoverAttestor: returns the signer or zero / BullBear relayed execution: the route must be signed by BENCHMARK_ATTESTOR, fixed in the code / BullBear benchmark: signed by…. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source lines 367/759: `address public immutable BENCHMARK_ATTESTOR`. Line 990: executeRelayed requires `_recoverAttestor(...) == BENCHMARK_ATTESTOR`. Lines 1417-1429: a failed benchmark attestation returns false, so the fee is 0 (comment at line 605: never a revert).
- Line 7: no owner, admin, rescue or upgrade. The EIP-1967 slots are 0. GUARDIAN 0x4689ec8f… can only pause.
- cast at block 26438999: BENCHMARK_ATTESTOR = 0xa7001d0C…3CD4, no code (nonce 7). FEE_RECIPIENT = 0xC24d1419…. Balance 0: the contract holds nothing between swaps.
- execute() pulls tokens from msg.sender with no attestor check, so the same swap stays open to users.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 5 transactions called it in the 90 days before that block; last on 2026-09-18.

## Remediation

The operator deploys a new settlement contract with a replaceable attestor (or one that accepts ERC-1271), or keeps the attestor key free of code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
