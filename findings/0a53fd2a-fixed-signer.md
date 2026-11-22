---
id: 0a53fd2a-fixed-signer
title: "0x0a53fd2a: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0a53fd2aba0bd178e195e1a6a20b47e4df73b363"
  family: "1095e7faa81b6a2ede2ebf421a3ac049"
  copies: 5
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 235
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "project owner (redeploy with a new signer)"
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
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "The study note says this is a presale with deposit and claim. The source is a signed NFT mint with no deposits and no claims."
---

## Summary

The mint signer is immutable and has no code today, so it is an EOA. If that key's account gets real code, signed mints stop working. Nothing gets locked: the owner can still withdraw the ETH, and holders can still move the NFTs they already have.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable SIGNER` is set only in the constructor
- mint() reverts InvalidSignature if ECDSA.recover(...) != SIGNER
- No setter for SIGNER; the only setter listed is transferOwnership
- The constant 0x14185d5c... has code_bytes 0 and is not delegated

## Impact and exposure

- Value held at block 26,438,999: $235 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the signer key free of code, or deploy a new collection with a new signer or with ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
