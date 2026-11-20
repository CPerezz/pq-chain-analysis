---
id: 183276cf-fixed-signer
title: "0x183276cf: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x183276cf6dd6195de7d09d3ff4e80e97e3de1fee"
  family: "e6690aa17eea568039ecb6877b54c8e3"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "project owner (redeploy, or teamMint to whitelisted users)"
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
  note: "The constant 0x6f6c63430008090033 is solc metadata, not an address. The signer comes from the bytecode immutable."
---

## Summary

The signer is an immutable that nothing can replace. The bytecode immutable 0x73310a94…eb6 is an EOA today. If that account gets code, whitelistMint stops working. No user funds are held, so this only stops minting.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address private immutable signer` is set only in the constructor
- whitelistMint requires recoverSigner(hash, signature) == signer, via ECDSA.recover, with no ERC-1271 check
- The address pushed in bytecode, 0x73310a94668fb486911e1f3748bf404953a50eb6, has no code
- No setter for signer; upgradeable: no

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the signer key as an EOA. Otherwise the owner can use teamMint to mint to allowlisted users, or redeploy with a replaceable signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
