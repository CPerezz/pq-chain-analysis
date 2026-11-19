---
id: velora-augustus-rfq-maker-sig
title: "Velora AugustusRFQ: an EOA maker that later converts to a post-quantum account stays forgeable here, so its old ECDSA key can still sign orders that spend the maker's approvals"
project: paraswap
status: confirmed
severity: HIGH
patterns: [PQ-2]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0xe92b586627cca7a83dc919cc7127196d70f55a06"
  implementation: null
  name: AugustusRFQ
  upgradeable: "no"
  admin: none (no proxy, no owner; immutable, read at block 26,431,214)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 2050
families: []
fix:
  layer: account-migration
  who_acts: nobody can change AugustusRFQ (no admin); makers revoke their token approvals to 0xe92b586627cca7a83dc919cc7127196d70f55a06 before converting their address, or move funds to a fresh post-quantum account; Velora can stop quoting through it and route makers to a code-first settlement contract
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/velora-augustus-rfq-maker-sig
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read or judged, the registry text read; not executed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, reading 3 (does EIP-8151 close this path), 2026-11-19"
  date: 2026-11-19
  verdict: confirmed
  rating: ''
related: [velora-delta-order-code-first]
---

## Summary

AugustusRFQ (`0xe92b5866…`) settles market-maker and limit orders by checking the maker's signature with OpenZeppelin
4.4 `SignatureChecker`, which tries `ecrecover` first and only then ERC-1271 (PQ-2). A maker address that later
converts to a post-quantum smart account keeps its old ECDSA key valid here: a CRQC holder can sign orders that pull
whatever that address still has approved to AugustusRFQ. The contract is immutable and holds nothing; the exposure is
makers' standing approvals, which were not measured in full. In the 600 most recent fills, 597 came from one contract
maker (checked through its own ERC-1271, not the `ecrecover` path) and the two EOA makers had essentially nothing
approved. Rated HIGH, step 4: users' own funds stay forgeable after migration in a contract that cannot change.

## Mechanism

- Every fill function (`fillOrder`, `partialFillOrder*`, `fillOrderWithTarget*`, `batchFillOrderWithTarget`,
  `tryBatchFillOrder*`, and the NFT variants) calls `_fillOrder`/`_fillOrderNFT`, which hash the `Order` (EIP-712) and
  call `_checkOrder`. On the first fill of an order hash, `_checkOrder` requires
  `SignatureChecker.isValidSignatureNow(maker, orderHash, signature)` (`AugustusRFQ.sol` line 640).
- OpenZeppelin v4.4.0 `SignatureChecker.isValidSignatureNow` returns true if `ECDSA.tryRecover(hash, signature)` equals
  `maker`; otherwise it calls `maker.isValidSignature(hash, signature)` (ERC-1271) with the full signature.
- After the check, `transferTokens(order.makerAsset, maker, target, …)` pulls the maker's tokens through its approval
  to AugustusRFQ, and the taker pays `order.takerAsset`. The order fixes the price and an optional `taker`; a forged
  maker order with `taker = 0` and a token price of near zero empties the maker's approved balance.
- Pattern PQ-2: post-quantum accounts can make orders through ERC-1271, but an address that has a known ECDSA key and
  later gains real code is still accepted on the ECDSA branch. A pure contract maker (no private key for its address)
  is reached only through ERC-1271.
