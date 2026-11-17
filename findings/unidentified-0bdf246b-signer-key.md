---
id: unidentified-0bdf246b-signer-key
title: "PMMProtocol (RFQ market-maker contract, deployer 0xc6471559…, operator unidentified): ECDSA is tried before ERC-1271 on maker quotes, but its only maker is a Safe paid out through Permit2, so a quantum attacker can take nothing here beyond the maker's own Safe keys"
project: unidentified-0bdf246b
status: confirmed
severity: LOW
patterns: [PQ-2, PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x0bdf246b4aef9cfe4dd6eef153a1b645ac4bcbb6"
  implementation: null
  name: PMMProtocol
  upgradeable: "no"
  admin: "none (no owner, no proxy)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-03-31
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: "the deployer 0xc64715599f5910ae6fd5c3900850c561a44bd413 (operator unidentified) for a contract that checks account code before ecrecover; market makers by signing only through ERC-1271 and Permit2 from contract accounts"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-0bdf246b-signer-key
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
  who: Review11 (Claude), finding review
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-0bdf246b-signer-key/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

PMMProtocol fills RFQ orders signed by a market maker; unless the taker sets a smart-contract flag, it tries `ecrecover`
on the maker's signature before ERC-1271 (PQ-2). A maker that is an ECDSA account, or an EIP-7702 account that moved to
post-quantum signing, stays forgeable here with its old key. Every observed fill came from one maker, a Safe, which no
`ecrecover` result can match, and its funds move through Permit2 signature transfers that Permit2 verifies itself; the
maker has approved nothing to this contract directly. Rated LOW (step 4): the ERC-1271 path is already the one in use and
nothing can be taken through this contract's check; the contract has been idle since 2026-03-31.

## Mechanism

- `fillOrderRFQ…` (PmmProtocol.sol lines 112–128, 171–182): with `_SIGNER_SMART_CONTRACT_HINT`, ERC-1271 only (the `(r, vs)`
  entry forwards 64 bytes, the `bytes` entry the full signature); otherwise `ECDSA.recoverOrIsValidSignature`
  (ECDSA.sol lines 99–133): `ecrecover`, then ERC-1271. The taker sets the flag.
- `_fillOrderRFQTo` pulls the maker asset with Permit2: `permitWitnessTransferFrom`/`permitTransferFrom` with the maker's
  `permit2Signature` (lines 268–290), or a Permit2 allowance transfer (line 293). Permit2 checks account code before
  `ecrecover` (PQ-13), so a contract maker is protected there regardless of this contract.
- No owner, proxy or admin: the code cannot change.

## Evidence

- CHECKED (verified source, Blockscout): the paths above
  ([`source-excerpts.md`](#source-excerpts-unidentified-0bdf246b-signer-key),
  [`notes.md`](#review-notes-unidentified-0bdf246b-signer-key-2026-11-17)).
- CHECKED (on-chain read, block 26,431,214): no proxy, no owner, holds nothing
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-0bdf246b-signer-key/onchain.json)).
- CHECKED (Blockscout logs, latest 50 fills): maker always Safe `0xb7131fc8…` (1 of 2), `usePermit2 = true`.
- CHECKED (on-chain read, block 26,431,557): the maker's ERC-20 and Permit2 allowances to this contract are 0 for USDC,
  WETH and USDT.
- CHECKED (Xatu, any function): no calls 2026-10-16 to 2026-11-16; last 2026-03-31
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-0bdf246b-signer-key/activity.json)).
- INFERRED: the operator. The deployer `0xc6471559…` also deployed four `DexRouter` contracts with OKX DEX's function
  names, but that does not establish who runs this contract.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x0bdf246b…` PMMProtocol | no | none found (maker allowances to it are 0) | 2026-03-31 | 0 |

The contract holds nothing. The maker Safe holds about $2.36M, approved to Permit2, not to this contract; it is exposed
through its own 1-of-2 ECDSA owners (PQ-12 of that Safe), not through this check. Yearly pre-quantum count from the
census: 22,165 fills (`txs_y1`).

## Remediation

- A redeployment that checks account code before `ecrecover` (as Permit2 and current OpenZeppelin `SignatureChecker`
  do) removes the PQ-2 path; the operator is not identified (deployer `0xc6471559…`).
- Makers: sign only from contract accounts with post-quantum owners and keep approvals on Permit2; the maker Safe
  `0xb7131fc8…` needs post-quantum owners.
- EIP-8151 would help: `ecrecover` would fail for migrated EIP-7702 makers, closing the old-key path without the operator.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 4: an alternative path exists that one known party can switch to).
- 2026-11-17 review (Review11): LOW unchanged (step 4: the only maker already signs through ERC-1271 and is paid through Permit2; nothing can be taken through this check). Patterns [PQ-4] -> [PQ-2, PQ-4]; protocol change not-needed -> helps (EIP-8151). Operator still unidentified (deployer also deployed OKX-style DexRouters; not conclusive).

# Source excerpts: unidentified-0bdf246b-signer-key

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x0bdf246b4aef9cfe4dd6eef153a1b645ac4bcbb6` — PMMProtocol (verified source via blockscout)

