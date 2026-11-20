---
id: 8575b2db-fixed-signer
title: "0x8575b2db: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8575b2dbbd7608a1629adaa952aba74bcc53d22a"
  family: "dc711c9d6630e044265d49c87dd20641"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 13
  last_active: 2026-11-02
fix:
  layer: new-deployment
  who_acts: "The owner or project would need to redeploy, or mint reserved and author tokens some other way. Users can do nothing to restore the gated claims."
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
  note: "The _adminSigner value is inferred from the bytecode address list: 0xc7eb… is the only EOA left after taking out _teamAddress, the OpenSea contract and two values that look like ASCII string fragments. All candidate EOAs have no code today. The rating is MEDIUM because the gated functions only mint new NFTs and no user funds are locked."
---

## Summary

The signer is an immutable _adminSigner with no setter, no code check and no ERC-1271 support. The most likely value is the EOA 0xc7eb…843d. If that key's account gets real code, the presale, author and genesis claims stop working. No funds get locked: ETH can be withdrawn by the owner through disbursePayments, and a failed genesis ERC1155 transfer just reverts.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address private immutable _adminSigner;` is set only in the constructor
- _isVerifiedCoupon: `address signer = ecrecover(digest, coupon.v, coupon.r, coupon.s); ... return signer == _adminSigner;`
- No function writes _adminSigner. The only setter listed is transferOwnership (owner).
- disbursePayments(payees_, amounts_) onlyOwner sends the contract's ETH

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 13 transactions called it in the 90 days before that block; last on 2026-11-02.

## Remediation

Deploy a new contract with a signer that can be rotated, or with an ERC-1271 fallback. In the meantime, the owner can handle reserved and author allocations off-chain or by other means.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
