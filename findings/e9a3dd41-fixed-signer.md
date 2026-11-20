---
id: e9a3dd41-fixed-signer
title: "0xe9a3dd41: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe9a3dd41e187c4639a68328032770ac4ddd7d9fe"
  family: "88f07433e231f49f5ff6e021f98e6b94"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Project owner (deploy a new contract) / signer key holder (keep 0xee53... free of real code)"
evidence:
  level: bytecode
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
  note: "The study note says 'presale deposit and claim', which is wrong. This is an NFT contract, and only redemption needs the signature. The ecrecover step does not appear in the decompiled code: the redeem body is cut off. The signer is identified from the redemptionSigner constant and the EIP-712 setup (eip712Domain, usedClaims), and the study note confirms the signature check."
---

## Summary

Redemption needs a signature from the constant redemptionSigner 0xee53deae...846b, which is an EOA today. No function can change the signer and there is no upgrade path. If that key's account gets real code, redemption stops working. No ETH or NFTs would be locked: the owner can still withdraw ETH and holders can still transfer their NFTs.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- constant redemptionSigner = 1360610163513264036563251866536143023007276172395, which equals 0xee53deae33fcd94163c0a82ecd0fe2ec7d07846b. The verified facts show this address is an EOA with no code.
- 0xd80ee028 checks pause, reveal, that msg.sender owns the token, that claim id arg3 is unused (storage_map_r), and the deadline (block.timestamp <= arg4). It also takes a bytes signature (arg5).
- transferOwnership (0xf2fde38b) writes only the owner slot (slot 6). No setter writes a signer value.
- withdraw (0x3ccfd60b) is onlyOwner and sends address(this).balance to 0xee53...846b. No signature is needed.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the 0xee53... key as an EOA, or only use EIP-7702 delegation on it. Otherwise, deploy a new redemption contract whose signer can be changed or that accepts ERC-1271, and redeem tokens there.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
