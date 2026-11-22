---
id: 79241bbe-rotate-signer-before-migrating
title: "0x79241bbe: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x79241bbe3646d8405849cbe8608e77b82c402892"
  family: "bc7707498252227d8af27c5d08e1cd87"
  upgradeable: "yes"
  admin: "0xf2a2bee383c2e4d75d9ae5953b3a6cfabb661a47"
  rating: LOW
  txs_90d: 6
  last_active: 2026-10-12
fix:
  layer: onchain-config
  who_acts: "role holders re-grant a role to a plain key, through the flow itself, before or after a holder's account takes code"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "A role holder whose account takes code can no longer sign approvals, so multi-role actions that need its signature stop until the role is granted to a plain key. The flow holds its own admin role and owns its upgrade chain, so its holders re-grant or upgrade through it while their keys are still plain accounts: LOW, a rotation, as for wallets whose own signers can replace themselves. Filed under the rotation issue; the study's SimpleMultiSig mapping was wrong. Not read: the policy that governs role changes (which roles must sign it)."
---

## Summary

Not a SimpleMultiSig wallet: an 'ApprovalFlow' v1 (contractName(), EIP-712 domain 'ApprovalFlow' version 1) behind an EIP-1967 proxy, created at block 23,424,728 by factory 0x4815b877. It executes calls on target contracts once the roles a policy names approve: a one-role policy by a direct call from a holder, a multi-role policy by EIP-712 signatures of the holders (ecrecover, no ERC-1271). Holds no ETH.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: proxy to 0x621dd8d71526d7df51fa1aa8d098f5eaec81c573, admin 0xf2a2bee383c2e4d75d9ae5953b3a6cfabb661a47.
- Implementation 0x621dd8d71526d7df51fa1aa8d098f5eaec81c573 (unverified, 7,985 bytes) decompiled with heimdall 0.9.2: direct execution 0x17799dc3(target, data, nonce) checks the caller's role for the target's selector; signed execution 0x0c040708(target, data, validAfter, validBefore, nonce, signatures[]); role changes 0xfe4f1b68 need DEFAULT_ADMIN_ROLE; no isValidSignature selector in the code
- At the latest block (26,455,6xx; node down): hasRole(DEFAULT_ADMIN_ROLE, the flow itself) = true; the proxy's ProxyAdmin 0xf2a2bee3 is owned by factory 0x4815b877, whose owner() is the flow itself; balance 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-10-12.

## Remediation

Read the implementation and 0x4815 to find who can actually drive an upgrade.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-rotate-signer-before-migrating` applies, not `eip-8151-wallets-fixed-signers`; filed under it.
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
