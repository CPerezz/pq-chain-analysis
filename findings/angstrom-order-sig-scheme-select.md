---
id: angstrom-order-sig-scheme-select
title: "Angstrom (Sorella): any order may choose ECDSA, so a quantum attacker who derives a user's secp256k1 key can spend that user's Angstrom balance and token approvals even after the account migrates"
project: sorella
status: confirmed
severity: MEDIUM
patterns: [PQ-2]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x0000000aa232009084bd71a5797d089aa4edfad4"
  implementation: null
  name: Angstrom
  upgradeable: config-only
  admin: "_controller = ControllerV1 0x1746484ea5e11c75e009252c102c8c33e0315fd4 (owner TimelockController 0x60d41d9708bbefd29000d1486c6406ef23526c01, 5-day delay; fastOwner Safe 0xd31c82069da3013fdb16b731ad19076af9b93105, 2 of 3); order verification logic immutable, no proxy"
  value_usd: 608847
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 172107
families: []
fix:
  layer: new-deployment
  who_acts: "Sorella Labs: a new Angstrom deployment that checks account code before ECDSA (or drops the ECDSA variant for accounts with code); until then its 3 node operators (0x5875db54…, 0x2252f216…, 0xc917c3fa…) can refuse ECDSA-variant orders from accounts with code, and the controller (TimelockController 0x60d41d97…, fastOwner Safe 0xd31c8206…) manages nodes"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/angstrom-order-sig-scheme-select
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review06 (Claude), 2026-11-17 review
  ref: Sourcify source of 0x0000000a…; ControllerV1 source (Blockscout); cast reads at block 26,431,702
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
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

