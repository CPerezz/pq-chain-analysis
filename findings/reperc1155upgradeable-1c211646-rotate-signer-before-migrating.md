---
id: reperc1155upgradeable-1c211646-rotate-signer-before-migrating
title: "REPERC1155Upgradeable: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1c211646cb99d1557f93f06ce56c302b9493c02d"
  family: "0ddff458592be71fbdb7373e3adb8aaf"
  copies: 4
  name: "REPERC1155Upgradeable"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 9834
  last_active: 2026-11-18
  recoveries_14d: 91
fix:
  layer: onchain-config
  who_acts: "ADMIN_ROLE holder 0x1247…22ab"
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
  note: "Anon's rule (2026-11-20): a key that has never sent a transaction is presumed live; inactivity does not show the key is lost. So the party that can rotate the signer or upgrade the code can act: LOW. Earlier doubt: The setter and the upgrade path exist, but the only known admin has never sent a transaction (nonce 0), so whether it is live is unproven. If that key is held, the rating is LOW. Revoke and grant logs after the first 30k blocks were not fully scanned (RPC limited to 10k-block ranges)."
---

## Summary

REPERC1155Upgradeable is a UUPS implementation, and the live proxy 0xa78f7ca1…8d99 delegates to it. Mint and URI requests need an EIP-712 signature from a SIGNER_ROLE holder (ECDSA.recover only), so a signer with code fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source. Executed: a real transaction reverts with code at the signer.
- source REPERC1155Upgradeable.sol:407,467: ECDSA.recover then hasRole(SIGNER_ROLE); addSigner/removeSigner and _authorizeUpgrade are onlyRole(ADMIN_ROLE) (lines 185,190,499)
- proxy 0xa78f7ca187419753a2c7ebeb9a3ea67dbddf8d99: EIP-1967 impl = this address; hasRole(SIGNER_ROLE, 0x2dfa882e…a187) = true at block 26438999
- RoleGranted logs (blocks 25319677+): DEFAULT_ADMIN and ADMIN_ROLE to 0x12475759540eba8f9cbc8ab37b22ac3e79a122ab; hasRole(ADMIN_ROLE) = true at block 26438999, but that address has nonce 0 and no code

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 9,834 transactions called it in the 90 days before that block; last on 2026-11-18.
- 91 signature recoveries in the study's two-week trace window.

## Remediation

ADMIN_ROLE adds a new EOA signer (addSigner) or upgrades the proxy before the current signer takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
