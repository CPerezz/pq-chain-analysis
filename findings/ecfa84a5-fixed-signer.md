---
id: ecfa84a5-fixed-signer
title: "0xecfa84a5: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xecfa84a59c064bd20c24187bdc469d6baa3ad5a2"
  family: "4970f6a6a1362256d28e26e54282f942"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner (0x15bdeb0cd277a8001627215362f1e695fb0ea610)"
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
  note: "The row facts do not give the signer's code size, because immutables are not listed in constants[]. I treated it as an EOA because it is an operator key that signs digests off-chain. This was not checked on-chain."
---

## Summary

The signer is the immutable cSigner and nothing can replace it. If that key's account gets real code, only the signed publicMint stops working. Nothing is locked: the owner can still use setWhitelist/whiteMint or setPublicMintTime/mint to let people mint, and can take any ETH with withdraw().

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- constructor: cSigner = 0x32715879DD1fFBFa99F0A54F802E163FBA4fDE29 (declared immutable)
- publicMint: ecrecover(sha256(msg.sender, num)) == cSigner; no code check and no ERC-1271
- no function writes cSigner; setters list only has transferOwnership
- setWhitelist/whiteMint and setPublicMintTime/mint are mint paths that need no signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner moves minting to whiteMint (via setWhitelist) or turns on the public mint() with setPublicMintTime(true).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
