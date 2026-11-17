---
id: curve-stableswap-ng-permit
title: "Curve stableswap-ng USD0/USD0++ pool (0x1d08e7ad): LP-token permit passes only 65 bytes to ERC-1271, so post-quantum accounts cannot use it; nothing forgeable"
project: curve
status: confirmed
severity: LOW
patterns: [PQ-3]
primitives: [ecrecover]
trigger: none
impact: liveness
alternative: alternative-exists
role: auxiliary
contracts:
- address: "0x1d08e7adc263cfc70b1babe6dc5bb339c16eec52"
  implementation: null
  name: CurveStableSwapNG (USD0/USD0++ pool and LP token)
  upgradeable: "no"
  admin: "factory 0x6a8cbed756804b16e05e741edabd5cb544ae21bf admin 0xeda0108d5bb8cde2ba4a59e22f3ed5d211c77187: A, fee and oracle parameters only; permit cannot change"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 202
families: []
fix:
  layer: new-deployment
  who_acts: "Curve (stableswap-ng factory 0x6a8cbed756804b16e05e741edabd5cb544ae21bf, admin 0xeda0108d5bb8cde2ba4a59e22f3ed5d211c77187) ships a pool implementation whose permit takes bytes signatures; LPs use approve() meanwhile"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/curve-stableswap-ng-permit
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review17 (Sourcify Vyper source and on-chain reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/curve-stableswap-ng-permit/review-notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

The pool's LP token `permit` checks account code first: contract owners go to ERC-1271, code-less owners to
`ecrecover`. But the ERC-1271 call carries only a 65-byte `(r, s, v)` signature (PQ-3), so a post-quantum account
cannot sign an LP permit, while nothing is forgeable beyond each address's own key. Holders can still use `approve()`,
and the permit is an auxiliary feature of a swap pool. Rated LOW (step 4: auxiliary feature through which nothing can
be taken); the earlier NONE did not account for the 65-byte limit.

## Mechanism

- `permit(_owner, _spender, _value, _deadline, _v, _r, _s)` (`CurveStableSwapNG.vy` 1622-1668): if
  `_owner.is_contract`, it packs `(r, s, v)` into `Bytes[65]` and requires
  `ERC1271(_owner).isValidSignature(digest, sig) == 0x1626ba7e`; otherwise `ecrecover(digest, v, r, s) == _owner`.
  It then sets `allowance[_owner][_spender]`.
- The `ERC1271` interface is declared with `_signature: Bytes[65]` (line 68), and the external function takes
  `uint8, bytes32, bytes32`: a post-quantum signature (0.7–17 KB) cannot be passed.
- A migrated account with code is never sent to `ecrecover` here, so its old key cannot forge a permit (the part that
  made the draft PQ-13).

## Evidence

- CHECKED (Sourcify full match, Vyper 0.3.10, 2026-11-17): `permit`, the `ERC1271` interface and the admin functions
  (`ramp_A`, `stop_ramp_A`, `set_new_fee`, `set_ma_exp_time`, gated on `factory.admin()`)
  ([`review-notes.md`](#review-reads-curve-stableswap-ng-permit-2026-11-17-review17),
  [`source-excerpts.md`](#source-excerpts-curve-stableswap-ng-permit)).
- CHECKED (on-chain read at block 26,431,214): plain contract, no proxy; holds BUSD0 and USD0 worth $266k
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/curve-stableswap-ng-permit/onchain.json)).
- CHECKED (latest block, 2026-11-17): LP `totalSupply()` 267,503 at virtual price 1.011; factory admin
  `0xeda0108d…`.
- CHECKED (Xatu, any function): 202 transactions 2026-10-16 to 2026-11-16, last 2026-11-15
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/curve-stableswap-ng-permit/activity.json)); 8 `ecrecover` transactions in the yearly
  window (`studies/top-callers-classification/results/curated_contracts.csv`).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x1d08e7ad…` CurveStableSwapNG | no | $266k (pool reserves, not exposed) | 2026-11-15 | 202 |

Nothing can be taken through `permit` beyond what an address's own key already controls; the effect is that
post-quantum LP holders must use `approve()` instead. The $266k of pool reserves is not exposed by this check, so
`value_usd` is null. Other stableswap-ng pools share this `permit` code but were not part of this finding.

## Remediation

- Curve: a pool implementation whose `permit` takes `bytes signature` and forwards it unchanged to ERC-1271 (or uses
  ERC-7913). Existing pools cannot change; the factory admin `0xeda0108d…` can only add a new implementation for new
  pools.
- LP holders with post-quantum accounts: use `approve()` (an on-chain transaction) instead of `permit`.
- No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated NONE (code checked first: no exposure beyond the account's own key).
- 2026-11-17 review (Review17): NONE -> LOW, step 4: the ERC-1271 path is limited to `Bytes[65]`, so this is PQ-3 (post-quantum accounts locked out of LP `permit`), not PQ-13; the feature is auxiliary and `approve()` remains, so nothing can be taken. Status not-affected -> confirmed; held value removed (pool reserves are not the exposure).

# Source excerpts: curve-stableswap-ng-permit

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x1d08e7adc263cfc70b1babe6dc5bb339c16eec52` — CurveStableSwapNG (verified source via sourcify)

