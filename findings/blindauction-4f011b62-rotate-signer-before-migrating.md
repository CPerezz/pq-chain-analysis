---
id: blindauction-4f011b62-rotate-signer-before-migrating
title: "BlindAuction: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4f011b623eda3b7ad64c0ee506812dc1b98e1a33"
  family: "2af85c620b1ef66a3d29b926d2f35098"
  copies: 2
  name: "BlindAuction"
  label: "deployed by Kubz: Deployer"
  upgradeable: "yes"
  rating: LOW
  value_usd: 13534
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x6c8ee01f1f8b62e987b3d18f6f28b22a0ada755f"
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
  note: "LOW: setter callable by a live EOA owner, and the proxy is upgradeable too."
---

## Summary

Kubz BlindAuction (upgradeable): refunds and signed actions need ECDSA.recover == stored signer. A signer with code breaks them until the signer is replaced.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- BlindAuction.sol:98: setSigner is onlyOwner
- getSigner() = 0xA974c24C… (nonce 0, off-chain signer) at block 26438999
- owner 0x6c8ee01f… is an EOA with nonce 2429

## Impact and exposure

- Value held at block 26,438,999: $13,534 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner calls setSigner with a fresh key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
