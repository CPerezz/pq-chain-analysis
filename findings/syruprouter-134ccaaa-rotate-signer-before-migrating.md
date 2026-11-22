---
id: syruprouter-134ccaaa-rotate-signer-before-migrating
title: "SyrupRouter: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x134ccaaa4f1e4552ec8aecb9e4a2360ddcf8df76"
  family: "2f946ab3ce3dfed24c45fc5379ec2285"
  copies: 3
  name: "SyrupRouter"
  label: "Maple: USDC Router"
  upgradeable: "no"
  rating: LOW
  txs_90d: 3032
  last_active: 2026-11-18
  recoveries_14d: 57
fix:
  layer: onchain-config
  who_acts: "Maple operational admin Safe 0xCe1cE7c7… (3 of 5)"
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
  rating: LOW
  note: "A live Safe can rotate the permission admins."
---

## Summary

Maple SyrupRouter (USDC). authorizeAndDeposit requires a signature from a permission admin of the PoolPermissionManager. Under EIP-8151 an admin key that takes non-7702 code can no longer authorise deposits.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Maple SyrupRouter: the signer must be a permission admin in the pool permission manager. Read from source. Executed: a real transaction reverts with code at the signer.
- SyrupRouter.sol:122-127: ecrecover, then ppm.permissionAdmins(recovered) must be true. The recovered admin 0x4575e7e9… is an admin (true) with no code at block 26438999
- PPM 0xBe10aDcE… (proxy, impl 0xc3530358…) has setPermissionAdmin (0xf7133181). eth_call at block 26438999 from operationalAdmin 0xCe1cE7c7… succeeds; from 0xdEaD it reverts PPM:NOT_GOV_OR_OA
- 0xCe1cE7c7… is a Safe: threshold 3, 5 owners, nonce 211. The governor 0x2eFFf887… is a Maple GovernorTimelock (latestProposalId 49)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 3,032 transactions called it in the 90 days before that block; last on 2026-11-18.
- 57 signature recoveries in the study's two-week trace window.

## Remediation

The operational admin Safe sets a new permission admin and removes the old one before that key takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
