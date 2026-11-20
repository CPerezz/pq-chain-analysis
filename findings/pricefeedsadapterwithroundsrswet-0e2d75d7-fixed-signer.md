---
id: pricefeedsadapterwithroundsrswet-0e2d75d7-fixed-signer
title: "PriceFeedsAdapterWithRoundsRswethRswethethV1: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0e2d75d760b12ac1f2ae84cd2ff9fd13cb632942"
  family: "d55f8fbb6bfcdcdc8bde62f393c1b9a7"
  copies: 2
  name: "PriceFeedsAdapterWithRoundsRswethRswethethV1"
  upgradeable: "yes"
  admin: "ProxyAdmin 0x8223a6271d1e0bda019ee55d545d7b86eff1f573 → Safe 0x6906F3a09BCc1b7cd3b0C8626724299618dF4472 (2/3, nonce 69)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "RedStone: ProxyAdmin 0x8223a6271d1e0bda019ee55d545d7b86eff1f573, owned by Safe 0x6906F3a09BCc1b7cd3b0C8626724299618dF4472 (2 of 3)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "An implementation behind a live proxy is LOW. The row's 'no proxy slot' looked at the implementation address. This code is already superseded (refuted would also be defensible)."
---

## Summary

A RedStone rswETH adapter implementation. It was the first implementation behind the ERC-1967 proxy 0x3A236F67Fce401D87D7215695235e201966576E4, which has since been upgraded to 0xb6022412… by a live Safe-owned ProxyAdmin. The hardcoded signer list is replaceable by upgrade, and this code is no longer run by the proxy.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Deployer 0x6Ca8C4d5… created this at nonce 0 (tx 0xc4550ecb…, block 19460844) and the proxy 0x3A236F67… at nonce 1
- Proxy impl slot @19461000 = 0x0e2d75d7…; @26438999 = 0xb60224122830fd6cf5119f548477a190310d2c94
- Admin slot @26438999 = ProxyAdmin 0x8223a627…; owner() = Safe 0x6906F3a0… with getOwners 3, getThreshold 2, nonce 69
- Source PriceFeedsAdapterWithRoundsPrimaryProd: 5 constant RedStone keys, threshold 2; the keys have no code (nonce 0)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed for this address (already replaced). The live proxy's admin upgrades to an implementation with new signers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
