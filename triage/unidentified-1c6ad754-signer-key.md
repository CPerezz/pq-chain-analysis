---
id: unidentified-1c6ad754-signer-key
title: "Unidentified ERC-4337 operator (deployer 0xac6a87c6): a quantum attacker who recovers its ECDSA signer keys can drain the VerifyingPaymaster deposit and sign LiquidityBank releases (both now empty), and with an account owner's key plus the fixed co-signer key can take over the 852 smart accounts on its ownership module (about $6.6k)"
status: candidate
severity: MEDIUM
patterns: [PQ-4, PQ-12, PQ-17]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x1c6ad754810b4385ec3c46b0340e2954350c3e00"
  implementation: null
  name: VerifyingPaymaster (unverified, v0.6, with tx.origin allow-list)
  upgradeable: config-only
  admin: "owner EOA 0xbe4c70a00dcc0c0757257740e4e6f3f57d9a7c85 (deposit, withdrawTo, addOrigin/removeOrigin); verifyingSigner EOA 0x7e416860b6bbb0db05563116ce3750798c01e825; read at block 26,431,544"
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-01-03
  txs_30d: 0
- address: "0x3762a79b34dfb6774cfd45dbf5fd9a2780873783"
  implementation: "0xab8a2cfc2e4ca8f44cbd0bce309a361bb4c9aeb5"
  name: LiquidityBank (EIP-712 name; TransparentUpgradeableProxy, implementation unverified; paused)
  upgradeable: "yes"
  admin: ProxyAdmin 0x166fd12e962290250aebf178f60ff0a250e2159c owned by EOA 0xd77dbd0699582ca487f8519d2fecc4c0b41b78f9; logic owner EOA 0x82d04d2b250c3e017fcc2e333ec043b6b9bf7c77; read at block 26,431,733
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-10-09
  txs_30d: 0
- address: "0x82eace5d23ef8fc5e825a05e8eacd908289ee4dc"
  implementation: null
  name: "unverified ERC-1271 co-signer of module 0xba418fa6 (isValidSignature, getVerifyingSigner, setMode, getMode)"
  upgradeable: "no"
  admin: "none: owner() = 0x0 (renounced); verifying signer 0x5e028b8ce6397e8a81f94d80931ee02a8a854cdd is fixed"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-14
  txs_30d: 32
- address: "0xba418fa699622de824b258c61eb150ed7a13967b"
  implementation: null
  name: "Multichain PassKeys Ownership Registry Module 0.2.0 (unverified fork of Biconomy Smart Account v2 EcdsaOwnershipRegistryModule)"
  upgradeable: "no"
  admin: none (no proxy); each account enables or disables the module; co-signer 0x82eace5d23ef8fc5e825a05e8eacd908289ee4dc is an immutable (read at block 26431523)
  value_usd: 6557
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-14
  txs_30d: 25
families: []
fix:
  layer: new-deployment
  who_acts: "the operator behind deployer EOA 0xac6a87c681a5ed4cb58bc4fa7bf81a83b928c83c: paymaster owner EOA 0xbe4c70a00dcc0c0757257740e4e6f3f57d9a7c85 keeps deposits at zero or deploys a post-quantum paymaster; LiquidityBank ProxyAdmin owner EOA 0xd77dbd0699582ca487f8519d2fecc4c0b41b78f9 keeps it paused or upgrades it; a new module and co-signer replace 0xba418fa6/0x82eace5d, and each smart-account owner enables it and disables 0xba418fa6"
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-1c6ad754-signer-key
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_3.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review08 (paymaster bytecode, EntryPoint deposit reads, deployer siblings)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-1c6ad754-signer-key/notes.md
  date: 2026-11-17
  verdict: reported
  rating: LOW
