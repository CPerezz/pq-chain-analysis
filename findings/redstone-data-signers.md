---
id: redstone-data-signers
title: "RedStone: forging 3 of 5 node ECDSA keys plus one updater EOA key pushes arbitrary prices into the mainnet multi-feed adapter that lending markets read"
project: redstone
status: confirmed
severity: MEDIUM
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xd72a6ba4a87ddb33e801b3f1c7750b2d0911fc6c"
  implementation: "0x0c6c73865429e1d87b7b817b95bb1f38f2136529"
  name: EthereumMultiFeedAdapterWithoutRoundsV3 (TransparentUpgradeableProxy)
  upgradeable: "yes"
  admin: ProxyAdmin 0x8223a6271d1e0bda019ee55d545d7b86eff1f573, owned by Safe 0x6906f3a09bcc1b7cd3b0c8626724299618df4472 (2 of 3, read at block 26,431,562); signers and threshold are constants of the implementation
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 38538
families: []
fix:
  layer: contract-upgrade
  who_acts: RedStone; Safe 0x6906f3a09bcc1b7cd3b0c8626724299618df4472 (2 of 3) upgrades the proxy through ProxyAdmin 0x8223a6271d1e0bda019ee55d545d7b86eff1f573 to an implementation that verifies post-quantum node signatures, and RedStone's nodes sign with post-quantum keys
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/redstone-data-signers
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review02 (registry review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/redstone-data-signers/proxy-family-impls.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

RedStone's mainnet multi-feed adapter stores prices pushed in transactions that carry data packages signed by
RedStone's oracle nodes; it accepts a value when 3 of 5 hard-coded node addresses signed it, checked with `ecrecover`
(PQ-5). The node keys' public keys are exposed by their signatures in calldata, so a quantum attacker who recovers
three of them, plus the key of one whitelisted updater EOA that submits the update, can push any price for any feed,
and protocols that read these feeds (lending markets, vaults) can be drained through mispriced collateral. Those
consumers and their value were not measured. The adapter is a
TransparentUpgradeableProxy whose ProxyAdmin is owned by a 2-of-3 Safe, so RedStone can replace the verification by
upgrade: MEDIUM (step 4).

## Mechanism

- `updateDataFeedsValuesPartial(bytes32[] dataFeedsIds)` → `getOracleNumericValuesAndTimestampFromTxMsg`
  (RedstoneConsumerBase) parses the data packages appended to calldata; for each package `SignatureLib.recoverSignerAddress`
  calls `ecrecover(signedHash, v, r, s)` (`SignatureLib.sol` line 27) and `getAuthorisedSignerIndex` maps the signer to
  one of five constant addresses (`MultiFeedAdapterWithoutRoundsPrimaryProd.sol`); values need
  `getUniqueSignersThreshold()` = 3 distinct signers, then `_tryToUpdateDataFeed` stores the median.
- `_validateBlockTimestamp` in V3 (`EthereumMultiFeedAdapterWithoutRoundsV3.sol`) returns true only when
  `msg.sender` is one of the constant updaters (`MAIN_UPDATER_ADDRESS` `0x6809b956…`, `FALLBACK_UPDATER_ADDRESS`
  `0x12c88f64…`, `MANUAL_UPDATER_ADDRESS` `0x9e7caab1…`, or the Gelato addresses); otherwise the update is skipped.
  A forger therefore also needs one updater key; the three constant updaters are EOAs (no code; nonces 445,911,
  16,721 and 37 at the latest block on 2026-11-17), so a quantum attacker recovers their keys the same way.
- Consumers read `getValueForDataFeed` / `priceOf`.
- Excerpts: [`source-excerpts.md`](#source-excerpts-redstone-data-signers).

## Evidence

- CHECKED (verified source, Sourcify, implementation `0x0c6c7386…`): the path above; the five signer addresses
  (`0x8bb8f32d…`, `0xdeb22f54…`, `0x51ce04be…`, `0xdd682dae…`, `0x9c5ae89c…`) and the threshold 3 are constants.
- CHECKED (on-chain read at block 26,431,562): EIP-1967 implementation = `0x0c6c7386…`, admin = ProxyAdmin
  `0x8223a627…`, whose `owner()` is Safe `0x6906f3a0…` with threshold 2 of 3 owners; `getUniqueSignersThreshold()` = 3.
- CHECKED (on-chain read at block 26,431,214, [`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/redstone-data-signers/onchain.json)): the
  adapter holds nothing.
- CHECKED (Xatu, [`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/redstone-data-signers/activity.json)): 38,538 transactions
  2026-10-16 to 2026-11-16 (29,682 direct); 186,100 pre-quantum transactions in the last year (`txs_y1`,
  `studies/top-callers-classification/results/curated_contracts.csv`).
- CHECKED (EIP-1967 slots of 319 proxies at block 26,431,454 plus Blockscout names,
  [`proxy-family-impls.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/redstone-data-signers/proxy-family-impls.json)): the draft's 148-instance
  family was proxies sharing generic TransparentUpgradeableProxy code, with 261 different implementations; only this
  address runs the multi-feed adapter.
- INFERRED: consumers use these prices to value collateral; not enumerated.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xd72a6ba4…` EthereumMultiFeedAdapterWithoutRoundsV3 | yes | — | 2026-11-16 | 38,538 |

Exposure: the value in protocols that price assets with these feeds; not measured (it needs the list of consumer
contracts and what they lend against these prices), so `value_usd` is null.

Siblings: 21 other proxies under the same ProxyAdmin `0x8223a627…` run RedStone price-feed adapters and feeds (for
example `0x19219bc9…` MergedAdapterWithRoundsApxethethV1, `0x8751f736…` EthereumPriceFeedWeethethWithoutRoundsV1,
`0x1b9b4b67…` PriceFeedsAdapterWithoutRoundsUsdeSusdeV2, `0x17350e84…` PriceFeedsAdapterVenusMainnetXvsV2; full list
in `proxy-family-impls.json`). They are not in the census contracts list and were not read; the adapters among them
likely use the same signer check and the same admin.

## Remediation

- Replacement: an implementation whose `getAuthorisedSignerIndex` path verifies post-quantum node signatures
  (ML-DSA or hash-based) or a succinct hash-based proof over the nodes' attestations, with RedStone's nodes signing
  with post-quantum keys.
- Who acts: RedStone. Safe `0x6906f3a0…` (2 of 3) upgrades through ProxyAdmin `0x8223a627…`; the same applies to the
  sibling adapters. No protocol change is needed.
- Consumers: add bounds or a second, independently secured source for critical feeds.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review02): MEDIUM unchanged, step 4: upgrade by RedStone's 2-of-3 Safe 0x6906f3a0… through ProxyAdmin 0x8223a627… (read at block 26,431,562); value not measured, so step 5 does not apply. Removed the 148-instance family: it grouped unrelated proxies with generic TransparentUpgradeableProxy code (only this address runs the adapter); 21 RedStone siblings under the same ProxyAdmin are listed in the body.

# Source excerpts: redstone-data-signers

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xd72a6ba4a87ddb33e801b3f1c7750b2d0911fc6c` — TransparentUpgradeableProxy (verified source via sourcify)

## Implementation `0x0c6c73865429e1d87b7b817b95bb1f38f2136529` — EthereumMultiFeedAdapterWithoutRoundsV3 (verified source via sourcify)

### `contracts/__C7/@redstone-finance/evm-connector/contracts/libs/SignatureLib.sol`

```solidity
   23        s := calldataload(signatureCalldataStartPos)
   24        signatureCalldataStartPos := add(signatureCalldataStartPos, ECDSA_SIG_S_BS)
   25        v := byte(0, calldataload(signatureCalldataStartPos)) // last byte of the signature memory array
   26      }
   27      signerAddress = ecrecover(signedHash, v, r, s);
   28      if (signerAddress == address(0)) {
   29        revert InvalidSignature(signedHash);
   30      }
   31    }
  ...
```
