---
id: da38e3cf-fixed-signer
title: "0xda38e3cf: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xda38e3cf623793fa46277773bbc5def9ad435c06"
  family: "affc073834c279e0afda5585b5c4276d"
  upgradeable: "yes"
  admin: "0xfd3c396dd23c52b8b06aa5a641be9113f93c3bca (ProxyAdmin (Ownable)), owned by 0x2e3afad5fc47f686ccf2a46443fafa8ab4730b48 (EOA, nonce 238)"
  rating: LOW
  value_usd: 217
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "proxy admin owner 0x2e3afad5fc47f686ccf2a46443fafa8ab4730b48"
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
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW: a live party controls the proxy admin."
---

## Summary

DogZone721 free mint: signed by `signer`, set at construction, no setter in the source; EIP-8151 makes the fixed signer's signature fail once that signer has code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: DogZone721 free mint: signed by `signer`, set at construction, no setter in the source. Same code idiom as template d4de1d4c, not read on its own.
- Update path, read at block 26,438,999: proxy to 0xb6450c438d7e68be1f1c4534a8a354bf3d85c72e, admin 0xfd3c396dd23c52b8b06aa5a641be9113f93c3bca.
- EIP-1967 admin slot = 0xfd3c396dd23c52b8b06aa5a641be9113f93c3bca, implementation = 0xb6450c438d7e68be1f1c4534a8a354bf3d85c72e at block 26438999
- 0xfd3c396dd23c52b8b06aa5a641be9113f93c3bca: ProxyAdmin (Ownable); owner() = 0x2e3afad5fc47f686ccf2a46443fafa8ab4730b48
- 0x2e3afad5fc47f686ccf2a46443fafa8ab4730b48: EOA, nonce 238 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $217 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Admin owner upgrades the implementation to one with a replaceable signer or ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
