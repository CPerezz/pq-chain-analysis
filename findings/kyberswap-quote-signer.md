---
id: kyberswap-quote-signer
title: "KyberSwap KEM hook (Uniswap v4) and aggregation executor: a quantum attacker who recovers KyberSwap's quote-signer EOA key can sign swap quotes that let them arbitrage KEM pools without the surplus capture that protects LPs"
project: kyberswap
status: confirmed
severity: MEDIUM
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x4440854b2d02c57a0dc5c58b7a884562d875c0c4"
  implementation: null
  name: UniswapV4KEMHook
  upgradeable: config-only
  admin: "owner 0xbe2f0354d970265bfc36d383af77f72736b81b54 (EOA with EIP-7702 delegation): updateQuoteSigner, rescue"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 4448
- address: "0x63242a4ea82847b20e506b63b0e2e2eff0cc6cb0"
  implementation: null
  name: unverified executor (AccessControlDefaultAdminRules, SIGNER_ROLE, callBytes)
  upgradeable: config-only
  admin: "defaultAdmin/owner 0x697161a9ece8afd6ae30946d790077050f993cbc (EOA): grants and revokes SIGNER_ROLE"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-14
  txs_30d: 17
families: []
fix:
  layer: onchain-config
  who_acts: "KyberSwap: hook owner 0xbe2f0354d970265bfc36d383af77f72736b81b54 calls updateQuoteSigner with a contract signer that verifies a post-quantum signature through ERC-1271; executor admin 0x697161a9ece8afd6ae30946d790077050f993cbc for the executor (no ERC-1271 seen in its bytecode, so a new deployment)"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/kyberswap-quote-signer/classification.jsonl
  - evidence/kyberswap-quote-signer/onchain.json
  - evidence/kyberswap-quote-signer/activity.json
  - evidence/kyberswap-quote-signer/source-excerpts.md
  - evidence/kyberswap-quote-signer/reads.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review13 (re-read KEM hook source on Sourcify; signer, owner and admin reads; executor call path)
  ref: evidence/kyberswap-quote-signer/reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [kyberswap-order-sig-ecdsa-first]
---

## Summary

KyberSwap's KEM hook lets a swap through a Uniswap v4 pool that uses it only with a quote signed by `quoteSigner`, an
EOA; the quote caps the exchange rate, and any output above it is kept by the hook for LPs (PQ-4). The signer's key
has signed on-chain, so a quantum attacker can recover it, sign quotes with an unlimited rate, and arbitrage KEM pools
at stale prices, taking the value the hook exists to keep for LPs. An unverified KyberSwap aggregation executor also
checks an ECDSA `SIGNER_ROLE` key; what that signature releases is not established. The LP loss is bounded by price
moves, not the pools' full liquidity, and was not measured. Rated MEDIUM (step 4): the owner can point the hook at a
new post-quantum contract signer; the executor needs a new deployment.

## Mechanism

- UniswapV4KEMHook (`src/UniswapV4KEMHook.sol`): `beforeSwap` (lines 93-135, `onlyPoolManager`) decodes
  `maxAmountIn`, `maxExchangeRate`, `exchangeRateDenom`, `nonce`, `expiryTime` and `signature` from `hookData`, checks
  expiry, amount and nonce, and requires `SignatureChecker.isValidSignatureNow(quoteSigner, digest, signature)`
  (lines 130-132; OpenZeppelin v5: `ECDSA.tryRecover` first, then ERC-1271). `afterSwap` (lines 137-176) mints to the
  hook any output above `amountIn * maxExchangeRate / exchangeRateDenom` (the "EG" surplus), later sent to
  `egRecipient` by `claimEgTokens`. `quoteSigner` is set by `updateQuoteSigner` (`onlyOwner`,
  `src/base/BaseKEMHook.sol` line 42). A forged quote with a high `maxExchangeRate` turns off the surplus capture.
