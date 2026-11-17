---
id: usual-usd0pp-permit
title: "Usual bUSD0 (USD0++): permit accepts only ECDSA signatures, so a quantum attacker who recovers a holder's key can approve and take that holder's tokens, even after the holder moves to post-quantum authorisation; up to $489M in holders' balances"
project: usual
status: confirmed
severity: MEDIUM
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: sole
role: auxiliary
contracts:
- address: "0x35d8949372d46b7a3d5a56006ae77b215fc69bc0"
  implementation: "0x9f2bd21bf8012fce0d5845537c1deff3a89bc85b"
  name: TransparentUpgradeableProxy → Usd0PP ("Bond USD0", bUSD0)
  upgradeable: "yes"
  admin: "ProxyAdmin 0x65a7042460932a8e7b6aa9c765c2bae5f4535c22, owned by Safe 0xaada24358620d4638a2ee8788244c6f4b197ca16 (8 of 15), read at block 26431619"
  value_usd: 488989125
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 1318
families: []
fix:
  layer: contract-upgrade
  who_acts: "Usual Safe 0xaada24358620d4638a2ee8788244c6f4b197ca16 (8 of 15), owner of ProxyAdmin 0x65a7042460932a8e7b6aa9c765c2bae5f4535c22, upgrades Usd0PP to a permit that checks account code first (ERC-1271 with the full signature)"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/usual-usd0pp-permit
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
  who: review (Review12)
  ref: findings review 2026-11-17; Sourcify source of 0x9f2bd21b, cast reads at block 26431619, Blockscout token data
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Usual's bUSD0 token (formerly USD0++) inherits OpenZeppelin's `ERC20PermitUpgradeable`, whose `permit` accepts only an
ECDSA signature from the holder's address (PQ-1). A quantum attacker who recovers a holder's key from a past signature
can sign a permit for the whole balance and transfer it, and this keeps working after the holder moves the address to
post-quantum account code; post-quantum accounts cannot use `permit` at all (plain `approve` still works). The upper
bound is the holders' balances, $489.0M (market cap, 2026-11-17). Rated MEDIUM, step 4: an 8-of-15 Safe can upgrade
the token.

## Mechanism

- `permit(owner, spender, value, deadline, v, r, s)` (`ERC20PermitUpgradeable.sol` lines 49–70 in the excerpt): EIP-712
  hash of the permit with the owner's nonce, `ECDSA.recover(hash, v, r, s)` must equal `owner`, then `_approve`. There
  is no `isValidSignature` path and no code check anywhere in the implementation's sources.
- `mintWithPermit` and `unlockUSD0ppWithUsualWithPermit` (`Usd0PP.sol` lines 197–206, 370–384) call `permit` on the USD0
  and USUAL tokens for `msg.sender` inside `try/catch`; those checks live in the other tokens and are not part of this
  finding.
- Pattern PQ-1 (user signature checked with ECDSA only).

## Evidence

