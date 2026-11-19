---
id: airswap-maker-sig-ecdsa-first
title: "AirSwap SwapERC20 (0xd82e10b9): a quantum attacker who recovers a maker's ECDSA key can sign orders that spend the maker's token approvals, even after the maker moves to a post-quantum account"
project: airswap
status: confirmed
severity: HIGH
patterns: [PQ-2, PQ-3, PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0xd82e10b9a4107939e55fcca9b53a9ede6cf2fc46"
  implementation: null
  name: SwapERC20
  upgradeable: "no"
  admin: "owner Safe 0xf8bb149f9525875fa47b8cc632d368eb600faba3 (2 of 3, block 26431214): fee and staking settings only; no upgrade or verifier setter"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 169
families: []
fix:
  layer: new-deployment
  who_acts: "AirSwap (owner Safe 0xf8bb149f9525875fa47b8cc632d368eb600faba3) deploys a SwapERC20 that checks account code before ecrecover and passes full-length bytes signatures; makers revoke approvals to 0xd82e10b9 and move to it"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/airswap-maker-sig-ecdsa-first
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
  who: Review17 (full Sourcify source and on-chain reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/airswap-maker-sig-ecdsa-first/review-notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: HIGH
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by a person)"
  ref: "studies/eip-8151-impact, reading 3 (does EIP-8151 close this path), 2026-11-19"
  date: 2026-11-19
  verdict: confirmed
  rating: ''
related: [airswap-v4-maker-sig-ecdsa-only]
---

## Summary

AirSwap's SwapERC20 settles RFQ orders signed by a maker (the `signerWallet`) and pulls the maker's tokens with
`transferFrom`. The maker's signature is checked with `ecrecover` first and only then with ERC-1271, and the ERC-1271
call gets just 65 bytes; `swapLight` uses `ecrecover` alone. A quantum attacker who recovers a maker's secp256k1 key
from any on-chain signature can sign orders that spend whatever that address has approved to this contract, and this
stays true after the maker gives the address post-quantum code. The contract is immutable, the approvals at risk were
not measured, and the rating is HIGH (step 4: users' funds stay forgeable after they migrate, in a contract that cannot
change).

## Mechanism

- `swap` and `swapAnySender` call `_check` (`contracts/SwapERC20.sol` 645-690): the signatory is
  `authorized[signerWallet]` if the maker set a delegate, else `signerWallet`; then
  `SignatureCheckerLib.isValidSignatureNow(signatory, orderHash, abi.encodePacked(r, s, v))`.
- solady's `isValidSignatureNow` runs `ecrecover` for a 64/65-byte signature and returns true on a match, with no
  account-code check; only if that fails does it call `isValidSignature(hash, signature)` on the signatory (PQ-2).
- The public functions take `uint8 v, bytes32 r, bytes32 s`, so an ERC-1271 account receives only those 65 bytes and
  cannot be given a post-quantum signature (PQ-3). A contract signatory can still accept an order it has pre-approved
  on-chain and ignore the 65 bytes, which is the only path open to a post-quantum maker.
- `swapLight` (lines 243-325) uses `ECDSA.tryRecover(hash, v, r, s)` and requires the result to equal `signerWallet`
  or its delegate: ECDSA only (PQ-1).
- On success the contract calls `safeTransferFrom(signerToken, signerWallet, recipient, signerAmount)`: a forged order
  moves the maker's tokens up to its allowance to this contract.

## Evidence

- CHECKED (Sourcify full source, 2026-11-17): `_check`, `swapLight`, solady `SignatureCheckerLib` check order, and that
  the owner functions only set fees, bonus and staking ([`review-notes.md`](#review-reads-airswap-maker-sig-ecdsa-first-2026-11-17-review17),
  [`source-excerpts.md`](#source-excerpts-airswap-maker-sig-ecdsa-first)).
- CHECKED (on-chain read at block 26,431,214): no proxy; `owner()` = Safe `0xf8bb149f…` with threshold 2 of 3; ETH 0
  and tokens ~$0 held ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/airswap-maker-sig-ecdsa-first/onchain.json)).
- CHECKED (Xatu, any function): 169 transactions 2026-10-16 to 2026-11-16, last 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/airswap-maker-sig-ecdsa-first/activity.json)); Blockscout shows the latest direct
  `swap` on 2026-10-22.
