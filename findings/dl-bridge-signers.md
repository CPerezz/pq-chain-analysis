---
id: dl-bridge-signers
title: "Confidential Layer bridge (Distributed Lab Bridge.sol): withdrawals need one ECDSA signer key; a quantum attacker who recovers it can take the bridge's $57k and mint unlimited CLONE"
project: confidential-layer
status: confirmed
severity: MEDIUM
patterns: [PQ-4, PQ-5]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x44e37608f744a7aeb16f7dc9bf052c310e6cd015"
  implementation: "0x3f2e4e5a70f2a424d7c4e4e0323c878c77c20537"
  name: Bridge (ERC1967 UUPS proxy)
  upgradeable: "yes"
  admin: UUPS _authorizeUpgrade onlyOwner; owner Safe 0xab014cfff054692eeae239777c06647b47832d4c (2 of 3, block 26431609), which also sets signers and threshold
  value_usd: 57438
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-14
  txs_30d: 70
families: []
fix:
  layer: contract-upgrade
  who_acts: Confidential Layer, through owner Safe 0xab014cfff054692eeae239777c06647b47832d4c (2 of 3)
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/dl-bridge-signers
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
  who: Review10 (source and on-chain review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/dl-bridge-signers/review.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

This bridge runs Distributed Lab's open-source `Bridge.sol` (dl-solarity): every withdrawal needs ECDSA signatures from a signer set up to a threshold. On-chain the set is one signer with threshold 1, so a single key authorises all withdrawals (PQ-4; the code is a PQ-5 threshold set). Its signatures are public in withdrawal calldata; a quantum attacker who recovers the key can withdraw the bridge's ETH and tokens ($57k on 2026-11-17) and mint any amount of CLONE, the Confidential Layer token whose minter is this bridge. Rated MEDIUM (step 4): the owner Safe (2 of 3) can upgrade the UUPS proxy; $57k is above the step-5 threshold.

## Mechanism

- `withdrawERC20`, `withdrawERC721`, `withdrawERC1155`, `withdrawNative` (`Bridge.sol`, anyone can call) build a hash of the withdrawal (`getERC20SignHash`, etc., including `txHash_`, `txNonce_`, `block.chainid`), mark it used (`_checkAndUpdateHashes`), and call `Signers._checkSignatures`.
- `_checkSignatures` recovers each signature with `signHash_.toEthSignedMessageHash().recover(sig)` (OZ ECDSA) and `_checkCorrectSigners` requires every recovered address to be in `_signers`, no duplicates, and at least `signaturesThreshold` of them.
- Release: `_withdrawERC20` either transfers held tokens or, with `isWrapped_ = true`, calls `mintTo(receiver, amount)` on the wrapped token; native ETH is sent from the bridge.
- Admin (`onlyOwner`): `addSigners`, `removeSigners`, `setSignaturesThreshold`, `_authorizeUpgrade`.

Source excerpts: [`source-excerpts.md`](#source-excerpts-dl-bridge-signers).

## Evidence

- CHECKED (verified source, Sourcify implementation `0x3f2e4e5a…`: `bridge/Bridge.sol`, `utils/Signers.sol`, `handlers/*`): the path above.
- CHECKED (on-chain, block 26,431,609): EIP-1967 implementation `0x3f2e4e5a…`; `owner()` Safe `0xab014cff…` (threshold 2 of 3); `signaturesThreshold()` 1; `getSigners()` = [`0xe5b686fd…`]; 28.844 ETH ([`review.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/dl-bridge-signers/review.json)).
- CHECKED (Blockscout, 2026-11-17): CLONE `0xc9faeba8…` `owner()` is this bridge and its `mintTo` is `onlyOwner`; CLONE supply 102.2M, Blockscout circulating market cap $546k. Last 50 bridge transactions: 40 `withdrawERC20`, all CLONE with `isWrapped_ = true` (mints), 7 deposits, 3 native withdrawals.
- CHECKED (attribution): Confidential Layer's docs list `0xc9faeba8…` as CLONE on Ethereum; the bridge and CLONE were both deployed by `0x69a18eb6…`. The `project` is changed from Distributed Lab (code author) to Confidential Layer (operator).
- CHECKED (precompile trace, last year): 39,358 transactions with ecrecover (`txs_y1`); Xatu: 70 transactions 2026-10-16 to 2026-11-16, last 2026-11-14 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/dl-bridge-signers/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x44e37608…` Bridge | yes (UUPS) | $57k | 2026-11-14 | 70 |

- Held: 28.844 ETH ($52,255 at $1,811.62), USDT $3,322, DAI $1,860 (2026-11-17), $57,438 in total.
- Also exposed, not measured: forged withdrawals can mint unlimited CLONE on Ethereum, worth whatever DEX liquidity and other bridged chains would give for it (Blockscout circulating market cap $546k as an indication, not an exposure).
- One signer: the threshold set is configured as 1 of 1, so a single key is the trigger.

## Remediation

- Confidential Layer (owner Safe `0xab014cff…`) upgrades the implementation to verify a post-quantum attestation (ML-DSA or hash-based signatures through an ERC-7913 verifier, or a proof of the source-chain event). Adding more ECDSA signers raises the classical bar but not the quantum one.
- The Safe's owners are ECDSA keys (PQ-12).
- Distributed Lab's `Bridge.sol` is reused by others; the code change belongs upstream too.
- No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review10): MEDIUM confirmed, step 4 (UUPS upgrade by the 2-of-3 owner Safe; $57k held). Project distributed-lab -> confidential-layer (the bridge mints CLONE; code by Distributed Lab). Signer set read on-chain: 1 of 1, so trigger committee-keys -> operator-key and PQ-4 added; CLONE minting added to the exposure.

# Source excerpts: dl-bridge-signers

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x44e37608f744a7aeb16f7dc9bf052c310e6cd015` — ERC1967Proxy (verified source via sourcify)

## Implementation `0x3f2e4e5a70f2a424d7c4e4e0323c878c77c20537` — Bridge (verified source via sourcify)

### `contracts/utils/Signers.sol`

```solidity
    1  // SPDX-License-Identifier: MIT
    2  pragma solidity ^0.8.9;
    3  
    4  import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
    5  import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
    6  import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
    7  
    8  abstract contract Signers is OwnableUpgradeable {
  ...
   42      function _checkSignatures(bytes32 signHash_, bytes[] calldata signatures_) internal view {
   43          address[] memory signers_ = new address[](signatures_.length);
   44  
   45          for (uint256 i = 0; i < signatures_.length; i++) {
   46              signers_[i] = signHash_.toEthSignedMessageHash().recover(signatures_[i]);
   47          }
   48  
   49          _checkCorrectSigners(signers_);
   50      }
  ...
```

Library files with the primitive itself (not excerpted): `@openzeppelin/contracts/utils/cryptography/ECDSA.sol`
