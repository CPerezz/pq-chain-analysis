---
id: everclear-fee-signer
title: "Everclear FeeAdapter (V1 and V2): a quantum attacker who recovers the fee-signer key can sign its own fee quotes and skip Everclear's fees on its own intents; no user or pooled funds are released"
project: everclear
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: none
alternative: key-rotation-only
role: auxiliary
contracts:
- address: "0x15a7ca97d1ed168fb34a4055cefa2e2f9bdb6c75"
  implementation: null
  name: FeeAdapter (superseded)
  upgradeable: config-only
  admin: owner Safe 0xa02a88f0bbd47045001bd460ad186c30f9a974d6 (2 of 6; updateFeeSigner)
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-11-12
  txs_30d: 0
- address: "0xd0185bfb8107c5b2336bc73ce3fdd9bfb504540e"
  implementation: null
  name: FeeAdapterV2
  upgradeable: config-only
  admin: owner Safe 0xa02a88f0bbd47045001bd460ad186c30f9a974d6 (2 of 6; updateFeeSigner)
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-04-08
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: Everclear (owner Safe 0xa02a88f0bbd47045001bd460ad186c30f9a974d6) deploys a fee adapter that verifies fee quotes through ERC-1271 or a post-quantum scheme
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/everclear-fee-signer
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
  who: Review07 (registry review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/everclear-fee-signer/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Everclear's FeeAdapter takes the protocol fee for an intent only against a fee quote signed by one ECDSA key,
`feeSigner` (PQ-4). A quantum attacker who recovers that key can sign zero-fee quotes for its own intents and skip
Everclear's fee; the quote does not release user or pooled funds, which the Everclear spoke handles separately. The
original FeeAdapter has been unused since 2025-11-12; its replacement FeeAdapterV2 (same signer, same check) was last
used 2026-04-08; both hold nothing. Rated LOW (step 4): the check guards only the fee, through which nothing can be
taken from others.

## Mechanism

FeeAdapter: every `newIntent`/`newOrder` path calls `_handleFees` (FeeAdapter.sol lines 394–418), which requires
`ECDSA.recover(toEthSignedMessageHash(keccak256(abi.encode(tokenFee, nativeFee, inputAsset, deadline))), sig) ==
feeSigner` (lines 381–387) and then forwards the fees to `feeRecipient`; the intent itself is created on the Everclear
spoke. FeeAdapterV2 binds the signed data to the call, the adapter and the chain and checks the same `feeSigner`
(FeeAdapterV2.sol lines 423–436). `updateFeeSigner` is `onlyOwner`; any new signer is again an ECDSA key. Lines:
[`notes.md`](#review-reads-everclear-fee-signer-2026-11-17-review07).

## Evidence

- CHECKED (verified source, Sourcify, both adapters): the paths above.
- CHECKED (`cast` at block 26,431,599): both not proxies; `owner()` = `feeRecipient()` = Safe `0xa02a88f0…` (2 of 6);
  `feeSigner()` = `0xd148c7f3…81c8` on both; 0 ETH.
- CHECKED (Blockscout): V1 last called 2025-11-12; V2 deployed 2025-11-11, last called 2026-04-08; V2 holds ≈ $0.02.
- CHECKED (precompile trace to March 2026): 12,631 V1 transactions with `ecrecover` in the last year.
- CHECKED (Everclear docs, `resources/contracts/mainnet.md`): `FeeAdapter` on chain 1 is `0xd0185bfb…` (V2).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x15a7ca97…` FeeAdapter (superseded) | config-only | $0 | 2025-11-12 | 0 |
| `0xd0185bfb…` FeeAdapterV2 | config-only | $0 | 2026-04-08 | 0 |

The worst effect is lost fee revenue on intents the attacker submits itself; deposits and settlements run through the
Everclear spoke and hub, which this signature does not authorise. Fee adapters on other chains are out of scope.

## Remediation

- Everclear deploys a fee adapter that verifies quotes through ERC-1271 (a signer contract with a post-quantum key) or
  a post-quantum scheme, and points its API at it; the owner Safe's signers should also move to post-quantum
  accounts.
- No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1 reach: no activity in 12 months (last 2025-11-12) and nothing held).
- 2026-11-17 review (Review07): LOW unchanged, now step 4 (the check only guards Everclear's own fee) since the
  current FeeAdapterV2 `0xd0185bfb…`, added here, was active in 2026-04. Impact funds-loss -> none, role core ->
  auxiliary.

# Source excerpts: everclear-fee-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x15a7ca97d1ed168fb34a4055cefa2e2f9bdb6c75` — FeeAdapter (verified source via sourcify)

### `src/contracts/intent/FeeAdapter.sol`

```solidity
    4  import {Ownable, Ownable2Step} from '@openzeppelin/contracts/access/Ownable2Step.sol';
    5  import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
    6  import {SafeERC20} from '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
    7  import {Address} from '@openzeppelin/contracts/utils/Address.sol';
    8  import {ECDSA} from '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';
    9  import {MessageHashUtils} from '@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol';
   10  
   11  import {TypeCasts} from 'contracts/common/TypeCasts.sol';
   12  
  ...
  379     * @param _signature The signature of the message
  380     */
  381    function _verifySignature(bytes memory _data, bytes calldata _signature) internal view {
  382      bytes32 _hash = keccak256(_data);
  383      address _recoveredSigner = ECDSA.recover(MessageHashUtils.toEthSignedMessageHash(_hash), _signature);
  384      if (_recoveredSigner != feeSigner) {
  385        revert FeeAdapter_InvalidSignature();
  386      }
  387    }
  ...
```

### `../../node_modules/@hyperlane-xyz/core/contracts/interfaces/IInterchainSecurityModule.sol`

```solidity
   27       * the security model encoded by the module (e.g. validator signatures)
   28       * @param _message Hyperlane encoded interchain message
   29       * @return True if the message was verified
   30       */
   31      function verify(
   32          bytes calldata _metadata,
   33          bytes calldata _message
   34      ) external returns (bool);
   35  }
  ...
```

### `../../node_modules/@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol`

```solidity
   62       * section].
   63       *
   64       * CAUTION: See Security Considerations above.
   65       */
   66      function permit(
   67          address owner,
   68          address spender,
   69          uint256 value,
   70          uint256 deadline,
  ...
```

Library files with the primitive itself (not excerpted): `../../node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol`

# Review reads: everclear-fee-signer (2026-11-17, Review07)

## Source (Sourcify)

- `FeeAdapter` `0x15a7ca97d1ed168fb34a4055cefa2e2f9bdb6c75`, `src/contracts/intent/FeeAdapter.sol`: every
  `newIntent`/`newOrder` path calls `_handleFees` (lines 394–418), which calls `_verifySignature` (lines 381–387):
  `ECDSA.recover(toEthSignedMessageHash(keccak256(abi.encode(tokenFee, nativeFee, inputAsset, deadline))), sig) ==
  feeSigner`, then sends `tokenFee`/`nativeFee` to `feeRecipient`. `updateFeeSigner` is `onlyOwner` (lines 75–79).
- `FeeAdapterV2` `0xd0185bfb8107c5b2336bc73ce3fdd9bfb504540e` (Everclear docs list it as the Ethereum FeeAdapter),
  `src/contracts/intent/FeeAdapterV2.sol`: `_verifySignature` (lines 423–436) hashes the call data with
  `address(this)` and `block.chainid` and `ECDSA.recover(...) == feeSigner`; e.g. `newOrderSplitEvenly` (lines
  159–172).

## On-chain reads (`cast`, publicnode, block 26,431,599)

- Both adapters: not proxies (EIP-1967 slot 0); `owner()` = `feeRecipient()` =
  `0xa02a88f0bbd47045001bd460ad186c30f9a974d6` (Safe, threshold 2 of 6); `feeSigner()` =
  `0xd148c7f37b346a4bd8e14f8c1f181f5f640481c8`; ETH 0. `spoke()` (V1) = `0xa05a3380889115bf313f1db9d5f335157be4d816`.

## Activity and holdings (Blockscout, 2026-11-17)

- V1: last transactions `newIntent`/`newOrder` on 2025-11-12; Xatu found none in 2026-10-16 to 2026-11-16.
- V2: deployed 2025-11-11 (block 23,776,636) by `0x2d64a7617bf0761fe715a17693a4bff1abf445b0`; last transactions
  `newIntent` on 2026-04-08; holds 0.011998 USDC and 0.009998 USDT (≈ $0.02) plus unpriced dust.
- Yearly pre-quantum use (`data/report/curated_contracts.csv`, V1): `txs_y1` 12,631.
