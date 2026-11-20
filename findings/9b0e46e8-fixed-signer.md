---
id: 9b0e46e8-fixed-signer
title: "0x9b0e46e8: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9b0e46e80d6d35f0722c11306c1bf454f2d13a6d"
  family: "26870406a947ff63f0ad8e3a41ab0e1a"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The project owner, either by minting through airDrop or by deploying a new contract"
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
  note: "The study_note describes this as a presale where deposit and claim need the signature. That is wrong: this is an NFT mint, and only privateMint is gated. The signed message is a fixed struct and does not include msg.sender, so one signature works for any caller."
---

## Summary

The signer is a hardcoded constant and it is an EOA today (code size 0, no delegation). Nothing in the code can replace it. If that key's account gets real code, only the signed privateMint stops working. No funds get locked: the ETH already paid can still be released to the payees, NFT holders can still transfer and redeem their tokens, and the owner can still mint with airDrop.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- EIP712Whitelist.sol: `address private constant SIGNER_ADDRESS= 0x2e2C7099da471f09886e7425D0C1073ed34EB4Ce`
- simpleVerify uses ECDSA.recover and compares the result to SIGNER_ADDRESS. There is no code check and no ERC-1271 path.
- On-chain facts: the constant 0x2e2c...b4ce has code_bytes 0 and delegated false. It is also owner().
- privateMint has `require(simpleVerify(signature))`. It is the only place the signature is used.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

There is no upgrade path. The owner can keep distributing NFTs with airDrop and collect payment off-chain, or deploy a new contract whose signer can be changed or that accepts ERC-1271. Another option is to keep the signer key as an EOA or as a 7702-delegated account.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
