---
id: mimic-price-oracle-signer
title: "Mimic Protocol: a quantum attacker who recovers the single price-signer and relayer-executor key can sign false prices that void the swap-price floor in 50 Mimic smart vaults (about USD 278k)"
project: mimic
status: confirmed
severity: MEDIUM
patterns: [PQ-4, PQ-17]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0xb04b7813bf44fa7bb5c8e8cfc38cd770ffb3ca38"
  implementation: "0xda17f000985b2795b7b6c48384ba877f317e7dc5"
  name: PriceOracle (EIP-1167 clone; smart vault 0x45a6e007c874ffc6321d6fb90eac272dd6864bfa, paraswap-fee-collector-v3)
  upgradeable: config-only
  admin: "Authorizer 0xbbf4362611804c9f7856574889e3a5de6673b08b (setSigner, setFeed); authorize permission held by Safes 0x26a0c29261d18c49e6cf0cee175018274d58f90c (2 of 5) and 0x619bbf92fd6ba59893327676b2685a3762a49a33 (3 of 9)"
  value_usd: 17325
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 1083
families:
- code: "0xda17f000985b2795b7b6c48384ba877f317e7dc5"
  name: Mimic PriceOracle clones (50 deployed by Deployer 0x849b7b1102b0dcf6ec10f98b81c8d1c38f7cbf24, all with signer 0xb3afb6db38a8e72905165c1fbb96772e63560790; value = the other 49 smart vaults)
  instances: 50
  list: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/mimic-price-oracle-signer/escrow.json
  upgradeable: config-only
  value_usd: 260219
  value_basis: escrow
  value_as_of: 2026-11-17
fix:
  layer: new-deployment
  who_acts: "Mimic: deploy a PriceOracle that verifies a post-quantum signature (or no off-chain signer) and repoint each smart vault (setPriceOracle via its Authorizer), or remove signer 0xb3afb6db38a8e72905165c1fbb96772e63560790 with setSigner after configuring feeds; Authorizer admins: Mimic Safe 0x26a0c29261d18c49e6cf0cee175018274d58f90c (2 of 5) on all sampled vaults, plus each client's own admin"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/mimic-price-oracle-signer
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review16 (verified source of PriceOracle and ParaswapV6Swapper; on-chain reads at blocks 26,431,537 and 26,431,656)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/mimic-price-oracle-signer/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families ecf3d535"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
---

## Summary

