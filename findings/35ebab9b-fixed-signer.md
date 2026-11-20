---
id: 35ebab9b-fixed-signer
title: "0x35ebab9b: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x35ebab9ba38dbffa8678c15c20c3e52d85e3da0f"
  family: "c21f9c10b959eb5d24f570ebab0b763b"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Project owner would redeploy with a new signer"
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
  note: "Rated MEDIUM because only signed minting of new NFTs stops and nothing is locked. The study note's 'presale deposit/claim' wording does not match this code: it is an NFT mint, and sale proceeds go straight to the owner address."
---

## Summary

The signer is a hardcoded constant (0xe455...) with no setter, and it has no code today (code_bytes 0). If that key's account gets real code, mintBatch stops working. Only new mints are lost: no funds sit in the contract, and NFTs already minted stay transferable.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- _signerAddress declared private constant 0xe45539fE76E31DF9D126f6Aa59B8d24267394524
- _matchSigner uses ECDSA.recover with plain ecrecover; no isContract check and no ERC-1271 path
- No function writes _signerAddress; the only setter in the row facts is transferOwnership
- constants[]: 0xe455... code_bytes 0, not delegated

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new mint contract whose signer can be changed and that accepts ERC-1271 signatures, or use an EOA signer that will never get code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