### `src/OrderRFQLib.sol`

```solidity
    1  // SPDX-License-Identifier: MIT
    2  
    3  pragma solidity 0.8.17;
    4  
    5  import "./libraries/ECDSA.sol";
    6  
    7  library OrderRFQLib {
    8      struct OrderRFQ {
    9          uint256 rfqId; // 0x00
  ...
   55                  order.permit2Witness,
   56                  keccak256(bytes(order.permit2WitnessType))
   57              )
   58          );
   59          return ECDSA.toTypedDataHash(domainSeparator, structHash);
   60      }
   61  }
  ...
```

### `src/PmmProtocol.sol`

```solidity
  112      {
  113          orderHash = order.hash(_domainSeparatorV4());
  114          if (flagsAndAmount & _SIGNER_SMART_CONTRACT_HINT != 0) {
  115              if (flagsAndAmount & _IS_VALID_SIGNATURE_65_BYTES != 0) {
  116                  if (!ECDSA.isValidSignature65(order.makerAddress, orderHash, r, vs)) {
  117                      revert Errors.RFQ_BadSignature(order.rfqId);
  118                  }
  119              } else {
  120                  if (!ECDSA.isValidSignature(order.makerAddress, orderHash, r, vs)) {
  121                      revert Errors.RFQ_BadSignature(order.rfqId);
  122                  }
  123              }
  124          } else {
  125              if (!ECDSA.recoverOrIsValidSignature(order.makerAddress, orderHash, r, vs)) {
  126                  revert Errors.RFQ_BadSignature(order.rfqId);
  127              }
  128          }
  129  
  ...
  171          if (flagsAndAmount & _SIGNER_SMART_CONTRACT_HINT != 0) {
  172              if (flagsAndAmount & _IS_VALID_SIGNATURE_65_BYTES != 0 && signature.length != 65) {
  173                  revert Errors.RFQ_BadSignature(order.rfqId);
  174              }
  175              if (!ECDSA.isValidSignature(order.makerAddress, orderHash, signature)) {
  176                  revert Errors.RFQ_BadSignature(order.rfqId);
  177              }
  178          } else {
  179              if (!ECDSA.recoverOrIsValidSignature(order.makerAddress, orderHash, signature)) {
  180                  revert Errors.RFQ_BadSignature(order.rfqId);
  181              }
  182          }
  183          (filledMakerAmount, filledTakerAmount) = _fillOrderRFQTo(order, flagsAndAmount, target);
  ...
```

### `src/interfaces/IDaiLikePermit.sol`

```solidity
    1  // SPDX-License-Identifier: MIT
    2  pragma solidity ^0.8.0;
    3  
    4  interface IDaiLikePermit {
    5      function permit(
    6          address holder,
    7          address spender,
    8          uint256 nonce,
    9          uint256 expiry,
  ...
```

### `src/interfaces/IERC20Permit.sol`

