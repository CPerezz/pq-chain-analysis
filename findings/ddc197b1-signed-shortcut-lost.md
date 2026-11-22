---
id: ddc197b1-signed-shortcut-lost
title: "0xddc197b1: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xddc197b1ee3e11d14a3c62489266ea1d5a07862f"
  family: "dbcdc6407f220e22a999d6cb604cf994, 31774487b54747cf5b53a4374a2fd39b"
  copies: 678
  upgradeable: "no"
  rating: LOW
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 13
  last_active: 2026-10-29
fix:
  layer: offchain
  who_acts: "holders delegate by direct call"
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
  note: "A misattributed copy: its implementation's only recovery is the votes token's delegateBySig, which accepts whichever holder signed; a holder whose account has code delegates by direct call instead: LOW."
---

## Summary

This address is an EIP-1167 clone of 0xde9a07e5…2657, not of the dossier's code (dossier code.hex is 13.6 KB and differs from the 23.9 KB implementation). The implementation's only ecrecover is OZ Votes delegateBySig, which recovers whichever holder signed. There is no constant signer.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: 678 mint clones: a signer that is a constant in the code. Bytecode and names.
- cast code 0xddc1… = 363d3d37…73de9a07e5f1eaf3236e84724e0a221ce44d7b2657…
- the implementation has one secp256k1 n/2 constant and strings 'Votes: signature expired' / 'Votes: invalid nonce'; heimdall shows delegateBySig with nonce check, no compare to a constant
- the 40-hex runs in the bytecode (0xc3c69bb8…, 0x07eab39a…) are parts of the EIP-712 domain typehash and an event topic, not addresses
- delegate(address) is open to the same holder by a direct call

## Impact and exposure

- Value held at block 26,438,999: $902 (ETH and 49 priced tokens, over 678 addresses).
- Activity: 13 transactions called it in the 90 days before that block; last on 2026-10-29.

## Remediation

None needed: holders call delegate() directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-signed-shortcut-lost` applies, not `eip-8151-fixed-signer`; filed under it.
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
- 2026-11-20: the same contract was also a row of triage entry `eip-8151-signed-shortcut-lost`; it is the row this finding describes: the implementation's delegateBySig, reviewed with the fixed-signer row.