- CHECKED (`studies/top-callers-classification/results/curated_contracts.csv`): 252,079 transactions with an `ecrecover` call in the last year
  (`txs_y1`), $187.7M transferred in them (`usd_tx_y1`).
- INFERRED: maker allowances to this contract are the exposure; they were not measured.
- CHECKED (executed, study `eip-8151-impact`, 2026-11-19): a real transaction,
  `0xe76016c272c9aeef5a96ebcd490c69a7b60872f070ac07f2e49d41b318f42d3c` (block 26,365,407, position 4), replayed on
  the reference implementation of the fork with only the precompile changed. Under today's rule it matches its
  receipt (194,395 gas); under EIP-8151 it also succeeds (196,875 gas). With one byte of code at the recovered signer
  `0xce79b081c0c924cb67848723ed3057234d10fc6b`, it reverts after that recovery returned no address; with a 7702
  delegation there it succeeds. Study family `da9fa385` (SwapERC20).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xd82e10b9…` SwapERC20 | no | ~$0 (not the exposure) | 2026-11-16 | 169 |

The contract holds nothing; what can be taken is each maker's token allowance to `0xd82e10b9…`, limited by the maker's
balance. Measuring it needs every maker's current allowance and balance; not done, so `value_usd` is null and the
value step lowers nothing. The older SwapERC20 `0xd82fa167…` is in
[`airswap-v4-maker-sig-ecdsa-only`](airswap-v4-maker-sig-ecdsa-only.md).

## Remediation

- AirSwap deploys a new SwapERC20 whose order functions take `bytes signature` and verify with a code-first check
  (current OpenZeppelin `SignatureChecker` or solady `isValidSignatureNowCalldata` behind an `extcodesize` check, or
  ERC-7913), so a maker with post-quantum account code is verified only through ERC-1271 with the full signature.
  The owner Safe `0xf8bb149f…` cannot change this contract; only a new deployment helps.
- Makers: revoke token approvals to `0xd82e10b9…` before moving to post-quantum authorisation, or move funds to a
  fresh post-quantum account.
- Protocol: EIP-8151 (make `ecrecover` fail for accounts with real code) would close the ECDSA-first path for
  migrated makers without the team.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review17): HIGH kept, step 4: maker allowances forgeable through ECDSA-first `_check` and ECDSA-only `swapLight` in an immutable contract. Added PQ-3 (ERC-1271 gets 65 bytes) and PQ-1 (`swapLight`); fix layer set to new-deployment; linked the v4 finding.
- 2026-11-19 (study `eip-8151-impact`, reading 3): EIP-8151 as written closes this path for an account that takes
  real code (executed on a real transaction); plain and 7702-delegated accounts stay exposed, and approvals already
  given stay valid.

# Source excerpts: airswap-maker-sig-ecdsa-first

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xd82e10b9a4107939e55fcca9b53a9ede6cf2fc46` — SwapERC20 (verified source via sourcify)

### `contracts/SwapERC20.sol`

```solidity
    1  // SPDX-License-Identifier: MIT
    2  pragma solidity 0.8.23;
    3  
    4  import { ECDSA } from "solady/src/utils/ECDSA.sol";
    5  import { EIP712 } from "solady/src/utils/EIP712.sol";
    6  import { ERC20 } from "solady/src/tokens/ERC20.sol";
    7  import { Ownable } from "solady/src/auth/Ownable.sol";
    8  import { SafeTransferLib } from "solady/src/utils/SafeTransferLib.sol";
    9  import { SignatureCheckerLib } from "solady/src/utils/SignatureCheckerLib.sol";
   10  
   11  import "./interfaces/ISwapERC20.sol";
   12  
   13  /**
  ...
  255      // Ensure the expiry is not passed
  256      if (expiry <= block.timestamp) revert OrderExpired();
  257  
  258      // Recover the signatory from the hash and signature
  259      address signatory = ECDSA.tryRecover(
  260        keccak256(
  261          abi.encodePacked(
  262            "\x19\x01", // EIP191: Indicates EIP712
  263            DOMAIN_SEPARATOR,
  ...
  484        signatory = authorized[signatory];
  485      }
  486  
  487      if (
  488        !SignatureCheckerLib.isValidSignatureNow(
  489          signatory,
  490          _getOrderHash(
  491            order.nonce,
  492            order.expiry,
  ...
  668      }
  669  
  670      // Ensure the signature is correct for the order
  671      if (
  672        !SignatureCheckerLib.isValidSignatureNow(
  673          signatory,
  674          _getOrderHash(
  675            nonce,
  676            expiry,
  ...
```

