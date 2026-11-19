---
id: airswap-v4-maker-sig-ecdsa-only
title: "AirSwap SwapERC20 v4 (0xd82fa167, dormant): a quantum attacker who recovers a maker's ECDSA key can sign orders that spend any approvals makers left on it"
project: airswap
status: confirmed
severity: HIGH
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xd82fa167727a4dc6d6f55830a2c47abbb4b3a0f8"
  implementation: null
  name: SwapERC20 (v4)
  upgradeable: "no"
  admin: "owner Safe 0xf8bb149f9525875fa47b8cc632d368eb600faba3 (2 of 3, block 26431214): fee, rebate and staking settings only; no upgrade path"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-11-17
  txs_30d: 0
families: []
fix:
  layer: account-migration
  who_acts: "makers revoke token approvals to 0xd82fa167 (the contract cannot change; AirSwap has moved to SwapERC20 0xd82e10b9)"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/airswap-v4-maker-sig-ecdsa-only
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
  who: Review17 (full Sourcify source and on-chain reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/airswap-v4-maker-sig-ecdsa-only/review-notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [airswap-maker-sig-ecdsa-first]
---

## Summary

The older AirSwap SwapERC20 (v4) accepts a maker's order only if `ecrecover` returns the maker or the maker's
registered delegate, then pulls the maker's tokens with `transferFrom`. A quantum attacker who recovers a maker's
secp256k1 key could sign orders that spend any allowance the maker left on this contract; a post-quantum maker cannot
use it at all. The contract is immutable, holds nothing, and its order path has not been used since 2025-09-17, so the
rating is LOW (step 1: dormant and holds nothing).

## Mechanism

- `swap`, `swapAnySender` and `swapLight` verify the order with `ECDSA.tryRecover(orderHash, v, r, s)` (`_check`,
  `contracts/SwapERC20.sol` 648-699; `swapLight` 236-330). The result must equal `authorized[signerWallet]` if the maker
  set a delegate with `authorize()`, else `signerWallet`. There is no ERC-1271 path (PQ-1).
- On success `IERC20(signerToken).safeTransferFrom(signerWallet, recipient, signerAmount)` moves the maker's tokens.
- The signer is the maker (an end user or market maker), not a protocol operator: the draft's PQ-4/operator-key
  classification was wrong.

## Evidence

- CHECKED (Sourcify full source, 2026-11-17): `_check`, `swapLight`, the `safeTransferFrom` calls and the owner-only
  setters ([`review-notes.md`](#review-reads-airswap-v4-maker-sig-ecdsa-only-2026-11-17-review17),
  [`source-excerpts.md`](#source-excerpts-airswap-v4-maker-sig-ecdsa-only)).
- CHECKED (on-chain read at block 26,431,214): no proxy; `owner()` = Safe `0xf8bb149f…` (2 of 3); ETH 0, tokens $0
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/airswap-v4-maker-sig-ecdsa-only/onchain.json)).
- CHECKED (precompile trace and Xatu): last `ecrecover` use 2025-09-17; no transactions 2026-10-16 to 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/airswap-v4-maker-sig-ecdsa-only/activity.json)).
- CHECKED (Blockscout transaction list, 2026-11-17): last direct call `cancel` on 2025-11-17, last `swap` 2025-07-16.
- CHECKED (`studies/top-callers-classification/results/curated_contracts.csv`): 20,820 `ecrecover` transactions in the yearly window (`txs_y1`),
  $0.99M transferred in them (`usd_tx_y1`); that window ends before the 12 months used in step 1.
- INFERRED: some makers may still have allowances to this contract; not measured.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xd82fa167…` SwapERC20 (v4) | no | $0 | 2025-11-17 (`cancel`); order path 2025-09-17 | 0 |

The exposure is makers' remaining allowances to `0xd82fa167…`, which were not measured. The current SwapERC20
`0xd82e10b9…` is in [`airswap-maker-sig-ecdsa-first`](airswap-maker-sig-ecdsa-first.md).

## Remediation

- Nothing on this contract can change. Makers who ever traded on it revoke token approvals to `0xd82fa167…`; AirSwap
  can point its makers at that step and remove the contract from its tooling.
- The post-quantum replacement belongs in the current SwapERC20 (see the related finding).

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1 reach: no activity in 12 months (last 2025-09-17) and nothing held).
- 2026-11-17 review (Review17): LOW kept, step 1: order path unused since 2025-09-17 and nothing held. Pattern corrected from PQ-4 (operator key) to PQ-1 (the signer is the maker; ECDSA only); trigger user-key; fix layer account-migration (makers revoke approvals).
- 2026-11-19: LOW -> HIGH, step 1 removed (dormancy no longer lowers a rating); step 4 gives HIGH: users' own funds stay forgeable in a contract that cannot change.

# Source excerpts: airswap-v4-maker-sig-ecdsa-only

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xd82fa167727a4dc6d6f55830a2c47abbb4b3a0f8` — SwapERC20 (verified source via sourcify)

