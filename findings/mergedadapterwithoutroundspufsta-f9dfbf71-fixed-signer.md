---
id: mergedadapterwithoutroundspufsta-f9dfbf71-fixed-signer
title: "MergedAdapterWithoutRoundsPufStakingV1: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf9dfbf71f2d9c8a4e565e1346aeb2c3e1dc765de"
  family: "98da8b6b8c64cbed423d14ea55b6e752"
  name: "MergedAdapterWithoutRoundsPufStakingV1"
  upgradeable: "yes"
  admin: "ProxyAdmin 0x8223a6271d1e0bda019ee55d545d7b86eff1f573 owned by Safe 0x6906f3a09bcc1b7cd3b0c8626724299618df4472 (2/3)"
  rating: LOW
  txs_90d: 7941
  last_active: 2026-11-17
  recoveries_14d: 148
fix:
  layer: contract-upgrade
  who_acts: "RedStone 2-of-3 Safe 0x6906f3a0… via ProxyAdmin 0x8223a627…"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "A live upgrade admin (an active Safe) exists: LOW."
---

## Summary

A RedStone price adapter (PufStaking) behind a proxy. Its authorised signers are fixed in the code. A signer with code stops updates once fewer than the threshold remain.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone: the recovered address is looked up in getAuthorisedSignerIndex, a list of addresses fixed in the adapter's code; a threshold of distinct signers is needed. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: proxy to 0x26dc62470d4fa7f9cbcd597f9862345a2b3515aa, admin 0x8223a6271d1e0bda019ee55d545d7b86eff1f573.
- EIP-1967 admin slot at 26438999 = 0x8223a627… (ProxyAdmin); its owner() = 0x6906f3a0…
- 0x6906f3a0… is a Safe: getThreshold 2, owners 0xded99b7f (nonce 71), 0xecad2ed2 (nonce 65), 0x52acd229 (nonce 18), all EOAs

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 7,941 transactions called it in the 90 days before that block; last on 2026-11-17.
- 148 signature recoveries in the study's two-week trace window.

## Remediation

Upgrade to an implementation with a new signer list.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
