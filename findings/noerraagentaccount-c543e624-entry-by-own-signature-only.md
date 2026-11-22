---
id: noerraagentaccount-c543e624-entry-by-own-signature-only
title: "NoerraAgentAccount: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0xc543e624ed848df9ec18854a28be77b74d56db8c"
  family: "cd31133cdbbe7bbccb6d88900b5848cb"
  copies: 5
  name: "NoerraAgentAccount"
  upgradeable: "no"
  rating: LOW
  value_usd: 793
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 145
  last_active: 2026-10-30
fix:
  layer: account-migration
  who_acts: "agent runtime (picks an EOA/7702 nextSigner for handover)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Only the incoming signer's own acceptance is signature-gated; the human/signer reach held funds by direct calls. LOW holds."
---

## Summary

NoerraAgentAccount: the two precompile recoveries verify that the NEW signer accepts a rotation (activateApproved, handover). Under EIP-8151 a nextSigner with non-7702 code cannot accept; activateApproved already requires nextSigner.code.length == 0 so it is unchanged, and handover just needs a key without code.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: NoerraAgentAccount _checkStaleRecovery: the word recovery only; no signature / NoerraAgentAccount maxRecoveryReimbursement: no signature / NoerraAgentAccount maxRecoveryBounty: no signature /…. Read (function text).
- NoerraAgents.sol:949 activateApproved commitment requires nextSigner.code.length == 0 before the :968 recover == nextSigner (no change under EIP-8151); :1175-1181 handover recovers acceptance == nextSigner, nextSigner chosen by the calling runtime
- funds move via msg.sender roles: _signerOnly msg.sender == signer (:632-635), executeOwnerWithdrawal onlyHuman (:326 in contract), pay(...) by runtime; none needs the holder's signature
- at 26438999: signer 0x4B9fE851… (no code), human 0x39B19FBB…; ETH balance 0 (row value $793 held)

## Impact and exposure

- Value held at block 26,438,999: $793 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 145 transactions called it in the 90 days before that block; last on 2026-10-30.

## Remediation

The runtime hands over to an EOA or 7702-delegated nextSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