### `contracts/SwapERC20.sol`

```solidity
  250      // Ensure the expiry is not passed
  251      if (expiry <= block.timestamp) revert OrderExpired();
  252  
  253      // Recover the signatory from the hash and signature
  254      (address signatory, ) = ECDSA.tryRecover(
  255        keccak256(
  256          abi.encodePacked(
  257            "\x19\x01", // EIP191: Indicates EIP712
  258            DOMAIN_SEPARATOR,
  ...
  471      order.r = r;
  472      order.s = s;
  473      order.senderWallet = senderWallet;
  474  
  475      address signatory = ecrecover(
  476        _getOrderHash(
  477          order.nonce,
  478          order.expiry,
  479          order.signerWallet,
  ...
  664      // Ensure the expiry is not passed
  665      if (expiry <= block.timestamp) revert OrderExpired();
  666  
  667      // Recover the signatory from the hash and signature
  668      (address signatory, ) = ECDSA.tryRecover(
  669        _getOrderHash(
  670          nonce,
  671          expiry,
  672          signerWallet,
  ...
```

### `@openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol`

```solidity
   32       * For more information on the signature format, see the
   33       * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
   34       * section].
   35       */
   36      function permit(
   37          address owner,
   38          address spender,
   39          uint256 value,
   40          uint256 deadline,
  ...
```

### `@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol`

```solidity
   90          bytes32 r,
   91          bytes32 s
   92      ) internal {
   93          uint256 nonceBefore = token.nonces(owner);
   94          token.permit(owner, spender, value, deadline, v, r, s);
   95          uint256 nonceAfter = token.nonces(owner);
   96          require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
   97      }
   98  
  ...
```

Library files with the primitive itself (not excerpted): `@openzeppelin/contracts/utils/cryptography/ECDSA.sol`, `@openzeppelin/contracts/utils/cryptography/EIP712.sol`

# Review reads: airswap-v4-maker-sig-ecdsa-only (2026-11-17, Review17)

- Sourcify full source of `0xd82fa167727a4dc6d6f55830a2c47abbb4b3a0f8` (SwapERC20, solc 0.8.17, OpenZeppelin):
  - `swap` / `swapAnySender` -> `_check` (SwapERC20.sol 648-699): `ECDSA.tryRecover(orderHash, v, r, s)`; signatory
    must be non-zero and equal `authorized[signerWallet]` if set, else `signerWallet`. No ERC-1271 call anywhere.
  - `swapLight` (lines 236-330): same `ECDSA.tryRecover` check.
  - Then `IERC20(signerToken).safeTransferFrom(signerWallet, recipient, signerAmount)` (lines 137, 205, 303): the
    signer is the maker (end user), whose allowance is spent. The draft's "protocol operator single key" was wrong.
  - `onlyOwner` setters: `setProtocolFee`, `setProtocolFeeLight`, `setProtocolFeeWallet`, `setRebateScale`,
    `setRebateMax`, `setStaking`. No upgrade path.
- On-chain (onchain.json, block 26,431,214): no proxy; `owner()` = Safe `0xf8bb149f9525875fa47b8cc632d368eb600faba3`
  (2 of 3); ETH 0, tokens $0.
- Blockscout `/addresses/0xd82fa167…/transactions` (2026-11-17): latest direct calls `cancel` 2025-11-17 (block
  23,815,951), `swap` 2025-07-16, `swapAnySender` 2025-03-03. Creator `0x3768bec96a282273fe3756a92c4f6d7d06aa289b`.
- Precompile trace: last `ecrecover` use 2025-09-17; none in 2026-03-18 .. 2026-11-16 (activity.json).
- `data/report/curated_contracts.csv`: txs_y1 20,820, usd_tx_y1 $0.99M (window before 2026-03).
