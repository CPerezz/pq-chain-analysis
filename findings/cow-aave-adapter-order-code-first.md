---
id: cow-aave-adapter-order-code-first
title: "Aave Labs' Aave V3 × CoW flash-loan adapter factory checks account code before ECDSA; a quantum attacker gains nothing beyond each EOA's own key"
project: aave
status: not-affected
severity: NONE
patterns: [PQ-13]
primitives: [ecrecover]
trigger: none
impact: none
alternative: alternative-exists
role: core
contracts:
- address: "0xdecc46a4b09162f5369c5c80383aaa9159bcf192"
  implementation: null
  name: AaveV3AdapterFactory
  upgradeable: config-only
  admin: owner Safe 0x187aae17d4931310b3fc75743e7f16bdc9ed77e9 (5 of 8; setAdapterImplementation, pause, rescueTokens)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 4691
families: []
fix:
  layer: none
  who_acts: nobody needs to act; owner Safe 0x187aae17d4931310b3fc75743e7f16bdc9ed77e9 (Aave Labs deployment) controls adapter listing and pause only
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/cow-aave-adapter-order-code-first
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
  who: Review18 (Sourcify source incl. OpenZeppelin SignatureChecker, deployer history on Blockscout, owner read)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/cow-aave-adapter-order-code-first/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: NONE
related: [aave-atoken-permit-ecdsa-only]
---

## Summary

The AaveV3AdapterFactory lets an Aave user authorise a CoW Protocol order that runs a flash-loan adapter (debt swap,
collateral swap, repay with collateral) by signing the adapter order. It verifies that signature with OpenZeppelin
`SignatureChecker`, which sends any signer with code to ERC-1271 with the full signature and uses `ecrecover` only for
code-less addresses (PQ-13). A quantum attacker therefore gains nothing here beyond the EOA key they already broke,
and an account that migrates with real code (a smart account or an EIP-7702 delegate) is not forgeable. Rated NONE.
The contract was deployed by Aave Labs, not CoW: project changed to `aave`.

## Mechanism

- A CoW order's owner is a per-order adapter instance; when the settlement checks the instance's ERC-1271 signature,
  the instance calls `BaseAdapterFactory.verifyOrderSignature(orderOwner, order, signature)` (line 151), which builds
  an EIP-712 digest over the adapter order and returns `SignatureChecker.isValidSignatureNow(orderOwner, digest,
  signature)` (line 172).
- OpenZeppelin `SignatureChecker.isValidSignatureNow` (line 33): `signer.code.length == 0` → `ECDSA.tryRecover`;
  otherwise `isValidERC1271SignatureNow`, passing the whole signature (line 53).
