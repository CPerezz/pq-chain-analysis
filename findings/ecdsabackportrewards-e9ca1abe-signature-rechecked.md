---
id: ecdsabackportrewards-e9ca1abe-signature-rechecked
title: "ECDSABackportRewards: a signature checked again after others relied on it"
status: not-affected
severity: NONE
patterns: [PQ-15]
impact: none
contracts:
- address: "0xe9ca1abe343515312eb6d13178c5a2dce3c036fa"
  family: "414f094c65087f7a162def938ae9fa38"
  name: "ECDSABackportRewards"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "none"
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
  verdict: refuted
  rating: NONE
  note: "There is no signature recheck in this contract, and the keep's signer is a threshold-key address that cannot take code."
---

## Summary

Keep ECDSABackportRewards is a rewards distributor that calls no ecrecover itself; the ecrecover hits come from AbstractBondedECDSAKeep in the same verified bundle. There, the expected signer is publicKeyToAddress of the keep's threshold group key, an address nobody holds alone and that cannot take code.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Keep ManagedGrant.recoverStake: no signature (matched on a word) / Keep TokenGrant.recoverStake: no signature / Keep TokenGrantStake.recoverStake: no signature / Keep BondedECDSAKeep submitSignature:…. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Sourcify verified source (scratch review_agents/036/src): the only ecrecover sites are solidity_contracts_AbstractBondedECDSAKeep.sol:242 (submitSignature) and :529 (checkSignatureFraud), both compared with publicKeyToAddress(publicKey)
- ECDSABackportRewards.sol inherits Rewards only (contract ECDSABackportRewards is Rewards)
- the note's recoverStake matches are word matches with no signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
