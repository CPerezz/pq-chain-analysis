---
id: stakewise-oseth-permit
title: "StakeWise osETH: permit accepts only ECDSA, so a quantum attacker who recovers a holder's key can sign approvals and take their osETH, even after the holder converts the address to a post-quantum account"
project: stakewise
status: confirmed
severity: HIGH
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: sole
role: auxiliary
contracts:
- address: "0xf1c9acdc66974dfb6decb12aa385b9cd01190e38"
  implementation: null
  name: OsToken (osETH)
  upgradeable: "no"
  admin: none for permit; Ownable2Step owner renounced (owner() and pendingOwner both zero at block 26,431,521); owner could only toggle mint/burn controllers
  value_usd: 290592981
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 1214
families: []
fix:
  layer: account-migration
  who_acts: nobody can change OsToken (no proxy, owner renounced); holders protect themselves by moving osETH to a fresh post-quantum account (a converted address stays forgeable); a protocol change such as EIP-8151 would protect converted addresses
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/stakewise-oseth-permit
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
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

osETH (`0xf1c9acdc…`, StakeWise V3's overcollateralised staked-ETH token) implements EIP-2612 `permit` with
OpenZeppelin 5.0 `ERC20Permit`, which accepts only an `ecrecover` signature from the holder (PQ-1). A CRQC holder who
recovers a holder's secp256k1 key from any on-chain signature can sign a permit to itself and transfer the holder's
osETH; this keeps working after the holder converts the same address to post-quantum account code, and post-quantum
accounts cannot use `permit` at all (plain `approve` still works). The token is immutable and its owner renounced. The
exposure is bounded by osETH in circulation: USD 290.6M market cap on 2026-11-17. Rated HIGH, step 4.

## Mechanism

- `ERC20Permit.permit(owner, spender, value, deadline, v, r, s)` builds the EIP-712 `Permit` digest with
  `_useNonce(owner)`, calls `ECDSA.recover(hash, v, r, s)` and requires the result to equal `owner`
  (`ERC20Permit.sol` lines 44–64), then sets the allowance. No ERC-1271 or account-code check exists.
- `OsToken` (`contracts/osToken/OsToken.sol`) adds only `mint`/`burn` for the immutable `_vaultController` and
  owner-set `controllers`, and `setController` (owner-only).
- Pattern PQ-1. Excerpts: [`source-excerpts.md`](#source-excerpts-stakewise-oseth-permit).

## Evidence

- CHECKED (Sourcify exact match, fetched 2026-11-17): `OsToken.sol`, OpenZeppelin v5.0.0 `ERC20Permit.sol` and
  `ECDSA.sol`, solc 0.8.22. The original classification called it unverified; it is verified.
- CHECKED (on-chain read at block 26,431,214): no EIP-1967 slots, not a proxy
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/stakewise-oseth-permit/onchain.json)).
- CHECKED (on-chain read at block 26,431,521): `owner()` returns zero; storage slots 0 (`_owner`) and 1
  (`_pendingOwner`) are zero; `totalSupply()` 148,455.36 osETH ([`token.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/stakewise-oseth-permit/token.json)).
- CHECKED (Blockscout token API, 2026-11-17): price USD 1,957.39, circulating market cap USD 290,592,981, 1,921 holders.
- CHECKED (Xatu, any function): 1,214 transactions called the token 2026-10-16 to 2026-11-16, last on 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/stakewise-oseth-permit/activity.json)).
- CHECKED (precompile trace, year to March 2026, `studies/top-callers-classification/results/curated_contracts.csv`): 446 transactions with an
  `ecrecover` call by the token (`txs_y1`), about USD 274M moved in them (`usd_tx_y1`).
- CHECKED (executed, study `eip-8151-impact`, 2026-11-19): a real transaction,
  `0xfcf97ef80e7d92edec16f871a828b10a6f7a895c284ae02e729f418c279a77a4` (block 26,348,595, position 21), replayed on
  the reference implementation of the fork with only the precompile changed. Under today's rule it matches its
  receipt (544,907 gas); under EIP-8151 it also succeeds (551,307 gas). With one byte of code at the recovered signer
  `0xcc220072496b024bbf77839446e066e9f4a56028`, it reverts after that recovery returned no address; with a 7702
  delegation there it succeeds. Study family `197af5d7` (OsToken).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xf1c9acdc…` OsToken (osETH) | no | $290.6M (market cap) | 2026-11-16 | 1,214 |

The market cap is an upper bound: it counts every holder, including contracts (vaults, pools) that have no ECDSA key
and cannot be forged through `permit`. The draft's USD 371.1M came from a cached Blockscout market cap of unknown date;
the figure above was read on 2026-11-17. Only osETH is in this finding; StakeWise vaults were not assessed here.

## Remediation

- StakeWise cannot change osETH: no proxy, and the owner is renounced. A post-quantum permit (ERC-1271 for accounts
  with code first, or ERC-7913) needs a new token, which also needs a new vault controller and vaults to mint it.
- Holders: do not rely on converting an address in place; move osETH to a fresh post-quantum account, or hold it in a
  contract account.
- Protocol: EIP-8151 would make `ecrecover` fail for converted addresses with real code (`protocol_change: helps`).

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review19): HIGH kept, step 4. Source is verified on Sourcify (OZ 5.0 `ERC20Permit`); owner found renounced; market cap updated from USD 371.1M to USD 290.6M (Blockscout, 2026-11-17).
- 2026-11-19 (study `eip-8151-impact`, reading 3): EIP-8151 as written closes this path for an account that takes
  real code (executed on a real transaction); plain and 7702-delegated accounts stay exposed, and approvals already
  given stay valid.

# Source excerpts: stakewise-oseth-permit

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xf1c9acdc66974dfb6decb12aa385b9cd01190e38` — OsToken (verified source via sourcify)

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
