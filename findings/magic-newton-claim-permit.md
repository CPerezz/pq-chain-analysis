---
id: magic-newton-claim-permit
title: "Magic Newton NEWT airdrop: claimOnBehalf accepted only an ECDSA signature from the eligible account, but the claim window closed on 2025-07-24 and the contract holds no NEWT, so nothing is left to forge"
project: magic-newton
status: confirmed
severity: LOW
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: none
alternative: alternative-exists
role: auxiliary
contracts:
- address: "0x95835589f6e03a9a0f3bae95ab41c75122101fc8"
  implementation: null
  name: NewtonClaim
  upgradeable: "no"
  admin: owner Safe 0xcd14dc086511f33f91093410cdd0f3eab9ee8beb (3 of 8; pause, withdraw after endTime; read at block 26,431,214)
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-07-24
  txs_30d: 0
families: []
fix:
  layer: none
  who_acts: none needed; the claim window (immutable endTime 2025-07-24) has closed and the balance is zero
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/magic-newton-claim-permit
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

NewtonClaim (`0x95835589…`) distributed the NEWT airdrop from a Merkle root. Besides `claim()` by the eligible account
itself, `claimOnBehalf` let anyone submit an ECDSA signature from the eligible account directing the tokens to another
beneficiary (PQ-1). Both paths are restricted to the claim window, whose immutable `endTime` passed on 2025-07-24, and
the contract holds 0 NEWT, so a quantum attacker can no longer take anything through it. Rated LOW, step 1: no activity
in the last 12 months and nothing held.

## Mechanism

- `claimOnBehalf(index, account, beneficiary, amount, merkleProof, v, r, s)` (`src/NewtonClaim.sol`) is `whenNotPaused
  inWindow`; `ClaimPermit._verifyClaimPermit` hashes `(index, account, beneficiary, amount, keccak256(merkleProof))`
  under EIP-712 and requires `ECDSA.recover(hash, v, r, s) == account` (`ClaimPermit.sol` line 51); then the Merkle
  leaf `(index, account, amount)` is checked and `amount` NEWT goes to `beneficiary`.
- `MerkleDistributor.claim(index, amount, proof)` pays `msg.sender` only and has no signature (the alternative path).
- `inWindow` reverts with `ClaimWindowFinished` once `block.timestamp > endTime`; `withdraw()` (owner) is allowed only
  after `endTime`.
- Excerpts: [`source-excerpts.md`](#source-excerpts-magic-newton-claim-permit).

## Evidence

- CHECKED (Sourcify, fetched 2026-11-17): `src/NewtonClaim.sol`, `ClaimPermit.sol`, `MerkleDistributor.sol` as above.
- CHECKED (on-chain read at block 26,431,607): `endTime()` = 1,753,362,000 (2025-07-24 13:00 UTC); `token()` = NEWT
  `0xd0ec028a…`, NEWT `balanceOf(contract)` = 0; `owner()` = Safe `0xcd14dc08…`; `paused()` false.
- CHECKED (on-chain read at block 26,431,214): not a proxy; Safe threshold 3 of 8; no ETH or tokens
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/magic-newton-claim-permit/onchain.json)).
- CHECKED (Xatu, any function): no transaction called the contract from 2026-03-18 to 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/magic-newton-claim-permit/activity.json)); the last `ecrecover` call in the precompile
  trace is on 2025-07-24, with 40,423 such transactions in the year to March 2026 (`txs_y1`,
  `studies/top-callers-classification/results/curated_contracts.csv`).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x95835589…` NewtonClaim | no | $0 | 2025-07-24 | 0 |

Nothing is exposed: the window cannot reopen (`endTime` is immutable) and the contract holds no NEWT. The NEWT token
itself was not assessed here.

## Remediation

None needed for this contract. A future Magic Newton distribution should let contract accounts claim through ERC-1271
(account code checked first) or keep claims to `msg.sender` with a Merkle proof, which is already hash-based.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1 reach: no activity in 12 months (last 2025-07-24) and nothing held).
- 2026-11-17 review (Review19): LOW kept, step 1. Claim window found closed (immutable `endTime` 2025-07-24) and NEWT balance zero; impact set to none, alternative to alternative-exists (`claim()` by the account), fix to none; title corrected (claimOnBehalf, not a permit).

# Source excerpts: magic-newton-claim-permit

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x95835589f6e03a9a0f3bae95ab41c75122101fc8` — NewtonClaim (verified source via sourcify)

### `lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol`

```solidity
   41       * pair of leaves and each pair of pre-images are assumed to be sorted.
   42       *
   43       * This version handles proofs in memory with the default hashing function.
   44       */
   45      function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
   46          return processProof(proof, leaf) == root;
   47      }
   48  
   49      /**
  ...
   69       * pair of leaves and each pair of pre-images are assumed to be sorted.
   70       *
   71       * This version handles proofs in memory with a custom hashing function.
   72       */
   73      function verify(
   74          bytes32[] memory proof,
   75          bytes32 root,
   76          bytes32 leaf,
   77          function(bytes32, bytes32) view returns (bytes32) hasher
  ...
```

### `src/NewtonClaim.sol`

```solidity
   32          _verifyClaimPermit(index, account, beneficiary, amount, merkleProofHash, v, r, s);
   33  
   34          // Verify the merkle proof.
   35          bytes32 node = keccak256(abi.encodePacked(index, account, amount));
   36          if (!MerkleProof.verify(merkleProof, merkleRoot, node)) revert InvalidProof();
   37  
   38          // Mark it claimed and send the token.
   39          _setClaimed(index);
   40          IERC20(token).transfer(beneficiary, amount);
  ...
```

### `src/utils/merkle_distributor/ClaimPermit.sol`

```solidity
    3  // OpenZeppelin Contracts v4.4.1 (token/Delegate/extensions/ERC20Permit.sol)
    4  
    5  pragma solidity ^0.8.28;
    6  
    7  import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
    8  import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
    9  
   10  /**
   11   * Abstract contract including helper functions to allow claim by signature using
  ...
   47              keccak256(abi.encode(_CLAIM_TYPEHASH, index, account, beneficiary, amount, merkleProofHash));
   48  
   49          bytes32 hash = _hashTypedDataV4(structHash);
   50  
   51          address signer = ECDSA.recover(hash, v, r, s);
   52          require(signer == account, SignatureMismatch());
   53      }
   54  }
  ...
```

### `src/utils/merkle_distributor/MerkleDistributor.sol`

```solidity
   61          if (isClaimed(index)) revert AlreadyClaimed();
   62  
   63          // Verify the merkle proof.
   64          bytes32 node = keccak256(abi.encodePacked(index, account, amount));
   65          if (!MerkleProof.verify(merkleProof, merkleRoot, node)) revert InvalidProof();
   66  
   67          // Mark it claimed and send the token.
   68          _setClaimed(index);
   69          IERC20(token).transfer(account, amount);
  ...
```

Library files with the primitive itself (not excerpted): `lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol`
