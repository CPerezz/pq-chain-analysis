---
id: bytecoderepository-1ce2b1be-entry-by-own-signature-only
title: "BytecodeRepository: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0x1ce2b1be96a082b1b1539f80d5d8f82ec06a0f9a"
  family: "ce8154430d257cb425f57c454b0105dc"
  copies: 2
  name: "BytecodeRepository"
  label: "Gearbox: Bytecode Repository"
  upgradeable: "no"
  rating: LOW
  txs_90d: 126
  last_active: 2026-11-12
  recoveries_14d: 2
fix:
  layer: onchain-config
  who_acts: "bytecode authors (sign from an EOA/7702 key); Gearbox owner Safe replaces an auditor that holds code"
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
  note: "Registration (upload/audit) only; nothing held; the auditor key is replaceable by a live 4-of-N Safe through InstanceManager. LOW holds."
---

## Summary

Gearbox BytecodeRepository: uploadBytecode needs the author's own EIP-712 signature (and on mainnet msg.sender == author); submitAuditReport needs an approved auditor's signature. Under EIP-8151 an author or auditor whose address holds non-7702 code cannot sign; nothing is held by the repository.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: Gearbox bytecode repository: authors sign their uploads; audit reports are signed by approved auditors. Read by hand. Executed: a real transaction reverts with code at the signer.
- BytecodeRepository.sol:233-245 uploadBytecode: msg.sender must equal bytecode.author on chainid 1 and ECDSA.recover(...) == author; :319-326 submitAuditReport: auditor must be in _auditorsSet and recover to it
- addAuditor/removeAuditor (:500/:508) are onlyOwner; owner() at 26438999 = 0xb1576BBA… (executor, owner 0x77777777…CB2e InstanceManager, whose owner() = Safe 0x1E9ec044… threshold 4); 5 auditors at the block, 4 with no code and 1 a 7702 delegation (0xef0100…), so all can sign today
- balance 0 at 26438999; no payable/withdraw path in the contract: nothing held

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 126 transactions called it in the 90 days before that block; last on 2026-11-12.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

Authors upload from an EOA or 7702-delegated key; if an auditor key gains code, the owner Safe calls removeAuditor/addAuditor with a new key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
