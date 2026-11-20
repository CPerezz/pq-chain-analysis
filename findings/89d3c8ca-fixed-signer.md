---
id: 89d3c8ca-fixed-signer
title: "0x89d3c8ca: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x89d3c8ca994831d161a12143b90b0e2fe8012af5"
  family: "3e394e65490158e46b454f1a171ebf09"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator, who would deploy a new contract with a new signer."
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
  note: "The owner getter reads 0, so the owner-only withdraw functions may be unusable today (renounced, or never initialized). User value is passed through rather than held, so this does not change the MEDIUM rating."
---

## Summary

The signer is a constant EOA with no setter and no ERC-1271 or code check. If the signer key's account gets real code, the signed calls stop. User ETH is forwarded within each call, so nothing users already hold gets locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 0x8ff0018f: require(0xd410910e6cdec5975fa8d46e575af3c3ebb0ca3d == recovered, 'invalid signature'), followed by the 'deadline expired' check
- Verified facts: 0xd410…ca3d has no code today (EOA)
- Row facts: setters list only transferOwnership, which writes the owner slot 0x33
- Row facts: upgradeable = no, with no proxy slot

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new relay whose signer can be rotated or that accepts ERC-1271 signatures. Off-chain, keep the signer key a plain EOA or a 7702-delegated account.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