- Excerpts: [`source-excerpts.md`](#source-excerpts-velora-augustus-rfq-maker-sig).

## Evidence

- CHECKED (verified source, Sourcify exact match, fetched 2026-11-17): `contracts/AugustusRFQ.sol` `_checkOrder` and
  `_fillOrder`; `@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol` is v4.4.0 with `tryRecover` before the
  ERC-1271 call.
- CHECKED (on-chain read at block 26,431,214): no EIP-1967 implementation or admin, no `owner()`; ETH 0 and token dust
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/velora-augustus-rfq-maker-sig/onchain.json)).
- CHECKED (Blockscout logs, `OrderFilled` events, blocks 26,339,038–26,425,893): 600 fills by three makers.
  `0xbee3211ab312a8d065c4fef0247448e17a8da000` (597 fills) is a TransparentUpgradeableProxy contract; its USDC, USDT and
  WETH approvals to AugustusRFQ are unlimited, backed by about 2.15M USDC, 4.09M USDT and 1,521.6 WETH at block
  26,431,531. The two EOA makers had 0 and 0.0000019 WETH approved
  ([`makers.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/velora-augustus-rfq-maker-sig/makers.json)).
- CHECKED (Xatu, any function): 2,050 transactions called the contract 2026-10-16 to 2026-11-16, 6 of them directly;
  last on 2026-11-16 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/velora-augustus-rfq-maker-sig/activity.json)).
- CHECKED (precompile trace, year to March 2026, `studies/top-callers-classification/results/curated_contracts.csv`): 67,258 transactions with an
  `ecrecover` call by this contract (`txs_y1`), about USD 1.02B moved in them (`usd_tx_y1`).
- INFERRED: the contract maker's ~USD 9M inventory is reached only through its own ERC-1271 implementation, so a CRQC
  attack on it is an attack on that maker's own signer, not on this check.
- CHECKED (study `eip-8151-impact`, reading 3, 2026-11-19, not executed): the order check tries `ecrecover` first and
  then ERC-1271 (study family `5f3ec24c`, read); the replayed order was signed by a contract maker through ERC-1271,
  so it does not show an EOA maker. By the EIP's text, a signer whose address has real code recovers to no address,
  so its old ECDSA key no longer works here.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xe92b5866…` AugustusRFQ | no | — (dust; not the exposure) | 2026-11-16 | 2,050 |

The value at risk is what maker EOAs that later convert to real account code still have approved to AugustusRFQ. That
needs a scan of every `Approval` to the contract and was not done; `value_usd` stays null. The active EOA makers in the
recent sample have almost nothing approved, so today's exposure through the `ecrecover` branch is small, but older
limit-order makers may hold unlimited approvals. Takers are not exposed: the taker side is always `msg.sender`.
Velora's Delta/Portikus settlement is covered in `velora-delta-order-code-first`.

## Remediation

- AugustusRFQ cannot be changed. Velora can stop routing orders to it and settle makers through a contract that checks
  account code first (as its Portikus `SignatureLib` does) or accepts ERC-1271/ERC-7913 only.
- Makers: revoke approvals to `0xe92b586627cca7a83dc919cc7127196d70f55a06` before converting an address to post-quantum
  code, or keep maker inventory in a contract maker (checked through ERC-1271) with a post-quantum signer.
- Protocol: EIP-8151 would make the `ecrecover` branch fail for converted addresses with real code and would protect
  makers who forget to revoke (`protocol_change: helps`).

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review19): HIGH kept, step 4. Source and OZ 4.4.0 `SignatureChecker` re-read; title corrected (AugustusRFQ has no cosigner); recent maker set and approvals checked (main maker is a contract, EOA makers' approvals near zero); full approval exposure not measured, so step 5 does not apply. Linked `velora-delta-order-code-first`.
- 2026-11-19 (study `eip-8151-impact`, reading 3): EIP-8151 as written closes this path for an account that takes
  real code (read, not executed); plain and 7702-delegated accounts stay exposed, and approvals already given stay
  valid.

# Source excerpts: velora-augustus-rfq-maker-sig

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xe92b586627cca7a83dc919cc7127196d70f55a06` — AugustusRFQ (verified source via sourcify)

### `contracts/AugustusRFQ.sol`

```solidity
    3  import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
    4  import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
    5  import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
    6  import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
    7  import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
    8  
    9  import "./IERC20Permit.sol";
   10  
   11  
  ...
  223          require(takerTokenFillAmount > 0 && takerTokenFillAmount <= order.takerAmount, "Invalid Taker amount");
  224          makerTokenFilledAmount = (takerTokenFillAmount * order.makerAmount) / order.takerAmount;     
  225          require(makerTokenFilledAmount > 0, "Maker token fill amount cannot be 0");
  226          
  227          _permit(order.takerAsset, permitTakerAsset);
  228          _permit(order.makerAsset, permitMakerAsset);
  229          _fillOrder(
  230              order,
  231              signature,
  232              makerTokenFilledAmount,
  ...
  291          require(takerTokenFillAmount > 0 && takerTokenFillAmount <= order.takerAmount, "Invalid Taker amount");
  292          makerTokenFilledAmount = (takerTokenFillAmount * order.makerAmount) / order.takerAmount;     
  293          require(makerTokenFilledAmount > 0, "Maker token fill amount cannot be 0");
  294          
  295          _permit(address(uint160(order.takerAsset)), permitTakerAsset);
  296          _permit(address(uint160(order.makerAsset)), permitMakerAsset);
  297          _fillOrderNFT(
  298              order,
  299              signature,
  300              makerTokenFilledAmount,
  ...
  414              
  415              uint256 makerTokenFillAmountOrder = (takerTokenFillAmountOrder * orderInfo.order.makerAmount) / orderInfo.order.takerAmount;     
  416              require(makerTokenFillAmountOrder > 0, "Maker token fill amount cannot be 0");
  417  
  418              _permit(orderInfo.order.takerAsset, orderInfo.permitTakerAsset);
  419              _permit(orderInfo.order.makerAsset, orderInfo.permitMakerAsset);
  420  
  421              _fillOrder(
  422                  orderInfo.order,
  423                  orderInfo.signature,
  ...
  529              
  530              uint256 makerTokenFillAmountOrder = (takerTokenFillAmountOrder * orderInfo.order.makerAmount) / orderInfo.order.takerAmount;     
  531              require(makerTokenFillAmountOrder > 0, "Maker token fill amount cannot be 0");
  532  
  533              _permit(address(uint160(orderInfo.order.takerAsset)), orderInfo.permitTakerAsset);
  534              _permit(address(uint160(orderInfo.order.makerAsset)), orderInfo.permitMakerAsset);
  535  
  536              _fillOrderNFT(
  537                  orderInfo.order,
  538                  orderInfo.signature,
  ...
  636          uint256 remainingAmount = remainingMaker[orderHash];
  637          // You only need to check the signature of the order for the first time
  638          // For later you already know the orderHash coresponds to the signed order
  639          if(remainingAmount == UNFILLED_ORDER) {
  640              require(SignatureChecker.isValidSignatureNow(maker, orderHash, signature), "Invalid Signature");
  641              remainingMaker[orderHash] = (orderAmount - fillRequest) + 1;
  642          } else {
  643              require(remainingAmount > fillRequest, "Order already filled or expired");
  644              remainingMaker[orderHash] = remainingAmount - fillRequest;
  ...
  710              revert("Invalid token type");
  711          }
  712      }
  713  
  714      function _permit(address token, bytes memory permit) internal {
  715          if (permit.length == 32 * 7) {
  716              (bool success, ) = token.call(abi.encodePacked(IERC20Permit.permit.selector, permit));
  717              require(success, "Permit failed");
  718          }
  ...
```

### `contracts/IERC20Permit.sol`

```solidity
    1  pragma solidity 0.8.10;
    2  
    3  interface IERC20Permit {
    4      function permit(
    5          address owner,
    6          address spender,
    7          uint256 amount,
    8          uint256 deadline,
  ...
   12      ) external;
   13  }
   14  
   15  interface IERC20PermitLegacy {
   16      function permit(
   17          address holder,
   18          address spender,
   19          uint256 nonce,
   20          uint256 expiry,
  ...
```

### `@openzeppelin/contracts/interfaces/IERC1271.sol`

```solidity
   14       * @dev Should return whether the signature provided is valid for the provided data
   15       * @param hash      Hash of the data to be signed
   16       * @param signature Signature byte array associated with _data
   17       */
   18      function isValidSignature(bytes32 hash, bytes memory signature) external view returns (bytes4 magicValue);
   19  }
  ...
```

### `@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol`

```solidity
    2  // OpenZeppelin Contracts v4.4.0 (utils/cryptography/draft-EIP712.sol)
    3  
    4  pragma solidity ^0.8.0;
    5  
    6  import "./ECDSA.sol";
    7  
    8  /**
    9   * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
   10   *
  ...
   98       * address signer = ECDSA.recover(digest, signature);
   99       * ```
  100       */
  101      function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
  102          return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
  103      }
  104  }
  ...
```

Library files with the primitive itself (not excerpted): `@openzeppelin/contracts/utils/cryptography/ECDSA.sol`, `@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol`
