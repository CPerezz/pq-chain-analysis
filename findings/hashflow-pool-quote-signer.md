---
id: hashflow-pool-quote-signer
title: "Hashflow pools: a quantum attacker who recovers a pool's ECDSA quote-signer key can sign quotes that pull the market maker's approved funds (about $10.1M behind the Kipseli pool)"
project: hashflow
status: confirmed
severity: MEDIUM
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x478eca1b93865dca0b9f325935eb123c8a4af011"
  implementation: "0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1"
  name: HashflowPool "Kipseli" (EIP-1167 clone)
  upgradeable: config-only
  admin: operations 0x97f7d4093e5bdd0776e2ca90c90124c5e16ca569 (updateSigner); router owner 0xac6a83b29e5ff66fd558171ead7ed9d619b055d0 can killswitch (read at block 26431523)
  value_usd: 10145696
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 2557
- address: "0x741c939c644576433ca03c368ade3352e3252b35"
  implementation: "0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1"
  name: HashflowPool "hashflow-mkr" (EIP-1167 clone)
  upgradeable: config-only
  admin: operations 0xe8736af1926e9d8f5a6602fbbb0893b26436d710 (also the signer); router owner can killswitch (read at block 26431523)
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-03
  txs_30d: 13603
- address: "0x4c4c3e005c6cb9ce249a267f28299293a628cf38"
  implementation: "0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1"
  name: HashflowPool "prod-0x6047b3" (EIP-1167 clone)
  upgradeable: config-only
  admin: operations 0x50c03775c8e5b6227f1e00c4b3e479b4a7c57983 (updateSigner); router owner can killswitch (read at block 26431523)
  value_usd: 9489
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-10-16
  txs_30d: 0
- address: "0x5d8853028fbf6a2da43c7a828cc5f691e9456b44"
  implementation: "0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1"
  name: HashflowPool "kekpoolv5" (EIP-1167 clone)
  upgradeable: config-only
  admin: operations 0xbd660c8749b36be241c2a9aaf61ede24dfe706d0 (updateSigner); router owner can killswitch (read at block 26431523)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-05-07
  txs_30d: 0
families:
- code: "0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1"
  name: HashflowPool clones
  instances: 19
  list: docs/lookup (any address can be checked on the site)
  upgradeable: config-only
  value_usd: null
  value_basis: null
  value_as_of: null
fix:
  layer: new-deployment
  who_acts: Hashflow (new pool implementation with post-quantum quote verification; HashflowRouter 0x55084ee0fef03f14a305cd24286359a35d735151, owner 0xac6a83b29e5ff66fd558171ead7ed9d619b055d0) and each pool's market maker (operations address) moving liquidity and allowances to a new pool
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/hashflow-pool-quote-signer/classification.jsonl
  - evidence/hashflow-pool-quote-signer/onchain.json
  - evidence/hashflow-pool-quote-signer/activity.json
  - evidence/hashflow-pool-quote-signer/source-excerpts.md
  - evidence/hashflow-pool-quote-signer/review-reads.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl,out_1.jsonl,out_4.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: review (Review22)
  ref: evidence/hashflow-pool-quote-signer/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Each Hashflow pool releases funds on an RFQ quote signed by one secp256k1 key. The quote names the paying account:
the pool itself, or an "external account" that has approved the pool. A quantum attacker who recovers the signer key
(public, since the key signs every quote) can sign a quote that sends any approved token from the external account to
themselves for nothing. The Kipseli pool's external account `0xbee3211a…` has given unlimited approvals over about
$10.1M; the other three pools expose under $10k. Rated MEDIUM (step 4: the signer can only be rotated to another ECDSA
key, so Hashflow must ship a new pool implementation and each market maker must move to it).

## Mechanism

- `tradeRFQT`, `tradeRFQM`, `tradeXChainRFQT` and `tradeXChainRFQM` (`HashflowPool.sol` lines 112-163, 166-205, 207-252,
  282-310) are `authorizedRouter` and require `quoteHash.recover(signature) == signerConfiguration.signer`
  (OpenZeppelin ECDSA; lines 130-133, 175-178, 228-231, 294-297). They then pay `quoteTokenAmount` to the trader with
  `_transferFromPool` or, if `quote.externalAccount != 0`, `_transferFromExternalAccount`
  (`safeTransferFrom(externalAccount, trader, amount)`, lines 495-512). The quote's amounts and external account are
  whatever the signer signed. PQ-4.
