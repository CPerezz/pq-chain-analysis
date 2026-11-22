---
id: gppurchaserv3-e0469f0b-signer-upgrade-only
title: "GpPurchaserV3: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe0469f0beeff05effd5c46d35043079db9f1bfe3"
  family: "440f0d16c83ceb7b8cfdd2ce42f6bb03"
  name: "GpPurchaserV3"
  upgradeable: "yes"
  rating: LOW
  value_usd: 2
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "admin 0xB2E72323… (slot 1; nonce 0); owners B2E72323…, 1212DC60…, 4731eFC9… (all nonce 0)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Anon's rule (2026-11-20): a key that has never sent a transaction is presumed live; inactivity does not show the key is lost. So the party that can rotate the signer or upgrade the code can act: LOW. Earlier doubt: both paths (upgrade, owner rotation) are authorized, but none of the keys behind them has ever sent a transaction; value $2, txs_90d=0"
---

## Summary

GpPurchaserV3: the signer is one key in storage with no setter; EIP-8151 makes ecrecover return nothing once that key holds real code, so the signed function stops working until the code is upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: GpPurchaser admin signature: the signer must be an owner / GpPurchaser _recoverSigner: returns the signer. Read (function text).
- Update path, read at block 26,438,999: proxy to 0x0823fad0616093b9779657da8f053faab316dc4a with UPGRADE_INTERFACE_VERSION(), called through its own checks.
- GpPurchaserV3 source: _authorizeUpgrade is onlyAdmin; the signed admin signature must come from an owner, and owners can be replaced through requestUpdateOwner/confirmUpdateOwner (2 confirmations), so a setter exists too
- eth_call upgradeToAndCall(0x0823fad0…,'') from admin 0xB2E72323… succeeds, but the admin and all three owners have no code and nonce 0 at block 26438999
- txs_90d=0, value_usd=2

## Impact and exposure

- Value held at block 26,438,999: $2 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

resolve who holds the upgrade path, then upgrade before the signer gains real code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