- CHECKED (Sourcify full source of implementation `0x9f2bd21bf8012fce0d5845537c1deff3a89bc85b`, read 2026-11-17):
  `Usd0PP` inherits `ERC20PermitUpgradeable` without overriding `permit`; no source file mentions `isValidSignature` or
  `SignatureChecker` ([`source-excerpts.md`](#source-excerpts-usual-usd0pp-permit)).
- CHECKED (cast at block 26,431,619): EIP-1967 implementation `0x9f2bd21b…`, admin `0x65a70424…`; ProxyAdmin `owner()` =
  Safe `0xaada2435…`, threshold 8 of 15; `name()` = "Bond USD0", `symbol()` = "bUSD0"; `totalSupply()` = 500,077,104
  tokens ([`notes.md`](#review-notes-review12-2026-11-17)).
- CHECKED (Blockscout token data, 2026-11-17): price $0.9778, circulating market cap $488,989,125, 2,652 holders.
- CHECKED (Xatu, any function): 1,318 transactions 2026-10-16 to 2026-11-16, last 2026-11-15
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/usual-usd0pp-permit/activity.json)); precompile trace, year to March 2026: 2,907
  transactions calling `ecrecover`, $53.2M moved in them (`curated_contracts.csv`).

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0x35d89493…` TransparentUpgradeableProxy → Usd0PP (bUSD0) | yes | $489.0M (market cap) | 2026-11-15 | 1,318 |

- Exposure: each holder's own balance, for holders whose key has signed on-chain; the market cap is the upper bound.
  Balances held by contracts without an ECDSA key (pools, vaults, Safes) cannot be permitted away.
- Not in this finding: the USD0 and USUAL token permits that the wrappers consume.

## Remediation

- Replacement: upgrade `Usd0PP` so `permit` checks account code first and verifies contract signers through ERC-1271
  with the full signature (OpenZeppelin `SignatureChecker`, current version, i.e. the PQ-13 pattern), and accepts
  `bytes` signatures.
- Who acts: Usual Safe `0xaada2435…` (8 of 15) through ProxyAdmin `0x65a70424…`.
- Protocol change: helps. EIP-8151 would make `ecrecover` fail for addresses that have real account code, protecting
  migrated holders without the upgrade. Holders can protect themselves today by moving bUSD0 to a fresh post-quantum
  account (a migrated address keeps its old ECDSA key here).

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by upgrading the contract (admin or governance)).
- 2026-11-17 review (Review12): MEDIUM -> MEDIUM, step 4: upgrade by Safe 0xaada2435 (8 of 15) via ProxyAdmin 0x65a70424. Market cap updated to $489.0M (Blockscout, 2026-11-17); token now named "Bond USD0" (bUSD0).

# Source excerpts: usual-usd0pp-permit

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x35d8949372d46b7a3d5a56006ae77b215fc69bc0` — TransparentUpgradeableProxy (verified source via sourcify)

## Implementation `0x9f2bd21bf8012fce0d5845537c1deff3a89bc85b` — Usd0PP (verified source via sourcify)

### `lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/ERC20PermitUpgradeable.sol`

```solidity
    4  pragma solidity ^0.8.20;
    5  
    6  import {IERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";
    7  import {ERC20Upgradeable} from "../ERC20Upgradeable.sol";
    8  import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
    9  import {EIP712Upgradeable} from "../../../utils/cryptography/EIP712Upgradeable.sol";
   10  import {NoncesUpgradeable} from "../../../utils/NoncesUpgradeable.sol";
   11  import {Initializable} from "../../../proxy/utils/Initializable.sol";
   12  
  ...
   45  
   46      /**
   47       * @inheritdoc IERC20Permit
   48       */
   49      function permit(
   50          address owner,
   51          address spender,
   52          uint256 value,
   53          uint256 deadline,
  ...
   62          bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
   63  
   64          bytes32 hash = _hashTypedDataV4(structHash);
   65  
   66          address signer = ECDSA.recover(hash, v, r, s);
   67          if (signer != owner) {
   68              revert ERC2612InvalidSigner(signer, owner);
   69          }
   70  
  ...
```

### `lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol`

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

### `src/token/Usd0PP.sol`

```solidity
  199      {
  200          Usd0PPStorageV0 storage $ = _usd0ppStorageV0();
  201  
  202          try IERC20Permit(address($.usd0))
  203              .permit(msg.sender, address(this), amountUsd0, deadline, v, r, s) {}
  204              catch {} // solhint-disable-line no-empty-blocks
  205  
  206          _deconstruct(amountUsd0, msg.sender, msg.sender);
  207      }
  ...
  376          Usd0PPStorageV0 storage $ = _usd0ppStorageV0();
  377  
  378          // Execute the USUAL permit
  379          try IERC20Permit(address($.usual))
  380              .permit(
  381                  msg.sender,
  382                  address(this),
  383                  maxUsualAmount,
  384                  usualApproval.deadline,
  ...
```

Library files with the primitive itself (not excerpted): `lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol`

# Review notes (Review12, 2026-11-17)

- cast (https://eth.drpc.org) at block 26,431,619 on proxy 0x35d8949372d46b7a3d5a56006ae77b215fc69bc0:
  - EIP-1967 implementation slot = 0x9f2bd21bf8012fce0d5845537c1deff3a89bc85b; admin slot = 0x65a7042460932a8e7b6aa9c765c2bae5f4535c22.
  - ProxyAdmin `owner()` = 0xaada24358620d4638a2ee8788244c6f4b197ca16 (Safe; `getThreshold()` = 8; 15 owners).
  - `name()` = "Bond USD0", `symbol()` = "bUSD0", `totalSupply()` = 500077104376794414385378052 (18 decimals).
- Blockscout `/api/v2/tokens/0x35d8…`: exchange_rate 0.977828, circulating_market_cap 488989125, 2,652 holders.
- Sourcify sources of implementation 0x9f2bd21b…: no file contains `isValidSignature` or `SignatureChecker`;
  `src/token/Usd0PP.sol` has no `function permit` (inherited from OZ `ERC20PermitUpgradeable`).
