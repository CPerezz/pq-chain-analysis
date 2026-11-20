---
id: vaulthandlerv8-f314fa95-rotate-signer-before-migrating
title: "VaultHandlerV8: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf314fa957255ad6ba189a641e6086c81385040fb"
  family: "0cb07440e29773ead5b4532425ebef35"
  name: "VaultHandlerV8"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2033
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "owner 0x2272ECf4 (EOA, nonce 7060)"
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
  note: "The witness setter is callable by a live EOA owner."
---

## Summary

VaultHandlerV8 (signed-price NFT minting). buyWithSignedPrice requires the recovered signer to be a stored witness. Under EIP-8151 a witness with code is rejected.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: VaultHandler getAddressFromSignatureHash: returns the recovered address / VaultHandlerV8 isWitnessed: the signer must be a stored witness / VaultHandlerV8 recoverSigner: returns the recovered address…. Read (function text).
- VaultHandlerV8.sol:89-90 getAddressFromSignature then require(witnesses[signer]); ecrecover at 228
- addWitness/removeWitness onlyOwner (149-155)
- owner()=0x2272ECf4 EOA nonce 7060 at 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2,033 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The owner calls addWitness with a fresh EOA and removeWitness on the old key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
