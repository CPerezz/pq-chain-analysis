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
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/meson-swap-sig-ecdsa-only
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review15 (finding review)
  ref: findings/meson-swap-sig-ecdsa-only.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read or judged, the registry text read; not executed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, reading 3 (does EIP-8151 close this path), 2026-11-19"
  date: 2026-11-19
  verdict: confirmed
  rating: ''
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

Pattern PQ-1. Excerpt: [`source-excerpts.md`](#source-excerpts-meson-swap-sig-ecdsa-only).

## Evidence

- CHECKED (verified source, Sourcify, original implementation in `ProxyToMeson`): request and release checks are
  `ecrecover` only; `_authorizeUpgrade` is `onlyOwner`.
- CHECKED (bytecode of the current implementation, block 26,431,550,
  [`onchain-review.md`](#review-reads-review15-2026-11-17)): selectors and precompile calls as
  above. The two checks agree; evidence level stays `bytecode`.
- CHECKED (storage, block 26,431,608): EIP-1967 implementation `0xf7dace61…`; `_owner` (slot 308) =
  EOA `0x0000…e1e1`, also the proxy's deployer; `_premiumManager` (slot 309) = `0x666d…65a2`.
- CHECKED (precompile trace to March 2026): `ecrecover`, 25,463 pre-quantum calls in the last year (USD 98.9M moved
  in those transactions; `curated_contracts.csv`).
- CHECKED (Xatu, any function): 2,532 transactions 2026-10-16 to 2026-11-16; last 2026-11-15
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/meson-swap-sig-ecdsa-only/activity.json)).
- CHECKED (study `eip-8151-impact`, reading 3, 2026-11-19, not executed): requests and releases recover the signer
  with `ecrecover` only (study family `754e8121`, placed by a rule); the replayed transaction had already reverted on
  chain, so it shows nothing. By the EIP's text, a signer whose address has real code recovers to no address, so its
  old ECDSA key no longer works here.

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

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by upgrading the contract (admin or governance)).
- 2026-11-17 review (Review15): MEDIUM confirmed (step 4). Held USD 97k removed (LP liquidity, not the exposure); owner read from storage; evidence level source-read -> bytecode (current implementation unverified, checked by selectors, precompile calls and the verified predecessor).
- 2026-11-19 (study `eip-8151-impact`, reading 3): EIP-8151 as written closes this path for an account that takes
  real code (read, not executed); plain and 7702-delegated accounts stay exposed, and approvals already given stay
  valid.

# Source excerpts: meson-swap-sig-ecdsa-only

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x25ab3efd52e6470681ce037cd546dc60726948d3` — ProxyToMeson (verified source via sourcify)

### `contracts/Flattened.sol`

```solidity
 1977          mstore(0, typehash)
 1978          digest := keccak256(0, 64)
 1979        }
 1980      }
 1981      require(signer == ecrecover(digest, v, r, s), "Invalid signature");
 1982    }
 1983  
 1984    /// @notice Check the initiator's signature for the release request
 1985    /// Signatures are constructed with the package `mesonfi/sdk`. Go to `packages/sdk/src/SwapSigner.ts` and 
  ...
 2017          mstore(0, typehash)
 2018          digest := keccak256(0, 64)
 2019        }
 2020      }
 2021      require(signer == ecrecover(digest, v, r, s), "Invalid signature");
 2022    }
 2023  }
 2024  
 2025  
  ...
```

## Implementation `0xf7dace615099950410bd07f52427a0448429518a`

No verified source on Sourcify or Blockscout.

# Review reads (Review15, 2026-11-17)

Proxy `0x25ab3efd52e6470681ce037cd546dc60726948d3` (ProxyToMeson, verified on Sourcify as `contracts/Flattened.sol`,
which also contains the original `UpgradableMeson` implementation deployed by its constructor).

## Storage (RPC eth.drpc.org, block 26,431,608)

| Read | Result |
|---|---|
| EIP-1967 implementation slot (publicnode, block 26,431,550) | `0xf7dace615099950410bd07f52427a0448429518a` (unverified) |
| EIP-1967 admin slot | 0 (UUPS: `_authorizeUpgrade` is `onlyOwner`) |
| slot 308 (`MesonManager._owner`, layout computed from the verified source) | `0x000039ddcf1f63cf3555e62a8d32a11bd1e7e1e1` (EOA, nonce 237; also the proxy's deployer per Blockscout) |
| slot 309 (`_premiumManager`) | `0x666d6b8a44d226150ca9058beebafe0e3ac065a2` (23 bytes of code: an EIP-7702 delegated EOA, nonce 161,230) |
| `ownerOfPool(1)` | `0x0014eb4ac6dd1473b258d088e6ef214b2bcdc53c` (EOA) |

Layout: Initializable (slot 0), two OZ `__gap[50]` (1–100), MesonTokens (101–152), MesonStates (153–205), MesonSwap
(206–256), MesonPools (257–307), MesonManager `_owner` 308, `_premiumManager` 309.

## Current implementation bytecode (20,195 bytes)

Dispatcher selectors resolved with openchain.xyz include `postSwapWithSignature(uint256,bytes32,bytes32,address,uint40)`,
`postSwap(uint256,address,uint40)`, `postSwapFromInitiator(uint256,uint200)`, `lock(uint256,bytes32,bytes32,address)`,
`release(uint256,bytes32,bytes32,address,address)`, `executeSwap(uint256,bytes32,bytes32,address,bool)`,
`directSwap(uint256,address,bytes32,bytes32)`, `directRelease(uint256,bytes32,bytes32,address,address)`,
`upgradeTo(address)`, `transferOwnership(address)`. Signatures are `(r, yParityAndS)`, 64 bytes. Five `STATICCALL`s to
precompile `0x01`; the ERC-1271 selector `0x1626ba7e` does not occur.
