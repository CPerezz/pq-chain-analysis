---
id: aave-atoken-permit-ecdsa-only
title: "Aave v3: a quantum attacker who recovers a holder's ECDSA key can sign an EIP-2612 permit and take that holder's aTokens in 11 Ethereum-core markets (USD 18.84B supply), even after the holder migrates"
project: aave
status: confirmed
severity: MEDIUM
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: auxiliary
contracts:
- address: "0x4d5f47fa6a74757f35c14fd3a6ef8e3c9bc514e8"
  implementation: "0xadc45df3cf1584624c97338bef33363bf5b97ada"
  name: aEthWETH (AToken proxy)
  upgradeable: "yes"
  admin: "PoolConfigurator 0x64b761d848206f447fe2dd461b0c635ec39ebb27 (immutable proxy admin, address in proxy bytecode) under Aave Governance V3 Executor 0x5300a1a15135ea4dc7ad5a167152c01efc9b192a (read at block 26431537)"
  value_usd: 3854239607
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 54087
- address: "0x23878914efe38d27c4d67ab83ed1b93a74d4086a"
  implementation: "0xadc45df3cf1584624c97338bef33363bf5b97ada"
  name: aEthUSDT (AToken proxy)
  upgradeable: "yes"
  admin: "PoolConfigurator 0x64b761d848206f447fe2dd461b0c635ec39ebb27 (immutable proxy admin, address in proxy bytecode) under Aave Governance V3 Executor 0x5300a1a15135ea4dc7ad5a167152c01efc9b192a (read at block 26431537)"
  value_usd: 2895507739
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 42506
- address: "0x5c647ce0ae10658ec44fa4e11a51c96e94efd1dd"
  implementation: "0xadc45df3cf1584624c97338bef33363bf5b97ada"
  name: aEthcbBTC (AToken proxy)
  upgradeable: "yes"
  admin: "PoolConfigurator 0x64b761d848206f447fe2dd461b0c635ec39ebb27 (immutable proxy admin, address in proxy bytecode) under Aave Governance V3 Executor 0x5300a1a15135ea4dc7ad5a167152c01efc9b192a (read at block 26431537)"
  value_usd: 1382868622
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 7856
families:
- code: "0xadc45df3cf1584624c97338bef33363bf5b97ada"
  name: Other Aave v3 aToken proxies on the same ATokenInstance implementation (cluster 1)
  instances: 51
  list: docs/lookup (any address can be checked on the site)
  upgradeable: "yes"
  value_usd: null
  value_basis: null
  value_as_of: null
- code: "0xadc45df3cf1584624c97338bef33363bf5b97ada"
  name: Other Aave v3 aToken proxies on the same ATokenInstance implementation (cluster 2)
  instances: 6
  list: docs/lookup (any address can be checked on the site)
  upgradeable: "yes"
  value_usd: null
  value_basis: null
  value_as_of: null
fix:
  layer: contract-upgrade
  who_acts: "Aave governance (Governance V3 Executor 0x5300a1a15135ea4dc7ad5a167152c01efc9b192a, owner PayloadsController 0xdabad81af85554e9ae636395611c58f7ec1aaec5) calls PoolConfigurator 0x64b761d848206f447fe2dd461b0c635ec39ebb27 updateAToken with a permit (and, for aEthAAVE, metaDelegate) that checks account code first"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aave-atoken-permit-ecdsa-only
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_2.jsonl,out_3.jsonl,out_4.jsonl,out_5.jsonl
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
related: [cow-aave-adapter-order-code-first, ghotoken-40d16fc0-permit-ecdsa-only]
---

## Summary

Eleven Aave v3 Ethereum-core aTokens accept EIP-2612 `permit` only through `ecrecover` (PQ-1). A quantum attacker
who recovers a holder's key from any on-chain signature can sign a permit for that holder, then `transferFrom` the
aTokens and redeem them; this keeps working after the holder moves to post-quantum authorisation at the same address.
Exposure is the holders' balances: USD 18.84B of supply at block 26,431,537, an upper bound. Post-quantum accounts can
still use on-chain `approve`. Rated MEDIUM: step 4 (one Aave governance payload upgrades every aToken implementation
through the PoolConfigurator).

