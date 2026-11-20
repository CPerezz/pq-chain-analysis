---
id: cyanvaultv2-460e0cd0-rotate-signer-before-migrating
title: "CyanVaultV2: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x460e0cd087033a73e1bc5c071711f1f27884968a"
  family: "dc6228849d2f53d6f3cb270f42355a36"
  copies: 10
  name: "CyanVaultV2"
  label: "deployed by Cyan: Deployer"
  upgradeable: "yes"
  rating: LOW
  value_usd: 396642
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 158
  last_active: 2026-11-16
fix:
  layer: onchain-config
  who_acts: "DEFAULT_ADMIN_ROLE holder or ProxyAdmin owner EOA"
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
  note: "Role holder unknown but live upgrade path via EOA-owned ProxyAdmin."
---

## Summary

CyanVaultV2: CYAN_ROLE auto-liquidation needs a signature from stored cyanSigner.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- updateCyanSigner(address) gated by DEFAULT_ADMIN_ROLE (holders not enumerable)
- EIP-1967 admin 0x891222ad…1374 is a ProxyAdmin owned by EOA 0xdF576863…e50C, nonce 981 at block

## Impact and exposure

- Value held at block 26,438,999: $396,642 (ETH and 49 priced tokens, over 10 addresses).
- Activity: 158 transactions called it in the 90 days before that block; last on 2026-11-16.

## Remediation

Admin calls updateCyanSigner, or upgrade via ProxyAdmin.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