- `isValidSignature` (ERC-1271, lines 342-351) also accepts anything the signer `ecrecover`s to, so the pool's own
  balances and approvals can be spent through ERC-1271 signatures as well.
- `updateSigner` (lines 423-436, `authorizedOperations`) only replaces the address that `ecrecover` must return. The
  clone's logic is fixed, so the scheme cannot change.
- `killswitchOperations` (lines 439-449) is callable only by the router; `HashflowRouter.killswitchPool` is
  `onlyOwner`.

## Evidence

- CHECKED (verified source on Sourcify, implementation `0xca310b1b…`; HashflowRouter `0x55084ee0…` on Blockscout): the
  code paths above.
- CHECKED (RPC at block 26,431,523; [`review-reads.json`](../evidence/hashflow-pool-quote-signer/review-reads.json)):
  per pool `signerConfiguration` (all enabled), `operations` and `router` = `0x55084ee0…`; all four are EIP-1167
  clones of `0xca310b1b…` and hold 0 ETH and no tokens. Router `owner()` = `0xac6a83b2…`, an EOA with an EIP-7702
  delegation (EIP7702StatelessDeleGator), not a Safe.
- CHECKED (Blockscout token transfers of each pool's latest trade, then `allowance(ext, pool)` and `balanceOf` read
  at about block 26,431,523): Kipseli pays from `0xbee3211a…` (a TransparentUpgradeableProxy market-maker vault) with
  unlimited approvals on USDT, WETH, USDC, WBTC and about 25 other tokens, worth $10,145,696; prod-0x6047b3 pays from
  its signer EOA `0x6047b384…` ($9,489 approved); hashflow-mkr pays from its signer/operations EOA `0xe8736af1…`
  (unlimited approvals, near-zero balance).
- CHECKED (Xatu call frames since block 24,700,000): 20,826 (Kipseli), 109,056 (hashflow-mkr), 3,371 (prod-0x6047b3)
  and 2,960 (kekpoolv5, last 2026-05-07) transactions. Pre-quantum calls in the year to March 2026
  (`curated_contracts.csv` `txs_y1`): 32,617, 46,867, 19,872 and 57,215.
- INFERRED: kekpoolv5's external account was not found (no WETH/USDC/USDT/DAI approval from its signer, operations or
  last counterparty). The other 15 clones in the family were not measured.

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0x478eca1b…` Kipseli | config-only | $10.1M (escrow: vault `0xbee3211a…` approvals) | 2026-11-15 | 2,557 |
| `0x741c939c…` hashflow-mkr | config-only | $0 (escrow: signer EOA approvals) | 2026-11-03 | 13,603 |
| `0x4c4c3e00…` prod-0x6047b3 | config-only | $9.5k (escrow: signer EOA approvals) | 2026-10-16 | 0 |
| `0x5d885302…` kekpoolv5 | config-only | not measured | 2026-05-07 | 0 |

- The pools hold nothing; the value sits in market makers' accounts that approved them. For hashflow-mkr and
  prod-0x6047b3 the paying account is the signer EOA itself, so the pool check adds no exposure beyond that EOA's own
  key. For Kipseli the vault is a separate contract, so the signer key alone reaches about $10.1M.
- Family: 19 clones run `0xca310b1b…`; the other 15 were not checked.

## Remediation

- Hashflow: a new pool implementation that verifies quotes with a post-quantum signature, for example through an
  ERC-7913 verifier or an ERC-1271 signer contract instead of `recover(...) == signer`, authorised in HashflowRouter
  `0x55084ee0…` (owner `0xac6a83b2…`). The router owner is itself an ECDSA EOA and should move too.
- Each market maker (pool `operations`): deploy a new pool, move liquidity, and revoke the external account's
  approvals to the old pool. Until then, they can limit exposure by keeping approvals to what quotes need. The router
  owner can stop a pool with `killswitchPool`.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review22): stays MEDIUM, step 4: signer rotation only; fix is a new pool implementation from Hashflow plus each market maker moving. Exposure measured as external-account approvals ($10.1M behind Kipseli), so step 5 does not lower it. Admins corrected to per-pool `operations` and the router owner's killswitch.