Mimic smart vaults (fee collectors for Paraswap, Ledger, Exodus, OneKey, Zerion and others) swap and bridge their
tokens through task contracts that take their minimum output from a Mimic PriceOracle. The oracle accepts any price
list signed by one allowed ECDSA key, `0xb3afb6db…`, which is also the EOA that executes the tasks through Mimic's
Relayer (PQ-4). A quantum attacker who recovers that key can sign near-zero prices and run swaps whose output it
captures, across all 50 oracle clones that trust the same signer: the vaults hold about USD 278k (USD 17.3k behind
this finding's oracle `0xb04b7813…`). Rated MEDIUM (step 4): the fix is a new oracle deployment that each vault is
repointed to (or removing the signer after configuring on-chain feeds), done by Mimic's Safe with the clients' admins;
the total exposed is above USD 50k, so step 5 does not lower it.

## Mechanism

- `PriceOracle.getPrice(base, quote, data)` (`contracts/PriceOracle.sol` lines 172–186) calls `_decodePricesData`
  (lines 303–312): `ECDSA.tryRecover(getPricesDigest(prices), signature)` over
  `toEthSignedMessageHash(keccak256(abi.encode(prices)))` (line 137–139) and `isSignerAllowed(recovered)`; if the pair
  is in the signed list and its `deadline` has not passed, the signed `rate` is returned as is. Only when the data is
  absent or malformed does it fall back to `getFeed` on-chain feeds.
- Tasks call it through `BaseTask._getPrice`, passing the caller-appended `extraCallData` as `data`. Swappers
  (e.g. `ParaswapV6Swapper.call`) set `minAmountOut = amountIn * price * (1 - slippage)`; the slippage is capped by
  `defaultMaxSlippage` (2% here), but the price is whatever the signer signed. Relayer-funding, volume-limit and
  bridge-fee checks use the same price.
- Task `call` is restricted by the vault's Authorizer to the Mimic Relayer `0x9e0a5387…`, whose `execute` is open to
  allowed executors; `0xb3afb6db…` is one (CHECKED) and is the same key as the oracle signer. So one key gives both the
  right to run a swap with chosen DEX calldata and the right to set its price floor.
- `setSigner(signer, allowed)` (line 193) and `setFeed` are `authP` through the Authorizer; the clone itself cannot
  be upgraded.

Pattern PQ-4. Source excerpts: [`source-excerpts.md`](#source-excerpts-mimic-price-oracle-signer).

## Evidence

- CHECKED (verified source, Sourcify for implementation `0xda17f000…` and Blockscout for ParaswapV6Swapper
  implementation `0x323d3d6a…`): the code path above.
- CHECKED (precompile trace): ecrecover; `txs_y1` 27,227 (`studies/top-callers-classification/results/curated_contracts.csv`).
- CHECKED (eth_call at block 26,431,537): oracle `getAllowedSigners()` = [`0xb3afb6db…`] (no code), `authorizer()` =
  `0xbbf43626…`, `pivot()` = `0x…0348`; smart vault `0x45a6e007…` `priceOracle()` = this oracle.
- CHECKED (eth_call at block 26,431,656): `getFeed(WETH, USDC)`, `getFeed(USDC, WETH)` and both pivot feeds are zero,
  and `getPrice(WETH, USDC)` without data reverts, so for the main pairs the signed price is the only source (the
  draft's "alternative-exists" was wrong). ParaswapV6Swapper `0xb1490565…` and relayer-funder `0xd4e3ddfc…` serve
  this vault with `defaultMaxSlippage` 2%. Relayer `isExecutorAllowed(0xb3afb6db…)` = true.
- CHECKED (Authorizer event replay, 377 `Authorized`/`Unauthorized` logs from Blockscout): `authorize` on the
  Authorizer is held by Safes `0x26a0c292…` (2 of 5, also admin of the four other vault Authorizers sampled) and
  `0x619bbf92…` (3 of 9); nobody currently holds `setSigner` on the oracle or `setPriceOracle` on the vault, so a
  change needs an admin Safe to grant and use it. ParaswapV6Swapper `call` is granted only to the Relayer.
- CHECKED (transaction `0x61be0760…`, block 26,430,224): `0xb3afb6db…` → Relayer `execute` → swap of the vault's
  cbBTC to USDC, with the oracle called during the swap.
- CHECKED (Deployer `0x849b7b11…` `PriceOracleDeployed` events): 50 oracle clones of `0xda17f000…`, each paired with
  one smart vault; every one has the single allowed signer `0xb3afb6db…` (eth_call at block 26,431,537).
- CHECKED (holdings, remote run: `eth_getBalance` at block 26,431,537 and Blockscout token balances with each token's
  `exchange_rate`, read 2026-11-17; ETH at USD 1,811.62): 50 vaults hold USD 277,544 in total, 27 of them above zero;
  the largest are Paraswap Ltd USD 84.2k, Ledger USD 54.5k, OneKey USD 43.1k, Ledger/1inch USD 27.6k,
  paraswap-fee-collector-v3 (this oracle's vault) USD 17.3k, mostly USDC. Reads:
  [`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/mimic-price-oracle-signer/escrow.json).
- CHECKED (Xatu activity): oracle called in 1,083 transactions in 2026-10-16 to 2026-11-16, last 2026-11-16; the
  implementation 10,820.
- INFERRED: with a forged price the attacker can route the swap through a pool it controls and keep the difference;
  task volume limits and token allow-lists (not read for every vault) may cap a single run, so the vault balances are
  an upper bound.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xb04b7813…` PriceOracle (vault `0x45a6e007…`) | config-only | escrow USD 17,325 | 2026-11-16 | 1,083 |
| 49 other clones of `0xda17f000…` (same signer) | config-only | escrow USD 260,219 (their vaults) | — | — |

- Escrow: the Mimic smart vaults that use these oracles; USD 277,544 in total at block 26,431,537 (per-vault list in
  `escrow.json`).
- The draft listed 29 instances of the family; the Deployer's events show 50, all on the same signer key.
- Bridger and relayer-funding tasks use the same price; their extra exposure (Relayer deposit of this vault: 0.123 ETH)
  is small.

## Remediation

- Mimic deploys a PriceOracle that verifies a post-quantum signature over the price list (or relies only on
  on-chain feeds), and each vault's Authorizer admin calls `setPriceOracle` on the vault; or, with feeds configured
  through `setFeed`, removes `0xb3afb6db38a8e72905165c1fbb96772e63560790` via `setSigner(…, false)` on each oracle.
  Acting parties: Mimic Safe `0x26a0c29261d18c49e6cf0cee175018274d58f90c` (2 of 5), Safe
  `0x619bbf92fd6ba59893327676b2685a3762a49a33` for this vault, and each client's admin where required.
- Move the Relayer executor role and the signer to separate post-quantum accounts.
- No protocol change is needed; vault owners can withdraw idle balances to accounts they control.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review16): MEDIUM -> MEDIUM, step 4: fix is a new oracle deployment the vaults are repointed to, by Mimic's Safe and clients' admins; escrow measured (50 vaults, USD 277,544, so step 5 does not apply); alternative changed from alternative-exists to configurable-verifier (no on-chain feeds set for the main pairs), role auxiliary -> core (the price is the swap floor), admin set to the Authorizer and its Safes, family instances 29 -> 50.
- 2026-11-19 (study `eip-8151-impact`, PQ-17): under EIP-8151 the signer key can be replaced; it must be rotated before its account takes code.

# Source excerpts: mimic-price-oracle-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xb04b7813bf44fa7bb5c8e8cfc38cd770ffb3ca38`

No verified source on Sourcify or Blockscout.

## Implementation `0xda17f000985b2795b7b6c48384ba877f317e7dc5` — PriceOracle (verified source via sourcify)

### `contracts/PriceOracle.sol`

```solidity
   16  
   17  import '@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol';
   18  
   19  import '@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol';
   20  import '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';
   21  import '@openzeppelin/contracts/utils/math/SafeCast.sol';
   22  import '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';
   23  import '@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol';
   24  
  ...
  134       * @dev Tells the digest expected to be signed by the off-chain oracle signers for a list of prices
  135       * @param prices List of prices to be signed
  136       */
  137      function getPricesDigest(PriceData[] memory prices) public pure override returns (bytes32) {
  138          return ECDSA.toEthSignedMessageHash(keccak256(abi.encode(prices)));
  139      }
  140  
  141      /**
  142       * @dev Tells the price of a token (base) in a given quote. The response is expressed using the corresponding
  ...
  303      function _decodePricesData(bytes memory data) internal view returns (PriceData[] memory) {
  304          if (!_isOffChainDataEncodedProperly(data)) return new PriceData[](0);
  305  
  306          (PriceData[] memory prices, bytes memory signature) = abi.decode(data, (PriceData[], bytes));
  307          (address recovered, ECDSA.RecoverError error) = ECDSA.tryRecover(getPricesDigest(prices), signature);
  308  
  309          bool isSignerValid = error == ECDSA.RecoverError.NoError && isSignerAllowed(recovered);
  310          if (!isSignerValid) revert PriceOracleInvalidSigner(recovered);
  311          return prices;
  312      }
  313  
  ...
```

Library files with the primitive itself (not excerpted): `@openzeppelin/contracts/utils/cryptography/ECDSA.sol`