Angstrom, a Uniswap v4 hook with batch order settlement, lets each signed order pick its signature scheme with a flag:
raw `ecrecover` or ERC-1271. A quantum attacker who derives a user's secp256k1 key can sign orders for that address
that sell its Angstrom internal balance or pull any tokens it has approved to Angstrom, with the output sent to the
attacker; this keeps working after the user migrates the address to post-quantum authorisation (EIP-7702 or other
account code), because the ECDSA variant never asks whether the address has code. The contract held USD 609k on
2026-11-17 (users' internal balances plus accrued fees); approvals are not measured. Rated MEDIUM: step 4: the
verification is immutable, but Sorella controls the only submitters (3 node EOAs) and can ship a new deployment.

## Mechanism

- `execute(encoded)` is callable only by a node (`_nodeBundleLock`, `TopLevelAuth.sol` lines 223-227); it unlocks
  the v4 PoolManager and `unlockCallback` runs `_validateAndExecuteToBOrders` and `_validateAndExecuteUserOrders`.
- For each order, `variantMap.isEcdsa()` (bit `0x08` in `ToBOrderVariantMap`, `0x80` in `UserOrderVariantMap`) selects
  `SignatureLib.readAndCheckEcdsa` (raw call to precompile 0x01 on 65 bytes; the recovered address becomes `from`)
  or `SignatureLib.readAndCheckERC1271` (Solady `isValidERC1271SignatureNowCalldata`) (`Angstrom.sol` lines
  148-150 and 229-231). The flag is chosen by whoever builds the order, so the signer chooses the scheme.
- The order then pays `amountOut` to `buffer.recipient` (`_settleOrderOut`) and takes `amountIn` from `from`, either
  from its internal balance `_balances[asset][from]` or with `safeTransferFrom(from, …)` (`Settlement.sol` lines
  105-116), i.e. from the user's approvals to Angstrom.
- Pattern PQ-2: ERC-1271 exists, so post-quantum accounts can trade, but a migrated address stays forgeable with its
  old ECDSA key. `PermitSubmitterHook` additionally submits EIP-2612/DAI permits for the order signer; those are the
  token contracts' own checks (their findings), not Angstrom's.
- `unlockWithEmptyAttestation` (node attestation, `TopLevelAuth.sol` 194-211) uses Solady `SignatureCheckerLib` with
  node keys; it only unlocks pools for swaps in a block and moves no funds (auxiliary, not rated here).

## Evidence

- CHECKED (verified source on Sourcify, `Angstrom` at 0x0000000a…, no proxy): the path above.
- CHECKED (cast, block 26,431,702): `extsload(0)` (`_controller`) = ControllerV1 0x1746484e…; its `owner()` =
  TimelockController 0x60d41d97… (`getMinDelay()` 432,000 s); `fastOwner()` = Safe 0xd31c8206…, 2 of 3; `nodes()` =
  3 addresses without code (EOAs). In ControllerV1, `addNode` needs the owner and `removeNode` the owner or fastOwner
  ([`control.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/angstrom-order-sig-scheme-select/control.json)).
- CHECKED (on-chain read at block 26,431,214): Angstrom holds USD 608,847 (USDC USD 269k, WETH USD 195k, USDT USD
  144k) ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/angstrom-order-sig-scheme-select/onchain.json)).
- CHECKED (Xatu, any function): 172,107 transactions in 2026-10-16 to 2026-11-16, last on 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/angstrom-order-sig-scheme-select/activity.json)); `curated_contracts.csv`: 617,253
  ecrecover calls in the last year.
- INFERRED: the held balance mixes users' internal balances (spendable with each owner's key) and fees accrued for the
  controller; the split was not measured. Users' token approvals to Angstrom are not measurable here.
- CHECKED (executed, study `eip-8151-impact`, 2026-11-19): a real transaction,
  `0x918980ae06d91bc280bb1fa3ea79c9f6e34d13607f512d82b72761bf6fb24da2` (block 26,438,998, position 0), replayed on
  the reference implementation of the fork with only the precompile changed. Under today's rule it matches its
  receipt (158,492 gas); under EIP-8151 it also succeeds (161,592 gas). With one byte of code at the recovered signer
  `0xf198e8453dd6e03ec86c0c58e9f21d56186cc8fb`, it reverts after that recovery returned no address; with a 7702
  delegation there it succeeds. Study family `e5390aaf` (Angstrom).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x0000000a…` Angstrom | config-only (controller; logic immutable) | $609k (2026-11-17) | 2026-11-16 | 172,107 |

- The `held` value is kept as an upper bound of internal balances reachable with forged user keys; each user's
  exposure is their own internal balance plus their approvals to Angstrom.
- An attacker needs a node to include the forged order. Nodes take signed orders from users (INFERRED from the
  design; node software not reviewed), and the node accounts are themselves secp256k1 EOAs, so they do not stop a
  quantum attacker unless their software filters orders.

## Remediation

- New deployment: check `from.code.length` (or an explicit claimed signer with ERC-1271 for any address with code)
  before accepting the ECDSA variant, as in PQ-13. The order logic cannot be changed in place.
- Until then, Sorella's node operators can refuse ECDSA-variant orders for addresses with code; the controller's
  owner (TimelockController 0x60d41d97…) and fastOwner Safe 0xd31c8206… manage the node set, and the nodes would need
  post-quantum-controlled accounts for the filter to hold against a quantum attacker.
- Protocol change helps: EIP-8151 would make the raw `ecrecover` fail for addresses with real code, protecting
  migrated accounts without Sorella.
- Users: use the ERC-1271 variant from a post-quantum account; keep no internal balance and revoke approvals to
  Angstrom from addresses whose ECDSA key is exposed, or move funds to a fresh post-quantum account.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by upgrading the contract (admin or governance)).
- 2026-11-17 review (Review06): MEDIUM confirmed, step 4: no upgrade is possible (no proxy), but Sorella controls the only submitters (3 node EOAs via ControllerV1) and can redeploy; fix layer corrected to new deployment plus node policy. Controller, timelock and nodes read on-chain.
- 2026-11-19 (study `eip-8151-impact`, reading 3): EIP-8151 as written closes this path for an account that takes
  real code (executed on a real transaction); plain and 7702-delegated accounts stay exposed, and approvals already
  given stay valid.

# Source excerpts: angstrom-order-sig-scheme-select

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x0000000aa232009084bd71a5797d089aa4edfad4` — Angstrom (verified source via sourcify)

### `src/interfaces/IDaiPermit.sol`

```solidity
    2  pragma solidity ^0.8.0;
    3  
    4  /// @author philogy <https://github.com/philogy>
    5  interface IDaiPermit {
    6      function permit(
    7          address holder,
    8          address spender,
    9          uint256 nonce,
   10          uint256 expiry,
  ...
```

### `src/interfaces/IERC2612.sol`

```solidity
    2  pragma solidity ^0.8.0;
    3  
    4  /// @author philogy <https://github.com/philogy>
    5  interface IERC2612 {
    6      function permit(
    7          address owner,
    8          address spender,
    9          uint256 value,
   10          uint256 deadline,
  ...
```

### `src/libraries/SignatureLib.sol`

```solidity
    1  // SPDX-License-Identifier: MIT
    2  pragma solidity ^0.8.0;
    3  
    4  import {CalldataReader} from "../types/CalldataReader.sol";
    5  import {SignatureCheckerLib} from "solady/src/utils/SignatureCheckerLib.sol";
    6  
    7  /// @author philogy <https://github.com/philogy>
    8  library SignatureLib {
    9      error InvalidSignature();
  ...
   42      {
   43          (reader, from) = reader.readAddr();
   44          bytes calldata signature;
   45          (reader, signature) = reader.readBytes();
   46          if (!SignatureCheckerLib.isValidERC1271SignatureNowCalldata(from, hash, signature)) {
   47              revert InvalidSignature();
   48          }
   49          return (reader, from);
   50      }
  ...
```

### `src/modules/PermitSubmitterHook.sol`

```solidity
   31              uint256 r;
   32              (reader, r) = reader.readU256();
   33              uint256 s;
   34              (reader, s) = reader.readU256();
   35              IERC2612(token).permit(
   36                  from, msg.sender, type(uint256).max, deadline, v, bytes32(r), bytes32(s)
   37              );
   38          } else if (permitType == ERC2612_SPECIFIC) {
   39              address token;
  ...
   47              uint256 r;
   48              (reader, r) = reader.readU256();
   49              uint256 s;
   50              (reader, s) = reader.readU256();
   51              IERC2612(token).permit(from, msg.sender, value, deadline, v, bytes32(r), bytes32(s));
   52          } else if (permitType == DAI_INFINITE) {
   53              address token;
   54              (reader, token) = reader.readAddr();
   55              uint32 nonce;
  ...
   61              uint256 r;
   62              (reader, r) = reader.readU256();
   63              uint256 s;
   64              (reader, s) = reader.readU256();
   65              IDaiPermit(token).permit(
   66                  from, msg.sender, nonce, deadline, true, v, bytes32(r), bytes32(s)
   67              );
   68          } else {
   69              revert InvalidPermitType(permitType);
  ...
```

### `src/modules/TopLevelAuth.sol`

```solidity
   13  import {PoolKey} from "v4-core/src/types/PoolKey.sol";
   14  import {SafeCastLib} from "solady/src/utils/SafeCastLib.sol";
   15  import {LPFeeLibrary} from "v4-core/src/libraries/LPFeeLibrary.sol";
   16  import {SafeTransferLib} from "solady/src/utils/SafeTransferLib.sol";
   17  import {SignatureCheckerLib} from "solady/src/utils/SignatureCheckerLib.sol";
   18  import {UnlockSwapFeeCollector} from "./UnlockSwapFeeCollector.sol";
   19  
   20  /// @dev Maximum fee that the `bundleFee` for any given pool should be settable to.
   21  uint256 constant MAX_UNLOCK_FEE_E6 = 0.4e6;
  ...
  202              attestationStructHash := keccak256(0x00, 0x40)
  203          }
  204  
  205          bytes32 digest = _hashTypedData(attestationStructHash);
  206          if (!SignatureCheckerLib.isValidSignatureNowCalldata(node, digest, signature)) {
  207              revert InvalidSignature();
  208          }
  209  
  210          _lastBlockUpdated = SafeCastLib.toUint64(block.number);
  ...
```

Library files with the primitive itself (not excerpted): `lib/solady/src/utils/SignatureCheckerLib.sol`
