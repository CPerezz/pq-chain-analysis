---
id: 3a151f06-fixed-signer
title: "0x3a151f06: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3a151f0630cd8833e0c2485597c5843e976bc364"
  family: "4da0de38e0bb9a29cfc8b5372c5899b7"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner or operator: switch on the public sale or redeploy with a new signer."
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
  note: "The study note calls this a presale with deposit/claim. The code is actually an NFT mint, and no user funds are held behind the signature."
---

## Summary

The signer is a hardcoded constant and is an EOA today (0 code bytes). If its account gets code, the signed private and whitelist mints stop working. Nothing is locked: withdraw() is open to anyone and sends ETH to the fixed wallet, and the public mint and airDrop do not use the signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- EIP712Whitelist: `address private constant SIGNER_ADDRESS = 0x6e4d...95fE`. The signer is a constant and no function can change it.
- Row facts: constant 0x6e4d5431b9ee9be61e73130f51c96c9c017495fe has code_bytes 0 and delegated false, so it is an EOA today.
- privateMint requires `simpleVerify(signature)`. whitelistMint requires `verify(msg.sender, nonce, price, startAt, endAt, signature)`.
- withdraw() has no access check and does `payable(WALLET_ADDRESS).transfer(balance)`. WALLET_ADDRESS (0x6471...) has 0 code bytes.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Use togglePublicSaleStatus to open publicMint, or redeploy with a signer that can be changed or with ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