## Mechanism

- aTokens (implementation `ATokenInstance` `0xadc45df3…`, aave-v3-origin): `AToken.permit(owner, spender, value,
  deadline, v, r, s)` builds the EIP-712 digest and requires `owner == ECDSA.recover(digest, v, r, s)` (AToken.sol
  lines 162-182), then sets the allowance; no ERC-1271 path, no code check.
- aEthAAVE (implementation `ATokenWithDelegationInstance` `0x38769a7d…`): the same `permit`, plus
  `BaseDelegation.metaDelegateByType` and `metaDelegate` require `delegator == ECDSA.recover(…)` (BaseDelegation.sol
  lines 170 and 195), so a forged key also moves the holder's Aave governance voting and proposition power.
- What it releases: the allowance lets the attacker `transferFrom` the holder's aTokens, redeemable for the underlying
  through the Pool.
- Pattern PQ-1; excerpts in [`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aave-atoken-permit-ecdsa-only/source-excerpts.md).

## Evidence

- CHECKED (verified source on Sourcify, via the excerpts): the permit and delegation lines above for implementations
  `0xadc45df3…` and `0x38769a7d…` (aEthLINK runs the verified `0xadc45df3…` implementation; its proxy is not itself
  verified).
- CHECKED (`eth_getStorageAt` at block 26,431,537): EIP-1967 implementation slot of each aToken proxy as listed. The
  proxies are `InitializableImmutableAdminUpgradeabilityProxy`, whose admin is an immutable: the PoolConfigurator
  address `0x64b761d8…` appears in all 11 proxies' bytecode.
- CHECKED (`cast call` at block 26,431,537): `POOL()` `0x87870bca…` → `ADDRESSES_PROVIDER()` `0x2f39d218…` →
  `getPoolConfigurator()` `0x64b761d8…`; `owner()` and `getACLAdmin()` of the provider = `0x5300a1a1…` (Blockscout:
  Executor), whose `owner()` is `0xdabad81a…`.
- CHECKED (`totalSupply()`/`decimals()` at block 26,431,537, prices from Blockscout `exchange_rate` of the underlying on
  2026-11-17): the table below ([`supply.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aave-atoken-permit-ecdsa-only/supply.json)).
- CHECKED (precompile trace, year to March 2026): `ecrecover` calls per contract, e.g. aEthWETH 29,250, aEthUSDC
  16,249, aEthUSDT 14,935, aEthWBTC 11,919 (`curated_contracts.csv`, `txs_y1`).
- CHECKED (Xatu, any function, 2026-10-16 to 2026-11-16): 30-day transactions and last activity in the table
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aave-atoken-permit-ecdsa-only/activity.json)).
- INFERRED: only holders whose public key is on-chain can be forged; holders that are contracts (Safes, vaults) are not
  exposed through permit at all.
- CHECKED (executed, study `eip-8151-impact`, 2026-11-19): a real transaction,
  `0xa90756933220d993ddcdcc423199ad77b775f6e44996907d43b4f018335e5a3b` (block 26,420,588, position 2), replayed on
  the reference implementation of the fork with only the precompile changed. Under today's rule it matches its
  receipt (736,680 gas); under EIP-8151 it also succeeds (743,080 gas). With one byte of code at the recovered signer
  `0xef3cb25c9c0ea0fffa82c78dd1c431cd23a49318`, it reverts after that recovery returned no address; with a 7702
  delegation there it succeeds. Study family `f346a7e0` (ATokenWithDelegationInstance).

## Impact and exposure

