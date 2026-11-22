---
id: beefyclient-7cfc5c8b-rotate-signer-before-migrating
title: "BeefyClient: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7cfc5c8b341991993080af67d940b6ad19a010e1"
  family: "2f07aaa2e750389f3880fef8d9a819f7"
  name: "BeefyClient"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2235
  last_active: 2026-11-09
  recoveries_14d: 5004
fix:
  layer: offchain
  who_acts: "the Polkadot validator holding the BEEFY key (session key rotation)"
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
  note: "The key holder itself can replace the key through session-key rotation, and the set self-updates. No admin is needed."
---

## Summary

Snowbridge BeefyClient. submitInitial and submitFinal check each validator signature with OZ ECDSA.recover against the account in the validator-set proof. Under EIP-8151 a validator whose derived address takes non-7702 code cannot be counted.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Snowbridge BeefyClient submitInitial: the signer must be the validator account named in the proof, a member of the current or next validator set; the sets advance with the light client's own updates…. Read from source. Executed: a real transaction reverts with code at the signer.
- BeefyClient.sol:313/686/727: ECDSA.recover(...) != proof.account reverts
- BeefyClient.sol:427/583: currentValidatorSet = nextValidatorSet. The sets advance only through the light client's own updates; there is no owner setter
- txs.json: recovered signers are validator EOAs (for example 0x363a02f5…)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2,235 transactions called it in the 90 days before that block; last on 2026-11-09.
- 5,004 signature recoveries in the study's two-week trace window.

## Remediation

The validator rotates its BEEFY session key on Polkadot (or keeps a 7702 delegation); the new key enters the next validator set.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
