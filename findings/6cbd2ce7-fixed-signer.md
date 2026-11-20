---
id: 6cbd2ce7-fixed-signer
title: "0x6cbd2ce7: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6cbd2ce7fc763fbd160c6adfdd938f7ae63dd2ec"
  family: "02d92c189a209c9035ad1bde67c47fca"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 6
  last_active: 2026-11-12
fix:
  layer: onchain-config
  who_acts: "Owner: setMintDay(PUBLIC) or ownerMint to give allowlisted users their mints"
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
  note: "The study note calls this a presale with deposit and claim. The code is actually an NFT mint with no deposits held. Rated MEDIUM: only the signed mints of new NFTs stop, and nothing is locked."
---

## Summary

The signer is a hard-coded constant with no setter and no code or ERC-1271 check. Today it is an EOA (code_bytes 0, not delegated). If it ever gets code, the four signed mints stop working. Nothing is locked: payment happens in the same mint call, and withdraw needs no signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- address constant signer = 0xdA0c2FF4eB0924560eE4FA5561036DA42Dfc91Ad
- _verifySignature uses ECDSA.recover(...) == signer, which calls ecrecover. There is no isValidSignature path.
- Row facts: constant 0xda0c...91ad has code_bytes 0 and delegated false
- Row facts: upgradeable 'no'. The only setter is transferOwnership, which changes the owner, not the signer.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-11-12.

## Remediation

If the signer key gets code, the owner can switch to publicMint (setMintDay(PUBLIC)) or use ownerMint to give allowlisted users their mints. Changing the signer itself requires a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
