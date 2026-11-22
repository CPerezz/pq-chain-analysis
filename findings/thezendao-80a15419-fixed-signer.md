---
id: thezendao-80a15419-fixed-signer
title: "TheZenDao: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x80a15419a4596f1723c2b416803b9ae7878ed640"
  family: "4ea474336796b76c5e1883498d48d07d"
  name: "TheZenDao"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 423
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
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
  note: "No update path; one function (compose) dies, no funds locked → MEDIUM."
---

## Summary

signerAddress is set only in the constructor. freeMint and preSale are closed for good by time, since onPreSale ended at publicSaleStartTime in 2022. compose() has no time gate and still needs signerAddress's signature, so NFT composing dies.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: TheZenDao freeMint, preSale, compose: signed by signerAddress, set only in the constructor; only these mint gates stop (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- TheZenDao.sol: signerAddress written only in constructor; freeMint/preSale/compose compare recover with it
- preSaleStartTime 1664359200, publicSaleEndTime 1664445600: the presale window is in the past
- signerAddress = 0x1C2BFA53…e730, code 0x today
- compose has only onlyHuman; ETH leaves via owner distribute/recover (direct calls)

## Impact and exposure

- Value held at block 26,438,999: $423 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-26.

## Remediation

None on-chain; composing stops.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
