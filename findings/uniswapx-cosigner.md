---
id: uniswapx-cosigner
title: "UniswapX V2DutchOrderReactor: a quantum attacker who recovers Uniswap Labs' cosigner key can cosign open orders to fill them at each swapper's worst signed price"
project: uniswap
status: confirmed
severity: MEDIUM
patterns: [PQ-4, PQ-18]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x00000011f84b9aa48e5f8aa8b9897600006289be"
  implementation: null
  name: V2DutchOrderReactor
  upgradeable: "no"
  admin: owner 0x1a9c8182c09f50c8318d769245bea52c32be35bc (Uniswap governance Timelock) can only set the protocol fee controller; no upgrade path
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 35213
families: []
fix:
  layer: new-deployment
  who_acts: Uniswap Labs (runs the cosigner and the UniswapX order API) deploys a reactor that verifies the cosigner through ERC-1271 or a post-quantum scheme and routes new orders to it; fillers follow
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/uniswapx-cosigner
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
  who: Review07 (registry review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/uniswapx-cosigner/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 299dfbb7"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: [uniswap-permit2-code-first]
---

## Summary

Every UniswapX V2 Dutch order must carry a cosignature that the reactor checks with raw `ecrecover` against the
cosigner address in the swapper's order (PQ-4); Uniswap Labs runs that cosigner key. A quantum attacker who recovers
it can cosign any open order with decay times already past and itself as exclusive filler, filling the order at the
swapper's worst signed amounts and keeping the slippage tolerance. It cannot exceed the swapper's signed limits or
touch funds outside open orders. The reactor is immutable; the exposure (users' slippage on open orders, drawn from
their Permit2 approvals) is not measurable. Rated MEDIUM (step 4): fixed by a new reactor deployment that Uniswap
Labs routes orders to.

## Mechanism

`V2DutchOrderReactor._resolve` (lines 43–69) calls `_validateOrder` (lines 111–123), which requires
`ecrecover(keccak256(orderHash || abi.encode(cosignerData)), v, r, s) == order.cosigner`. The cosigner data sets
`decayStartTime`, `decayEndTime`, `exclusiveFiller`, `exclusivityOverrideBps` and optional better start amounts;
`_updateWithCosignerAmounts` (lines 83–104) only lets the cosigner improve the start amounts. Input and outputs then
decay between the cosigned times, and the swapper's tokens move through
`permit2.permitWitnessTransferFrom` with the swapper's own signature (lines 72–81). Forging the cosigner therefore
controls timing and exclusivity, i.e. where on the swapper's signed start-to-end curve the order fills. Pattern PQ-4.
Lines: [`notes.md`](#review-reads-uniswapx-cosigner-2026-11-17-review07),
[`source-excerpts.md`](#source-excerpts-uniswapx-cosigner).

## Evidence

- CHECKED (verified source, Sourcify): raw `ecrecover` against `order.cosigner`, no ERC-1271; cosigner amounts
  bounded by the swapper's signed amounts.
- CHECKED (`cast` at block 26,431,621): not a proxy; `owner()` = Uniswap Timelock `0x1a9c8182…` (2-day delay); owner
  functions only set the protocol fee controller (currently zero).
- CHECKED (precompile trace to March 2026): 525,706 transactions with `ecrecover` in the last year; Xatu: 35,213
  transactions called the reactor in 2026-10-16 to 2026-11-16, last 2026-11-16.
- INFERRED: the cosigner key has signed on-chain-visible cosignatures (every filled order carries one), so its public
  key is recoverable from any filled order.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x00000011…` V2DutchOrderReactor | no | not measurable (swappers' slippage on open orders) | 2026-11-16 | 35,213 |

The reactor holds nothing between fills (dust only). What a forged cosigner can take is, per open order, the gap
between the market price and the swapper's signed end amounts; orders live for seconds to minutes, so the amount at
risk at any time is not measurable from chain state. Swapper funds sit in their own wallets behind Permit2 approvals,
which this check does not release. Other UniswapX reactors and V3 Dutch order reactors were not checked here.

## Remediation

- Uniswap Labs deploys a reactor that verifies the cosignature through ERC-1271 (so the cosigner can be a contract
  with a post-quantum signer) or a post-quantum scheme directly, and routes new orders to it through its order API;
  fillers integrate the new reactor. Orders already signed for this reactor expire within their short deadlines.
- Until then, Uniswap Labs can stop issuing V2 orders and route through a reactor without a cosigner.
- Swappers limit exposure by signing tight slippage; post-quantum swappers already sign through Permit2's ERC-1271
  path. No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by a new deployment that the operator and users move to).
- 2026-11-17 review (Review07): MEDIUM unchanged (step 4). Confirmed the forged cosigner is bounded by the swapper's
  signed amounts (it takes slippage, not principal); owner identified as Uniswap Timelock (fee controller only).
- 2026-11-19 (study `eip-8151-impact`, PQ-18): under EIP-8151 a real transaction fails as sent and passes with more gas: whoever sends it must add gas on activation day. Executed: a real transaction reverts when its signer has code.

# Source excerpts: uniswapx-cosigner

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x00000011f84b9aa48e5f8aa8b9897600006289be` — V2DutchOrderReactor (verified source via sourcify)

### `lib/permit2/src/interfaces/IAllowanceTransfer.sol`

```solidity
  126      /// @dev May fail if the owner's nonce was invalidated in-flight by invalidateNonce
  127      /// @param owner The owner of the tokens being approved
  128      /// @param permitSingle Data signed over by the owner specifying the terms of approval
  129      /// @param signature The owner's signature over the permit data
  130      function permit(address owner, PermitSingle memory permitSingle, bytes calldata signature) external;
  131  
  132      /// @notice Permit a spender to the signed amounts of the owners tokens via the owner's EIP-712 signature
  133      /// @dev May fail if the owner's nonce was invalidated in-flight by invalidateNonce
  134      /// @param owner The owner of the tokens being approved
  135      /// @param permitBatch Data signed over by the owner specifying the terms of approval
  136      /// @param signature The owner's signature over the permit data
  137      function permit(address owner, PermitBatch memory permitBatch, bytes calldata signature) external;
  138  
  139      /// @notice Transfer approved tokens from one address to another
  140      /// @param from The address to transfer from
  141      /// @param to The address of the recipient
  ...
```

### `lib/solmate/src/tokens/ERC20.sol`

```solidity
  112      /*//////////////////////////////////////////////////////////////
  113                               EIP-2612 LOGIC
  114      //////////////////////////////////////////////////////////////*/
  115  
  116      function permit(
  117          address owner,
  118          address spender,
  119          uint256 value,
  120          uint256 deadline,
  ...
  126  
  127          // Unchecked because the only math done is incrementing
  128          // the owner's nonce which cannot realistically overflow.
  129          unchecked {
  130              address recoveredAddress = ecrecover(
  131                  keccak256(
  132                      abi.encodePacked(
  133                          "\x19\x01",
  134                          DOMAIN_SEPARATOR(),
  ...
```

### `src/reactors/V2DutchOrderReactor.sol`

```solidity
  115  
  116          (bytes32 r, bytes32 s) = abi.decode(order.cosignature, (bytes32, bytes32));
  117          uint8 v = uint8(order.cosignature[64]);
  118          // cosigner signs over (orderHash || cosignerData)
  119          address signer = ecrecover(keccak256(abi.encodePacked(orderHash, abi.encode(order.cosignerData))), v, r, s);
  120          if (order.cosigner != signer || signer == address(0)) {
  121              revert InvalidCosignature();
  122          }
  123      }
  ...
```

# Review reads: uniswapx-cosigner (2026-11-17, Review07)

## Source (Sourcify, `0x00000011f84b9aa48e5f8aa8b9897600006289be`, `V2DutchOrderReactor`)

`src/reactors/V2DutchOrderReactor.sol`:

- `_resolve` (lines 43–69): `orderHash = order.hash()`; `_validateOrder(orderHash, order)`;
  `_updateWithCosignerAmounts(order)`; input and outputs decay between `cosignerData.decayStartTime` and
  `decayEndTime`; `handleExclusiveOverride(cosignerData.exclusiveFiller, decayStartTime, exclusivityOverrideBps)`.
- `_validateOrder` (lines 111–123): `ecrecover(keccak256(abi.encodePacked(orderHash, abi.encode(order.cosignerData))), v, r, s)`
  must equal `order.cosigner` (an address inside the swapper-signed order). Raw `ecrecover`, no ERC-1271.
- `_updateWithCosignerAmounts` (lines 83–104): cosigner input must be ≤ `baseInput.startAmount`, outputs ≥
  `baseOutputs[i].startAmount`; the cosigner cannot move the order outside the swapper's signed start/end amounts.
- `_transferInputTokens` (lines 72–81): swapper funds move through `permit2.permitWitnessTransferFrom` with the
  swapper's own signature (Permit2 checks account code first: see `uniswap-permit2-code-first`).

## On-chain reads (`cast`, publicnode, block 26,431,621)

- EIP-1967 implementation slot = 0 (not a proxy); `permit2()` = `0x000000000022d473030f116ddee9f6b43ac78ba3`.
- `owner()` = `0x1a9c8182c09f50c8318d769245bea52c32be35bc` (Blockscout name `Timelock`; `delay()` = 172,800 s;
  `admin()` = `0x408ed6354d4973f66138c91495f2f2fcbd8724c3`, Uniswap governor). The owner can only set the protocol fee
  controller (`feeController()` = 0 now); it cannot change the cosigner check.
- Deployed 2024-05-07 through the CREATE2 factory by `0x496d57839975e5c0bd36d39ffa27336b078b1b16`.
- Yearly pre-quantum use (`data/report/curated_contracts.csv`): `txs_y1` 525,706 `ecrecover` transactions.
