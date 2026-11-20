---
id: bdcb49e9-rotate-signer-before-migrating
title: "0xbdcb49e9: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbdcb49e941615668dad186d8a95043d666fd08a5"
  family: "c0815231a21bca113d19c7bd66f408e1"
  copies: 2
  upgradeable: "yes"
  rating: LOW
  value_usd: 13173
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 153
  last_active: 2026-11-17
  recoveries_14d: 12
fix:
  layer: onchain-config
  who_acts: "owner EOA 0xc8baef7fb09d0c0300c4e47e0d75d5232d380219"
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
  note: "LOW: setter and upgrade callable by a live EOA owner."
---

## Summary

UUPS wallet proxy (impl 0x3f2529b0…): withdraw(address,address,uint256,uint256,bytes) needs a signature from the stored operator. An operator with code makes withdrawals revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setOperator). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- heimdall decompile of the implementation: setOperator requires msg.sender == owner (ERC-7201 Ownable slot, OwnableUnauthorizedAccount error)
- operator() = 0x7b43feb3… (EOA nonce 147); owner() = 0xc8baef7f… (EOA nonce 7) at block 26438999
- upgradeToAndCall and setWalletImplementation are present (upgradeable)

## Impact and exposure

- Value held at block 26,438,999: $13,173 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 153 transactions called it in the 90 days before that block; last on 2026-11-17.
- 12 signature recoveries in the study's two-week trace window.

## Remediation

The owner calls setOperator with a new key, or upgrades.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
