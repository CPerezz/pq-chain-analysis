---
id: transit-fee-signer
title: "Transit Swap TransitSwapRouterV5 (paused): a quantum attacker who recovers the fee-signer key can only sign fee discounts for their own swaps; nothing can be taken"
project: transit-swap
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: none
alternative: key-rotation-only
role: auxiliary
contracts:
- address: "0x00000047bb99ea4d791bb749d970de71ee0b1a34"
  implementation: null
  name: TransitSwapRouterV5
  upgradeable: config-only
  admin: "executor 0x7b570fec1f31a971d9fc77def3c3c17bd9440711 (Safe, 2 of 3): changeTransitProxy sets _fee_signer, changeFee, changePause"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-09-30
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: "Transit Swap executor Safe 0x7b570fec1f31a971d9fc77def3c3c17bd9440711 (2 of 3): keep the router paused, or set the fee signer to an unusable address; a new router would verify a post-quantum fee signer"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/transit-fee-signer
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
  who: Review13 (re-read verified source on Sourcify; executor, signer and pause reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/transit-fee-signer/reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

TransitSwapRouterV5 charges a fee (0.30% on aggregate swaps, 0.20% on cross-chain swaps) unless the trader presents a
lower fee signed by `_fee_signer`, an EOA checked with `ecrecover` (PQ-4). A quantum attacker who recovers that key
can only waive the fee on their own swaps: the signature binds `msg.sender`, the amount and the fee, and releases no
one else's tokens. The router is paused, has had no transaction since 2026-09-30, and its USD 2.3k of dust tokens
are not reachable through this check. Rated LOW (step 4): the check guards an auxiliary feature through which nothing
can be taken (the draft's "market-maker quotes" label was wrong).

## Mechanism

- Every swap entry (`AggregateRouter`, `UniswapV2Router`, `UniswapV3Router`, `CrossRouter`) calls
  `BaseCore.calculateTradeFee(isAggregate, amount, fee, signature)` (`BaseCore.sol` 121-132): if the requested `fee`
  is below `amount × _aggregate_fee` (or `_cross_fee`) / 10000, it requires `verifySignature(amount, fee, signature)`.
- `verifySignature` (lines 220-231) builds the EIP-712 digest of `CHECKFEE(msg.sender, amount, fee)`, runs `ecrecover`
  and compares with `_fee_signer`. The function returns `amount - fee`; the trader's own tokens are swapped.
- `_fee_signer` is set by `changeTransitProxy` (`onlyExecutor`, lines 158-168); `changePause` (line 197) pauses all
  entry paths (`whenNotPaused` on `_executeAggregate`, `_executeV2Swap`, `_executeV3Swap`, `cross`).
- Pattern PQ-4, auxiliary. Excerpts: [`source-excerpts.md`](#source-excerpts-transit-fee-signer).

## Evidence

- CHECKED (verified source, Sourcify, re-read 2026-11-17): the path above.
- CHECKED (on-chain, block 26,431,214): no proxy; holds USD 2,276 of small tokens (NAT, DITAU, TRU, …)
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/transit-fee-signer/onchain.json)).
- CHECKED (on-chain, block 26,431,605, [`reads.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/transit-fee-signer/reads.json)): `paused()` = true;
  `transitProxyAddress()` fee signer `0x01c54379c4323844273a7ce865fbd94d77f78849` (code size 0, an EOA);
  `transitFee()` = 30 / 20 bps; `executor()` = `0x7b570fec…`, a Safe with threshold 2 of 3 owners.
- CHECKED (precompile trace, 12 months to March 2026, `curated_contracts.csv` `txs_y1`): `ecrecover` in 33,727
  transactions. Xatu: none 2026-10-16 to 2026-11-16, last 2026-09-30
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/transit-fee-signer/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x00000047…` TransitSwapRouterV5 | config-only | — (USD 2,276 dust, not reachable via the check) | 2026-09-30 | 0 |

The only loss a forged fee signature causes is Transit's fee revenue on the attacker's own swaps; `value_usd` is
`null`. No other Transit deployment is in the registry.

## Remediation

- Executor Safe `0x7b570fec…`: keep the router paused (it is), or point `_fee_signer` at an address with no key; a
  future router should check the fee discount with a post-quantum signer.
- No protocol change needed; users are not exposed through this check.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review13): MEDIUM -> LOW, step 4: the signature only lowers the caller's own fee (auxiliary, nothing can be taken); router paused, executor is a 2-of-3 Safe. `impact` funds-loss -> none; `fix.layer` new-deployment -> onchain-config; removed the USD 2,276 `held` value (not reachable through the check).

# Source excerpts: transit-fee-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x00000047bb99ea4d791bb749d970de71ee0b1a34` — TransitSwapRouterV5 (verified source via sourcify)

### `BaseCore.sol`

```solidity
  225                  keccak256(abi.encode(CHECKFEE_TYPEHASH, msg.sender, amount, fee))
  226              )
  227          );
  228          (uint8 v, bytes32 r, bytes32 s) = splitSignature(signature);
  229          address recovered = ecrecover(digest, v, r, s);
  230          return recovered == _fee_signer;
  231      }
  232  
  233      function splitSignature(bytes memory _signature) internal pure returns (uint8 v, bytes32 r, bytes32 s) {
  ...
```
