---
id: pendle-limit-order-sig
title: "Pendle Limit Router: a quantum attacker can forge a maker's old ECDSA key to fill limit orders against that maker's approved tokens, even after the maker moves to a post-quantum smart account at the same address"
project: pendle
status: confirmed
severity: MEDIUM
patterns: [PQ-2]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x000000000000c9b3e2c3ec88b1b4c0cd853f4321"
  implementation: "0xc96ca8f090b7ef89c8ec43a50ac802a22935e99b"
  name: TransparentUpgradeableProxy → PendleLimitRouter
  upgradeable: "yes"
  admin: "ProxyAdmin 0xa28c08f165116587d4f3e708743b4dee155c5e64, owned by Safe 0x8119ec16f0573b7dac7c0cb94eb504fb32456ee1 (3 of 5); router owner() 0x2ad631f72fb16d91c4953a7f4260a97c2fe2f31e (PendleGovernanceProxy, admin role held by the same Safe); read at block 26431426"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 13318
families: []
fix:
  layer: contract-upgrade
  who_acts: "Pendle: Safe 0x8119ec16f0573b7dac7c0cb94eb504fb32456ee1 (3 of 5) upgrades the router through ProxyAdmin 0xa28c08f165116587d4f3e708743b4dee155c5e64"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/pendle-limit-order-sig
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review23 (finding review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/pendle-limit-order-sig/notes.md
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

Pendle's limit-order router checks a maker's order signature with OpenZeppelin 4.9 `SignatureChecker`, which tries
`ecrecover` before ERC-1271 (PQ-2). Post-quantum smart accounts can already sign through ERC-1271 or pre-sign on
chain, but an address that migrates in place stays forgeable with its old secp256k1 key: a quantum attacker can sign
orders at any price for that maker and fill them, pulling whatever the maker has approved to the router. The exposure
is makers' approvals to the router, which was not measured (the router holds about $0). Rated MEDIUM (step 4): the
router is an upgradeable proxy controlled by Pendle's 3-of-5 Safe, so one upgrade removes the ECDSA-first path.

## Mechanism

- `fill(params, …)` → `_checkSig_updMakingAndStatus` → `_checkSig(order, signature)`: for an order that was not
  pre-signed, `SignatureChecker.isValidSignatureNow(order.maker, orderHash, signature)` (`LimitRouterBase.sol` line
  297). The library (v4.9.0) returns true if `ECDSA.tryRecover(hash, signature) == signer`, and only otherwise calls
  `isValidSignature` on the maker.
- The fill then pulls the maker's tokens with `_transferIn(order.token, order.maker, makingAmount)` (SY or tokens
  converted to SY for `SY_FOR_PT`/`SY_FOR_YT` orders; PT/YT for the reverse), and pays the maker in the asset and at
  the rate the order states, so a forged order at a bad rate transfers the maker's value to the taker.
- Alternatives: `preSignSingle`/`preSignBatch` (`order.maker == msg.sender`) bypass the signature check, and ERC-1271
  works for makers with code, so post-quantum accounts are not locked out.
- A second, separate check: `MintSyHelper._verifyMintSyData` requires two operator signatures (`mintSySigner1/2`) for
  the optional mint-SY swap data. Both signers are `address(0)` on mainnet, so that option is disabled; when set, its
  effect is bounded per order by the maker's `failSafeRate`.
- Pattern PQ-2. Excerpt: [`source-excerpts.md`](#source-excerpts-pendle-limit-order-sig).

## Evidence

- CHECKED (verified source, Sourcify, implementation `0xc96ca8f0…`): `LimitRouterBase._checkSig`, OpenZeppelin
  `SignatureChecker` v4.9.0 body, `PendleLimitRouter.preSignSingle`, `MintSyHelper._verifyMintSyData`
  ([`notes.md`](#review-notes-review23-2026-11-17)).
- CHECKED (on-chain read, block 26,431,426): EIP-1967 implementation `0xc96ca8f0…`, admin `0xa28c08f1…`;
  `ProxyAdmin.owner()` = Safe `0x8119ec16…`; router `owner()` = `0x2ad631f7…` (PendleGovernanceProxy) whose
  `DEFAULT_ADMIN_ROLE` is held by the same Safe; `mintSySigner1/2` = zero.
- CHECKED (on-chain read, block 26,431,214): Safe threshold 3 of 5 owners; router holds about $0.06
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/pendle-limit-order-sig/onchain.json)).
- CHECKED (Xatu, any function): 13,318 transactions 2026-10-16 to 2026-11-16, last 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/pendle-limit-order-sig/activity.json)). Pre-quantum use over a year
  (`curated_contracts.csv`): `txs_y1` 29,490 ecrecover transactions, `usd_tx_y1` $7.14B.
