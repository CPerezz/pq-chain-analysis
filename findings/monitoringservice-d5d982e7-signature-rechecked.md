---
id: monitoringservice-d5d982e7-signature-rechecked
title: "MonitoringService: a signature checked again after others relied on it"
status: not-affected
severity: NONE
patterns: [PQ-15]
impact: none
contracts:
- address: "0xd5d982e72ddac6c6479d5c5ece9bce3ae3779938"
  family: "578b20b9c9a01891ddc960ff8c432b01"
  name: "MonitoringService"
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
  note: "Closed for good by state (deprecated registry, expired sole registration). Even when live, the reward-proof signer is the node itself, and the monitoring service had done no work yet."
---

## Summary

Raiden MonitoringService: monitor() checks the node's reward proof and calls updateNonClosingBalanceProof, but firstBlockAllowedToMonitorChannel requires service_registry.hasValidRegistration(msg.sender), and no registration can exist any more. Every path to the check is closed for good. claimReward() does not recheck any signature.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Raiden MonitoringService updateReward: a reward proof the Raiden node signed earlier is used later. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Sourcify verified source (scratch review_agents/036/src) MonitoringService.sol: monitor → updateReward (recoverAddressFromRewardProof == non_closing_participant), then the registration check
- the only registered service ever, 0xDCd32F44…, has service_valid_till 1634114147 (2021); ServiceRegistry 0xbDFDCE3B… deprecated()=true, so deposit() reverts and no one can register again
- claimReward pays from the UDC using stored data only (no ecrecover)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
