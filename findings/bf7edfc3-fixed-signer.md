---
id: bf7edfc3-fixed-signer
title: "0xbf7edfc3: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbf7edfc329fa4587bd278733d76d07e691cac418"
  family: "c30c6c585bc7120f60c5eca8a8fab6bb"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "owner"
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
  note: "Rated MEDIUM because only the allowlist mint of new NFTs stops. Nothing users already hold is locked."
---

## Summary

The signer is an immutable whitelistChecker. It has no setter, the code does not check for code or accept ERC-1271, and the address is an EOA today. If it gets code, only the signed allowlist mint of new NFTs stops. No funds lock, because the owner can withdraw the ETH and mint the remaining supply after the presale.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable whitelistChecker` is set once in the constructor
- presaleMint requires `recover(signature) == whitelistChecker`
- The address in the bytecode, 0x91e286f4...86b8, is an EOA (no code)
- ownerWithdrawETH sends the whole balance to the owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

If the signer gets code, the owner can use changePresaleTime and ownerMintForSell to sell another way, or redeploy with a signer that can be replaced or checked through ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
