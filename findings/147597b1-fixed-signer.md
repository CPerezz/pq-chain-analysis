---
id: 147597b1-fixed-signer
title: "0x147597b1: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x147597b1662fbea8f5a4ccea8c538410c26b91cb"
  family: "44431c2615e1693b07931e6d75b05742"
  upgradeable: "yes"
  admin: "0xe4fc651f392deccf158a168525c6a92486c3e847 (ProxyAdmin (Ownable)), owned by 0xd4b2b24185d6342f1b53687a684121218e800000 (EOA, nonce 10)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "proxy admin owner 0xd4b2b24185d6342f1b53687a684121218e800000"
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
- Update path, read at block 26,438,999: proxy to 0xc27d4d350be3dfb83b13dee076ba158442aaeb71, admin 0xe4fc651f392deccf158a168525c6a92486c3e847.
- EIP-1967 admin slot = 0xe4fc651f392deccf158a168525c6a92486c3e847, implementation = 0xc27d4d350be3dfb83b13dee076ba158442aaeb71 at block 26438999
- 0xe4fc651f392deccf158a168525c6a92486c3e847: ProxyAdmin (Ownable); owner() = 0xd4b2b24185d6342f1b53687a684121218e800000
- 0xd4b2b24185d6342f1b53687a684121218e800000: EOA, nonce 10 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Admin owner upgrades the implementation to one with a replaceable signer or ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
