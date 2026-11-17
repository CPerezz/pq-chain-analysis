---
id: aori-order-sig-ecdsa-only
title: "Aori (current and three older deployments): a quantum attacker who forges a user's ECDSA order signature can have a whitelisted solver pull that user's approved ERC-20 tokens; post-quantum accounts cannot sign ERC-20 orders"
project: aori
status: confirmed
severity: MEDIUM
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x0736bdc975af0675b9a045384efed91360d25479"
  implementation: null
  name: Aori (current)
  upgradeable: config-only
  admin: "0x941327e206b8d8cfe1014a8a95b05e1536dfd00d (owner(), EOA): pause, solver/hook/chain whitelists, emergencyCancel/emergencyWithdraw; no upgrade path"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-08
  txs_30d: 1820
- address: "0x8635c874b0fcb361fb9a2f5218852d4b7fc5ace3"
  implementation: null
  name: Aori (earlier version; paused)
  upgradeable: config-only
  admin: "0xb4afac168ca0cce40c5b4d4e8e49a1e18a630b40 (owner(), EOA); paused() = true since 2026-08-19"
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-08-19
  txs_30d: 0
- address: "0x7dec965cf240f81299683f48a18ebdbe8b2accb5"
  implementation: null
  name: Aori (earlier version; unverified)
  upgradeable: config-only
  admin: "0xb4afac168ca0cce40c5b4d4e8e49a1e18a630b40 (owner(), EOA): pause, solver/hook/peer whitelists, emergencyWithdraw; no upgrade path; not paused"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-08-19
  txs_30d: 0