- CHECKED (executed, study `eip-8151-impact`, 2026-11-19): a real transaction,
  `0x3aa805c2351cf3c13a9df3918b9122c9dcbde7eb0d1155973ee436042fde3c9c` (block 26,393,520, position 1), replayed on
  the reference implementation of the fork with only the precompile changed. Under today's rule it matches its
  receipt (2,065,569 gas); under EIP-8151 it also succeeds (2,068,669 gas). With one byte of code at the recovered
  signer `0x743d7b30661d65b41960bf6b5d1bb93cf7972a73`, it reverts after that recovery returned no address; with a
  7702 delegation there it succeeds. Study family `832eb249` (PendleLimitRouter).

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x00000000…4321` TransparentUpgradeableProxy → PendleLimitRouter | yes (Safe 3/5) | makers' approvals to the router, not measured; holds ~$0 | 2026-11-16 | 13,318 |

The router keeps no balances; what a forged signature can take is each affected maker's allowance (SY, PT, YT or the
input token) to `0x000000000000c9b3e2c3ec88b1b4c0cd853f4321`, capped by their balance. Measuring it needs an
Approval-event scan across Pendle tokens and was not done. Only makers whose address has migrated to post-quantum
code (or who still use their ECDSA key) are affected; EOA makers are as safe as their own key. No other Pendle
limit-router deployment is in the registry.

## Remediation

- Pendle upgrades the implementation to a signature check that looks at account code first (current OpenZeppelin
  `SignatureChecker` or Solady `SignatureCheckerLib`, PQ-13) and passes the full signature to ERC-1271 / ERC-7913.
  Acting party: Safe `0x8119ec16…` (3 of 5) through ProxyAdmin `0xa28c08f1…`. If the mint-SY signers are ever set, they should be
  post-quantum (ERC-1271/ERC-7913) signers.
- Users: post-quantum accounts can pre-sign orders on chain; any maker can revoke approvals to the router.
- Protocol change: helps. EIP-8151 would make `ecrecover` fail for migrated accounts with code.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by upgrading the contract (admin or governance)).
- 2026-11-17 review (Review23): MEDIUM kept, step 4: upgradeable proxy, one Safe (3/5) upgrade fixes it; something can still be taken (migrated makers' approvals), so the existing alternative does not lower it. Owner resolved to PendleGovernanceProxy under the same Safe; mint-SY operator signers read as zero (disabled).
- 2026-11-19 (study `eip-8151-impact`, reading 3): EIP-8151 as written closes this path for an account that takes
  real code (executed on a real transaction); plain and 7702-delegated accounts stay exposed, and approvals already
  given stay valid.

# Source excerpts: pendle-limit-order-sig

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x000000000000c9b3e2c3ec88b1b4c0cd853f4321` — TransparentUpgradeableProxy (verified source via sourcify)

## Implementation `0xc96ca8f090b7ef89c8ec43a50ac802a22935e99b` — PendleLimitRouter (verified source via sourcify)

### `lib/pendle-core-v2/contracts/limit/LimitRouterBase.sol`

```solidity
    9  import "../interfaces/IStandardizedYield.sol";
   10  import {LimitMathCore as LimitMath} from "./LimitMathCore.sol";
   11  import "./helpers/MintSyHelper.sol";
   12  import "./helpers/NonceManager.sol";
   13  import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
   14  
   15  abstract contract LimitRouterBase is
   16      IPLimitRouter,
   17      MintSyHelper,
  ...
  293          OrderStatus memory status = _status[orderHash];
  294          (uint256 remainingMakerAmount, uint256 filledMakerAmount) = (status.remaining, status.filledAmount);
  295  
  296          if (remainingMakerAmount == _ORDER_DOES_NOT_EXIST) {
  297              require(SignatureChecker.isValidSignatureNow(order.maker, orderHash, signature), "LOP: bad signature");
  298  
  299              remainingMakerAmount = order.makingAmount;
  300          } else {
  301              unchecked {
  ...
```

### `lib/pendle-core-v2/contracts/limit/helpers/MintSyHelper.sol`

