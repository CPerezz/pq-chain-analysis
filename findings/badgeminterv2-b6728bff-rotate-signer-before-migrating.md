---
id: badgeminterv2-b6728bff-rotate-signer-before-migrating
title: "BadgeMinterV2: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb6728bff344e2109dbb3a0c153cad65ec4bdb736"
  family: "fec5b27796813af5cbcc3e491a314958"
  copies: 2
  name: "BadgeMinterV2"
  label: "deployed by Noox Protocol: Deployer"
  upgradeable: "yes"
  admin: "DEFAULT_ADMIN_ROLE 0xe734f67ab0832b986d4105e15c799d86567f1c19 (UUPS)"
  rating: LOW
  value_usd: 11730
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "DEFAULT_ADMIN_ROLE holder 0xe734f67ab0832b986d4105e15c799d86567f1c19"
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
  note: "The setter exists and the admin is a live EOA: LOW. txs_90d 0."
---

## Summary

Noox BadgeMinterV2 (UUPS proxy) requires the recovered claim signer to equal the stored signer. Claims die if that signer gets code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: BadgeMinter: signed by `signer`, a stored address with a setter. Read from source.
- BadgeMinterV2.sol:61-65 setSigner(address) onlyRole(DEFAULT_ADMIN_ROLE); :162-165 recover == signer
- signer()=0x2694…9f8b (EOA)
- hasRole(0x00,0xe734…1c19)=true at block 26438999; it is an EOA with nonce 238 (0x737d…b9a4 is also an admin, a contract)

## Impact and exposure

- Value held at block 26,438,999: $11,730 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin calls setSigner with a new EOA key, or upgrades the implementation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
