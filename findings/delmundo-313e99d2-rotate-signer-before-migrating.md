---
id: delmundo-313e99d2-rotate-signer-before-migrating
title: "DelMundo: signer key to rotate before its account takes code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x313e99d23d6a9ed47af8dccd545c2685f21ec44b"
  family: "ae01a30572d3d64a8b1e247e1ef1547f"
  name: "DelMundo"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 3106
  last_active: 2026-11-17
fix:
  layer: new-deployment
  who_acts: "owner EOA 0x348F…A20E (keep its key un-migrated)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "The note's grantRole/revokeRole setter is unusable (no DEFAULT_ADMIN holder). No update path, the signed mint dies, nothing locked → MEDIUM."
---

## Summary

DelMundo NFT mint requires an ECDSA signature from a holder of MINTER_ROLE. If that holder gets code, signed mints fail.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (grantRole, revokeRole, setAutomaticApprovalOfTransfersFromValidator, setTransferValidator). Whoever holds it must replace it before…. Rule: stored-key.
- verified source (sourcify) DelMundo.sol:351-353: voucher mint requires hasRole(MINTER_ROLE, ECDSA.recover(voucher)); MINTER_ROLE only granted in the constructor (line 100); no DEFAULT_ADMIN_ROLE grant and no setRoleAdmin, so grantRole(MINTER_ROLE) is callable by nobody
- at block 26438999: hasRole(MINTER_ROLE, owner 0x348F…A20E)=true (EOA, nonce 548, no code); getRoleAdmin(MINTER_ROLE)=0x00; hasRole(0x00, owner)=false
- safeMint(address,uint256) is onlyRay (an owner-side mint), so paid voucher sales die but nothing held is locked; 3106 txs in 90d (row)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3,106 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

No rotation: the minter EOA must never get code, or the project redeploys. safeMint stays available for owner mints.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
