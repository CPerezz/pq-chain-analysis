---
id: 6970a2d8-fixed-signer
title: "0x6970a2d8: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6970a2d8df91afbd9a6560829689f57ae2773a68"
  family: "5ea859590f87b3f22faf0544e56d6f30"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 812
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Owner/operator (redeploy, or rely on the public sale)"
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
  note: "Picking 0xb85f... as the signer is an inference from the bytecode address list: the other address-shaped values are LINK, the VRF coordinator and string data."
---

## Summary

The presale signer is an immutable with no setter, and the likely signer address is an EOA today. If it gets code, only signed presale minting of new NFTs stops. Nothing is locked: the owner can still withdraw ETH and LINK, and public mint() works without a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address private immutable signerAddress;` is set only in the constructor (`signerAddress = _signerAddress`)
- matchAddressSigner returns `signerAddress == hash.recover(signature)`, with no ERC-1271 or code check
- preSalebuy requires matchAddressSigner(...) before minting
- mint(uint256) public sale has no signature check

## Impact and exposure

- Value held at block 26,438,999: $812 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a replaceable signer or ERC-1271 support. Otherwise, run sales through the public mint() path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