| Contract | Upgradeable | Supply × price (market cap, upper bound) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x4d5f47fa…` aEthWETH (AToken proxy) | yes | 2,123,887 × $1,814.71 = $3.85B | 2026-11-16 | 54,087 |
| `0x98c23e9d…` aEthUSDC (AToken proxy) | yes | 2,783,450,870 × $0.999622 = $2.78B | 2026-11-16 | 56,697 |
| `0x23878914…` aEthUSDT (AToken proxy) | yes | 2,897,553,412 × $0.999294 = $2.90B | 2026-11-16 | 42,506 |
| `0x5ee5bf7a…` aEthWBTC (AToken proxy) | yes | 34,844 × $64,633 = $2.25B | 2026-11-16 | 27,233 |
| `0x5e8c8a72…` aEthLINK (AToken proxy) | yes | 7,519,946 × $9.1 = $68.4M | 2026-11-16 | 3,484 |
| `0xa700b4eb…` aEthAAVE (ATokenWithDelegation proxy) | yes | 804,556 × $108.42 = $87.2M | 2026-11-15 | 4,818 |
| `0x0b925ed1…` aEthwstETH (AToken proxy) | yes | 854,774 × $2,265.04 = $1.94B | 2026-11-16 | 7,150 |
| `0x5c647ce0…` aEthcbBTC (AToken proxy) | yes | 21,398 × $64,625.0 = $1.38B | 2026-11-16 | 7,856 |
| `0x4f5923fc…` aEthUSDe (AToken proxy) | yes | 616,726,003 × $0.999341 = $616.3M | 2026-11-16 | 1,869 |
| `0x4579a27a…` aEthsUSDe (AToken proxy) | yes | 209,983,090 × $1.26 = $264.6M | 2026-11-15 | 766 |
| `0xbdfa7b78…` aEthweETH (AToken proxy) | yes | 1,345,250 × $2,009.37 = $2.70B | 2026-11-16 | 1,893 |

Total $18.84B at block 26,431,537. The draft's `held` values (underlying sitting in the aToken contracts, i.e.
unborrowed liquidity) were not the exposure and were replaced by supply. GhoToken, grouped here in the draft, is now
`gho-token-permit-ecdsa-only` (no proxy, rated HIGH).

Siblings: 57 other proxies run the same `0xadc45df3…` implementation (other Aave v3 aTokens); they share the
mechanism and the governance fix and are not measured here.

## Remediation

- Post-quantum replacement: a permit that checks whether `owner` has code and then calls ERC-1271 with the full
  signature (OpenZeppelin `SignatureChecker`, PQ-13 behaviour), or ERC-7913 verification; the same for
  `metaDelegate*` on aEthAAVE.
- aTokens: one Aave governance payload executed by the Executor `0x5300a1a1…` calling
  `PoolConfigurator.updateAToken` for each reserve (no protocol change needed).
- Users: post-quantum accounts use `approve` instead of permit; holders who migrate should move balances to an address
  whose old ECDSA key was never exposed until the contract or the protocol changes.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by upgrading the contract (admin or governance)).
- 2026-11-17 review (Review20): MEDIUM -> HIGH, step 4: GhoToken `0x40d16fc0…` has no proxy (no EIP-1967 slots, no
  admin over `permit`), so holders' GHO stays forgeable after migration in a contract that cannot change; the 11 aTokens
  alone stay MEDIUM (governance upgrade via PoolConfigurator `0x64b761d8…`). Exposure replaced by `totalSupply` ×
  price per token at block 26,431,537 ($19.54B; draft mixed `held` and zero market caps); `alternative` sole ->
  alternative-exists (on-chain `approve` is open to post-quantum accounts; it does not stop forging).
- 2026-11-17 review (Review20): HIGH -> MEDIUM, step 4: GhoToken `0x40d16fc0…` moved to `gho-token-permit-ecdsa-only`
  (rated HIGH there); the remaining 11 aTokens are fixed by one governance upgrade through PoolConfigurator
  `0x64b761d8…`. Exposure now $18.84B (aTokens only).
- 2026-11-19 (study `eip-8151-impact`, reading 3): EIP-8151 as written closes this path for an account that takes
  real code (executed on a real transaction); plain and 7702-delegated accounts stay exposed, and approvals already
  given stay valid.
