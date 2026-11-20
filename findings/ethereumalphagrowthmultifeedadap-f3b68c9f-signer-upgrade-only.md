---
id: ethereumalphagrowthmultifeedadap-f3b68c9f-signer-upgrade-only
title: "EthereumAlphaGrowthMultiFeedAdapterWithoutRoundsV2: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf3b68c9f8ea997c60bf4f3a03b271c5ee02d985c"
  family: "d072ae45266149404a67e4ccb0f3dd29"
  name: "EthereumAlphaGrowthMultiFeedAdapterWithoutRoundsV2"
  upgradeable: "yes"
  admin: "ProxyAdmin 0x8223a6271d1e0bda019ee55d545d7b86eff1f573 owned by 2-of-3 Safe 0x6906F3a09BCc1b7cd3b0C8626724299618dF4472"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "RedStone 2-of-3 Safe 0x6906F3a0 via ProxyAdmin 0x8223a627"
evidence:
  level: executed
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
  note: "A live multisig admin can upgrade, so LOW. This contradicts the row's 'no proxy slot' finding, which measured the implementation and not its proxy."
---

## Summary

RedStone multi-feed adapter implementation: the recovered address is looked up in a signer list fixed in the code. The live proxy 0x5232974b runs this code and its ProxyAdmin is owned by a live 2-of-3 Safe.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: RedStone: the recovered address is looked up in getAuthorisedSignerIndex, a list of addresses fixed in the adapter's code; a threshold of distinct signers is needed. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- proxy 0x5232974b EIP-1967 implementation slot at 26438999 = 0xf3b68c9f (the row); admin slot = ProxyAdmin 0x8223a627, owner() = Safe 0x6906F3a0
- Safe 0x6906F3a0 getThreshold=2; owners 0xDed99B7F (nonce 71), 0xeCad2Ed2 (65), 0x52acD229 (18), all EOAs

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The RedStone multisig upgrades the proxy to an implementation with new authorised signers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
