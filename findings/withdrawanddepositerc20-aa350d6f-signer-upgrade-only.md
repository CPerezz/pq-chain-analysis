---
id: withdrawanddepositerc20-aa350d6f-signer-upgrade-only
title: "WithdrawAndDepositErc20: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xaa350d6f83e90275bffd528cb18310880ae170d9"
  family: "27a55a390ffff6544add97ae721703c3"
  name: "WithdrawAndDepositErc20"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "The signer set can be replaced through a setter (update), so the 'upgrade-only' premise is wrong. The setter's authority is an external large-oracle contract I did not review."
---

## Summary

Partisia BYOC bridge implementation. update() replaces the small-oracle signer set whenever the large-oracle contract signs off, and it is the live implementation of proxy 0x71d86ea3.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: each signature must come from the oracle at its position in the stored list; a bitmask counts them. Read from source.
- Update path, read at block 26,438,999: upgradeTo(bytes,address), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- WithdrawAndDepositErc20.sol:1326-1359 update(): largeOracle.verifyUpdate(...) then oracles = new keys; withdraw (1382-1417) requires a majority of the stored oracles
- upgradeTo(bytes,address) (1228) is authorised by largeOracle.verifyContractUpdate
- proxy 0x71d86ea3f8f3d45ebbd2b54fde7361067fdf1fd4: impl slot = 0xaa350d6f; getOracleSize 3, oracles(0) 0x577279fC (EOA n=0), oracleNonce 1, largeOracle 0x3435359D (contract) @26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The large oracle signs an update() with fresh oracle keys before the current ones migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
