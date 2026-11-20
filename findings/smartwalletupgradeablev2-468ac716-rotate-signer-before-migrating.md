---
id: smartwalletupgradeablev2-468ac716-rotate-signer-before-migrating
title: "SmartWalletUpgradeableV2: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x468ac716493c51184162681130035b61baff040b"
  family: "b57e40770f9472d9d55d7ec50adf6d58"
  copies: 2
  name: "SmartWalletUpgradeableV2"
  upgradeable: "yes"
  rating: LOW
  value_usd: 92033
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1989
  last_active: 2026-11-18
  recoveries_14d: 324
fix:
  layer: onchain-config
  who_acts: "DEFAULT_ADMIN Safe 0xe146…6338"
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
  note: "A live Safe (2-of-5, active EOAs) holds the role admin and the proxy admin."
---

## Summary

SmartWalletUpgradeableV2 (proxy): withdraw needs an ECDSA signature from a MODERATOR_ROLE holder (hash.recover, no ERC-1271). A moderator whose account takes code can no longer sign withdrawals.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: SmartWallet withdraw: the signer must hold MODERATOR_ROLE / SmartWallet.recoverSigner: returns the signer. Read from source.
- source SmartWalletUpgradeable.sol:140 requires hasRole(MODERATOR_ROLE, recovered); roles are AccessControlEnumerable, administered by DEFAULT_ADMIN_ROLE
- DEFAULT_ADMIN_ROLE has 1 member at block 26438999: 0xe146146d…6338, a Safe 2-of-5 whose owners are EOAs with nonces 47/368/41/5184/27; the same Safe is owner() and owns ProxyAdmin 0x8ca471ca…430f
- withdrawByModerator (direct msg.sender path) also remains for moderators below thresholdAmount

## Impact and exposure

- Value held at block 26,438,999: $92,033 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,989 transactions called it in the 90 days before that block; last on 2026-11-18.
- 324 signature recoveries in the study's two-week trace window.

## Remediation

Admin Safe grants MODERATOR_ROLE to a new EOA key (or upgrades the implementation through ProxyAdmin) before a moderator migrates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
