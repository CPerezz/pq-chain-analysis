---
id: tollanuniverseitems-196c463b-rotate-signer-before-migrating
title: "TollanUniverseItems: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x196c463b51d9b02c5aadaedb1cca4be850ebb27d"
  family: "a20bac9e36b02495aa335d9d17d03b48"
  copies: 2
  name: "TollanUniverseItems"
  upgradeable: "yes"
  admin: "ProxyAdmin 0x09b72e36… owned by 0x0E7E99884c1422749aE895e357b010F995abd85e (kind not checked)"
  rating: LOW
  txs_90d: 1392
  last_active: 2026-11-17
  recoveries_14d: 344
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x449B94D779F86F7743d4c7fD82Acd0c350cedD0B"
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
  note: "Owner is a live EOA → LOW."
---

## Summary

TollanUniverseItems ERC-1155 (implementation behind proxy 0xf3df375e58bc5e9afcc7892e02739f9eb3f1d250). claim/claimBatch need a signature from a CLAIM_SIGNER_ROLE or CLAIM_BATCH_SIGNER_ROLE holder; a signer with code stops claims.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- TollanUniverseItems.sol:409-413: ECDSA.tryRecover, then hasRole(signerRole, recovered); no ERC-1271.
- grantRole/revokeRole are overridden as onlyOwner (:62-74), and renounceOwnership is disabled.
- Proxy owner at 26438999 = 0x449B94D7… (EOA, nonce 11). Proxy is upgradeable via ProxyAdmin 0x09b72e36… (owner 0x0E7E9988…).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,392 transactions called it in the 90 days before that block; last on 2026-11-17.
- 344 signature recoveries in the study's two-week trace window.

## Remediation

The owner grants the claim-signer role to a fresh EOA and revokes the old one.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
