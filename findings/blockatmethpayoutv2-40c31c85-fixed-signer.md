---
id: blockatmethpayoutv2-40c31c85-fixed-signer
title: "BlockATMEthPayoutV2: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x40c31c859eb6d1a25ee288372672864fe2d15da6"
  family: "1617d0b3b3ecf9a6b494c54e853248f9"
  name: "BlockATMEthPayoutV2"
  upgradeable: "no"
  rating: LOW
  txs_90d: 13
  last_active: 2026-11-12
  recoveries_14d: 1
fix:
  layer: onchain-config
  who_acts: "contract owner + finance"
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
  rating: LOW
  note: "A setting plus a direct call keeps the same act (payout or withdrawal) open: LOW."
---

## Summary

BlockATMEthPayoutV2: payoutByProxy accepts batches signed by an address in financeMap. That map is set once in the constructor ([0xbe414353…], an EOA) and has no add or remove. If the finance key takes code, the finance address itself can still pay with payoutByContract and withdrawByFinancial by direct call, once the immutable owner (EOA 0x0b9251a1…) runs enableFinanceOperations().

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: BlockATM payout (newer build): the same design as adfd1a78; the finance list is set in the constructor and has no add or remove; finance addresses also withdraw by direct call. Read by hand. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source: processList is called only in the constructor; no finance setter; _validateSignature requires financeMap[signer].
- payoutByContract and withdrawByFinancial are onlyFinance, gated by financeOperationsEnabled (false today); enableFinanceOperations is onlyOwner.
- owner()=0x0b9251a1… EOA; finance list=[0xbe414353…], no code; balance 0 ETH (cast).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 13 transactions called it in the 90 days before that block; last on 2026-11-12.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

The owner calls enableFinanceOperations; finance pays directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
