---
id: de46cf01-fixed-signer
title: "0xde46cf01: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xde46cf01561b68b4df4f32502768af47240dddde"
  family: "69f1b6a9470612437585be7086ae73dc"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Operator/owner: redeploy with a new signer, or withdraw and redistribute the tokens"
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
  note: "The study note calls this a presale. The source is actually a vesting contract, and only registration needs the signature."
---

## Summary

The signer is an immutable EOA that cannot be replaced. If that key's account gets real code, only new beneficiary registrations stop. Beneficiaries already registered can still claim without a signature, and the owner can withdraw the remaining tokens, so nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable cSigner; cSigner = _signer` in the constructor
- addBeneficiary: `require(ecrecover(digest, v, r, s) == cSigner)`
- Immutable value in the bytecode is 0x5ec051e9...606e, which is an EOA (no code) at block 26438999
- claimTokens has no signature check

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new vesting contract with a rotatable signer or ERC-1271 support. The owner can withdraw the tokens and move them to it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
