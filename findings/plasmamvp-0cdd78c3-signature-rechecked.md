---
id: plasmamvp-0cdd78c3-signature-rechecked
title: "PlasmaMVP: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x0cdd78c34a4305234898864c1daccdbb326a520d"
  family: "79512fd4b7340b3af67b3fad7e6f7150"
  name: "PlasmaMVP"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "plasma users and operator"
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
  note: "Wrong verdicts (unchallengeable fraud, a recipient blocked from exiting) hit users who did nothing; no update path."
---

## Summary

PlasmaMVP root contract: a transaction exit requires the input owners' confirm signatures, checked again at exit time, and challengeExit uses the exit owner's own spend or confirm signature as fraud evidence. If an input owner takes code, the recipient cannot exit; if a cheating exit owner takes code, a double-spend exit cannot be challenged.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: PlasmaMVP exit: the input owners' confirmation signatures, made earlier, are checked again at exit / PlasmaMVP challengeExit: the exit owner's own signature on a spending transaction is evidence…. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- PlasmaMVP.sol:842-848 startTransactionExitHelper: confirmationHash.recover(...) must equal txHash.recover(sig) for each input
- PlasmaMVP.sol:969-976 challengeExit: recovered signer must equal exit_.owner
- operator() 0x1d97…5e21 with changeOperator, but no upgrade; txs_90d 0

## Impact and exposure

- Value held at block 26,438,999: $902 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on chain; exits must be made before signers' addresses take code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
