# Review notes: unidentified-807cf9a7-signer-key (2026-11-17, Review14)

All reads via eth.drpc.org (latest, 2026-11-17) and Blockscout unless stated.

## Proxy and admin

- `0x807cf9a7…` TransparentUpgradeableProxy (verified); EIP-1967 implementation `0xbe4e645caaae7c1d0874bb8d1c8d337f31d79dd8`
  (unverified), admin slot ProxyAdmin `0x291baf88f60e8f83de7568ae56280a3e29ac725e`, `owner()` =
  `0xbc33a1f908612640f2849b56b67a4de4d179c151` (Blockscout: MultiSigWalletWithDailyLimit; `required()` = 2,
  `getOwners()` = 3 owners). The proxy's own `owner()` is the same multisig.
- `executorSigner()` = `0xe9f191c09679a745a1d7a7f20658681b18d9a31a` (EOA).
- Implementation selectors (`cast selectors`): `isValidSignature(bytes32,bytes)` 0x1626ba7e, `nonces(address)`
  0x7ecebe00, `owner()`, `transferOwnership`, `renounceOwnership`, `withdraw(address,uint256,address)` 0x69328dec, several
  `(address[])` operator-list setters, `(uint256,bytes)` payable/nonpayable entry points (0x4cf3fe9c, 0x8594ac40,
  0x7507bd7a), `(address,bytes)` payable 0xab06e403. Names other than standard ones are not resolved.

## Who calls the check

- `data/agg/alltime_caller.parquet`: `ecrecover` 707,291 calls, blocks 15,724,490–23,974,448 (last 2025-12-09);
  trace year 97,704 transactions.
- `trace_filter` (eth.drpc.org) at block 23,974,448: tx `0xee0c8998…4567`, 1inch AggregationRouterV6
  `0x111111125421ca6dc452d289314280a0f8842a65` staticcalls `isValidSignature` (0x1626ba7e) on this contract. The
  contract acts as an ERC-1271 maker for 1inch limit orders; its `isValidSignature` is answered with `ecrecover`
  (INFERRED from the trace pairing; the exact comparison against `executorSigner`/operators is not read from source).
- Direct transactions: last ones are `withdraw` (0x69328dec, `WithdrawFunds` events) from EOA
  `0xf3d872b9e8d314820dc8e99dafbe1a3feedc27d5` at block 22,326,545 (2025-04-22). Later token transfers in are unsolicited
  tokens. `activity.json`: no transaction since 2026-03-18.

## Holdings (onchain.json, block 26,431,214)

USD 152 (RENDER, ETHFI, LOOM, … ; 0.00006 ETH).

## Sibling

Deployer `0xfc68e9b0d3497db6dc1ce68d25d45315b8cc3076` also operates `0xd198885a138d3b1810a7363dd055c540d521c0c2`: same
implementation `0xbe4e…9dd8`, ProxyAdmin `0xfe71ca5f6c9c4bac61c25e38bfa4258de7ab272c`, `executorSigner()` =
`0xdd41094fc512b96ee0c92d08c35fd67d52fd0fb5`; holds USD 240 (Blockscout, 2026-11-17); 33 `ecrecover` calls, last at block
20,828,948 (2024-09). Not in the registry.

## Identity

Not identified: deployer, executor and withdrawer are unlabelled EOAs; the owner is an unlabelled 2-of-3 multisig.