### `CurveStableSwapNG.vy`

```solidity
   64      def admin() -> address: view
   65      def views_implementation() -> address: view
   66  
   67  interface ERC1271:
   68      def isValidSignature(_hash: bytes32, _signature: Bytes[65]) -> bytes32: view
   69  
   70  interface StableSwapViews:
   71      def get_dx(i: int128, j: int128, dy: uint256, pool: address) -> uint256: view
   72      def get_dy(i: int128, j: int128, dx: uint256, pool: address) -> uint256: view
  ...
  219  allowance: public(HashMap[address, HashMap[address, uint256]])
  220  total_supply: uint256
  221  nonces: public(HashMap[address, uint256])
  222  
  223  # keccak256("isValidSignature(bytes32,bytes)")[:4] << 224
  224  ERC1271_MAGIC_VAL: constant(bytes32) = 0x1626ba7e00000000000000000000000000000000000000000000000000000000
  225  EIP712_TYPEHASH: constant(bytes32) = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)")
  226  EIP2612_TYPEHASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
  227  
  ...
 1619      return True
 1620  
 1621  
 1622  @external
 1623  def permit(
 1624      _owner: address,
 1625      _spender: address,
 1626      _value: uint256,
 1627      _deadline: uint256,
  ...
 1658  
 1659      if _owner.is_contract:
 1660          sig: Bytes[65] = concat(_abi_encode(_r, _s), slice(convert(_v, bytes32), 31, 1))
 1661          # reentrancy not a concern since this is a staticcall
 1662          assert ERC1271(_owner).isValidSignature(digest, sig) == ERC1271_MAGIC_VAL
 1663      else:
 1664          assert ecrecover(digest, convert(_v, uint256), convert(_r, uint256), convert(_s, uint256)) == _owner
 1665  
 1666      self.allowance[_owner][_spender] = _value
 1667      self.nonces[_owner] = unsafe_add(nonce, 1)
 1668  
  ...
```

# Review reads: curve-stableswap-ng-permit (2026-11-17, Review17)

- Sourcify (match, Vyper 0.3.10) `CurveStableSwapNG.vy` for `0x1d08e7adc263cfc70b1babe6dc5bb339c16eec52`:
  - line 67-68: `interface ERC1271: def isValidSignature(_hash: bytes32, _signature: Bytes[65]) -> bytes32: view`
  - `permit(_owner, _spender, _value, _deadline, _v, _r, _s)` (lines 1622-1668): if `_owner.is_contract`, builds
    `sig: Bytes[65] = concat(_abi_encode(_r, _s), slice(convert(_v, bytes32), 31, 1))` and requires
    `ERC1271(_owner).isValidSignature(digest, sig) == ERC1271_MAGIC_VAL`; else `ecrecover(digest, v, r, s) == _owner`.
    Code is checked first, but the ERC-1271 path can only carry 65 bytes (PQ-3).
  - Admin functions (`ramp_A`, `stop_ramp_A`, `set_new_fee`, `set_ma_exp_time`) require `msg.sender ==
    factory.admin()`; none touches `permit`. `factory` is an immutable set at deployment.
- Blockscout: creator (factory) `0x6a8cbed756804b16e05e741edabd5cb544ae21bf`; `admin()` of that factory =
  `0xeda0108d5bb8cde2ba4a59e22f3ed5d211c77187` (read 2026-11-17, latest block).
- Pool `name()` = "USD0/USD0++"; `totalSupply()` = 267,503.0 LP; `get_virtual_price()` = 1.0111 (latest block,
  2026-11-17), i.e. about $270k of LP tokens in total.
- `data/report/curated_contracts.csv`: 8 transactions with an `ecrecover` call in the yearly window.
