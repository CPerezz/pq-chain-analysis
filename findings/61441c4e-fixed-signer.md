---
id: 61441c4e-fixed-signer
title: "0x61441c4e: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x61441c4eb8146d6808373df235c7eee08267f470"
  family: "e0839afdce6ebc391f1f889abc7a4a2c"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "Owner (0xa510529f...) can sweep remaining stock; no user action needed"
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
  note: "Rated MEDIUM because only the claim function stops. The tokens are the operator's own stock, which the owner can sweep. Claims have also been closed by the time limit since 2022."
---

## Summary

The signer can't be replaced: cSigner is an immutable set in the constructor, and the only setter is transferOwnership, which changes the owner, not the signer. The signer address 0x0aeefc34... has no code today. The signature only unlocks claims of tokens the contract minted to itself, and the owner can sweep that stock. If the signer's account gets code, claims stop but nothing is locked. The claim period also ended in 2022, so claim already reverts on the time check.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable cSigner; cSigner = _signer;` in the constructor
- claim: `require(ecrecover(digest, v, r, s) == cSigner)`
- Immutable 0x0aeefc3490fee05b4d14640a2a5452441fafdd1a is an EOA (no code) at block 26438999
- sweep(dest) onlyOwner moves balanceOf(address(this)) after claimPeriodEnds

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No fix needed in the code. The owner can call sweep to move the unclaimed stock. Any further distribution would need a new contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
