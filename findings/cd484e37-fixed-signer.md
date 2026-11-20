---
id: cd484e37-fixed-signer
title: "0xcd484e37 (tagged Mirage Gallery: Curated Minter V3): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xcd484e37931f62013e6bd47fda62c21480248b47"
  family: "22fe665a1978cae56fe58cef6aba4fe2"
  label: "Mirage Gallery: Curated Minter V3"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "Owner (0x4a462cbf4902a8d26bf2c6931f12260d8fcec69e)"
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
  note: "The study note calls this a presale, but it is an NFT minter. The constant 0x6f6c63430008130033 is Solidity compiler metadata, not a real address. I matched the EOA in the bytecode to adminSigner by inference; the bytecode doesn't name it, and `registry` is also immutable."
---

## Summary

The coupon signer is an immutable key with no setter and no code check or ERC-1271 path. The likely signer address has no code today. If it gets code, only coupon mints of new NFTs stop. No funds are held, so nothing can be locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- _isVerifiedCoupon: ecrecover(digest, v, r, s) == adminSigner
- `address private immutable adminSigner`, assigned only in the constructor; no function writes it
- Only address in the runtime bytecode: 0x1539330800eb03c4da74cdd25c5dad03a7ec3623, an EOA (no code) at block 26438999. The bytecode doesn't say which immutable it is.
- _splitFundsETH forwards all msg.value right away, so the contract keeps no balance

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

If the signer key's account gets code, the owner can call enableCoupons to switch coupons off for a drop, then use setIntelAllotment so members mint through earlyIntelligentPurchase. Alternatively, deploy a new minter with a replaceable signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
