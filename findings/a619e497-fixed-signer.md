---
id: a619e497-fixed-signer
title: "0xa619e497: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa619e4976555501931faf7f9980e48397ab99f60"
  family: "80248977cfa3fd356dd69eb46fade64b"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The project owner would need to deploy a new contract with a new signer. This contract cannot be upgraded."
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
  note: "The row facts do not give the signer's current code size. I am treating it as an EOA (or a 7702-delegated account) because it must hold a secp256k1 private key to produce valid ECDSA signatures. The study note calls this a presale, which is wrong: it is a free signed NFT claim."
---

## Summary

The signer is immutable, there is no setter, and there is no ERC-1271 path. If the signer's account gets real code, signed claims stop. Existing passes and transfers are unaffected and no funds are locked, so this is MEDIUM.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable signer;` is assigned only in the constructor
- `mintAlphaPass`: `keccak256(...msg.sender).recover(signature) == signer` (ECDSA recover only, no code check, no ERC-1271)
- No function writes `signer`. The only setters are `transferOwnership` and `setBaseURI`, and neither touches `signer`
- No payable functions and no withdraw function, so the contract holds no funds

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a signer that can be rotated, or allow ERC-1271 signatures. Users could also be minted passes from the team allocation instead.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
