---
id: pricefeedsadapterwithoutroundsus-8d6d49dd-signer-upgrade-only
title: "PriceFeedsAdapterWithoutRoundsUsdeSusdeV2: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8d6d49ddd5fe84b6b43d9420d1dac96b88dba9a1"
  family: "1454f72b9a94eb03b9cfc45c74b37605"
  name: "PriceFeedsAdapterWithoutRoundsUsdeSusdeV2"
  upgradeable: "yes"
  admin: "2-of-3 Safe 0x6906F3a09BCc1b7cd3b0C8626724299618dF4472"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "2-of-3 Safe 0x6906F3a09BCc1b7cd3b0C8626724299618dF4472 via ProxyAdmin 0x8223a6271d1e0bda019ee55d545d7b86eff1f573"
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
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Live 2-of-3 Safe admin found on-chain — corrects the row's 'no proxy slot, no upgrade function' to LOW."
---

## Summary

RedStone PriceFeedsAdapterWithoutRoundsUsdeSusdeV2: requireAuthorisedUpdater checks the recovered address against 5 fixed constants, no setter in this contract — but unlike the row's claim ('no proxy slot, no upgrade function'), this address IS the live implementation behind a real TransparentUpgradeableProxy with a live admin.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- node, block 26438999: proxy 0x1b9b4b6705797968954a597362898ace5f30c1c5, eip1967 implementation = 0x8d6d49ddd5fe84b6b43d9420d1dac96b88dba9a1 (matches, live), admin = ProxyAdmin 0x8223a627... (nonce 1), owner() of that ProxyAdmin = Safe 0x6906F3a0...
- node: Safe getThreshold()=2, getOwners()=[0xDed99B7F..., 0xeCad2Ed2..., 0x52acD229...], all three EOAs with real nonces (71, 65, 18) — live

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Safe upgrades the proxy to an implementation with a replaceable updater list.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
