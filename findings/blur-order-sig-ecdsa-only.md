---
id: blur-order-sig-ecdsa-only
title: "Blur Blend: a quantum-forged lender signature borrows that lender's Blur Pool ETH (4,937 ETH deposited) through a contract whose owner Safe can no longer act"
project: blur
status: confirmed
severity: HIGH
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x29469395eaf6f95920e59f858042f0e28d98a20b"
  implementation: "0xb258ca5559b11cd702f363796522b04d7722ea56"
  name: Blend (ERC1967Proxy)
  upgradeable: "no"
  admin: "UUPS owner Safe 0xfa9fb502534761dbddacf5b7e2aa84684815f1bb, threshold 5 of 5 with 0x…dead as an owner since block 26429758; cannot execute (read at block 26431492)"
  value_usd: 8943430
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 4170
- address: "0xb2ecfe4e4d61f8790bbb9de2d1259b9e2410cea5"
  implementation: "0x5fa60726e62c50af45ff2f6280c468da438a7837"
  name: BlurExchangeV2 (ERC1967Proxy)
  upgradeable: "no"
  admin: "UUPS owner Safe 0xfa9fb502534761dbddacf5b7e2aa84684815f1bb, threshold 5 of 5 with 0x…dead as an owner since block 26429758; cannot execute (read at block 26431492)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-13
  txs_30d: 3791
families: []
fix:
  layer: new-deployment
  who_acts: "Blur, by deploying a new lending contract and pool (the owner Safe 0xfa9fb502534761dbddacf5b7e2aa84684815f1bb of Blend and Blur Pool 0x0000000000a39bb272e79075ade125fd351887ac can no longer act); each lender, by withdrawing ETH from Blur Pool"
  protocol_change: helps
evidence:
  level: source-read
  links:
  - evidence/blur-order-sig-ecdsa-only/classification.jsonl
  - evidence/blur-order-sig-ecdsa-only/onchain.json
  - evidence/blur-order-sig-ecdsa-only/activity.json
  - evidence/blur-order-sig-ecdsa-only/source-excerpts.md
  - evidence/blur-order-sig-ecdsa-only/escrow.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl,out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: review (Review01)
  ref: evidence/blur-order-sig-ecdsa-only/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: HIGH
related: []
---

## Summary

Blur's NFT lending contract Blend accepts a lender's loan offer on an `ecrecover` signature alone (PQ-1). A quantum
attacker who recovers a lender's ECDSA key from its public key can sign an offer for a worthless collection and
borrow that lender's ETH out of Blur Pool, including after the lender has moved to a post-quantum account. Blur Pool
holds 4,937 ETH (USD 8.9M) of user deposits, the upper bound of what such offers could release. Blend's owner Safe was
set on 2026-11-16 to need a signature from `0x…dead`, so the contract can no longer be upgraded; BlurExchangeV2,
covered by the same draft, has no approved oracle left and can no longer execute trades. Rated HIGH (step 4:
user-key loss in a contract that cannot change; was MEDIUM).

## Mechanism

- Blend `borrow(LoanOffer, signature, loanAmount, collateralTokenId)` → `_borrow` → `_takeLoanOffer` →
  `OfferController._validateOffer` → `Signatures._verifyOfferAuthorization(offerHash, lender, oracle, signature)`,
  which calls `_verify(lender, …)`: `ecrecover(digest, v, r, s)` compared with `offer.lender` (excerpt lines
  278–286). No ERC-1271 path. The oracle co-signature is checked only `if (oracle != address(0))`, and the oracle is
  a field of the lender-signed offer, so a forged offer sets it to zero.
- `borrow` then takes the attacker's NFT of `offer.collection` (chosen in the forged offer) as collateral and calls
  `_POOL.transferFrom(offer.lender, msg.sender, loanAmount)` on Blur Pool. The attacker never repays. `refinance`,
  `refinanceAuctionByOther` and `borrowerRefinance` also pull from `offer.lender` on a signed offer, and
  `buyLocked` accepts a borrower's signed sell offer the same way.
- BlurExchangeV2 `takeAsk`/`takeBid`/`takeAskSingle`/`takeBidSingle` (and the `*Pool` wrappers) check maker order
  signatures with raw `ecrecover` (`Signatures._verifyAuthorization` → `_verify`, excerpt lines 322–330), but every
  entry point first runs `verifyOracleSignature`, which reverts with `UnauthorizedOracle` when `oracles[oracle] == 0`.
  The only oracle ever approved, `0x6af68e5d…`, was removed at block 26,401,100, and the owner can no longer add one,
  so no trade can execute and nothing can be taken through it.

