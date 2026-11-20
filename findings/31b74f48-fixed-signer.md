---
id: 31b74f48-fixed-signer
title: "0x31b74f48: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x31b74f484cd6d0a9f810be7642080cf276befc31"
  family: "d8b34ef6a44df9e3e97717212b315a0e"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner (0xb704c7b1f02bf5defbf97e0b49301fbd17377243)"
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
  note: "The study note calls this a presale with deposit and claim, but the code is an NFT mint. Signatures only gate minting new tokens."
---

## Summary

The signer is a hard-coded constant with no code today (code_bytes 0, not delegated), so the fixed-signer claim holds. If that key's account gets real code, only the signed private and whitelist mints of new NFTs stop. No funds get locked: anyone can call withdraw(), and the owner can turn on publicMint instead.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- EIP712Whitelist: SIGNER_ADDRESS is a constant 0x6A1f...9023; constants[] reports code_bytes 0, delegated false
- privateMint: require(simpleVerify(signature)); whitelistMint: require(verify(msg.sender,...))
- ECDSA.recover is used, with no ERC-1271 or code check
- withdraw() has no access control and pays to the constant WALLET_ADDRESS 0x21B8...608d

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner turns off privateSale and turns on publicSale (togglePublicSaleStatus), or uses airDrop to mint for allowlisted buyers. The signer itself can only be changed by deploying a new contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