### `solady/src/tokens/ERC20.sol`

```solidity
  299      /// @dev Sets `value` as the allowance of `spender` over the tokens of `owner`,
  300      /// authorized by a signed approval by `owner`.
  301      ///
  302      /// Emits a {Approval} event.
  303      function permit(
  304          address owner,
  305          address spender,
  306          uint256 value,
  307          uint256 deadline,
  ...
  358                  mstore(0x00, 0xddafbaef) // `InvalidPermit()`.
  359                  revert(0x1c, 0x04)
  360              }
  361              // Increment and store the updated nonce.
  362              sstore(nonceSlot, add(nonceValue, t)) // `t` is 1 if ecrecover succeeds.
  363              // Compute the allowance slot and store the value.
  364              // The `owner` is already at slot 0x20.
  365              mstore(0x40, or(shl(160, _ALLOWANCE_SLOT_SEED), spender))
  366              sstore(keccak256(0x2c, 0x34), value)
  ...
```

Library files with the primitive itself (not excerpted): `solady/src/utils/ECDSA.sol`, `solady/src/utils/SignatureCheckerLib.sol`

# Review reads: airswap-maker-sig-ecdsa-first (2026-11-17, Review17)

- Sourcify full source of `0xd82e10b9a4107939e55fcca9b53a9ede6cf2fc46` (SwapERC20, solc 0.8.23, solady):
  - `swap` / `swapAnySender` -> `_check` (SwapERC20.sol 645-690): `signatory = authorized[signerWallet]` if set, else
    `signerWallet`; `SignatureCheckerLib.isValidSignatureNow(signatory, orderHash, abi.encodePacked(r, s, v))`.
  - solady `SignatureCheckerLib.isValidSignatureNow` (lines 32-92 of the bundled copy): for 64/65-byte signatures it
    calls `ecrecover` first and returns true if it matches `signer`; only otherwise calls ERC-1271
    `isValidSignature(hash, signature)`. No code-length check before `ecrecover`.
  - The ERC-1271 call receives only the 65 bytes `r || s || v` built from the function arguments (PQ-3).
  - `swapLight` (lines 243-325): `ECDSA.tryRecover(hash, v, r, s)` only; signatory must equal `signerWallet` or
    `authorized[signerWallet]`. No ERC-1271 path (PQ-1).
  - Tokens move by `safeTransferFrom(signerToken, signerWallet, recipient, signerAmount)`: the maker's allowance to
    this contract is what a forged order spends.
  - Owner functions (`setProtocolFee`, `setProtocolFeeLight`, `setProtocolFeeWallet`, `setBonusMax`,
    `setBonusScale`, `setStaking`) only; no upgrade or verifier setter.
- On-chain (onchain.json, block 26,431,214): no proxy code; `owner()` = Safe `0xf8bb149f9525875fa47b8cc632d368eb600faba3`
  (2 of 3); ETH 0, tokens ~$0.
- Blockscout `/addresses/0xd82e10b9…/transactions` (2026-11-17): latest direct calls `swap` 2026-10-22 (block
  26,247,248), `swapAnySender` 2026-09-16; creator `0x8b31f79d547f84f0ce7be9e5d1445486289000f9`.
- `data/report/curated_contracts.csv`: txs_y1 252,079 pre-quantum (`ecrecover`) transactions, usd_tx_y1 $187.7M.
- Maker approvals to this contract were not measured (would need every Approval event and current allowance x
  balance per maker).
