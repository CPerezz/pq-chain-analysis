---
id: f95f0359-rotate-signer-before-migrating
title: "0xf95f0359: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf95f0359704a66db38d159e5a99721f069f30d9c"
  family: "c76477982e6f6b42b474391b612ed1bd"
  upgradeable: "no"
  rating: LOW
  value_usd: 77957
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 18
  last_active: 2026-11-13
  recoveries_14d: 7
fix:
  layer: onchain-config
  who_acts: "AccessManager admin Safes 0xaaaa…1aaa / 0xff0d…cfff"
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
  note: "A live Safe holds the AccessManager admin role. The selector-to-role mapping of the signer setter was not read individually."
---

## Summary

Unverified OpenZeppelin AccessManaged token-release contract (EIP-712 'Reserve'): releases need stored signer keys up to a threshold (releaseThreshold = 2), checked by ecrecover. A signer that takes code stops counting.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (setAuthority, setReleaseThreshold). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- heimdall decompile (s1/c76477): every admin function (signer set changes, setReleaseThreshold) is gated by authority.canCall (0xb7009613); setAuthority requires msg.sender == authority
- authority = AccessManager 0xcCC7B6cb…EccC; hasRole(0, ·) at block is true for Safe 0xaaaaee75…1aaa (2-of-3, owner EOAs nonces 7/171/414) and Safe 0xff0d7803…cfff (3-of-5); the initial EOA 0xbbcf…c426 was revoked
- the AccessManager admin role can grant any function role, so the signer setter is reachable

## Impact and exposure

- Value held at block 26,438,999: $77,957 (ETH and 49 priced tokens).
- Activity: 18 transactions called it in the 90 days before that block; last on 2026-11-13.
- 7 signature recoveries in the study's two-week trace window.

## Remediation

AccessManager admin grants itself or an operator the role for the signer-set function and replaces the migrating signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
