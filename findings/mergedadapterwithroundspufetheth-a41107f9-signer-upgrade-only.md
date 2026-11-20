---
id: mergedadapterwithroundspufetheth-a41107f9-signer-upgrade-only
title: "MergedAdapterWithRoundsPufethethV1: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa41107f9259bb835275eacaad8048307b80d7c00"
  family: "124046a36acfb5987c9402e00b5bbea7"
  copies: 3
  name: "MergedAdapterWithRoundsPufethethV1"
  upgradeable: "yes"
  admin: "ProxyAdmin 0x8223a6271d1e0bda019ee55d545d7b86eff1f573, owned by 2-of-3 Safe 0x6906F3a09BCc1b7cd3b0C8626724299618dF4472"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "ProxyAdmin 0x8223a627 owner (2-of-3 Safe 0x6906f3a0)"
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
  note: "The live proxy runs this exact code and its ProxyAdmin is owned by a live 2-of-3 Safe, so this is LOW. The row's 'no proxy slot' only looked at the implementation address. Row txs_90d 0, but the proxy is active."
---

## Summary

RedStone adapter with its signer set fixed in code. It is the live implementation of transparent proxy 0x76a495b0, and that proxy's ProxyAdmin is owned by a live Safe, so an upgrade can replace the signers.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- proxy 0x76a495b0bffb53ef3f0e94ef0763e03ce410835c: EIP-1967 impl slot = 0xa41107f9, admin slot = 0x8223a6271d1e0bda019ee55d545d7b86eff1f573 (cast storage @26438999)
- ProxyAdmin 0x8223a627 owner() = Safe 0x6906F3a0; getThreshold 2; owners 0xDed99B7F (EOA n=71), 0xeCad2Ed2 (EOA n=65), 0x52acD229 (EOA n=18) @26438999
- txs.json: 32 recoveries in 16 txs through context 0x76a495b0, last block 26434047; the signers are constants in Addresses.sol (source/)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Before signers migrate, the Safe upgrades proxy 0x76a495b0 to an adapter build with a new signer list.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
