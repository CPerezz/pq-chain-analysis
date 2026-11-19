---
id: unidentified-7d3201fa-signer-key
title: "ERC-4337 token paymaster 0x7d3201fa (EntryPoint v0.7, operator unidentified): a quantum attacker who recovers the sponsor-signer key can have the paymaster pay gas for any UserOperation, but its EntryPoint deposit is empty and it has been idle since June 2026"
project: unidentified-7d3201fa
status: confirmed
severity: MEDIUM
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x7d3201fa7a85c0a5f9fa1c0c6b9d0b784368d2ac"
  implementation: null
  name: Paymaster (EntryPoint v0.7 token paymaster)
  upgradeable: config-only
  admin: "owner Safe 0x8cef85a571bef5379ef1cc9952eae7e109a38a0f (3 of 6): updateSigner, updateTreasury, withdrawTo, stake; read at block 26431610"
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-06-05
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: "The paymaster's operator, owner Safe 0x8cef85a571bef5379ef1cc9952eae7e109a38a0f (3 of 6): deploy a paymaster that verifies sponsorship through ERC-1271/ERC-7913 and stop funding this one"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-7d3201fa-signer-key
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
  who: review (Review12)
  ref: findings review 2026-11-17; Sourcify source, cast reads at block 26431610
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

This ERC-4337 v0.7 paymaster sponsors a UserOperation's gas from its EntryPoint deposit when an off-chain signer EOA
(`0x5437edbb…`) has signed the operation, checked with `ecrecover` only (PQ-4); the user then pays a signed token
amount to the treasury. A quantum attacker who recovers the signer key can sign sponsorships with a zero token charge
and spend the whole deposit on gas. The deposit is 0 today and the paymaster has had no activity since 2026-06-05,
after 751,773 sponsored transactions in the year to March 2026. Rated LOW, step 5: a new deployment would be MEDIUM,
lowered one level because $0 is exposed.

## Mechanism

- `validatePaymasterUserOp` → `_validatePaymasterUserOp` (`Paymaster.sol` lines 82–108) reads (validUntil,
  validAfter, token, amount, signature) from `paymasterAndData`, requires a 65-byte signature and returns
  `SIG_VALIDATION_FAILED` unless `ECDSA.recover(toEthSignedMessageHash(getHash(userOp, …, token, amount)))` equals
  `signer`. The EntryPoint then charges the gas to the paymaster's deposit.
- `_postOp` (lines 110–120) pulls `amount` of `token` from `userOp.sender` to `treasury`. The sender is the account
  that validated the operation itself, so a forged sponsorship cannot pull another user's tokens.
- `updateSigner` (owner only) rotates the key but not the scheme. Pattern PQ-4.

## Evidence

- CHECKED (Sourcify full source, read 2026-11-17): the paths above
  ([`notes.md`](#review-notes-review12-2026-11-17), [`source-excerpts.md`](#source-excerpts-unidentified-7d3201fa-signer-key)).
- CHECKED (cast at block 26,431,610): `signer()` = EOA `0x5437edbb…`; `treasury()` = `0x480a825b…` (`PaymasterBuffer`);
  `owner()` = Safe `0x8cef85a5…` (threshold 3, 6 owners); `entryPoint()` = v0.7 EntryPoint `0x00000000717…`;
  `getDeposit()` = 0, EntryPoint `getDepositInfo` all zero (no stake).
- CHECKED (block 26,431,214): the contract holds nothing ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-7d3201fa-signer-key/onchain.json)).
- CHECKED (Xatu): last transaction 2026-06-05, none in 2026-10-16 to 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-7d3201fa-signer-key/activity.json)); precompile trace, year to March
  2026: 751,773 transactions calling `ecrecover`, $784M moved in them (`curated_contracts.csv`).
