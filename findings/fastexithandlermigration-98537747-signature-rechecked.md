---
id: fastexithandlermigration-98537747-signature-rechecked
title: "FastExitHandlerMigration: a signature checked again after others relied on it"
status: not-affected
severity: NONE
patterns: [PQ-15]
impact: none
contracts:
- address: "0x985377478341fa9d4f09a8ec95b58b4c7fb80c6e"
  family: "8309dc4a3ca0e98c810a16c5a5511112"
  name: "FastExitHandlerMigration"
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
  note: "Every path to the check is closed by code: no exit can be created"
---

## Summary

challengeExit does recover the spender's signature, but this FastExitHandlerMigration implementation disables every exit entry (startExit, startDepositExit, startBoughtExit, deposit revert 'not implemented'), so exits[utxoId].amount>0 can never hold and the check is unreachable.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Parsec/Leap FastExitHandler challengeExit: an exit is challenged with a spending transaction its owner signed earlier. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- FastExitHandlerMigration overrides deposit/startExit/startDepositExit/startBoughtExit with revert('not implemented') (source L1108-1122)
- challengeExit requires exits[utxoId].amount > 0 after the ecrecover (L1006-1035)
- EIP-1967 and zos impl/admin slots zero, ETH balance 0 at 26438999 (an implementation; used behind a Leap AdminUpgradeabilityProxy whose admin upgrades it)
- txs_90d 0, last_active null (measured)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
