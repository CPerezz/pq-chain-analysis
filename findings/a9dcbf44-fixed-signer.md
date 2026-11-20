---
id: a9dcbf44-fixed-signer
title: "0xa9dcbf44: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa9dcbf44c2de9162f8c050626236b1dd5d7fab54"
  family: "c4f3305db1d6fc8a7a08b8bf36fa160b"
  copies: 4
  upgradeable: "no"
  rating: LOW
  value_usd: 2376
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2
  last_active: 2026-11-01
fix:
  layer: onchain-config
  who_acts: "owner (setPublicsale)"
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
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW: a setting keeps the same mint open. The study's 'claims' wording is wrong: the signature guards the presale mint only."
---

## Summary

An NFT-lending clone (impl 0x8e563b…2771): the only signed function is preMint(uint256,uint256,bytes), checked against signerAddress, which is set at initialize with no setter. Claims, redeem and withdraw take no signature, contrary to the study's 'claims'. The owner can open publicMint with setPublicsale.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: claims checked against one stored signer; all 66 selectors named and none replaces it. Bytecode and names.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Impl selector scan: preMint is the only function with a bytes argument; no signerAddress setter; setPublicsale/publicMint present
- signerAddress() = owner() = 0x14C5…a224 at 26438999, no code
- Clone balance 0 ETH; 2 txs in 90d

## Impact and exposure

- Value held at block 26,438,999: $2,376 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-11-01.

## Remediation

The owner opens the public sale.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
