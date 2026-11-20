---
id: kubzauction-d923af5d-rotate-signer-before-migrating
title: "KubzAuction: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd923af5d509042a3b24b711caaba8c408d4d4c23"
  family: "aa68edc9fd8910d366ddefbdc45e46bc"
  copies: 2
  name: "KubzAuction"
  label: "deployed by Kubz: Deployer"
  upgradeable: "yes"
  admin: "ProxyAdmin 0xf025a72ed25c5d24a0179c93a75ca74a9fa5744c owned by EOA 0x759c5F293EdC487aA02186f0099864Ebc53191C1"
  rating: LOW
  value_usd: 44573
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner 0x6c8ee01f (EOA)"
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
  note: "Setter and upgrade both have live EOA callers."
---

## Summary

KubzAuction (proxy): refunds and claims need an ECDSA signature from the stored signer 0xabcddc23. If it gets code, those calls revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- KubzAuction.sol:70 ECDSA.recover compared with signer; :182 setSigner onlyOwner
- owner() at block 26438999 = 0x6c8ee01f1f8b62e987b3d18f6f28b22a0ada755f, no code, nonce 2429
- EIP-1967 admin = ProxyAdmin 0xf025a72e, owner 0x759c5F29 (no code, nonce 1780)

## Impact and exposure

- Value held at block 26,438,999: $44,573 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls setSigner with an EOA, or upgrades through the ProxyAdmin.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
