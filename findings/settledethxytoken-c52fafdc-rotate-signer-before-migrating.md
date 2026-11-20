---
id: settledethxytoken-c52fafdc-rotate-signer-before-migrating
title: "SettledEthXYToken: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc52fafdc900cb92ae01e6e4f8979af7f436e2eb2"
  family: "e74c42168a05140791606c34aa4dec79"
  name: "SettledEthXYToken"
  label: "EthXY: SEXY Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 1207
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 102
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "the key holder or owner rotates the key"
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025)"
---

## Summary

`SettledEthXYToken` at `0xc52fafdc900cb92ae01e6e4f8979af7f436e2eb2` (Etherscan tag: EthXY: SEXY Token). It accepts signatures from a key that a function can replace; the holder rotates it before the account takes code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: SettledEthXYToken: mint_by_sig signed by the stored minter (set_minter replaces it); Vyper permit by the owner named, approve is the direct call. Read.
- Reviewed through the root issue's mechanism (D-025): the reading for this address names how the checked key or key set is replaced (a setter, a role grant, an owner hand-over or an edit of the signer set), so it can rotate before the key's account takes code: LOW
- Not checked per row: whether the party allowed to call that function is live at block 26,438,999
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 18,615 rows below Anon's thresholds: 15 held at LOW, 5 were unused implementations (not affected), 1 had owners that cannot be replaced (MEDIUM), 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $1,207 (ETH and 49 priced tokens).
- Activity: 102 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
