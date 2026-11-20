---
id: astros-48fe8692-fixed-signer
title: "ASTROS: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x48fe8692397772ecc0ab8f021159ccb26434da44"
  family: "dc8e8039e637d8149f047896d6165bf4"
  name: "ASTROS"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 415
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2
  last_active: 2026-09-26
fix:
  layer: new-deployment
  who_acts: "contract owner"
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
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "No update path; only the signed mint dies, funds still leave → MEDIUM."
---

## Summary

mint() requires matchSigner, where signer is a storage variable fixed at declaration with no setter. withdraw() sends to fixed payees with no signature, and mintGiftOwner is owner-only.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ASTROS matchSigner: a constant signer with no setter gates minting; only the signed mint stops (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- astros.sol l.11: signer = 0x3f75B46F…ccFf; l.80: signer == ECDSA.recover(hash, signature); no setter
- signer() = 0x3f75…ccFf, code 0x today
- withdraw() (l.83) pays 8 constant addresses with no signature

## Impact and exposure

- Value held at block 26,438,999: $415 (ETH and 49 priced tokens).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-09-26.

## Remediation

Owner mints via mintGiftOwner; the public signed mint stops.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
