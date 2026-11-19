---
id: unidentified-6c1e7867-fixed-signer
title: "ParaswapV5Filter (2 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-6c1e7867
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x8a3c6f0b97ca577caddcb2b72a1b30e4cd367595"
  name: "ParaswapV5Filter (study family 46ba5735), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x8a3c6f0b97ca577caddcb2b72a1b30e4cd367595"
  name: "ParaswapV5Filter (study family 46ba5735)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 46ba5735"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x8a3c6f0b97ca577caddcb2b72a1b30e4cd367595` (ParaswapV5Filter, family `46ba5735`, 2 addresses, $0): Argent Paraswap filter: the signature must come from the account its caller passes, a Paraswap authority fixed in the code. Decided by: read (function text). Executed: a real transaction ends without error but with other logs when its signer has code: the failure is caught…
