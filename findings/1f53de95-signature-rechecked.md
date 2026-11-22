---
id: 1f53de95-signature-rechecked
title: "0x1f53de95: a signature checked again after others relied on it"
status: confirmed
severity: MEDIUM
patterns: [PQ-15]
impact: liveness
contracts:
- address: "0x1f53de95888a82aaae1d90741009a559c107dce6"
  family: "017a236549e48add6294844213dd4db2"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 7
  last_active: 2026-11-14
  recoveries_14d: 2
fix:
  layer: new-deployment
  who_acts: "link creator (cancel) / operator (redeploy)"
evidence:
  level: bytecode
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
  note: "The relying recipient never had a guarantee: the creator can cancel an open link at any time. The escrow therefore always returns to the creator through a direct call, so nothing is locked. The signed claim dies for good and there is no update path → MEDIUM, not CRITICAL. Signer identity (creator key vs ephemeral link key) is inferred from the struct, not traced."
---

## Summary

Confidential-token (FHE) payment links: claim(uint256,address,bytes) (0xecbd45af) pays an open link to a recipient on a signature recovered for claimDigest. If the link signer's address takes real code, unclaimed links can no longer be claimed, but the creator can always take the escrow back with cancel(uint256): no signature, no timeout.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: payment links (2 recoveries): a link created with a signer can be claimed with its signature later; a signer with code voids unclaimed links (inferred). Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompiled cancel(uint256): requires msg.sender == creator (link word >> 80) and status==1 (open), sets status 5, refunds the escrow to the creator via confidentialTransfer; no expiry gate
- claim path 0xecbd45af: status==1, block.timestamp < expiry, ecrecover over EIP-712 claimDigest(id,recipient), then confidentialTransfer to the recipient
- EIP-1967 impl/admin slots are 0 at 26438999; no owner/upgrade selector among the 12 functions; ETH balance 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 7 transactions called it in the 90 days before that block; last on 2026-11-14.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

Creators cancel unclaimed links before the signer key migrates and re-issue them on a new deployment with ERC-1271 or code-aware verification.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