- address: "0xbb4c20cb237f3629d1afc3ecb3e84148fa426c12"
  implementation: null
  name: Aori (earlier version; unverified)
  upgradeable: config-only
  admin: "0xb4afac168ca0cce40c5b4d4e8e49a1e18a630b40 (owner(), EOA); not paused"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-05-06
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: "Aori: deploy a version with ERC-1271 (account-code-first) order signatures and move solvers to it; owner EOA 0x941327e206b8d8cfe1014a8a95b05e1536dfd00d can pause 0x0736bdc9…, owner EOA 0xb4afac168ca0cce40c5b4d4e8e49a1e18a630b40 can pause 0x7dec965c… and 0xbb4c20cb…; users revoke approvals"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aori-order-sig-ecdsa-only
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_4.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review13 (deployer trace, selector match against verified Aori, owner/pause reads; former finding unidentified-7dec965c-user-sig-ecdsa-only)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aori-order-sig-ecdsa-only/attribution-older-deployments.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
- by: ai-assisted
  study: top-callers-classification
  who: Review23 (finding review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aori-order-sig-ecdsa-only/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Aori's ERC-20 deposits accept a user's EIP-712 order signature only through `ecrecover` (PQ-1). A quantum attacker
who recovers a user's secp256k1 key can sign an order that pays the attacker on the destination chain; a whitelisted
solver that fills it pulls the user's tokens from their approval to Aori, including for users who have since moved
their account to post-quantum authorisation. Post-quantum smart accounts cannot place ERC-20 orders at all. Four
deployments carry the check: the current one (`0x0736bdc9…`, active) and three older ones (one paused, two unpaused
but unused since mid-2025). The exposure is what users still approve to them, which was not measured; none holds more
than about $1. Rated MEDIUM (step 4): the logic is immutable, so the fix is a new deployment users move to.

## Mechanism

- `Aori.deposit(Order, bytes signature)` and `deposit(Order, bytes, SrcHook)` (both `onlySolver`, `whenNotPaused`)
  call `AoriUtils.validateDeposit`, which does `ECDSA.recover(digest, signature)` (solady) and requires the result to
  equal `order.offerer` (`AoriUtils.sol` lines 58–60). There is no `isValidSignature` call and no account-code check.
- After the check, `IERC20(order.inputToken).safeTransferFrom(order.offerer, address(this), order.inputAmount)` takes
  the offerer's tokens; the hook variant sends them to a whitelisted hook and, for single-chain swaps, settles at once.
  The order's `recipient` and `outputAmount` are whatever the signer chose, so a forged order pays the attacker.
- `depositNative(Order)` needs no signature (`msg.sender == order.offerer`), so native-ETH orders work for any
  account, including post-quantum smart accounts. ERC-20 orders have no such path.
- The verified older deployment `0x8635c874…` has the same `validateDeposit` check. The two unverified ones
  (`0x7dec965c…`, `0xbb4c20cb…`) expose `deposit(Order, bytes signature)` and `cancel(bytes32, Order, bytes)` with no
  `isValidSignature` selector, and share 44 and 39 of the 46 selectors of verified Aori; INFERRED to behave the same.
- Pattern PQ-1. Excerpt: [`source-excerpts.md`](#source-excerpts-aori-order-sig-ecdsa-only).

## Evidence

- CHECKED (verified source, Sourcify, `0x0736bdc9…` and `0x8635c874…`: `contracts/Aori.sol`, `contracts/AoriUtils.sol`):
  the deposit paths above; owner-only `pause`, solver/hook/chain whitelists, `emergencyCancel`, `emergencyWithdraw`;
  no upgrade function ([`notes.md`](#review-notes-review23-2026-11-17)).
- CHECKED (on-chain read, block 26,431,426): `0x0736bdc9…` `owner()` = `0x941327e2…` (EOA, nonce 514), `paused()` =
  false, EIP-1967 slot empty.
- CHECKED (on-chain read, block 26,431,716): `owner()` of the three older deployments = `0xb4afac16…` (EOA);
  `paused()` = true on `0x8635c874…`, false on `0x7dec965c…` and `0xbb4c20cb…`; no ETH; priced tokens $0.02 or less.
- CHECKED (Review13, Blockscout and runtime code, block 26,431,618): `0xb4afac16…` created `0x7dec965c…` and
  `0xbb4c20cb…`; selector match against verified Aori
  ([`attribution-older-deployments.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aori-order-sig-ecdsa-only/attribution-older-deployments.json)).
  On 2026-08-19 it paused `0x8635c874…`, called `emergencyWithdraw` on it and on `0x7dec965c…`, and sent a transaction
  to `0x941327e2…`, the current owner.
- CHECKED (precompile trace): last `ecrecover` use 2025-07-19 (`0x7dec965c…`), 2025-05-06 (`0xbb4c20cb…`), 2026-03-17
  (`0x8635c874…`). Yearly `txs_y1`: `0x0736bdc9…` 25,538 (`usd_tx_y1` $86.8M); `0x7dec965c…` 29,535;
  `0xbb4c20cb…` 22,508; `0x8635c874…` 6,491.
- CHECKED (Xatu, any function): `0x0736bdc9…` had 1,820 transactions 2026-10-16 to 2026-11-16, last 2026-11-08; the
  older three had none ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aori-order-sig-ecdsa-only/activity.json)).
- INFERRED: whitelisted solvers would fill a forged order at an attractive price, so the solver whitelist does not
  stop the attack on the active deployment; on the dormant ones it depends on whether a whitelisted solver still runs
  (solver lists not enumerated).

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x0736bdc9…` Aori (current) | config-only (owner EOA `0x941327e2…`) | users' ERC-20 approvals, not measured; holds ~$1 | 2026-11-08 | 1,820 |
| `0x8635c874…` Aori (paused) | config-only (owner EOA `0xb4afac16…`) | none while paused; holds $0 | 2026-08-19 | 0 |
| `0x7dec965c…` Aori (old, unpaused) | config-only (owner EOA `0xb4afac16…`) | users' leftover approvals, not measured; holds $0 | 2026-08-19 (owner withdraw) | 0 |
| `0xbb4c20cb…` Aori (old, unpaused) | config-only (owner EOA `0xb4afac16…`) | users' leftover approvals, not measured; holds $0 | 2025-05-06 | 0 |

Deposits are pulled from users at fill time, so what can be taken is every allowance users have left to these
addresses; measuring it needs an Approval-event scan per token and was not done, so `value_usd` is null on the
contracts that can still take deposits. The contracts' own holdings (about $1 at most) are not the exposure.

Separately, both owners are single EOAs that can call `emergencyWithdraw` on whatever their contracts hold; that is an
owner-key exposure on about $1 today, not part of this finding.

## Remediation

- Aori deploys a new version whose `validateDeposit` checks the offerer's code first and calls ERC-1271
  `isValidSignature` with the full signature for contract accounts (current OpenZeppelin `SignatureChecker` or Solady
  `SignatureCheckerLib`, PQ-13), and migrates solvers to it.
- Owner EOA `0x941327e2…` can `pause()` `0x0736bdc9…`; owner EOA `0xb4afac16…` can `pause()` `0x7dec965c…` and
  `0xbb4c20cb…`, as it already did for `0x8635c874…`. Pausing stops forged deposits (and all use).
- Users: revoke ERC-20 approvals to all four addresses when not trading; post-quantum users can use native-ETH orders.
- Protocol change: helps. EIP-8151 would make `ecrecover` fail for migrated accounts with code, protecting them
  without a new deployment; it does not let post-quantum accounts sign ERC-20 orders.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by upgrading the contract (admin or governance)).
- 2026-11-17 review (Review23): MEDIUM kept, step 4: immutable logic, fix is a new deployment users move to (owner EOA can pause the old one); post-quantum users are also locked out of ERC-20 orders. Removed the $1 `held` value (not the exposure; users' approvals unmeasured); owner read as EOA `0x941327e2…`.
- 2026-11-17 review (Review13, in former finding `unidentified-7dec965c-user-sig-ecdsa-only`): identified `0x7dec965c…` and `0xbb4c20cb…` as earlier Aori deployments (deployer/owner `0xb4afac16…`, selector match); rated them LOW (step 1: no signed deposit since 2025-07-19, nothing held).
- 2026-11-17 merge (Review23): `unidentified-7dec965c-user-sig-ecdsa-only` merged into this finding and removed; added its two contracts and the paused verified deployment `0x8635c874…` (read at block 26,431,716). MEDIUM kept, step 4: the finding is rated by its active deployment `0x0736bdc9…`; the older three are dormant or paused.

# Source excerpts: aori-order-sig-ecdsa-only

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x0736bdc975af0675b9a045384efed91360d25479` — Aori (verified source via sourcify)

### `@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/ILayerZeroEndpointV2.sol`

```solidity
   61          MessagingParams calldata _params,
   62          address _refundAddress
   63      ) external payable returns (MessagingReceipt memory);
   64  
   65      function verify(Origin calldata _origin, address _receiver, bytes32 _payloadHash) external;
   66  
   67      function verifiable(Origin calldata _origin, address _receiver) external view returns (bool);
   68  
   69      function initializable(Origin calldata _origin, address _receiver) external view returns (bool);
  ...
```

### `contracts/Aori.sol`

```solidity
    8  import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
    9  import { Pausable } from "@openzeppelin/contracts/utils/Pausable.sol";
   10  import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
   11  import { EIP712 } from "solady/src/utils/EIP712.sol";
   12  import { ECDSA } from "solady/src/utils/ECDSA.sol";
   13  import { IAori } from "./IAori.sol";
   14  import "./AoriUtils.sol";
   15  
   16  /**                            @@@@@@@@@@@@                                              
  ...
```

### `contracts/AoriUtils.sol`

```solidity
    2  pragma solidity 0.8.28;
    3  
    4  import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
    5  import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
    6  import { ECDSA } from "solady/src/utils/ECDSA.sol";
    7  import { IAori } from "./IAori.sol";
    8  
    9  /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
   10  /*                          VALIDATION                        */
  ...
   55          require(isSupportedChain(order.dstEid), "Destination chain not supported");
   56  
   57  
   58          // Signature validation
   59          address recovered = ECDSA.recover(digest, signature);
   60          require(recovered == order.offerer, "InvalidSignature");
   61  
   62          // Order parameter validation
   63          validateCommonOrderParams(order);
  ...
```

Library files with the primitive itself (not excerpted): `solady/src/utils/ECDSA.sol`


# Merged from unidentified-7dec965c-user-sig-ecdsa-only (2026-11-17)

## Contract `0x7dec965cf240f81299683f48a18ebdbe8b2accb5`

No verified source on Sourcify or Blockscout.


## Contract `0xbb4c20cb237f3629d1afc3ecb3e84148fa426c12`

No verified source on Sourcify or Blockscout.

# Review notes (Review23, 2026-11-17)

Reads at block 26,431,426 (https://ethereum-rpc.publicnode.com):

- `Aori(0x0736bdc975af0675b9a045384efed91360d25479).owner()` = `0x941327e206b8d8cfe1014a8a95b05e1536dfd00d`
- `cast code 0x941327e2…` = `0x` (EOA, nonce 514)
- `paused()` = false
- EIP-1967 implementation slot = 0 (not a proxy)

Verified source (Sourcify, `contracts/Aori.sol`, `contracts/AoriUtils.sol`):

- `deposit(Order, bytes signature)` and `deposit(Order, bytes, SrcHook)`: `onlySolver`, `whenNotPaused`;
  `AoriUtils.validateDeposit` -> `ECDSA.recover(digest, signature) == order.offerer` (solady, no ERC-1271), then
  `safeTransferFrom(order.offerer, address(this), order.inputAmount)`.
- `depositNative(Order)`: `msg.sender == order.offerer`, no signature (native ETH only).
- Owner-only: `pause`, `add/removeAllowedSolver`, `add/removeAllowedHook`, `add/removeSupportedChain`,
  `emergencyCancel`, `emergencyWithdraw` (two overloads). No upgrade function, no proxy.

Yearly pre-quantum use (`data/report/curated_contracts.csv`): `txs_y1` = 25,538, `usd_tx_y1` = 86,753,915.

## Older and paused deployments (merged 2026-11-17)

Attribution and selector match by Review13: [`attribution-older-deployments.json`](attribution-older-deployments.json)
(block 26,431,618). Reads by Review23 at block 26,431,716:

| Contract | owner() | paused() | ETH | priced tokens | last ecrecover use |
|---|---|---|---|---|---|
| 0x7dec965cf240f81299683f48a18ebdbe8b2accb5 (unverified) | 0xb4afac16… (EOA) | false | 0 | $0 | block 22,953,387 (2025-07-19) |
| 0xbb4c20cb237f3629d1afc3ecb3e84148fa426c12 (unverified) | 0xb4afac16… | false | 0 | $0 | block 22,421,870 (2025-05-06) |
| 0x8635c874b0fcb361fb9a2f5218852d4b7fc5ace3 (verified Aori) | 0xb4afac16… | true | 0 | $0.02 | block 24,677,597 (2026-03-17) |

- `0x8635c874…` verified source (Sourcify, `contracts/AoriUtils.sol` lines 58–60): same
  `ECDSA.recover(digest, signature) == order.offerer` check as `0x0736bdc9…`. Its last transactions (Blockscout) are
  the owner's `emergencyWithdraw` (x2) and `pause` on 2026-08-19; none since.
- Yearly pre-quantum use (`curated_contracts.csv`, `txs_y1`): `0x7dec965c…` 29,535; `0xbb4c20cb…` 22,508;
  `0x8635c874…` 6,491 (from attribution.json; not in curated_contracts.csv).
