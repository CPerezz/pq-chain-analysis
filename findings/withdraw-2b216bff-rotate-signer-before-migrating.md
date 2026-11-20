---
id: withdraw-2b216bff-rotate-signer-before-migrating
title: "Withdraw: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2b216bff2d2be0a542af34314161a815a807be49"
  family: "6ffe3cc5982f806f759aac69e2c8127e"
  copies: 2
  name: "Withdraw"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2498
  last_active: 2026-11-18
  recoveries_14d: 241
fix:
  layer: onchain-config
  who_acts: "owner EOA (7702-delegated)"
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
  note: "Owner-only setter exists; the owner is a live (7702-delegated) EOA."
---

## Summary

Withdraw: pays out tokens on claimreward when the recovered address equals signAddr; a signAddr with code would block claims.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- source Withdraw.sol: setSignAddr(address) is onlyOwner and writes signAddr, which claimreward compares to the ecrecover result; no ERC-1271 path
- eth_call at block 26438999: setSignAddr from owner succeeds, from 0xdead reverts 'Ownable: caller is not the owner'
- owner 0x5840242988422ABD8546c514b8e4D3FF1F7dFB7d is a 7702-delegated EOA, nonce 207 (probe); signAddr()=0x56bF8b22F81ed39a750E8F320fB9Af1A2EA6CF57; rescueToken/rescueETH onlyOwner as well

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,498 transactions called it in the 90 days before that block; last on 2026-11-18.
- 241 signature recoveries in the study's two-week trace window.

## Remediation

Owner calls setSignAddr with a plain key before the signer takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
