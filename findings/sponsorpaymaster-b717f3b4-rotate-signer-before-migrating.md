---
id: sponsorpaymaster-b717f3b4-rotate-signer-before-migrating
title: "SponsorPaymaster: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb717f3b4c4d3aa40da1ee9c92f3d5e291bfd8d05"
  family: "cd78360ba73046c83f55a7fcc7aff0ba"
  copies: 2
  name: "SponsorPaymaster"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 6172
  last_active: 2026-11-18
  recoveries_14d: 1784
fix:
  layer: onchain-config
  who_acts: "proxy owner 0x199fc47f…b0CF"
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
  note: "A live EOA owner holds the setter."
---

## Summary

SponsorPaymaster (ERC-4337) is a UUPS implementation, and the live proxy 0x03df76c8…103b delegates to it. Sponsorship needs an ECDSA signature from a stored verifying signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source. Executed: a real transaction reverts with code at the signer.
- SponsorPaymaster.sol:258 tryRecover then _containsVerifyingSigner; addVerifyingSigners/removeVerifyingSigners onlyOwner (lines 341,349)
- proxy 0x03df76c8c30a88f424cf3cbbc36a1ca02763103b: EIP-1967 impl = this address; owner() = 0x199fc47fBCFd85d05B409D2333363B96BEeeb0CF, an EOA with nonce 3, at block 26438999
- this address's own owner() = 0 (implementation); txs.json context = the proxy

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 6,172 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,784 signature recoveries in the study's two-week trace window.

## Remediation

The owner adds a new EOA verifying signer before the old one takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