```solidity
    2  pragma solidity ^0.8.17;
    3  
    4  import "../../interfaces/IPLimitRouter.sol";
    5  import "../../interfaces/IPAllActionTypeV3.sol";
    6  import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
    7  import "@openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";
    8  
    9  abstract contract MintSyHelper is EIP712Upgradeable {
   10      // forgefmt: disable-next-item
  ...
   67  
   68          bytes32 digest =
   69              hashMintSyPayload(mintSyData.inps, mintSyData.minSyOuts, mintSyData.expiry, mintSyData.fillParamsHash);
   70  
   71          require(SignatureChecker.isValidSignatureNow(signer1, digest, mintSyData.sig1), "LOP: bad mintSy sig1");
   72          require(SignatureChecker.isValidSignatureNow(signer2, digest, mintSyData.sig2), "LOP: bad mintSy sig2");
   73      }
   74  
   75      function _hashSwapData(SwapData memory d) internal pure returns (bytes32) {
   76          return keccak256(abi.encode(SWAP_DATA_TYPEHASH, d.swapType, d.extRouter, keccak256(d.extCalldata), d.needScale));
  ...
```

### `node_modules/@openzeppelin/contracts/interfaces/IERC1271.sol`

```solidity
   14       * @dev Should return whether the signature provided is valid for the provided data
   15       * @param hash      Hash of the data to be signed
   16       * @param signature Signature byte array associated with _data
   17       */
   18      function isValidSignature(bytes32 hash, bytes memory signature) external view returns (bytes4 magicValue);
   19  }
  ...
```

### `node_modules/@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol`

```solidity
   32       * For more information on the signature format, see the
   33       * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
   34       * section].
   35       */
   36      function permit(
   37          address owner,
   38          address spender,
   39          uint256 value,
   40          uint256 deadline,
  ...
```

### `node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol`

```solidity
  102          bytes32 r,
  103          bytes32 s
  104      ) internal {
  105          uint256 nonceBefore = token.nonces(owner);
  106          token.permit(owner, spender, value, deadline, v, r, s);
  107          uint256 nonceAfter = token.nonces(owner);
  108          require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
  109      }
  110  
  ...
```

Library files with the primitive itself (not excerpted): `node_modules/@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol`, `node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol`, `node_modules/@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol`

# Review notes (Review23, 2026-11-17)

Reads at block 26,431,426 (https://ethereum-rpc.publicnode.com):

- Proxy `0x000000000000c9b3e2c3ec88b1b4c0cd853f4321`: EIP-1967 implementation slot =
  `0xc96ca8f090b7ef89c8ec43a50ac802a22935e99b` (PendleLimitRouter); admin slot = `0xa28c08f165116587d4f3e708743b4dee155c5e64`.
- ProxyAdmin `0xa28c08f1…`.owner() = Safe `0x8119ec16f0573b7dac7c0cb94eb504fb32456ee1` (threshold 3; 5 owners per onchain.json).
- Router `owner()` = `0x2ad631f72fb16d91c4953a7f4260a97c2fe2f31e`: ERC1967Proxy -> PendleGovernanceProxy
  (`0x53c26f76…`, Blockscout name); `hasRole(DEFAULT_ADMIN_ROLE, 0x8119ec16…)` = true.
- `mintSySigner1()` = `mintSySigner2()` = `0x0000000000000000000000000000000000000000` (mintSy option disabled: no
  signature can verify for address 0).
- `feeRecipient()` = `0x8270400d528c34e1596ef367eedec99080a1b592`.

Verified source (Sourcify, implementation `0xc96ca8f0…`):

- `LimitRouterBase._checkSig`: `SignatureChecker.isValidSignatureNow(order.maker, orderHash, signature)` for orders
  not pre-signed; OpenZeppelin SignatureChecker v4.9.0 = `ECDSA.tryRecover` first, then ERC-1271.
- `_transferFromMakers_mintSy_updMakings` -> `_transferIn(order.token, order.maker, makingAmount)` pulls maker tokens.
- `PendleLimitRouter.preSignSingle/preSignBatch`: `order.maker == msg.sender`, sets remaining so `fill` skips the
  signature check. `cancelSingle/cancelBatch` by maker; owner `forceCancel`.
- `MintSyHelper._verifyMintSyData`: two operator signatures (`mintSySigner1/2`) over swap data; result bounded per
  order by `failSafeRate`.

Yearly pre-quantum use (`data/report/curated_contracts.csv`): `txs_y1` = 29,490; `usd_tx_y1` = 7,142,508,889.
