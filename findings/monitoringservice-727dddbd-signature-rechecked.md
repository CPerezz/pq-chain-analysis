---
id: monitoringservice-727dddbd-signature-rechecked
title: "MonitoringService: a signature checked again after others relied on it"
status: confirmed
severity: MEDIUM
patterns: [PQ-15]
impact: liveness
contracts:
- address: "0x727dddbd042d891180a252c7a20634a696a16925"
  family: "bd161c27a0b85189963fa22023d65007"
  copies: 2
  name: "MonitoringService"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Raiden/Brainbot (new MonitoringService)"
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
  rating: MEDIUM
  note: "Signer (Raiden node) only harms its own protection; the MS has put no funds at risk and its reward is created only by a successful monitor; the closing_signature recheck lives in TokenNetwork (its own row). Function dies, nothing locked -> MEDIUM, not CRITICAL"
---

## Summary

updateReward (called first by monitor) requires the reward proof to recover to non_closing_participant, the Raiden node key that hired the MS. If that node's address takes code, monitor() reverts: the node loses its own monitoring and the MS is simply never owed a reward; claimReward pays only after a successful monitor and has no signature check.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Raiden MonitoringService updateReward: a reward proof the Raiden node signed earlier is used later by the monitoring service. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- updateReward: require(recoverAddressFromRewardProof(...)==non_closing_participant,'Bad reward proof') (source/data/source/services/MonitoringService.sol L103-134)
- monitor() -> updateReward -> TokenNetwork.updateNonClosingBalanceProof; claimReward moves UDC funds without a signature
- EIP-1967 impl/admin slots zero at 26438999; no owner/upgrade function in source
- txs_90d 0, last_active null (measured)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

New MonitoringService with code-aware verification; Raiden nodes migrate keys only after channels settle

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