```solidity
    1  // SPDX-License-Identifier: MIT
    2  pragma solidity ^0.8.0;
    3  
    4  interface IERC20Permit {
    5      function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
    6          external;
    7  }
  ...
```

### `src/interfaces/IPermit2.sol`

```solidity
   64      function DOMAIN_SEPARATOR() external view returns (bytes32);
   65  
   66      function transferFrom(address user, address to, uint160 amount, address token) external;
   67  
   68      function permit(address owner, PermitSingle memory permitSingle, bytes calldata signature) external;
   69      function permitTransferFrom(
   70          PermitTransferFrom memory permit,
   71          SignatureTransferDetails calldata transferDetails,
   72          address owner,
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

Library files with the primitive itself (not excerpted): `src/EIP712.sol`, `src/libraries/ECDSA.sol`

# Review notes: unidentified-0bdf246b-signer-key (2026-11-17)

Reads with `cast` against https://ethereum-rpc.publicnode.com at block 26,431,557; source from Blockscout (verified,
Solidity 0.8.17, `src/PmmProtocol.sol`, `src/libraries/ECDSA.sol`).

## Code path

- `fillOrderRFQ…` (PmmProtocol.sol lines 112–128 and 171–182): if the taker sets `_SIGNER_SMART_CONTRACT_HINT` in
  `flagsAndAmount`, the maker signature goes to ERC-1271 only (`ECDSA.isValidSignature`; the `(r, vs)` entry forwards 64
  bytes, the `bytes signature` entry forwards the full signature); otherwise `ECDSA.recoverOrIsValidSignature`
  (ECDSA.sol lines 99–133) tries `ecrecover` first and falls back to ERC-1271. The flag is chosen by the caller.
- Maker funds move in `_fillOrderRFQTo`: with `usePermit2`, by `Permit2.permitWitnessTransferFrom` /
  `permitTransferFrom` with the maker's `permit2Signature` (lines 268–290), which Permit2 verifies itself (ERC-1271 for
  makers with code); otherwise by a Permit2 allowance transfer (line 293).
- No owner, no proxy, no admin functions (`onchain.json`: owner null, kind none).

## Makers and allowances

- Blockscout logs, latest 50 `OrderFilledRFQ` events (blocks 24,768,478–24,777,223): every fill has maker
  `0xb7131fc8cdc43060a6210257f537dba5fcae6aed` and `usePermit2 = true`.
- `0xb7131fc8…` is a Safe 1.4.1 (`getThreshold()` = 1, owners `0x388364512b2603eb2588ea12eda201423d5f7ffe`,
  `0x6e64095a0170b8c1721694b49fb58c974a4c45f0`), holding about $2.36M (Blockscout, WETH $321k, XAUT $206k, PENDLE $164k, …).
- Maker allowances to the PMM contract: ERC-20 `allowance(maker, PMM)` = 0 for USDC, WETH, USDT; Permit2
  `allowance(maker, token, PMM)` = 0 for the same three. The maker's unlimited approvals are to Permit2
  (`0x000000000022d473030f116ddee9f6b43ac78ba3`), whose signature transfers check ERC-1271 for the Safe.

## Deployer

- Creator `0xc64715599f5910ae6fd5c3900850c561a44bd413` (EOA, creation tx
  `0x650932e1bffb59b192b30940c7bbf03bceda1321f4abb08f351425e0212a4342`) also created verified `DexRouter` contracts
  `0xc6d05c8efb86b44612d2aec43d14b04635044c2a`, `0x156acd2bc5fc336d59baae602a2bd9b5e20d6672`,
  `0x5b4826f302d3043ab2b907f79c7e2e4e5cbc6aac`, `0x31756c38708c3571b771b00155a7fee9d75e36b2`, whose source has OKX DEX
  router function names (`smartSwapByOrderId`, `unxswapByOrderId`). `0x7d0ccaa3fac1e5a943c5168b6ced828691b46b36`, a
  `DexRouter` commonly listed as OKX DEX's router (listing not checked here), was created by a different address
  (`0xea522fe3a65874ba3cec38e912220282b7c71e97`). Attribution to OKX is plausible but not established.
