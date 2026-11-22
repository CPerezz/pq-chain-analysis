---
id: dexvaultv1-ec0377a6-rotate-signer-before-migrating
title: "DEXVaultV1: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xec0377a6bc71c4a28288a5cfd307b80c53a7e1e1"
  family: "06599eb90bb08b3db5f36ee14279b564"
  copies: 2
  name: "DEXVaultV1"
  upgradeable: "yes"
  rating: LOW
  value_usd: 779931
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3534
  last_active: 2026-11-18
  recoveries_14d: 378
fix:
  layer: onchain-config
  who_acts: "vault owner (3-of-n Safe 0xd2f7…2a19)"
evidence:
  level: executed
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
  note: "Setter exists and owner is a live Safe."
---

## Summary

DEXVaultV1 custodial vault (UUPS) paying withdrawals on 2-of-3 stored co-signer signatures; a co-signer with real code stops counting.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (signer, validator, authority, relayer), distinct or ordered; a quorum or weight is needed. Read from source. Executed: a real transaction reverts with code at the signer.
- changeSigners(address[]) onlyOwner replaces all signers (DEXVaultV1.sol:399-416)
- owner()=0xd2f73c7a…2a19 is a Safe proxy, threshold 3, nonce 1 at block (getThreshold/getOwners)
- owner also authorises UUPS upgrades; signers 0xf160…,0xcae7…,0x200c…

## Impact and exposure

- Value held at block 26,438,999: $779,931 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 3,534 transactions called it in the 90 days before that block; last on 2026-11-18.
- 378 signature recoveries in the study's two-week trace window.

## Remediation

Owner Safe calls changeSigners with fresh EOA signers before any co-signer takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
