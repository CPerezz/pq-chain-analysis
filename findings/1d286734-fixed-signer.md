---
id: 1d286734-fixed-signer
title: "0x1d286734: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x1d28673414bda19015a34762d968593d3130e102"
  family: "11aa8691ce3bafef4a2f1c3c58dd7303"
  upgradeable: "yes"
  admin: "0x276457cc455d88b1416bcc3c54663c49a9aa56c1 (ProxyAdmin (Ownable)), owned by 0xd3cedfc7b4cd9b5aa63aafcd0287c85fbfc188ab (EIP-7702-delegated EOA, nonce 228)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "proxy admin owner 0xd3cedfc7b4cd9b5aa63aafcd0287c85fbfc188ab"
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

Presale: deposit and claim need a signature of SIGNER, fixed in the code; EIP-8151 makes the fixed signer's signature fail once that signer has code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: proxy to 0xcec34a3781b54f253c59b04235f50425f8a968ec, admin 0x276457cc455d88b1416bcc3c54663c49a9aa56c1.
- EIP-1967 admin slot = 0x276457cc455d88b1416bcc3c54663c49a9aa56c1, implementation = 0xcec34a3781b54f253c59b04235f50425f8a968ec at block 26438999
- 0x276457cc455d88b1416bcc3c54663c49a9aa56c1: ProxyAdmin (Ownable); owner() = 0xd3cedfc7b4cd9b5aa63aafcd0287c85fbfc188ab
- 0xd3cedfc7b4cd9b5aa63aafcd0287c85fbfc188ab: EIP-7702-delegated EOA, nonce 228 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Admin owner upgrades the implementation to one with a replaceable signer or ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
