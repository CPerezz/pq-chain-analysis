---
id: gho-token-permit-ecdsa-only
title: "GHO: a quantum attacker who recovers a holder's ECDSA key can sign an EIP-2612 permit and take that holder's GHO (USD 698M supply), even after the holder migrates; the token cannot be upgraded"
project: aave
status: confirmed
severity: HIGH
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: auxiliary
contracts:
- address: "0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f"
  implementation: null
  name: GhoToken (GHO)
  upgradeable: "no"
  admin: "none over permit (no proxy); DEFAULT_ADMIN_ROLE (facilitators, buckets) held by Aave Governance V3 Executor 0x5300a1a15135ea4dc7ad5a167152c01efc9b192a (read at block 26431537)"
  value_usd: 697792827
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 19366
families: []
fix:
  layer: account-migration
  who_acts: "nobody can change GhoToken 0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f; holders move GHO to fresh post-quantum addresses, or Aave governance (Executor 0x5300a1a15135ea4dc7ad5a167152c01efc9b192a) migrates GHO to a new token; EIP-8151 would protect migrated accounts with code"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gho-token-permit-ecdsa-only
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_2.jsonl,out_3.jsonl,out_4.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: [aave-atoken-permit-ecdsa-only]
---

## Summary

Aave's GHO stablecoin accepts EIP-2612 `permit` only through `ecrecover` (PQ-1). A quantum attacker who recovers a
holder's key from any on-chain signature can sign a permit for that holder and `transferFrom` the balance, and this
keeps working after the holder moves to post-quantum authorisation at the same address. GhoToken has no proxy, so
the check can never change. Exposure is holders' balances, USD 698M of supply at block 26,431,537 (an upper bound).
Rated HIGH: step 4 (users' funds stay forgeable in a contract that cannot change; only every holder moving, a token
migration, or EIP-8151 protects them).

## Mechanism

- `permit(owner, spender, value, deadline, v, r, s)` in gho-core `ERC20.sol` (lines 107-133) builds the EIP-712
  digest, sets `recoveredAddress = ecrecover(digest, v, r, s)`, requires it to be non-zero and equal to `owner`, and
  writes `allowance[owner][spender] = value`; no ERC-1271 path and no code check.
- What it releases: the allowance lets the attacker `transferFrom` the holder's GHO.
- Pattern PQ-1; excerpt in [`source-excerpts.md`](#source-excerpts-gho-token-permit-ecdsa-only).

## Evidence

- CHECKED (verified source on Sourcify, via the excerpt): the lines above.
- CHECKED (on-chain read at block 26,431,214 and `eth_getStorageAt` at block 26,431,537): plain contract, 8,046 bytes,
  no EIP-1967 implementation or admin slot ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gho-token-permit-ecdsa-only/onchain.json)).
- CHECKED (`cast call` at block 26,431,537): `hasRole(DEFAULT_ADMIN_ROLE, 0x5300a1a1…)` true (Aave Governance V3
  Executor, `owner()` `0xdabad81a…`); that role manages facilitators, not `permit`.
- CHECKED (`totalSupply()` at block 26,431,537): 699,000,000 GHO × $0.998273 (Blockscout `exchange_rate`,
  2026-11-17) = $697.8M ([`supply.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gho-token-permit-ecdsa-only/supply.json)).
- CHECKED (precompile trace): 20,448 `ecrecover` calls in the year to March 2026 (`curated_contracts.csv`, `txs_y1`).
- CHECKED (Xatu, any function): 19,366 transactions in 2026-10-16 to 2026-11-16, last 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gho-token-permit-ecdsa-only/activity.json)).
- INFERRED: part of the supply sits in contracts (facilitators, pools, Safes), which cannot be forged through permit;
  only holders whose public key is on-chain are exposed.

## Impact and exposure

| Contract | Upgradeable | Supply × price (market cap, upper bound) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x40d16fc0…` GhoToken (GHO) | no | 699,000,000 × $0.998273 = $697.8M | 2026-11-16 | 19,366 |

GhoToken itself holds $20k of GHO (block 26,431,214), which is not the exposure.

## Remediation

- Post-quantum replacement: a permit that checks account code first and calls ERC-1271 with the full signature
  (PQ-13 behaviour), or ERC-7913; impossible in this contract.
- Who acts: holders who migrate should move GHO to an address whose ECDSA key was never exposed; Aave governance
  (Executor `0x5300a1a1…`) could migrate GHO to an upgradeable or post-quantum-aware token.
- Protocol change: helps. EIP-8151 would make `ecrecover` fail for migrated accounts with code.
- Post-quantum accounts can use on-chain `approve` instead of permit.

## History

- 2026-11-04: classified from verified source (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`), grouped into
  `aave-atoken-permit-ecdsa-only`.
- 2026-11-17 review (Review20): split out of `aave-atoken-permit-ecdsa-only` (same mechanism, different fix: no
  proxy). Rated HIGH, step 4: holders' GHO stays forgeable after migration in a contract that cannot change; exposure
  `totalSupply` × price at block 26,431,537 ($697.8M, market cap); `alternative` alternative-exists (on-chain
  `approve`).

# Source excerpts: gho-token-permit-ecdsa-only

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f` — GhoToken (verified source via sourcify)

### `lib/gho-core/src/contracts/gho/ERC20.sol`

```solidity
  103    /*///////////////////////////////////////////////////////////////
  104                                EIP-2612 LOGIC
  105      //////////////////////////////////////////////////////////////*/
  106  
  107    function permit(
  108      address owner,
  109      address spender,
  110      uint256 value,
  111      uint256 deadline,
  ...
  125            keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
  126          )
  127        );
  128  
  129        address recoveredAddress = ecrecover(digest, v, r, s);
  130  
  131        require(recoveredAddress != address(0) && recoveredAddress == owner, 'INVALID_SIGNER');
  132  
  133        allowance[recoveredAddress][spender] = value;
  ...
```


