---
id: c8cd42a8-fixed-signer
title: "0xc8cd42a8: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc8cd42a8164e3ae01eb2c5c6e898b33bb35c644e"
  family: "97b6e9f92ed4b306ea88383c69ee927b"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Project owner/deployer"
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
  note: "The constant 0xedcb… is assumed to be the deployer address embedded as the immutable. MEDIUM because signed mints of new NFTs stop but nothing is locked: the owner can still withdraw ETH via distribute. Free shill mints have no path without the signature."
---

## Summary

The signer is an immutable set to the deployer, an address with no code today, and nothing can replace it. If that key's account gets code, whitelistMint and shillMint stop working. Nothing is locked: the owner can withdraw ETH via distribute, and the public receive() mint still works when unpaused.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- immutable _whitelistSigner = _msgSender() in constructor
- onlyValidAddress: ecrecover result must equal _whitelistSigner; no code check or ERC-1271
- no function writes _whitelistSigner
- constant 0xedcb3f7b… code_bytes 0, not delegated

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a signer that can be replaced, or use the public receive() mint and teamMint instead.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
