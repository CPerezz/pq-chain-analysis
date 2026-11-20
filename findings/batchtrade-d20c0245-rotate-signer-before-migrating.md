---
id: batchtrade-d20c0245-rotate-signer-before-migrating
title: "BatchTrade: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd20c024560cca40288c05bab650ac087ae9b0f6e"
  family: "0eb672e90cf44aa24378f59648641967"
  name: "BatchTrade"
  label: "31Third: Batch Trade"
  upgradeable: "no"
  rating: LOW
  value_usd: 11730
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2157
  last_active: 2026-11-17
  recoveries_14d: 166
fix:
  layer: onchain-config
  who_acts: "owner Safe 0xec0905ec85e9c8bfd70fd4bb4988488a3c92ab93"
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
  note: "The setter exists and a live 2-of-3 Safe can call it: LOW holds. txs_90d 2157, value $11,730."
---

## Summary

31Third BatchTrade checks that each trade's ecrecover result equals tradeSigner. If tradeSigner gets non-7702 code, every signed trade reverts.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source. Executed: a real transaction reverts with code at the signer.
- BatchTrade.sol:343 updateTradeSigner(address) is onlyOwner; :502 recover == tradeSigner
- owner()=0xec0905…ab93 at block 26438999: a Safe proxy, getOwners=[0x6c9B…7b34,0x6E38…85c5,0x2185…424a], threshold 2

## Impact and exposure

- Value held at block 26,438,999: $11,730 (ETH and 49 priced tokens).
- Activity: 2,157 transactions called it in the 90 days before that block; last on 2026-11-17.
- 166 signature recoveries in the study's two-week trace window.

## Remediation

Before the trade signer takes code, the owner Safe calls updateTradeSigner with a new EOA key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
