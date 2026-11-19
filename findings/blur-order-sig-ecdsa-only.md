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
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/blur-order-sig-ecdsa-only
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl,out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review01)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/blur-order-sig-ecdsa-only/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: HIGH
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by a person)"
  ref: "studies/eip-8151-impact, reading 3 (does EIP-8151 close this path), 2026-11-19"
  date: 2026-11-19
  verdict: confirmed
  rating: ''
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
  26,429,758 ([`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/blur-order-sig-ecdsa-only/escrow.json)).
- CHECKED (block 26,431,492): `oracles(0x6af68e5d…)` = 0 on both contracts; `SetOracle` logs on BlurExchangeV2
  (eth_getLogs, blocks 17,000,000–26,431,500) show only that oracle, added at 17,603,916 and removed at 26,401,100.
- CHECKED (block 26,431,492): Blur Pool ETH balance 4,936.70 ETH = `totalSupply()`.
- CHECKED (Xatu, [`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/blur-order-sig-ecdsa-only/activity.json)): 4,170 transactions to Blend
  and 3,791 to BlurExchangeV2 in 2026-10-16 to 2026-11-16; yearly `ecrecover` calls (`curated_contracts.csv`,
  `txs_y1`): 92,587 (Blend) and 177,860 (BlurExchangeV2).
- INFERRED: the Safe cannot execute again: `0x…dead` has no key and no code, so it can neither sign, approve a hash
  nor answer ERC-1271. The intent behind the change (ending upgradeability) is not documented here.
- INFERRED: BlurExchangeV2 transactions after block 26,401,100 can only be cancels, nonce increments or reverted
  trades.
- CHECKED (executed, study `eip-8151-impact`, 2026-11-19): a real transaction,
  `0x2a36c36001cdbeba685345a52533a96960b2bfe389defe6f8b529c1399da8c15` (block 26,398,867, position 1), replayed on
  the reference implementation of the fork with only the precompile changed. Under today's rule it matches its
  receipt (193,457 gas); under EIP-8151 it also succeeds (197,157 gas). With one byte of code at the recovered signer
  `0x6af68e5d010513ff70a3aaed9afeb8661116e6ce`, it reverts after that recovery returned no address; with a 7702
  delegation there it succeeds. Study family `ede746d8` (BlurExchangeV2).

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

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by upgrading the contract (admin or governance)).
- 2026-11-17 review (Review01): MEDIUM -> HIGH, step 4: the owner Safe 0xfa9fb502… became 5-of-5 with 0x…dead as an owner at block 26,429,758, so neither contract can be upgraded and Blend lender offers stay forgeable (user-key loss in a contract that cannot change); BlurExchangeV2 has no approved oracle since block 26,401,100 and cannot trade; escrow is Blur Pool (4,936.70 ETH).
- 2026-11-19 (study `eip-8151-impact`, reading 3): EIP-8151 as written closes this path for an account that takes
  real code (executed on a real transaction); plain and 7702-delegated accounts stay exposed, and approvals already
  given stay valid.

# Source excerpts: blur-order-sig-ecdsa-only

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xb2ecfe4e4d61f8790bbb9de2d1259b9e2410cea5` — ERC1967Proxy (verified source via sourcify)

## Implementation `0x5fa60726e62c50af45ff2f6280c468da438a7837` — BlurExchangeV2 (verified source via sourcify)

### `contracts/exchangeV2/Signatures.sol`

```solidity
  322          uint8 v,
  323          bytes32 r,
  324          bytes32 s
  325      ) private pure returns (bool valid) {
  326          address recoveredSigner = ecrecover(digest, v, r, s);
  327          if (recoveredSigner != address(0) && recoveredSigner == signer) {
  328              valid = true;
  329          }
  330      }
  ...
```

### `contracts/exchangeV2/Validation.sol`

```solidity
  138          OrderType orderType,
  139          Exchange memory exchange
  140      ) private pure returns (bool validListing) {
  141          Listing memory listing = exchange.listing;
  142          validListing = MerkleProof.verify(exchange.proof, order.listingsRoot, hashListing(listing));
  143          Taker memory taker = exchange.taker;
  144          if (orderType == OrderType.ASK) {
  145              if (order.assetType == AssetType.ERC721) {
  146                  validListing = validListing && taker.amount == 1 && listing.amount == 1;
  ...
```

### `lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol`

```solidity
   23       * defined by `root`. For this, a `proof` must be provided, containing
   24       * sibling hashes on the branch from the leaf to the root of the tree. Each
   25       * pair of leaves and each pair of pre-images are assumed to be sorted.
   26       */
   27      function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
   28          return processProof(proof, leaf) == root;
   29      }
   30  
   31      /**
  ...
```


## Contract `0x29469395eaf6f95920e59f858042f0e28d98a20b` — ERC1967Proxy (verified source via sourcify)

## Implementation `0xb258ca5559b11cd702f363796522b04d7722ea56` — Blend (verified source via sourcify)

### `contracts/blend/lib/Signatures.sol`

```solidity
  278      function _verify(address signer, bytes32 digest, uint8 v, bytes32 r, bytes32 s) internal pure {
  279          if (v != 27 && v != 28) {
  280              revert InvalidVParameter();
  281          }
  282          address recoveredSigner = ecrecover(digest, v, r, s);
  283          if (recoveredSigner == address(0) || signer != recoveredSigner) {
  284              revert InvalidSignature();
  285          }
  286      }
  ...
```
