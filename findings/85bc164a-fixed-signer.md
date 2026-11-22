---
id: 85bc164a-fixed-signer
title: "0x85bc164a: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x85bc164aa5b047873f52ad6e6ac4e66cfb7023f2"
  family: "c3b027e1fc2c144be9934f8243cb7a77"
  upgradeable: "yes"
  admin: "0x7ab1341a0179d450a7403e6456ecc51631688e95 (ProxyAdmin (Ownable)), owned by 0xbef40dcbd9d19449ba7b4d09f339b14c913a6679 (EOA, nonce 74)"
  rating: LOW
  value_usd: 5495
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "proxy admin owner 0xbef40dcbd9d19449ba7b4d09f339b14c913a6679"
evidence:
  level: bytecode
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

a token claim contract behind a proxy (3 ETH with tokens): a signer with code ends claims; EIP-8151 makes the fixed signer's signature fail once that signer has code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a token claim contract behind a proxy (3 ETH with tokens): a signer with code ends claims. Not established beyond the decompiler: whether one of the unresolved functions sets the signer. Bytecode and names.
- Update path, read at block 26,438,999: proxy to 0x0a64dbf3a80e69fe6e62b91470ba694cfa5b6cf4, admin 0x7ab1341a0179d450a7403e6456ecc51631688e95.
- EIP-1967 admin slot = 0x7ab1341a0179d450a7403e6456ecc51631688e95, implementation = 0x0a64dbf3a80e69fe6e62b91470ba694cfa5b6cf4 at block 26438999
- 0x7ab1341a0179d450a7403e6456ecc51631688e95: ProxyAdmin (Ownable); owner() = 0xbef40dcbd9d19449ba7b4d09f339b14c913a6679
- 0xbef40dcbd9d19449ba7b4d09f339b14c913a6679: EOA, nonce 74 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $5,495 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Admin owner upgrades the implementation to one with a replaceable signer or ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
