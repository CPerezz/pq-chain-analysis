---
id: kyodepository-7548fcd0-rotate-signer-before-migrating
title: "KyoDepository: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7548fcd0191a3372c00943e2f8ba21a3218ddeb5"
  family: "a68dc36e69f21b15000cc5178d77faf6"
  name: "KyoDepository"
  upgradeable: "no"
  rating: LOW
  value_usd: 10466
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 18067
  last_active: 2026-11-18
  recoveries_14d: 665
fix:
  layer: onchain-config
  who_acts: "owner 0x7b99bed47a9faba58a431d5456d5edfde012d3a3"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "The setter is callable by a live EOA owner: LOW. txs_90d 18067; the owner also has emergencyWithdraw."
---

## Summary

KyoDepository withdraw needs an EIP-712 signature recovered to an address with settlementSigners[signer]=true. Settlements die if every signer gets code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers / returns the recovered address or its id to a caller that decides. Read from source. Executed: a real transaction reverts with code at the signer.
- KyoDepository:148 setSettlementSigner(address,bool) onlyOwner; :234-236 _recoverEOASigner then the settlementSigners check
- owner()=0x7b99…d3a3: EOA, nonce 42 at block 26438999 (pendingOwner 0)

## Impact and exposure

- Value held at block 26,438,999: $10,466 (ETH and 49 priced tokens).
- Activity: 18,067 transactions called it in the 90 days before that block; last on 2026-11-18.
- 665 signature recoveries in the study's two-week trace window.

## Remediation

The owner calls setSettlementSigner(newEOA,true).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
