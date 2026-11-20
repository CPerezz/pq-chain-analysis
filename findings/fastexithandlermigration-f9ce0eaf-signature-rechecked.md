---
id: fastexithandlermigration-f9ce0eaf-signature-rechecked
title: "FastExitHandlerMigration: a signature checked again after others relied on it"
status: not-affected
severity: NONE
patterns: [PQ-15]
impact: none
contracts:
- address: "0xf9ce0eafc99b7cf002503da06553756743965677"
  family: "9a62ecb08a6096ac4cd1cbf1ea891f7d"
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
  note: "Uninitialized implementation. I did not exhaustively prove that no other proxy points here."
---

## Summary

This is an uninitialized Leap/Parsec FastExitHandlerMigration implementation: bridge()=0, exitDuration()=0, slot 0 empty, no exits possible. It is not the current implementation of the Leap exit-handler proxy (that is 0x07658107…).

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Parsec/Leap FastExitHandler challengeExit: an exit is challenged with a spending transaction its owner signed earlier. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Sourcify verified source (scratch review_agents/036/src) FastExitHandlerMigration.sol: challengeExit recovers the spender via ecrecover (line ~1002)
- at 26438999: bridge()=0x0, exitDuration()=0, storage slot 0 = 0
- Leap proxy 0x495AeB6F… implementation slot (zos) = 0x07658107…, not this address

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
