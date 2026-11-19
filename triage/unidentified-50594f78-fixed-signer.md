---
id: unidentified-50594f78-fixed-signer
title: "Unverified contract 0xf8c062…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-50594f78
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xf8c0622839ef0d2bbdc11954e6e129c668ec2288"
  name: "unverified code (study family 03dc9c4f)"
  upgradeable: "no"
  value_usd: 86980
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 03dc9c4f"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $87k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xf8c0622839ef0d2bbdc11954e6e129c668ec2288` (unverified, family `03dc9c4f`, 1 address, $87k): NFT mint allowlist (48 ETH of mint proceeds, owner 0xba5edab6…): the allowlist signer looks fixed; the owner's own functions are direct. A signer with code ends signed mints; nothing is locked. Decided by: bytecode and names (no source).
