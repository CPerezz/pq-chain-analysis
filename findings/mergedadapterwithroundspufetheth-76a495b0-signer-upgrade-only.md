---
id: mergedadapterwithroundspufetheth-76a495b0-signer-upgrade-only
title: "MergedAdapterWithRoundsPufethethV1: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x76a495b0bffb53ef3f0e94ef0763e03ce410835c"
  family: "124046a36acfb5987c9402e00b5bbea7"
  copies: 3
  name: "MergedAdapterWithRoundsPufethethV1"
  upgradeable: "yes"
  admin: "ProxyAdmin 0x8223a627…, owner Safe 0x6906F3a0… (2 of 3)"
  rating: LOW
  txs_90d: 136
  last_active: 2026-11-17
  recoveries_14d: 32
fix:
  layer: contract-upgrade
  who_acts: "ProxyAdmin 0x8223a627…, owner Safe 0x6906F3a0… (2 of 3)"
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
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Safe controls the ProxyAdmin; the impl has already been changed once"
---

## Summary

MergedAdapterWithRoundsPufethethV1: the signer is one key in storage with no setter; EIP-8151 makes ecrecover return nothing once that key holds real code, so the signed function stops working until the code is upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: proxy to 0xf57ba29437c130e155ca4b65128630777638f05d, admin 0x8223a6271d1e0bda019ee55d545d7b86eff1f573.
- transparent proxy; impl at the block is 0xa41107f9… (the row says 0xf57ba294…, since upgraded); admin slot 0x8223a627…
- eth_call ProxyAdmin.upgrade(proxy, impl) from Safe 0x6906F3a0… succeeds; Safe threshold 2, 3 owners
- txs_90d=136, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 136 transactions called it in the 90 days before that block; last on 2026-11-17.
- 32 signature recoveries in the study's two-week trace window.

## Remediation

the upgrade holder deploys an implementation whose signer check accepts the new key (or ERC-1271) and upgrades before the signer gains real code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