## Evidence

- CHECKED (verified source, Sourcify): Blend implementation `0xb258ca55…` and BlurExchangeV2 implementation
  `0x5fa60726…`, functions as quoted; Blur Pool implementation `0x01a65602…` (`transferFrom` only for EXCHANGE,
  EXCHANGE_V2, SWAP, BLEND); Delegate `0x2f18f339…4dfb` (immutable exchange, no owner).
- CHECKED (runtime code): Blend and BlurExchangeV2 embed Blur Pool `0x0000000000a39bb2…` as an immutable; the Blur Pool
  implementation embeds both `0xb2ecfe4e…` and `0x29469395…`.
- CHECKED (block 26,431,492): both proxies' EIP-1967 implementation slots as above, `owner()` = Safe `0xfa9fb502…`
  (also owner of Blur Pool); Safe v1.3.0, threshold 5, owners include `0x…dead`, no modules, no guard. Safe history:
  `changeThreshold(2)` at block 26,429,748, then `removeOwner(0xa742009a…)`, `addOwner(0x…dead)`, threshold 5 at block
  26,429,758 ([`escrow.json`](../evidence/blur-order-sig-ecdsa-only/escrow.json)).
- CHECKED (block 26,431,492): `oracles(0x6af68e5d…)` = 0 on both contracts; `SetOracle` logs on BlurExchangeV2
  (eth_getLogs, blocks 17,000,000–26,431,500) show only that oracle, added at 17,603,916 and removed at 26,401,100.
- CHECKED (block 26,431,492): Blur Pool ETH balance 4,936.70 ETH = `totalSupply()`.
- CHECKED (Xatu, [`activity.json`](../evidence/blur-order-sig-ecdsa-only/activity.json)): 4,170 transactions to Blend
  and 3,791 to BlurExchangeV2 in 2026-10-16 to 2026-11-16; yearly `ecrecover` calls (`curated_contracts.csv`,
  `txs_y1`): 92,587 (Blend) and 177,860 (BlurExchangeV2).
- INFERRED: the Safe cannot execute again: `0x…dead` has no key and no code, so it can neither sign, approve a hash
  nor answer ERC-1271. The intent behind the change (ending upgradeability) is not documented here.
- INFERRED: BlurExchangeV2 transactions after block 26,401,100 can only be cancels, nonce increments or reverted
  trades.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x29469395…` Blend | no (owner Safe cannot act) | USD 8.9M (escrow: Blur Pool deposits) | 2026-11-15 | 4,170 |
| `0xb2ecfe4e…` BlurExchangeV2 | no (owner Safe cannot act) | none (no approved oracle) | 2026-11-13 | 3,791 |

Escrow: Blur Pool `0x0000000000a39bb272e79075ade125fd351887ac`, 4,936.70 ETH = USD 8,943,430 at USD 1,811.62
(block 26,431,492). Each lender's own balance is what a forged offer in that lender's name can take; the total is an
upper bound and assumes the lender's public key is known (any address that has sent a transaction). Blend's own
holdings (USD 1.2k of stray tokens) are not the exposure. Blur Exchange V1 (`0x000000000000ad05…`) and the swap
contract can also pull from Blur Pool; they are not in this finding.

## Remediation

- Replacement: lender and sell offers verified through the signer's account code (ERC-1271 with the full signature,
  or ERC-7913), so a migrated lender's old ECDSA key no longer signs for it.
- Who acts: the contracts cannot be upgraded; their owner Safe `0xfa9fb502534761dbddacf5b7e2aa84684815f1bb` needs a
  signature from `0x…dead`. Blur can only deploy a new lending contract and pool for users to move to.
- Users: lenders protect themselves by withdrawing their ETH from Blur Pool (withdrawal is by `msg.sender`, so a
  post-quantum account can do it) or by never keeping a balance there. EIP-8151 would protect lenders whose address
  has real post-quantum account code, without Blur.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by upgrading the contract (admin or governance)).
- 2026-11-17 review (Review01): MEDIUM -> HIGH, step 4: the owner Safe 0xfa9fb502… became 5-of-5 with 0x…dead as an owner at block 26,429,758, so neither contract can be upgraded and Blend lender offers stay forgeable (user-key loss in a contract that cannot change); BlurExchangeV2 has no approved oracle since block 26,401,100 and cannot trade; escrow is Blur Pool (4,936.70 ETH).
