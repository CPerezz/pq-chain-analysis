---
id: rayls-distributor-signer
title: "Rayls (RLS) airdrop Distributor on Clique's code (0x96c67b14): a quantum attacker who recovers the claim-signer key can release Merkle allocations ahead of schedule from a vault holding ~$15k"
project: rayls
status: confirmed
severity: MEDIUM
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x96c67b143000a60d9162f25c29fa0cf5b8d0e5af"
  implementation: null
  name: Distributor (Clique Distributor1MC v3.0.0)
  upgradeable: config-only
  admin: "owner and PROJECT_ADMIN EOA 0xfdacab3de84fc1ac6518cced5afc008b16a9c1ff (block 26431623): setSigner, setClaimRoot, setVault, setToken, pause"
  value_usd: 15360
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-01
  txs_30d: 4
families: []
fix:
  layer: new-deployment
  who_acts: "the distributor's admin EOA 0xfdacab3de84fc1ac6518cced5afc008b16a9c1ff pauses this contract and deploys a distributor without the ECDSA signer (Merkle-only, or a post-quantum signer); vault Safe 0x5b9089a93dd0f48fd74ab80d6b9dccfac64d9989 revokes the RLS allowance"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/rayls-distributor-signer
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review17 (Sourcify source and on-chain reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/rayls-distributor-signer/review-notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

This contract distributes Rayls (RLS) tokens from a vault Safe: a claim needs a Merkle proof of the recipient's
allocation and an ECDSA signature from one off-chain signer key that sets how much of the allocation is released so
far. A quantum attacker who recovers the signer key (its signatures are in every `claim` calldata) can release the rest
of any allocation at once, paid to the allocation's own recipient; the vault holds 9.85M RLS (~$15.4k). The admin can
pause it and redeploy, so step 4 gives MEDIUM; the exposure is under $50k, so LOW (step 5).

## Mechanism

- `claim(_proof, _signature, _amount, _released, _handler, _onBehalfOf, _extra)` (`src/sub/BaseDistributor.sol`
  244-292) checks the Merkle leaf `(handler, amount)` against a configured root, requires
  `handler == keccak256(onBehalfOf)` (`dynamicRecipient` is false), then `_signatureCheck`, then pays
  `_released - claimedAmount` to `_onBehalfOf` through the root's hooks, pulling from `vault`.
- `_signatureCheck` (326-346): `ECDSA.recoverCalldata(toEthSignedMessageHash(keccak256(handler, onBehalfOf, amount,
  released, root, this, chainid, extra)), signature) == signer` (PQ-4). The signer decides the released amount and the
  hook data; the admin can rotate it with `setSigner`, not change the scheme.
- The Merkle root bounds each allocation, so a forged signer cannot pay more than an allocation or to another
  address; the admin EOA, which can set the root, vault and signer, is a separate ECDSA key with full control.

## Evidence

- CHECKED (Sourcify source, `Distributor` v3.0.0, NatSpec "Clique Airdrop contract (Mekle + ECDSA)"): `claim`,
  `_signatureCheck`, `_execute`, admin setters ([`review-notes.md`](#review-reads-rayls-distributor-signer-2026-11-17-review17),
  [`source-excerpts.md`](#source-excerpts-rayls-distributor-signer)).
- CHECKED (on-chain, latest block 26,431,623): `signer()` = `0x0f828d66…` (EOA, signs off-chain only); `owner()` =
  EOA `0xfdacab3d…`; `token()` = RLS `0xb5f7b021…`; `vault()` = Safe `0x5b9089a9…` (1 of 1); vault RLS balance
  9,849,783.86 with 30.58M allowance to the distributor; `dynamicRecipient()` false.
- CHECKED (Blockscout, 2026-11-17): RLS price $0.00155938 (vault ≈ $15,360); distributor holds 0.067 ETH of claim fees.
- CHECKED (Xatu, any function): 4 transactions 2026-10-16 to 2026-11-16, last 2026-11-01
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/rayls-distributor-signer/activity.json)); 88,592 `ecrecover` transactions in the
  yearly window (`studies/top-callers-classification/results/curated_contracts.csv`).
- INFERRED: Clique wrote the contract (NatSpec); who runs the admin EOA (Clique or Rayls) is not established. The hook
  contracts were not read.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x96c67b14…` Distributor | config-only | ~$121 (fees); escrow ~$15.4k (vault) | 2026-11-01 | 4 |

Escrow: vault Safe `0x5b9089a93dd0f48fd74ab80d6b9dccfac64d9989`, 9.85M RLS ≈ $15,360 on 2026-11-17, the most a
forged release can draw (allowance 30.58M RLS is higher than the balance). Other Clique distributors were not checked.

## Remediation

- The admin `0xfdacab3d…` pauses or closes the active window, and the project redeploys a distributor whose claims are
  Merkle-only (fixed vesting computed on-chain) or verified with a post-quantum signer (ERC-1271/ERC-7913 key); the
  vault Safe revokes the allowance to `0x96c67b14…`. Clique would make that change in its Distributor code.
- The admin EOA and the vault Safe's single owner are ECDSA keys that control the same funds and need post-quantum
  accounts as well.
- No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review17): MEDIUM -> LOW, step 5: escrow measured at ~$15.4k (vault Safe RLS balance), under $50k. Project identified from `token()` (Rayls RLS) and the source NatSpec (Clique Distributor); held $121 replaced by the vault escrow.
- 2026-11-17 integration: id renamed from `unidentified-96c67b14-signer-key` (project identified).
- 2026-11-19: LOW -> MEDIUM, step 5 removed (value no longer lowers a rating); step 4 gives MEDIUM.

# Source excerpts: rayls-distributor-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x96c67b143000a60d9162f25c29fa0cf5b8d0e5af` — Distributor (verified source via sourcify)

### `src/sub/BaseDistributor.sol`

```solidity
    1  // SPDX-License-Identifier: MIT
    2  pragma solidity 0.8.30;
    3  
    4  import {ECDSA} from "solady/utils/ECDSA.sol";
    5  import {FixedPointMathLib} from "solady/utils/FixedPointMathLib.sol";
    6  import {OwnableRoles} from "solady/auth/OwnableRoles.sol";
    7  
    8  struct ClaimInfo {
  ...
  338          /// forge-lint: disable-next-item(asm-keccak256)
  339          bytes32 messageHash = keccak256(
  340              abi.encodePacked(_handler, _onBehalfOf, _amount, _released, _root, address(this), block.chainid, _extra)
  341          );
  342          bytes32 prefixedHash = ECDSA.toEthSignedMessageHash(messageHash);
  343          address recoveredSigner = ECDSA.recoverCalldata(prefixedHash, _signature);
  344  
  345          if (recoveredSigner != _signer) revert InvalidSignature();
  346      }
  347  
  ...
```

Library files with the primitive itself (not excerpted): `lib/solady/src/utils/ECDSA.sol`, `solady/utils/ECDSA.sol`

# Review reads: rayls-distributor-signer (2026-11-17, Review17)

Sourcify source of `0x96c67b143000a60d9162f25c29fa0cf5b8d0e5af` (`src/sub/Distributor.sol:Distributor`, solc 0.8.30,
solady): NatSpec `@title Distributor1MC`, `@notice Clique Airdrop contract (Mekle + ECDSA), allows for multiple claims`;
`version()` = "3.0.0".

- `claim(_proof, _signature, _amount, _released, _handler, _onBehalfOf, _extra)` (BaseDistributor.sol 244-292):
  `_handler` must equal `keccak256(_onBehalfOf)` unless `dynamicRecipient`; `_rootCheck` requires the Merkle leaf
  `(handler, amount)` to resolve to a configured root; then `_signatureCheck` and `_execute(vault, _onBehalfOf, root,
  _released - claimedAmount, _extra)`.
- `_signatureCheck` (326-346): `ECDSA.recoverCalldata(toEthSignedMessageHash(keccak256(handler, onBehalfOf, amount,
  released, root, this, chainid, extra)), signature) == signer`. The signer decides how much of an allocation is
  released (`_released`) and the hook data (`_extra`).
- `Distributor._execute` (Distributor.sol 107-144) splits the amount over the root's configured hooks
  (`IHook.execute(vault, recipient, root, amount, data)`).
- `PROJECT_ADMIN` (`_ROLE_0`) functions: `setSigner`, `setClaimRoot`, `setVault`, `setToken`, `pause`, `unpause`,
  `setActiveWindow`, fee setters, `setHooks`; `withdrawFee` is `onlyOwner`.

On-chain reads (latest block 26,431,623, 2026-11-17):

- `signer()` = `0x0f828d66ec5eba50d80b234ef487f82edfecbb92` (no code, nonce 0: signs off-chain only; its signatures are
  in `claim` calldata).
- `owner()` = `0xfdacab3de84fc1ac6518cced5afc008b16a9c1ff` (no code; Blockscout: creator, last admin calls
  `setClaimRoot`/`setFixedFee` 2026-03-01, `withdrawFee` 2026-01-21).
- `token()` = RLS `0xb5f7b021a78f470d31d762c1dda05ea549904fbd` ("Rayls", 18 decimals); `isWrappedToken()` false;
  `dynamicRecipient()` false.
- `vault()` = `0x5b9089a93dd0f48fd74ab80d6b9dccfac64d9989` (Blockscout: SafeProxy, singleton Safe; `getThreshold()` = 1,
  owner `0x60f0e09e51704ea6e472f877f849269eede76309`).
- RLS `balanceOf(vault)` = 9,849,783.86 RLS; `allowance(vault, distributor)` = 30,581,168.9 RLS.
- Blockscout RLS token: price $0.00155938, circulating market cap $3.37M → vault balance ≈ $15,360.
- Distributor ETH balance 0.0669 ETH (claim fees; Blockscout coin_balance).
- Blockscout transactions: `claim` calls through 2026-11-01.
