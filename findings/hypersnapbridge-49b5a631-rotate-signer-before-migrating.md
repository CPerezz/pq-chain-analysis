---
id: hypersnapbridge-49b5a631-rotate-signer-before-migrating
title: "HypersnapBridge: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x49b5a631f54927c0007232844f06fe18cbf69786"
  family: "5fe4b0da0d53f256e93e305a83b3813e"
  copies: 2
  name: "HypersnapBridge"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 16799
  last_active: 2026-11-17
  recoveries_14d: 26
fix:
  layer: onchain-config
  who_acts: "current owner key (threshold-ECDSA)"
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
  note: "The key holder itself can rotate, and it is live. Its key is threshold-derived, so it is unlikely ever to hold code."
---

## Summary

HypersnapBridge (UUPS). Claims and admin actions need the ECDSA signature of ownerAddress, a DKLS23 threshold-derived secp256k1 key.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call / a claim above the latest block must carry the signature of the stored owner address; rotateOwner replaces it /…. Read from source. Executed: a real transaction reverts with code at the signer.
- rotateOwner (HypersnapBridge.sol:229) takes the outgoing owner's signature plus the new owner's acceptance; anyone can relay it
- ownerAddress at 26438999 = 0x32d1550e…85E8: EOA, nonce 5, no code
- UUPS upgrades are also signed by the owner (proposeUpgrade/executeUpgrade)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 16,799 transactions called it in the 90 days before that block; last on 2026-11-17.
- 26 signature recoveries in the study's two-week trace window.

## Remediation

The owner key signs rotateOwner to a fresh key before that address takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
