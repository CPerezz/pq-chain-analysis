---
id: sponsorpaymaster-26f77c64-rotate-signer-before-migrating
title: "SponsorPaymaster: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x26f77c6455518caf29a5414004c5a2ef441228b1"
  family: "299f7893ef608b33cc7616a04dadcd3f"
  copies: 4
  name: "SponsorPaymaster"
  upgradeable: "yes"
  rating: NONE
  txs_90d: 24197
  last_active: 2026-11-18
  recoveries_14d: 3611
fix:
  layer: none
  who_acts: "none"
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
  verdict: refuted
  rating: NONE
  note: "The code accepts ERC-1271 for the stored signer, so the definition rates it refuted. The owners that could rotate are EOAs that have never sent a transaction; they can still act, but their liveness is unproven."
---

## Summary

SponsorPaymaster (ERC-4337) checks paymaster data with OZ SignatureChecker.isValidSignatureNow(verifyingSigner, …). When recovery fails, as it does under EIP-8151 for a signer with code, it falls back to ERC-1271 on that signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: SignatureChecker on a signer kept in storage (ECDSA, or its ERC-1271 if it is a contract). Read from source. Executed: a real transaction reverts with code at the signer.
- src/paymaster/v1/permissioned/SponsorPaymaster.sol:74: SignatureChecker.isValidSignatureNow(verifyingSigner, hash, signature).
- The bundled SignatureChecker calls tryRecover and then isValidERC1271SignatureNow(signer, …).
- setVerifyingSigner (line 130) is onlyOwner whenNotPaused. This address is a bare implementation (slot0 0xff, owner and verifyingSigner 0). Etherscan lists proxies 0x67ac303f… (owner EOA 0x092ea63d…, nonce 0) and 0x7cea357b… (owner EOA 0x225b9f5f…, nonce 0). Read at latest block 26452892 via publicnode (the archive node timed out at 26438999); the proxies were taken from Etherscan's 'proxy contracts using this implementation' list.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 24,197 transactions called it in the 90 days before that block; last on 2026-11-18.
- 3,611 signature recoveries in the study's two-week trace window.

## Remediation

If the verifying signer migrates, its code must implement ERC-1271. Otherwise rotate with setVerifyingSigner first (needs a live owner).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
