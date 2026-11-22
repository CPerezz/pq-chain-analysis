---
id: custodian-ce00901a-fixed-signer
title: "Custodian: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xce00901a0638d758d6f89d59dfa32120d2259b0c"
  family: "f7ca127d2de4b566f748fd6b83efb55e"
  name: "Custodian"
  upgradeable: "no"
  rating: HIGH
  value_usd: 62581
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the operator keeps the key without code, or moves users to a new deployment"
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
  rating: HIGH
  note: "operator fixed; users' exits need it"
---

## Summary

`Custodian` at `0xce00901a0638d758d6f89d59dfa32120d2259b0c`. It accepts signatures only from a key fixed in its code; once that key's account has code, every signed function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Gluon Custodian: every withdrawal and exit needs the operator's ECDSA signature on the entry (verifySignedBy(entry.hash, signature, operator)) and the caller must be the entry's account; the operator…. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Read by hand (Gluon Custodian): every withdrawal and exit needs the operator's ECDSA signature on the entry; the operator (0x5ccaaae7bea14e8e04fb0fc7ed16df49d5678eb8) is set in the constructor with no setter; addOwner and removeOwner manage the custodian's owners, not the operator.
- No proxy, no upgrade. Dormant.

## Impact and exposure

- Value held at block 26,438,999: $62,581 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The operator keeps the signing key without code, or moves users to a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