- CHECKED (attribution attempts): Blockscout names and tags for the deployer (an EIP-7702 EOA `0xd87df9fd…`), treasury,
  Safe and signer; Sourcify metadata; web search. The same addresses are used on BSC, Arbitrum, Polygon and Base; no
  project is named. Operator unidentified.

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0x7d3201fa…` Paymaster | config-only | $0 (EntryPoint deposit) | 2026-06-05 | 0 |

- Escrow: the paymaster's EntryPoint v0.7 deposit, 0 ETH at block 26,431,610. If the operator funds it again, a forged
  signer could spend all of it on gas.
- Users' token approvals to the paymaster cannot be pulled through a forged sponsorship (the sender authorises its own
  operation).

## Remediation

- Replacement: a paymaster that verifies sponsorship through ERC-1271/ERC-7913 (so a post-quantum signer account can
  approve), or an on-chain sponsorship policy; then stop funding this one.
- Who acts: the operator, owner Safe `0x8cef85a5…` (3 of 6). No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review12): MEDIUM -> LOW, step 5: EntryPoint deposit (the escrow) is 0 at block 26,431,610; idle since 2026-06-05. Signer, treasury and owner read; operator still unidentified (Blockscout, Sourcify, web search tried).
- 2026-11-19: LOW -> MEDIUM, step 5 removed (value no longer lowers a rating); step 4 gives MEDIUM.

# Source excerpts: unidentified-7d3201fa-signer-key

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x7d3201fa7a85c0a5f9fa1c0c6b9d0b784368d2ac` — Paymaster (verified source via sourcify)

### `src/v0.7/Paymaster.sol`

```solidity
    3  
    4  import "./core/BasePaymaster.sol";
    5  import "./core/UserOperationLib.sol";
    6  import "./core/Helpers.sol";
    7  import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
    8  import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
    9  import {SafeTransferLib} from "solady/utils/SafeTransferLib.sol";
   10  
   11  // Paymaster for EPv0.7
  ...
   94          require(signature.length == 65, InvalidSignatureLength());
   95          bytes32 hash = MessageHashUtils.toEthSignedMessageHash(getHash(userOp, validUntil, validAfter, token, amount));
   96  
   97          //don't revert on signature failure: return SIG_VALIDATION_FAILED
   98          if (signer != ECDSA.recover(hash, signature)) {
   99              return ("", _packValidationData(true, validUntil, validAfter));
  100          }
  101  
  102          // no need for other on-chain validation: entire UserOp should have been checked
  ...
```

Library files with the primitive itself (not excerpted): `@openzeppelin/contracts/utils/cryptography/ECDSA.sol`

# Review notes (Review12, 2026-11-17)

- Source: Sourcify `src/v0.7/Paymaster.sol` of 0x7d3201fa7a85c0a5f9fa1c0c6b9d0b784368d2ac (deployment tx
  0xb6df6e5a8a8b754c7ba392f8ef6b4949566f909a6a72493711d516016f38f495, block 22,318,390, deployer
  0xd87df9fd27b9a30fe27e7b294caaa4673f34b6b1, an EIP-7702 EOA).
  - `_validatePaymasterUserOp` (lines 82–108): parses (validUntil, validAfter, token, amount, signature) from
    `paymasterAndData`; requires a 65-byte signature; `signer != ECDSA.recover(toEthSignedMessageHash(getHash(...)))`
    returns SIG_VALIDATION_FAILED.
  - `_postOp` (lines 110–120): `safeTransferFrom(token, userOp.sender, treasury, amount)`.
  - `updateSigner`, `updateTreasury` (lines 135–143) and BasePaymaster `withdrawTo`, `addStake`, `unlockStake`,
    `withdrawStake` are `onlyOwner`; `deposit()` is public.
- cast (https://eth.drpc.org) at block 26,431,610: `signer()` = 0x5437edbb73bcbbad2c7fe2cca23969e3b8e5baa4 (EOA);
  `treasury()` = 0x480a825bed6cdba9da81cc01faacd12166761dec (Blockscout name `PaymasterBuffer`, created by
  0xd3da45475a96dddb7395fc449234e1604c405c6a); `owner()` = Safe 0x8cef85a571bef5379ef1cc9952eae7e109a38a0f,
  `getThreshold()` = 3 (6 owners, onchain.json); `entryPoint()` = 0x0000000071727de22e5e9d8baf0edac6f37da032;
  `getDeposit()` = 0 and EntryPoint `getDepositInfo` = (0, false, 0, 0, 0).
- Attribution tried: Blockscout names/tags of deployer, treasury, Safe and signer (none); Sourcify metadata (no
  author/repo); web search for the paymaster, treasury and Safe addresses (same addresses used on BSC, Arbitrum,
  Polygon and Base; no project named). Operator not identified.
