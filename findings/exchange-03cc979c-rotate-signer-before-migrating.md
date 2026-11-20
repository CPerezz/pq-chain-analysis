---
id: exchange-03cc979c-rotate-signer-before-migrating
title: "Exchange: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x03cc979c46b030c4abd7d4063cd075cb38cd0919"
  family: "80f3c228adcb12fabbd1dbcdf86f8a4d"
  name: "Exchange"
  upgradeable: "no"
  rating: LOW
  value_usd: 24362
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x5baa…7906"
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
  note: "Live EOA owner; user funds withdraw directly."
---

## Summary

Options Exchange (DSAuth): claimFeeRebate requires a signer authorised by owner/authority; orders recover the maker.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: options Exchange claimFeeRebate: the signer must be authorised by the authority contract / options Exchange _getMaker: returns the signer of an order. Read from source.
- setOwner/setAuthority are auth (owner) (Exchange.sol:69,77)
- owner() = 0x5baa…7906, EOA nonce 183 at 26438999
- withdraw/withdrawDai are direct calls, so makers' balances never depend on signatures

## Impact and exposure

- Value held at block 26,438,999: $24,362 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner authorises a new rebate signer via setAuthority/setOwner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
