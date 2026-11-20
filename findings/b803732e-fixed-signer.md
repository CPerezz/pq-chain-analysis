---
id: b803732e-fixed-signer
title: "0xb803732e: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb803732e69b5f1e10344514df9fb51d01d920e17"
  family: "0b1dd470ae27b8e783a443b6ad29a29f"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Owner/project, who would need to redeploy or sell through ownerMintForSell"
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
  note: "I'm assuming the immutable is 0x91e2...; the 0xfff...f value is a mask. Only the minting of new NFTs is affected."
---

## Summary

The whitelist signer is an immutable address with no setter and no ERC-1271 or code check. That address is an EOA today. If it gets code, only the whitelist mint stops. No funds get locked: the mint is atomic, and the owner can withdraw ETH and mint the remaining supply.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable whitelistChecker` is set only in the constructor
- presaleMint: `.toEthSignedMessageHash().recover(signature) == whitelistChecker`
- Bytecode immutable 0x91e286f4...86b8 is an EOA (no code) at block 26438999
- ownerWithdrawETH and ownerMintForSell are owner paths that do not need the signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a signer that can be replaced, or support ERC-1271. Alternatively, sell through ownerMintForSell after the presale.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
