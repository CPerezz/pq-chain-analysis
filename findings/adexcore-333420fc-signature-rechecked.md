---
id: adexcore-333420fc-signature-rechecked
title: "AdExCore: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x333420fc6a897356e69b62417cd17ff012177d2b"
  family: "07c7ce7d5145039825bfb3dd5519cddf"
  name: "AdExCore"
  label: "deployed by heyAura: Deployer 2"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 16036
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-10-19
fix:
  layer: new-deployment
  who_acts: "parties settle before a signing address takes code"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signature-rechecked"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: "earners lose their payout"
---

## Summary

`AdExCore` at `0x333420fc6a897356e69b62417cd17ff012177d2b` (Etherscan tag: deployed by heyAura: Deployer 2). It checks a signature again after others relied on it; once the signer's account has code, that check fails and the party that relied on it loses.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: AdEx core: a channel pays out only on a state root signed by two thirds of the channel's validators, the first of them always; after the channel's end its creator takes back what is left. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Read by hand (AdEx core): a channel pays out only on a state root signed by two thirds of its validators, the first always; earners withdraw later against that root. A validator that takes code after signing makes the root unusable, and after the channel ends its creator takes back what is left, so earners lose.
- No proxy, no upgrade. 1 transaction in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $16,036 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-19.

## Remediation

New deployments that check once, or accept ERC-1271; until then parties settle before migrating a signing address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
