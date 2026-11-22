---
id: snpbridgereleasevault-02e60f97-fixed-signer
title: "SNPBridgeReleaseVault: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x02e60f97feb25f9141e4e0a574b5b60d94b5eb27"
  family: "8df9f1330fee54ddffb7a86148410d97"
  name: "SNPBridgeReleaseVault"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 100
  last_active: 2026-11-13
  recoveries_14d: 42
fix:
  layer: new-deployment
  who_acts: "company plus SNP validators"
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
  note: "No update path, and users' bridged deposits are released only by a sealed proof (HIGH). The depositor fee consent is optional (claims without one exist)."
---

## Summary

SNPBridgeReleaseVault pays SNP deposits only against headers sealed by 3 of 4 immutable validators (V0..V3, all EOAs). If two validators' keys get code, no new root can be proven. Deposits made on SNP after that can never be paid, and the SNPAD reserve (31,331 tokens) only leaves via withdrawReserve, which itself needs a proven header.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: SNP bridge seals: each signer must be one of the validators fixed in the code, without duplicates / SNP bridge fee consent: the depositor may sign a fee cap; claims without a consent exist (by name). Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- BridgeProofVerifier.sol: V0..V3 are immutable, and the contract notes 'a validator change means a redeploy'; ecrecover must return a distinct validator
- V0 0xae50…, V1 0xd36b…, V2 0xe902…, V3 0xef3a… have no code at block 26438999
- SNPBridgeReleaseVault: no pause, guardian, drain or upgrade; rescue() refuses SNPAD; claimCached needs a root that a sealed path cached earlier

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 100 transactions called it in the 90 days before that block; last on 2026-11-13.
- 42 signature recoveries in the study's two-week trace window.

## Remediation

Redeploy with new validators; on SNP, a refund path for unpaid deposits.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
