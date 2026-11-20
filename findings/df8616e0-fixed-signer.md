---
id: df8616e0-fixed-signer
title: "0xdf8616e0: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdf8616e0e20192e82379ff27279f1da01b70d83c"
  family: "2f7f8ccc17fc0382d0cd32274ebd764d"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "The owner, by calling setWhitelist or setPublicMintTime(true) to open a mint path that needs no signature."
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
  note: "The row facts do not report the code size of cSigner 0x32715879…, because constants[] is empty and immutables are not listed there. So the claim that it is an EOA today (or only 7702-delegated) has not been measured. The verdict assumes it is an EOA; if it already has real code, the verdict should be refuted. The study note (\"Presale: deposit and claim\") does not match this source, which is a signed NFT mint."
---

## Summary

cSigner is immutable and no function can replace it. If the signer key's account gets real code, signed publicMint stops working. Nothing is locked: the owner can still withdraw ETH, and mint/whiteMint give a way to mint without a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- The contract declares `address public immutable cSigner`, and the constructor sets `cSigner = 0x32715879DD1fFBFa99F0A54F802E163FBA4fDE29`.
- publicMint: `require(ecrecover(digest, v, r, s) == cSigner, "Invalid signer")`. It has no code check and no ERC-1271 path.
- No function writes cSigner. The only setter listed is transferOwnership, and it changes the owner.
- mint(num) only needs publicMintflag, which the owner sets with setPublicMintTime. whiteMint uses _whitelistClaimed, which the owner sets with setWhitelist.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

If cSigner stops working, the owner can open mint through setPublicMintTime(true) or allowlist users with setWhitelist. A new deployment would be needed to bring back the signed flow with a signer that can be changed or that accepts ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