- Pattern PQ-13. Excerpts: [`source-excerpts.md`](#source-excerpts-cow-aave-adapter-order-code-first).

## Evidence

- CHECKED (Sourcify full source, read 2026-11-17): `verifyOrderSignature` and the code-first `SignatureChecker` as above;
  `@author Aave Labs.` in `AaveV3AdapterFactory.sol` and `BaseAdapterFactory.sol`
  ([`notes.md`](#review-notes-cow-aave-adapter-order-code-first-2026-11-17-review18)).
- CHECKED (Sourcify deployment record, Blockscout): deployed at block 23,812,751 by EOA
  `0xdf0a18f9be8cecc1d4fde078d99ee2ed4885ac5e`, which also deployed the newer Aave adapter factories through Aave's
  `TransparentProxyFactory` `0xeb0682d148e874553008730f0686ea89db7da412`.
- CHECKED (`cast`, block 26,431,494): `owner()` = Safe `0x187aae17d4931310b3fc75743e7f16bdc9ed77e9` (5 of 8 at block
  26,431,214, [`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/cow-aave-adapter-order-code-first/onchain.json)); `paused()` = false; not a
  proxy.
- CHECKED (precompile trace): 18,605 `ecrecover` calls in the last year (`studies/top-callers-classification/results/curated_contracts.csv`).
- CHECKED (Xatu, any function): last active 2026-11-16, 4,691 transactions in 2026-10-16 to 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/cow-aave-adapter-order-code-first/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xdecc46a4…` AaveV3AdapterFactory | config-only | none beyond each signer's own key | 2026-11-16 | 4,691 |

The factory holds nothing between transactions (USD 0 at block 26,431,214). Siblings checked: the newer factories
deployed 2026-10-09 (proxies `0xd2cc30cb…`, `0x0c6f0d00…`, `0xfdfa0362…`, same owner Safe; implementations
`0xde33afe5…`, `0xaed8fb57…`, `0x38a9bdc0…`) use OpenZeppelin v5.6.0 `SignatureChecker.isValidSignatureNowCalldata`,
also code-first; not affected either. CoW's GPv2Settlement, which settles these orders, is a separate finding
(`cow-order-sig-scheme-select`); adapter orders reach it through the `Eip1271` scheme.

## Remediation

None needed in the contract. EOA users who move to post-quantum authorisation keep this path working by giving the
address real code (EIP-7702 delegate or smart account) that implements ERC-1271 with a post-quantum signature.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated NONE (code checked first: no exposure beyond the account's own key).
- 2026-11-17 review (Review18): NONE kept. Project changed from `cow-protocol` to `aave`: source says `@author Aave
  Labs.` and the deployer EOA `0xdf0a18f9…` deploys Aave's adapter factories through Aave's TransparentProxyFactory;
  code-first check confirmed in OpenZeppelin `SignatureChecker`; newer factories checked, same pattern.

# Source excerpts: cow-aave-adapter-order-code-first

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xdecc46a4b09162f5369c5c80383aaa9159bcf192` — AaveV3AdapterFactory (verified source via sourcify)

### `lib/openzeppelin-contracts/contracts/interfaces/IERC1271.sol`

```solidity
   12       * @dev Should return whether the signature provided is valid for the provided data
   13       * @param hash      Hash of the data to be signed
   14       * @param signature Signature byte array associated with `hash`
   15       */
   16      function isValidSignature(bytes32 hash, bytes calldata signature) external view returns (bytes4 magicValue);
   17  }
  ...
```

### `lib/openzeppelin-contracts/contracts/interfaces/IERC7913.sol`

```solidity
   12       * MUST return the bytes4 magic value IERC7913SignatureVerifier.verify.selector if the signature is valid.
   13       * SHOULD return 0xffffffff or revert if the signature is not valid.
   14       * SHOULD return 0xffffffff or revert if the key is empty
   15       */
   16      function verify(bytes calldata key, bytes32 hash, bytes calldata signature) external view returns (bytes4);
   17  }
  ...
```

### `src/contracts/BaseAdapterFactory.sol`

```solidity
    4  
    5  import {IERC20} from 'openzeppelin/token/ERC20/IERC20.sol';
    6  import {SafeERC20} from 'openzeppelin/token/ERC20/utils/SafeERC20.sol';
    7  import {EIP712} from 'openzeppelin/utils/cryptography/EIP712.sol';
    8  import {SignatureChecker} from 'openzeppelin/utils/cryptography/SignatureChecker.sol';
    9  import {Clones} from 'openzeppelin/proxy/Clones.sol';
   10  import {Ownable} from 'openzeppelin/access/Ownable.sol';
   11  import {Pausable} from 'openzeppelin/utils/Pausable.sol';
   12  
  ...
  168            order.appData
  169          )
  170        )
  171      );
  172      return SignatureChecker.isValidSignatureNow(orderOwner, digest, signature);
  173    }
  174  
  175    /// @inheritdoc IBaseAdapterFactory
  176    function DOMAIN_SEPARATOR() external view returns (bytes32) {
  ...
```

Library files with the primitive itself (not excerpted): `lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol`, `lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol`

# Review notes: cow-aave-adapter-order-code-first (2026-11-17, Review18)

## Attribution

- Sourcify deployment record: deployed in tx `0x12842b16e307d9b98269cdde2397860ed4684e5f69e9eaafc789ab9f894ac497`
  (block 23,812,751) by EOA `0xdf0a18f9be8cecc1d4fde078d99ee2ed4885ac5e`.
- Verified source (`src/contracts/AaveV3AdapterFactory.sol` line 15, `BaseAdapterFactory.sol` line 23):
  `/// @author Aave Labs.` CoW code enters only as dependencies (`cowprotocol/flash-loan-router`, `cowprotocol/contracts`).
- Blockscout, transactions from the deployer: on 2026-10-09 it deployed `AaveV3AdapterV3Factory` /
  `AaveV3AdapterV4Factory` implementations and their adapters (`DebtSwapAaveV3Adapter`, `CollateralSwapAaveV4Adapter`,
  …) behind TransparentUpgradeableProxies created via Aave's `TransparentProxyFactory`
  `0xeb0682d148e874553008730f0686ea89db7da412`; on 2025-11-20 it called `transferOwnership` on this factory.
- Conclusion: the adapter factory is Aave Labs' code and deployment; project set to `aave`.

## On-chain reads (`cast`, https://ethereum-rpc.publicnode.com, block 26,431,494)

- `AaveV3AdapterFactory(0xdecc46a4…).owner()` = `0x187aae17d4931310b3fc75743e7f16bdc9ed77e9` (Safe, 5 of 8 at block
  26,431,214 per `onchain.json`); `paused()` = false. Not a proxy (no EIP-1967 slots, `onchain.json`).
- Newer factories, same owner Safe: proxies `0xd2cc30cb0e77b80a34b879ccb6da67799e4ecd83` (impl
  `0xde33afe502c8582c706d669a6808e6d24c15742d`, `AaveV3AdapterV3Factory`), `0x0c6f0d008b5ee6cdfbb8bf1cfb0148052e96ac14`,
  `0xfdfa036213c375808135744e865767fd90897f0a`.

## Source (Sourcify)

- `BaseAdapterFactory.verifyOrderSignature` (line 151): EIP-712 digest over the adapter order, then
  `SignatureChecker.isValidSignatureNow(orderOwner, digest, signature)` (line 172).
- OpenZeppelin `SignatureChecker` (v5.x file with ERC-7913 support), line 33: `if (signer.code.length == 0)` →
  `ECDSA.tryRecover`, else `isValidERC1271SignatureNow` with the full signature (line 53).
- Newer implementations `0xde33afe5…`, `0xaed8fb57…`, `0x38a9bdc0…`: OpenZeppelin v5.6.0 `SignatureChecker`, called
  as `SignatureChecker.isValidSignatureNowCalldata(orderOwner, digest, signature)` (`BaseAdapterV3Factory.sol` line
  211); the library checks `signer.code.length == 0` first. Same code-first pattern.

Yearly pre-quantum calls (`data/report/curated_contracts.csv`): `txs_y1` 18,605 ecrecover calls.
