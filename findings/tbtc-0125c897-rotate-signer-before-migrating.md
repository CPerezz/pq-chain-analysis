---
id: tbtc-0125c897-rotate-signer-before-migrating
title: "EcdsaDkgValidator: signer key to rotate before its account takes code"
project: tbtc
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0125c8977a02b2fa3970b1ed9af02f5bedd4ef27"
  family: "c7877dc4855722a5f03bf4c0c064af61"
  copies: 3
  name: "EcdsaDkgValidator"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1
  last_active: 2026-11-14
  recoveries_14d: 100
fix:
  layer: onchain-config
  who_acts: "the key holder or owner rotates the key"
evidence:
  level: executed
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

`EcdsaDkgValidator` at `0x0125c8977a02b2fa3970b1ed9af02f5bedd4ef27`, with 2 more addresses running its code. It accepts signatures from a key that a function can replace; the holder rotates it before the account takes code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Threshold/tBTC EcdsaDkgValidator.validateSignatures: every supporting signature of a DKG result must recover to the operator of the member at that index; a result that does not validate can be…. Read from source. Executed: a real transaction reverts with code at the signer. Rated by hand: executed: nothing moves today (seize only emits an event) and clients can leave such signatures out.
- Reviewed through the root issue's mechanism (D-025): the checked signers are a committee or validator set that its own quorum replaces by a signed update, so while enough keys are still EOAs the set rotates before migrating: LOW, as for wallets their own signers can upgrade
- Not checked per row: whether the party allowed to call that function is live at block 26,438,999
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 18,615 rows below Anon's thresholds: 15 held at LOW, 5 were unused implementations (not affected), 1 had owners that cannot be replaced (MEDIUM), 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-11-14.
- 100 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
