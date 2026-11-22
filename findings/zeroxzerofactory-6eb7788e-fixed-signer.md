---
id: zeroxzerofactory-6eb7788e-fixed-signer
title: "ZeroXZeroFactory: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6eb7788ee4f705951d3b990897c83190f9d790df"
  family: "aaeff6dcb880779a9ccacb258c025090"
  name: "ZeroXZeroFactory"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 476
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
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
  note: "No update path; one mint gate dies, no funds locked → MEDIUM. The owner can open buy() at its own price, which may arguably count as the same act (LOW)."
---

## Summary

presale() needs a ticket signed by signerAddress, which is fixed at declaration with no setter. buy, claim, giveaway and withdraw do not use it, so only the presale mint dies.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ZeroXZeroFactory presale: tickets signed by signerAddress, set at deployment and never changed; no funds held for buyers, only the presale stops (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- ZeroXZeroFactory.sol l.23: signerAddress = 0x82078e07…a2F2, no setter
- isAuthorized compares ECDSA recover with signerAddress
- signerAddress code 0x today; withdraw/withdrawTeam are onlyOwner direct calls (owner 0x7fc1…1f13, transferable)

## Impact and exposure

- Value held at block 26,438,999: $476 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner uses the public sale (setSaleActive) instead.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
