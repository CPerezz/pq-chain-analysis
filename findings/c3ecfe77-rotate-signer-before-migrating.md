---
id: c3ecfe77-rotate-signer-before-migrating
title: "0xc3ecfe77 (tagged deployed by Lombard: Deployer): signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc3ecfe771564e3f28cfb7a9b203f4d10279338ed"
  family: "9e00b76e6a82a4b873a35e801ef415f2"
  label: "deployed by Lombard: Deployer"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1472
  last_active: 2026-11-18
  recoveries_14d: 273
fix:
  layer: onchain-config
  who_acts: "timelock 0x055E…7e59 (DEFAULT_ADMIN_ROLE)"
evidence:
  level: bytecode
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
  note: "Setter is held by a working timelock with admin role, so LOW holds. I did not enumerate the timelock's proposers. Update (reviewer of chunk): timelock 0x055E…7e59 proposers at the block are a 3-of-5 Safe 0x251a…4892 and EOA 0x3f6b…a079 (nonce 209); executors not checked."
---

## Summary

A contract that checks signatures against a stored trustedSigner. It fails once that signer's account holds code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (grantRole, revokeRole, setTrustedSigner, updateValidateThreshold). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- setTrustedSigner(address) requires hasRole(DEFAULT_ADMIN_ROLE, msg.sender) (storage_map_d[0][msg.sender]) and a non-zero config address (0xf74d5480 = 0x8cdb…2768) (decompile)
- hasRole(0x0, timelock 0x055E…7e59) = true; timelock getMinDelay = 86400 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,472 transactions called it in the 90 days before that block; last on 2026-11-18.
- 273 signature recoveries in the study's two-week trace window.

## Remediation

The timelock schedules and executes setTrustedSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
