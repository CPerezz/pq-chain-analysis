---
id: coolpets-f3d13419-rotate-signer-before-migrating
title: "CoolPets: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf3d13419a03e794dd536d1d8fd6575de5781c31f"
  family: "a3cef04cbed2ef587683afbe8e3b1ec7"
  copies: 2
  name: "CoolPets"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1286
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "owner EOA 0xbc9A…99dA"
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
  note: "Setter exists and the owner is a live EOA, so LOW holds. The row's note says the signer is the owner; it is in fact the separate _systemAddress slot, which only coincides with the owner today."
---

## Summary

An ERC-721 ('Test Cool Pets') whose public mint requires a signature from _systemAddress (slot 9). Minting fails once that key's account holds code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one address in storage and the only such address the code names is its owner, which can be handed over (renounceOwnership, transferOwnership). Rule: stored-key (the owner).
- The public mint path does ECDSA recover and requires the result to equal _systemAddress ('CP: Invalid signature'); setSystemAddress(address) is onlyOwner (decompile)
- _systemAddress = owner() = 0xbc9Ac18eA3B24fDFf0a63Bd7Cb9DFd5469c199dA, an EOA with nonce 33, at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,286 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The owner calls setSystemAddress with a new EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