- Executor `0x63242a4e…` (unverified, bytecode): selectors `SIGNER_ROLE()`, `callBytes(bytes)`, `msgSender()`,
  `refundCollector()`; `ecrecover` against holders of `SIGNER_ROLE`; no `isValidSignature` selector. It is called by
  KyberSwap's MetaAggregationRouterV2 `0x6131b5fae19ea4f9d964eac0408e4408b66337b5` during swaps.
- Pattern PQ-4. Excerpts: [`source-excerpts.md`](../evidence/kyberswap-quote-signer/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify, re-read 2026-11-17): the KEM hook path above.
- CHECKED (on-chain, block 26,431,214): neither contract is a proxy; the hook holds nothing, the executor about USD 6 of
  dust tokens ([`onchain.json`](../evidence/kyberswap-quote-signer/onchain.json)).
- CHECKED (on-chain, block 26,431,552, [`reads.json`](../evidence/kyberswap-quote-signer/reads.json)): hook
  `quoteSigner()` = `0xa99a99ee4f63474e8ab3dfff0a716174e786a751` (code size 0, an EOA); `owner()` =
  `0xbe2f0354d970265bfc36d383af77f72736b81b54` (an EOA with an EIP-7702 delegation, also KyberSwapRFQ's admin).
  Executor `defaultAdmin()` = `owner()` = `0x697161a9ece8afd6ae30946d790077050f993cbc` (an EOA).
- CHECKED (Blockscout internal transactions of tx `0x67c241f8…`, block 24,683,719): PendleRouterV4 → KyberSwap
  MetaAggregationRouterV2 → executor; this supports the KyberSwap attribution of the executor.
- CHECKED (precompile trace, 12 months to March 2026, `curated_contracts.csv` `txs_y1`): `ecrecover` in 74,091
  transactions through the hook and 1,085,101 through the executor (blocks 23,416,114 to 24,683,719).
- CHECKED (Xatu, any function, 2026-10-16 to 2026-11-16): hook 4,448 transactions; executor 17, so the executor is
  close to retired ([`activity.json`](../evidence/kyberswap-quote-signer/activity.json)).
- INFERRED from bytecode: the executor's signature check and what it authorises; its `SIGNER_ROLE` holders were not
  enumerated.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x4440854b…` UniswapV4KEMHook | config-only | — | 2026-11-16 | 4,448 |
| `0x63242a4e…` executor (unverified) | config-only | — (USD 6 dust) | 2026-11-14 | 17 |

The KEM pools' liquidity sits in the Uniswap v4 PoolManager, but a forged quote does not release it: the attacker
still trades along the pool's curve and gains only what an unrestricted arbitrageur would (stale-price arbitrage that
the hook would otherwise capture). The pools were not enumerated and that loss cannot be measured from balances;
`value_usd` is `null` (the executor's USD 6 is dust, not the exposure).

## Remediation

- KEM hook: the owner calls `updateQuoteSigner` with a contract that verifies a post-quantum signature (for example an
  ERC-7913 verifier behind ERC-1271). `ecrecover` cannot return a contract address, so the OpenZeppelin
  `SignatureChecker` then accepts only the ERC-1271 path. Quote size and gas grow; no redeployment is needed. The owner
  itself is an ECDSA EOA and should move to a post-quantum account or multisig first.
- Executor: KyberSwap retires it (activity is already low) or deploys a replacement that verifies a post-quantum
  signer; the admin EOA can revoke `SIGNER_ROLE`.
- No protocol change needed; LPs can only withdraw from KEM pools.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review13): MEDIUM unchanged, step 4: one known owner points the hook at a new post-quantum contract signer; the executor needs a new deployment. Status candidate -> confirmed (KEM hook source and signer/owner state read; the executor stays bytecode-level); `fix.layer` new-deployment -> onchain-config; removed the executor's USD 6 `held` value (dust, not the exposure); executor attribution to KyberSwap supported by a traced call from MetaAggregationRouterV2.
