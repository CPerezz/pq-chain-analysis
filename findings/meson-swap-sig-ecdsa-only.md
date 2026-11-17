---
id: meson-swap-sig-ecdsa-only
title: "Meson cross-chain swap contract: swap requests and releases are signed with ECDSA only, so a quantum attacker with a user's old key can pull the tokens that user approved to Meson and release them to itself, and post-quantum accounts cannot complete swaps"
project: meson
status: confirmed
severity: MEDIUM
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x25ab3efd52e6470681ce037cd546dc60726948d3"
  implementation: "0xf7dace615099950410bd07f52427a0448429518a"
  name: ProxyToMeson -> UpgradableMeson (current implementation unverified)
  upgradeable: "yes"
  admin: "UUPS, upgradeTo onlyOwner; owner EOA 0x000039ddcf1f63cf3555e62a8d32a11bd1e7e1e1 (storage slot 308)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 2532
families: []
fix:
  layer: contract-upgrade
  who_acts: "Meson: owner EOA 0x000039ddcf1f63cf3555e62a8d32a11bd1e7e1e1 calls upgradeTo on 0x25ab3efd52e6470681ce037cd546dc60726948d3"
  protocol_change: helps
evidence:
  level: bytecode
  links:
  - evidence/meson-swap-sig-ecdsa-only/classification.jsonl
  - evidence/meson-swap-sig-ecdsa-only/onchain.json
  - evidence/meson-swap-sig-ecdsa-only/activity.json
  - evidence/meson-swap-sig-ecdsa-only/source-excerpts.md
  - evidence/meson-swap-sig-ecdsa-only/onchain-review.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review15 (finding review)
  ref: findings/meson-swap-sig-ecdsa-only.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Meson swaps are authorised by the user (the "initiator") signing the encoded swap and, on the destination chain, a
release to a recipient; both are checked only with `ecrecover` (PQ-1). A quantum attacker who recovers a user's
secp256k1 key can post a swap that pulls the tokens that user approved to Meson and release the output to itself,
including after the user migrates the address to post-quantum authorisation; post-quantum smart accounts cannot sign
releases at all. The exposure is users' approvals to Meson, which are not measurable here. The owner, one EOA, can
upgrade the contract. Rated MEDIUM (step 4: fix by upgrade; value unmeasured, so step 5 does not lower it).

## Mechanism

Verified source of the original implementation (`Flattened.sol` in the proxy's Sourcify entry):
`MesonSwap.postSwap(encodedSwap, r, s, v, postingValue)` calls `_checkRequestSignature(encodedSwap, r, s, v, initiator)`
(`require(signer == ecrecover(digest, v, r, s))`, line 1981) and then `_unsafeDepositToken(..., initiator, amount)`,
which pulls the amount (at most 100k per swap) from the initiator's allowance. On the target chain
`MesonPools.release(encodedSwap, r, s, v, initiator, recipient)` checks `_checkReleaseSignature` (line 2021) and
pays the LP-locked output to `recipient`; `MesonSwap.executeSwap` uses the same release signature to pay the LP on
the source chain. There is no ERC-1271 path.

The current implementation `0xf7da…518a` is unverified. Its dispatcher has the same functions with 64-byte compact
signatures (`postSwapWithSignature(uint256,bytes32,bytes32,address,uint40)`,
`release(uint256,bytes32,bytes32,address,address)`, `lock`, `executeSwap`, `directSwap`, `directRelease`), five
`STATICCALL`s to `ecrecover` and no ERC-1271 selector. It adds `postSwapFromInitiator(uint256,uint200)`, an on-chain
posting by the initiator without a signature, but releases still need the initiator's ECDSA signature.

Pattern PQ-1. Excerpt: [`source-excerpts.md`](../evidence/meson-swap-sig-ecdsa-only/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify, original implementation in `ProxyToMeson`): request and release checks are
  `ecrecover` only; `_authorizeUpgrade` is `onlyOwner`.
- CHECKED (bytecode of the current implementation, block 26,431,550,
  [`onchain-review.md`](../evidence/meson-swap-sig-ecdsa-only/onchain-review.md)): selectors and precompile calls as
  above. The two checks agree; evidence level stays `bytecode`.
- CHECKED (storage, block 26,431,608): EIP-1967 implementation `0xf7dace61…`; `_owner` (slot 308) =
  EOA `0x0000…e1e1`, also the proxy's deployer; `_premiumManager` (slot 309) = `0x666d…65a2`.
- CHECKED (precompile trace to March 2026): `ecrecover`, 25,463 pre-quantum calls in the last year (USD 98.9M moved
  in those transactions; `curated_contracts.csv`).
- CHECKED (Xatu, any function): 2,532 transactions 2026-10-16 to 2026-11-16; last 2026-11-15
  ([`activity.json`](../evidence/meson-swap-sig-ecdsa-only/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x25ab3efd…` Meson | yes (owner EOA) | not measured: users' approvals to Meson | 2026-11-15 | 2,532 |

The USD 97k the contract holds (`onchain.json`: USDT, USDC, WBTC and others) is LP pool liquidity; a forged user
signature does not release it beyond a swap the LP itself locks and fulfils, so it is not the exposure and
`value_usd` is left empty. What users have approved to Meson cannot be summed here.

## Remediation

- Meson upgrades the implementation to verify requests and releases with code-checked ERC-1271 (or ERC-7913) for
  accounts with code and `ecrecover` only for code-less addresses (PQ-13 order), with full-length signatures. Actor:
  owner EOA `0x0000…e1e1` (`upgradeTo`). No protocol change is required.
- Protocol change helps: EIP-8151 would stop forged requests for migrated addresses without the upgrade.
- Users: revoke approvals to `0x25ab…48d3` before migrating an address; the owner key itself is an ECDSA EOA and
  should move to a post-quantum account.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by upgrading the contract (admin or governance)).
- 2026-11-17 review (Review15): MEDIUM confirmed (step 4). Held USD 97k removed (LP liquidity, not the exposure); owner read from storage; evidence level source-read -> bytecode (current implementation unverified, checked by selectors, precompile calls and the verified predecessor).
