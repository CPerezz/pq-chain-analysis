---
id: bonusroll-46403e94-fixed-signer
title: "BONUSROLL: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x46403e94529fc04d04c9c393beab1d050ef06409"
  family: "ec48e906d326987fa6d024a17429964a"
  name: "BONUSROLL"
  label: "Fortunity"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 41467
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the owner takes the balance with takeAll"
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
  note: "as the fixed-gas row of the same contract"
---

## Summary

`BONUSROLL` at `0x46403e94529fc04d04c9c393beab1d050ef06409`. Its Oraclize proof accepts only the proof chain's fixed key; the raffle stops while the owner can take the balance without a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Oraclize verifySig (variant): the recovered address must be the address of the public key carried in the proof; the result flag is ignored / Oraclize safer_ecrecover: a constant 3,000 gas to the…. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read: the random-proof check recovers the address of the key carried in the proof, chained to a fixed key.
- takeAll() (onlyOwner) sends the whole balance; no signature.
- Dormant.

## Impact and exposure

- Value held at block 26,438,999: $41,467 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner withdraws with takeAll.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
