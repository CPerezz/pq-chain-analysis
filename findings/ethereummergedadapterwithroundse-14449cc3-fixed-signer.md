---
id: ethereummergedadapterwithroundse-14449cc3-fixed-signer
title: "EthereumMergedAdapterWithRoundsEurspkccNavV1: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x14449cc3185dec0421c3cb37074215f1aacb97f9"
  family: "566ee5477c2dffbcc79c9c56d07e3c58"
  copies: 3
  name: "EthereumMergedAdapterWithRoundsEurspkccNavV1"
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
  note: "An implementation behind a live proxy with a live admin is LOW. The row's 'no proxy slot' looked at the implementation address."
---

## Summary

A RedStone merged adapter (EURSPKCC NAV) implementation. It is the current implementation of the live ERC-1967 proxy 0x9e37DBF40fE5Fe9320E45fe6B95b000aa05459A9, whose admin is a Safe-owned ProxyAdmin, so the hardcoded signers are replaceable by upgrade.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone: the recovered address is looked up in getAuthorisedSignerIndex, a list of addresses fixed in the adapter's code; a threshold of distinct signers is needed. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Deployer 0xA1Be220e… created this at nonce 121 (tx 0x4810f7f3…) and the proxy 0x9e37DBF4… at nonce 122; proxy impl slot = 0x14449cc3… (read at latest; etherscan marks it 'Implementation For')
- @26438999: proxy admin slot = 0x8223a627…; owner() = Safe 0x6906F3a0…, getThreshold 2 of 3 owners, nonce 69
- Proxy is live: latestRoundData @26438999 = round 1244, answer 103034900, updatedAt 1794932423; description 'Redstone Price Feed'; consumer DebtEURSPKCCOracle 0x87c4e3a0… (facts.json)
- Source MergedPriceFeedAdapterWithRoundsPrimaryProd: the 5 constant RedStone primary-prod keys (no code, nonce 0); the row notes a real tx reverts with code at a signer

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

RedStone's Safe upgrades the proxy to an implementation with new or post-quantum signers

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