- by: ai-assisted
  study: top-callers-classification
  who: Review18 (LiquidityBank bytecode strings and selectors, proxy and paymaster reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-1c6ad754-signer-key/notes-liquiditybank.md
  date: 2026-11-17
  verdict: reported
  rating: LOW
- by: ai-assisted
  study: top-callers-classification
  who: Review15 (co-signer bytecode, module immutable, traced user operation)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-1c6ad754-signer-key/notes-cosigner.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
- by: ai-assisted
  study: top-callers-classification
  who: Review22 (module bytecode, NAME/VERSION, trace, account enumeration and balances; moved from biconomy-ecdsa-validator)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-1c6ad754-signer-key/module-0xba418fa6.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f8f8a07d, feda0516"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: [biconomy-ecdsa-validator]
---

## Summary

One unidentified operator (all contracts deployed by EOA `0xac6a87c6…`) runs an ERC-4337 stack on Ethereum, and
each piece trusts one secp256k1 key (PQ-4). Its VerifyingPaymaster pays gas for user operations signed by
`verifyingSigner`. Its upgradeable "LiquidityBank" takes deposits against orders that a verifying signer authorises.
Its smart-account ownership module `0xba418fa6…` (a fork of Biconomy's Smart Account v2 ECDSA module) validates each
user operation with the account owner's ECDSA signature plus a fixed co-signer's (PQ-12). A quantum attacker who
recovers the paymaster or LiquidityBank signer could drain the paymaster's EntryPoint deposit or sign releases of
LiquidityBank deposits. Both are empty (USD 0 on 2026-11-17), and LiquidityBank has been paused since 2026-04-20. With
an account owner's key plus the co-signer key, the attacker controls that account. The 852 accounts on the module hold
about USD 6.6k. Rated LOW (step 5): each fix is one operator redeploying or upgrading, or account owners switching
modules (MEDIUM at step 4), and less than USD 50k is exposed.

## Mechanism

- **VerifyingPaymaster `0x1c6ad754…`** (bytecode; eth-infinitism v0.6 `VerifyingPaymaster` plus a `tx.origin`
  allow-list): `validatePaymasterUserOp` (`0xf465c77e`, called by EntryPoint v0.6 `0x5ff137d4…`) parses
  `paymasterAndData`, hashes it with `getHash` and recovers the signer with OpenZeppelin `ECDSA`; INFERRED: it compares
  the signer with `verifyingSigner`, and `tx.origin` must be an allow-listed bundler ("Invalid tx origin"). On success
  the EntryPoint charges gas to the paymaster's deposit.
- **LiquidityBank `0x3762a79b…`** (bytecode of implementation `0xab8a2cfc…`): order deposits, releases and refunds
  ("Invalid deposit order", "Order already released", "Invalid refund order", "Origin not whitelisted"). There is an
  EIP-712 domain "LiquidityBank", OpenZeppelin `ECDSA` and a stored `getVerifyingSigner()`; `PAYMASTER()` points at
  sibling paymaster `0xf7bb387e…`. INFERRED: orders, releases and refunds are authorised by the verifying signer's
  EIP-712 signature. Which selector does this was not established.
- **Co-signer `0x82eace5d…`** (bytecode): `isValidSignature(bytes32,bytes)` recovers with `ecrecover` and compares
  with `getVerifyingSigner()` = `0x5e028b8c…`; the owner is renounced. A forged co-signature still needs the owner's
  signature.
- **Ownership module `0xba418fa6…`** (bytecode; `NAME()` = "Multichain PassKeys Ownership Registry Module",
  `VERSION()` = "0.2.0"): Biconomy Smart Account v2 module interface (`initForSmartAccount`, `getOwner`,
  `transferOwnership` with `NotEOA(address)`, `validateUserOp` for EntryPoint v0.6, `isValidSignature`,
  `isValidSignatureForAddress`); runtime code differs from Biconomy's `EcdsaOwnershipRegistryModule` `0x0000001c…ea8e`.
  It holds `0x82eace5d…` as an immutable. A traced call (tx `0x5f57a90e…`, 2026-11-14) shows `validateUserOp` calling
  `0x82eace5d….isValidSignature` (`ecrecover` → `0x5e028b8c…`), then `ecrecover`ing the account owner `0xd0b3b7a0…`.
  Owners must be EOAs (`NotEOA`), so the only post-quantum path is a different module.
- No verified source for any of the four implementations
  ([`source-excerpts.md`](#source-excerpts-unidentified-1c6ad754-signer-key); the LiquidityBank proxy's
  verified build only bundles unrelated files).

## Evidence

- CHECKED (paymaster, block 26,431,544, [`notes.md`](#review-notes-review08-2026-11-17)):
  `owner()` EOA `0xbe4c70a0…`; `verifyingSigner()` EOA `0x7e416860…`; `entryPoint()` v0.6; EntryPoint deposit 0, not
  staked. Siblings `0xf7bb387e…` (same signer) and `0x8cbd4a19…` (signer `0x67575ef3…`), same owner, have zero
  deposits in EntryPoint v0.6 and v0.7.
- CHECKED (LiquidityBank, block 26,431,733,
  [`notes-liquiditybank.md`](#review-notes-unidentified-3762a79b-signer-key-2026-11-17-review18)): EIP-1967 admin
  ProxyAdmin `0x166fd12e…` (owner EOA `0xd77dbd06…`); implementation `0xab8a2cfc…`; `owner()` EOA `0x82d04d2b…`;
  `paused()` true (`setPaused()` 2026-04-20); `getVerifyingSigner()` EOA `0x75814d09…`; `PAYMASTER()` `0xf7bb387e…`;
  ETH 0, tokens USD 0.09. Its last transactions are `withdraw` calls on 2026-10-09.
- CHECKED (co-signer, block ~26,431,608,
  [`notes-cosigner.md`](#review-reads-review15-2026-11-17)): selectors as above;
  `owner()` = 0x0; `getVerifyingSigner()` = `0x5e028b8c…` (no code, nonce 0); the module's runtime code holds
  `0x82eace5d…` as an immutable; EntryPoint v0.6 tx `0x6535749d…` (2026-03, paymaster `0xf7bb387e…`) shows `ecrecover`
  calls from both the co-signer and the module.
- CHECKED (deployment): the paymaster (2024-12-20) and the co-signer (2024-09-10) were created through CREATE2 factory
  `0x4e59b448…` by EOA `0xac6a87c6…`. LiquidityBank's proxy was deployed by the same EOA (Sourcify record, block
  20,719,196). No ENS, tag or source attribution identifies the operator.
- CHECKED (precompile trace, year to March 2026, `curated_contracts.csv`): `ecrecover` transactions: paymaster
  70,948; LiquidityBank 47,243 (USD 16.6M of transfers in them); co-signer 82,572 calls. Xatu, 2026-10-16 to
  2026-11-16: paymaster 0, LiquidityBank 0, co-signer 32 transactions (last 2026-11-14)
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-1c6ad754-signer-key/activity.json)).
- CHECKED (module, RPC at block 26,431,523; Xatu call frames since block 24,700,000, 5,193 EntryPoint v0.6 bundles;
  [`module-0xba418fa6.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-1c6ad754-signer-key/module-0xba418fa6.json)): no proxy; created
  2024-09-10 through the CREATE2 factory by `0xac6a87c6…`, which also deployed `SmartAccountFactory` `0xb3f15a44…`
  (Smart Account v2). Of 856 `handleOps` senders, 852 have `getOwner` ≠ 0; they hold 0.081 ETH and USD 6.4k in
  USDC/USDT/WETH/WBTC, USD 6,557 in total (eight major tokens counted). There were 80,263 pre-quantum calls in the year
  to March 2026 (`curated_contracts.csv`) and 25 transactions in 2026-10-16 to 2026-11-16.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x1c6ad754…` VerifyingPaymaster | config-only | $0 (EntryPoint v0.6 deposit) | 2026-01-03 | 0 |
| `0x3762a79b…` LiquidityBank (paused) | yes | $0 held | 2026-10-09 | 0 |
| `0x82eace5d…` co-signer | no | none through this key alone | 2026-11-14 | 32 |
| `0xba418fa6…` ownership module | no | $6.6k (escrow: 852 accounts; owner key + co-signer key) | 2026-11-14 | 25 |

The exposure returns if the owner refills a paymaster deposit or unpauses LiquidityBank and users deposit again. The
smart accounts behind module `0xba418fa6…` are reachable only with both the account owner's key and the co-signer key.

## Remediation

- Paymaster owner EOA `0xbe4c70a0…`: keep deposits at zero, or sponsor through a paymaster that verifies a post-quantum
  sponsor signature (ERC-7913 verifier) or through EIP-8141 frame-transaction sponsorship.
- LiquidityBank ProxyAdmin owner EOA `0xd77dbd06…`: keep it paused and empty, or upgrade it to verify order signatures
  with a post-quantum scheme.
- Module and co-signer: neither can be changed (no proxy; co-signer owner renounced). The operator must deploy a new
  module and co-signer with post-quantum verification; each account owner enables it and calls
  `disableModule(0xba418fa6…)`. Protocol change: EIP-8151 would also help owner EOAs that move to post-quantum code.
- Rotating any of these signer keys does not help; the owners and signers are themselves ECDSA EOAs. No protocol change
  is needed for the operator's fixes.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review08): MEDIUM -> LOW, step 5: EntryPoint deposit measured at 0 (escrow USD 0, block 26,431,544); status confirmed -> candidate and evidence source-read -> bytecode (no verified source exists); tx.origin allow-list found; project still unidentified (deployer EOA 0xac6a87c6… has no ENS or tag).
- 2026-11-17 (merged from `unidentified-3762a79b-signer-key`): created MEDIUM by `scripts/15_findings.py`; review (Review18): MEDIUM -> LOW, step 5: LiquidityBank holds USD 0 and has been paused since 2026-04-20; mechanism refined from bytecode.
- 2026-11-17 (merged from `unidentified-82eace5d-signer-key`): created MEDIUM by `scripts/15_findings.py`; review (Review15): MEDIUM -> LOW, step 4: the key is a co-signature next to the account owner's, so forging it alone takes nothing; identified as the co-signer of module 0xba418fa6 by deployer 0xac6a87; status candidate -> confirmed (bytecode plus trace).
- 2026-11-17 review (Review18, merge): `unidentified-3762a79b-signer-key` and `unidentified-82eace5d-signer-key`
  merged here (same deployer `0xac6a87c6…`); their evidence moved to `notes-liquiditybank.md` / `notes-cosigner.md` and
  the merged JSON files. Merged rating LOW (step 5: paymaster and LiquidityBank USD 0 exposed; co-signer LOW at step 4).
  Status `candidate`: two of three contracts are bytecode-only without a second check.
- 2026-11-17 review (Review22, move): module `0xba418fa6…` moved here from `biconomy-ecdsa-validator` (same deployer `0xac6a87c6…`; there it was rated MEDIUM at step 4). Here MEDIUM at step 4 (owners switch modules), LOW at step 5 (852 accounts, USD 6,557); finding stays LOW. Pattern PQ-12 added.
- 2026-11-19 (study `eip-8151-impact`, PQ-17): under EIP-8151 the signer is fixed; once its account has code the signed functions stop; the signer key can be replaced; it must be rotated before its account takes code. Executed: a real transaction reverts when its signer has code.
- 2026-11-19: LOW -> MEDIUM, step 5 removed (value no longer lowers a rating); step 4 gives MEDIUM.

# Source excerpts: unidentified-1c6ad754-signer-key

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x1c6ad754810b4385ec3c46b0340e2954350c3e00`

No verified source on Sourcify or Blockscout.

## Contract `0x3762a79b34dfb6774cfd45dbf5fd9a2780873783` — TransparentUpgradeableProxy (verified source via sourcify)

### `contracts/NFT/ERC721V1.sol`

```solidity
    1  // SPDX-License-Identifier: BSD-3-Clause
    2  pragma solidity ^0.8.20;
    3  
    4  import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
    5  import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
    6  import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
    7  import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
    8  import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
    9  import {IPriceFeed} from "../interfaces/IPriceFeed.sol";
  ...
  167      bytes32 signedMessage = keccak256(abi.encodePacked(payload.id, payload.recipient, payload.referral));
  168      if (payload.id != _id) {
  169        revert ERC721V1InvalidMintSignature();
  170      }
  171      if (signedMessage.toEthSignedMessageHash().recover(payload.signature) != _signer) {
  172        revert ERC721V1InvalidMintSignature();
  173      }
  174  
  175      address recipient = payload.recipient;
  ...
```

### `@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol`

```solidity
    4  pragma solidity ^0.8.20;
    5  
    6  import {IERC20Permit} from "./IERC20Permit.sol";
    7  import {ERC20} from "../ERC20.sol";
    8  import {ECDSA} from "../../../utils/cryptography/ECDSA.sol";
    9  import {EIP712} from "../../../utils/cryptography/EIP712.sol";
   10  import {Nonces} from "../../../utils/Nonces.sol";
   11  
   12  /**
  ...
   40  
   41      /**
   42       * @inheritdoc IERC20Permit
   43       */
   44      function permit(
   45          address owner,
   46          address spender,
   47          uint256 value,
   48          uint256 deadline,
  ...
   57          bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
   58  
   59          bytes32 hash = _hashTypedDataV4(structHash);
   60  
   61          address signer = ECDSA.recover(hash, v, r, s);
   62          if (signer != owner) {
   63              revert ERC2612InvalidSigner(signer, owner);
   64          }
   65  
  ...
```

### `@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol`

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

Library files with the primitive itself (not excerpted): `@openzeppelin/contracts/utils/cryptography/ECDSA.sol`

## Implementation `0xab8a2cfc2e4ca8f44cbd0bce309a361bb4c9aeb5`

No verified source on Sourcify or Blockscout.

## Contract `0x82eace5d23ef8fc5e825a05e8eacd908289ee4dc`

No verified source on Sourcify or Blockscout.

# Review reads (Review15, 2026-11-17)

RPC eth.drpc.org / publicnode, block ~26,431,608.

| Read | Result |
|---|---|
| `0x82eace5d…` runtime size | 1,694 bytes; PUSH4 selectors `0x1626ba7e` isValidSignature(bytes32,bytes), `0x521e47b9` getVerifyingSigner(), `0x21175b4a` setMode(uint8), `0x4b4fd03b` getMode(), `0x295a5212` mode(), `0x8da5cb5b` owner(), `0xf2fde38b`, `0x715018a6`, two unresolved (`0x05b1737e`, `0x441f7f5f`) |
| `owner()` | `0x0000000000000000000000000000000000000000` |
| `getVerifyingSigner()` | `0x5e028b8ce6397e8a81f94d80931ee02a8a854cdd` (code size 0, nonce 0) |
| `getMode()` | 0 |
| Blockscout creator | `0x4e59b44847b379578588920ca78fbf26c0b4956c` (CREATE2 deployer), tx `0x38d84e16e6ff3b4f3e74194106e088789b0c73ec79655bb2b59b5db89403fc53`, sent by `0xac6a87c681a5ed4cb58bc4fa7bf81a83b928c83c`, block 20,718,955 (2024-09-10) |
| Module `0xba418fa699622de824b258c61eb150ed7a13967b` `NAME()` / `VERSION()` | "Multichain PassKeys Ownership Registry Module" / "0.2.0" |
| Module runtime code | contains `7f00000000000000000000000082eace5d23ef8fc5e825a05e8eacd908289ee4dc` (immutable) |
| Module `getOwner(0x92def945bb59b524953fd01375ee896bbd5a2b81)` | `0x7c200643bdd88701a2142bf423af1e070fb95224` |

EntryPoint v0.6 tx `0x6535749db982ac198ba450f763d3805d65bc9522e84ee539fccc2b712f3d4755`: `handleOps` from bundler
`0x7f0fa0ba…`, sender `0x92def945…` (Biconomy `Proxy`), paymaster `0xf7bb387e…`; signature = `abi.encode(module
0xba418fa6…, moduleSig)` whose payload holds two 65-byte ECDSA signatures and a validity window. `data/agg/y1_tx_caller`
shows `ecrecover` calls from `0x82eace5d…` and `0xba418fa6…` in this transaction.

# Review notes: unidentified-3762a79b-signer-key (2026-11-17, Review18)

## Identity

- Proxy `0x3762a79b…` is a verified OpenZeppelin `TransparentUpgradeableProxy` (Sourcify exact match). The verified
  build includes unrelated project files (an "Eventum" ERC721/vault project and copied InceptionLRT bridge code);
  they are not the implementation and say nothing about the operator.
- Deployed in tx `0xd59a0da7…` (block 20,719,196) by EOA `0xac6a87c681a5ed4cb58bc4fa7bf81a83b928c83c` (Sourcify
  deployment record). The same EOA deployed VerifyingPaymaster `0x1c6ad754…` (finding
  `unidentified-1c6ad754-signer-key`) and its sibling paymasters, per that finding's notes.
- Implementation `0xab8a2cfc2e4ca8f44cbd0bce309a361bb4c9aeb5`: unverified (Sourcify, Blockscout); created by EOA
  `0xd77dbd0699582ca487f8519d2fecc4c0b41b78f9`.
- `eip712Domain()` = name "LiquidityBank", version "1", chain 1, verifying contract = the proxy.
- No ENS, tag or source attribution found for any of these EOAs: project still unidentified.

## Bytecode (implementation, 14,556 bytes)

- Dispatcher selectors: `getVerifyingSigner()`, `PAYMASTER()`, `ENTRY_POINT_ADDRESS()`, `eip712Domain()`,
  `initialize(address,address)`, `setPaused()`, `setUnpaused()`, `paused()`, `owner()`, `transferOwnership`,
  `renounceOwnership`, `0xb460af94` (= `withdraw(uint256,address,address)`), and 9 unresolved selectors
  (`05b1737e`, `101916e0`, `354d2a25`, `65bd4f0e`, `863d51c9`, `a0897609`, `b695c935`, `c617b667`, `f1db4763`).
- Revert strings: "Invalid deposit order", "Order token info required", "Unsupported token", "Incorrect ETH amount",
  "Order locked", "Order expired", "Order already processed", "Order already released", "Order already refunded",
  "Invalid release order", "Invalid refund order", "Invalid refund sender", "Origin not whitelisted",
  "Order not found in deposit record", "LiquidityBank: invalid verifying…", "Withdraw address cannot be zero".
- Contains the secp256k1 `n/2` constant (OpenZeppelin `ECDSA` malleability check) and EIP-712 code.
- INFERRED: users deposit ETH or tokens against an order (for paymaster-sponsored operations); the order, release and
  refund are authorised by an EIP-712 signature from `getVerifyingSigner()`, checked with `ecrecover`. Exact function
  per selector not established.

## On-chain reads (`cast`, https://ethereum-rpc.publicnode.com, block 26,431,733)

- EIP-1967 admin = ProxyAdmin `0x166fd12e962290250aebf178f60ff0a250e2159c`, `owner()` = EOA `0xd77dbd06…` (nonce 707).
- EIP-1967 implementation = `0xab8a2cfc…`.
- `owner()` = EOA `0x82d04d2b250c3e017fcc2e333ec043b6b9bf7c77` (set by `transferOwnership` from `0xd77dbd06…` on
  2026-04-20); `paused()` = true (`setPaused()` on 2026-04-20).
- `getVerifyingSigner()` = EOA `0x75814d0960258ea854b325049a0018027da162c7` (nonce 0: signs only off-chain).
- `PAYMASTER()` = `0xf7bb387ecdea4b8ffff53e6b1a8cd9f93bfbdcc4` (unverified; `verifyingSigner()` = `0x7e416860…`,
  `owner()` = `0xbe4c70a0…`, the same signer and owner as `0x1c6ad754…`); `ENTRY_POINT_ADDRESS()` = EntryPoint v0.6
  `0x5ff137d4…`.
- ETH balance 0; priced tokens USD 0.09 (`onchain.json`, block 26,431,214).

## Activity

- Blockscout: last transactions are `withdraw` (`0xb460af94`) calls by EOA `0xdf51b037…` on 2026-04-20 and
  2026-10-09 (4 each), after the pause.
- Precompile trace (remote `data/agg`): 57,715 `ecrecover` calls in total, blocks 20,724,686–24,682,544; 49,144 calls
  in 47,243 transactions in the year to March 2026 (`txs_y1`); `usd_tx_y1` USD 16.6M of transfers in those
  transactions (`data/report/curated_contracts.csv`).

# Review notes (Review08, 2026-11-17)

Unverified. Reads at block 26,431,544 unless noted.

| Call | Result |
|---|---|
| `owner()` | `0xbe4c70a00dcc0c0757257740e4e6f3f57d9a7c85` (EOA) |
| `verifyingSigner()` | `0x7e416860b6bbb0db05563116ce3750798c01e825` (EOA) |
| `entryPoint()` | `0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789` (v0.6) |
| EntryPoint `balanceOf(0x1c6ad754…)` / `getDepositInfo` | 0 / (deposit 0, not staked) |
| ETH / tokens held by the paymaster | 0 / 0 (onchain.json, block 26,431,214) |

Bytecode: selectors of the eth-infinitism v0.6 `VerifyingPaymaster` (`validatePaymasterUserOp`, `getHash`,
`parsePaymasterAndData`, `verifyingSigner`, `deposit`, `withdrawTo`, `addStake`) plus `addOrigin(address)` /
`removeOrigin(address)`. Strings: `ECDSA: invalid signature`, `VerifyingPaymaster: invalid signature length in
paymasterAndData`, `Invalid tx origin`, `Invalid origin`. The secp256k1 `n/2` constant is present (OpenZeppelin
`ECDSA`). INFERRED: the signature in `paymasterAndData` is recovered and compared with `verifyingSigner`, and
`tx.origin` must be on an allow-list of bundlers.

Deployment: created 2024-12-20 through the CREATE2 factory `0x4e59b448…` by EOA
`0xac6a87c681a5ed4cb58bc4fa7bf81a83b928c83c` (no ENS or Blockscout tag), which also deployed the Biconomy ECDSA module
copy `0xba418fa6…` (see `biconomy-ecdsa-validator`). Its CREATE2 deployments of 2025-12-31 to 2026-01-04 include two
more paymasters with the same code size and owner:

| Address | verifyingSigner | owner | EntryPoint v0.6 / v0.7 deposit | ETH |
|---|---|---|---|---|
| `0xf7bb387ecdea4b8ffff53e6b1a8cd9f93bfbdcc4` | `0x7e416860…` (same) | `0xbe4c70a0…` | 0 / 0 | 0 |
| `0x8cbd4a19f3a538d4ba85b6899263586a214ddc0a` | `0x67575ef3737dd3e4921297ba04b4ee281e4b10be` | `0xbe4c70a0…` | 0 / 0 | 0 |

Usage: `curated_contracts.csv`: 70,948 transactions with `ecrecover` in `0x1c6ad754…` in the year to March 2026.
