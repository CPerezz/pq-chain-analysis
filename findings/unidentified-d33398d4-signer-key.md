---
id: unidentified-d33398d4-signer-key
title: "Permissioned Uniswap v4 hooks for ELEVATE, GULD and related tokens (operator unidentified): a recovered approver ECDSA key lets unapproved addresses trade in the gated pools"
project: unidentified-d33398d4
status: candidate
severity: LOW
patterns: [PQ-4, PQ-17]
primitives: [ecrecover]
trigger: operator-key
impact: none
alternative: key-rotation-only
role: core
contracts:
- address: "0xd33398d46cb5749c7319ae1fabc498cdeb0f0fc0"
  implementation: "0xba7b889588d6c449a30066344dd47759cfcb4fc0"
  name: ERC1967Proxy → unverified v4 hook (UUPS; approver(), setApprover(address))
  upgradeable: "yes"
  admin: UUPS owner() 0xc5d3c245acb2f3eb41e19a609f9bf06ef77dd21d (EOA with EIP-7702 delegation to 0x59501312a46b1e9cde57c835c7c2ac2e0da95615; read at block 26,431,583)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 4654
families:
- code: "0xba7b889588d6c449a30066344dd47759cfcb4fc0"
  name: ERC1967Proxy → same unverified hook implementation, same owner and approver
  instances: 8
  list: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-d33398d4-signer-key/onchain-review.json
  upgradeable: "yes"
  value_usd: null
  value_basis: null
  value_as_of: null
fix:
  layer: contract-upgrade
  who_acts: hook owner EOA 0xc5d3c245acb2f3eb41e19a609f9bf06ef77dd21d upgrades the 8 hooks (UUPS) to verify a post-quantum approval (or calls setApprover with an ERC-1271 contract, if the unverified code supports it), and moves ownership to a post-quantum account
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-d33398d4-signer-key
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
  who: Review02 (registry review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-d33398d4-signer-key/onchain-review.json
  date: 2026-11-17
  verdict: reported
  rating: LOW
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families b85d88ae"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
---

## Summary

Eight Uniswap v4 hooks sharing one unverified implementation gate swaps (and liquidity changes) in pools of a group
of vanity-address tokens (ELEVATE `0x8888…807e`, GULD, GROW, RALLY, WIN, CDXR, ELMT, GREEN, IZE) on a signature from
one `approver()` EOA, checked with `ecrecover` (PQ-4). A quantum attacker who recovers the approver key can sign
approvals and trade in the gated pools without the operator's consent. The hook addresses carry no return-delta
permissions, so the hook cannot change swap amounts and nothing is taken through the check; the harm is bypassing the
permission. The operator behind the hooks is not identified. Rated LOW (step 4: nothing can be taken through the
check, and one known owner can upgrade the hooks); status stays `candidate` because the implementation is unverified.

## Mechanism

- Implementation `0xba7b8895…` is unverified. The classifier found the selectors `beforeSwap`, `setApprover(address)`,
  `approver()`, `nextNonce(address)`, `whitelistTrader`/`whitelistRouter` and `upgradeToAndCall`
  ([`classification.jsonl`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-d33398d4-signer-key/classification.jsonl)); the precompile trace
  shows `ecrecover` in its calls. INFERRED: `beforeSwap` recovers the signer of an approval in the hook data (with a
  per-trader nonce) and reverts unless it equals `approver()`.
- The hook address's low bits (`0x0fc0`) grant beforeAdd/afterAdd/beforeRemove/afterRemove liquidity and
  beforeSwap/afterSwap only, with no `*ReturnDelta` flag, so the hook cannot take or redirect swap amounts.
- Excerpts: none (no verified source; [`source-excerpts.md`](#source-excerpts-unidentified-d33398d4-signer-key)).

## Evidence

- CHECKED (on-chain read at block 26,431,583, [`onchain-review.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-d33398d4-signer-key/onchain-review.json)):
  all 8 proxies have EIP-1967 implementation `0xba7b8895…`, `owner()` = `0xc5d3c245…` and `approver()` =
  `0x9af2ea55…`; `poolManager()` = Uniswap v4 PoolManager `0x00000000…4444…8a90`. The owner is an EOA with an
  EIP-7702 delegation (code `0xef0100…59501312…`, nonce 4,502); the approver has no code and nonce 0 (its key is
  exposed only through its approval signatures).
- CHECKED (Blockscout): the proxy was created on 2026-02-10 by `0xfab0692c…`, whose only transaction it is; the
  implementation was created through the CREATE2 deployer `0x4e59b448…`. Latest swaps through each hook moved ELEVATE
  /USDT, RALLY/WIN, GROW/GULD, GULD/IZE, CDXR/ELMT, GREEN/GULD and CDXR/RALLY.
- CHECKED (on-chain read at block 26,431,214, [`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-d33398d4-signer-key/onchain.json)):
  the hook holds nothing.
- CHECKED (Xatu, [`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-d33398d4-signer-key/activity.json)): 4,654 transactions
  2026-10-16 to 2026-11-16; 29,607 pre-quantum transactions in the last year (`txs_y1`,
  `studies/top-callers-classification/results/curated_contracts.csv`).
- INFERRED: what the approval binds (trader, router, amount, fee) is not known without source.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xd33398d4…` ERC1967Proxy → hook | yes | — | 2026-11-16 | 4,654 |

Family: 8 hooks with the same implementation, owner and approver: `0xd33398d4…`, `0x00d4e856…`, `0x55f5894d…`,
`0x2208b399…`, `0x1141a66e…`, `0x44b9bdeb…`, `0x88c948a0…`, `0x99112573…`.

Exposure: a forged approval gives access to the gated pools at pool prices; liquidity in those pools is not taken
through the check, so `impact` is `none` and no value is recorded. Separate from this check, the owner is an ECDSA
key: a quantum attacker holding it could upgrade the hooks to revert in `beforeRemoveLiquidity` and lock LPs' funds
(INFERRED from the permission bits; owner-key exposure, PQ-12-like).

Attribution: the pools trade ELEVATE (`0x888888888887715fb9d9f84175af9e6cce46807e`, "Elevate") and the other tokens
above, but neither the deployer nor the owner was linked to a named team, so `project` stays unidentified.

## Remediation

- Replacement: hook logic that verifies a post-quantum approval signature (ML-DSA or hash-based), or approvals through
  an ERC-1271 approver contract holding a post-quantum key.
- Who acts: the owner EOA `0xc5d3c245acb2f3eb41e19a609f9bf06ef77dd21d` upgrades all 8 proxies, and transfers
  ownership to a post-quantum account. No protocol change is needed.
- Pool users: nothing to do for this check; LPs depend on the owner key for the hook's behaviour.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review02): MEDIUM -> LOW, step 4: the approver signature only gates access (no return-delta hook permissions, so nothing can be taken through it) and one known owner (EOA 0xc5d3c245…, read at block 26,431,583) can upgrade all 8 hooks. Impact funds-loss -> none. Family confirmed (8 proxies, same implementation, owner and approver). Operator still unidentified; pools trade ELEVATE and related tokens.
- 2026-11-19 (study `eip-8151-impact`, PQ-17): under EIP-8151 the signer key can be replaced; it must be rotated before its account takes code. Executed: a real transaction reverts when its signer has code.

# Source excerpts: unidentified-d33398d4-signer-key

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xd33398d46cb5749c7319ae1fabc498cdeb0f0fc0` — ERC1967Proxy (verified source via sourcify)

## Implementation `0xba7b889588d6c449a30066344dd47759cfcb4fc0`

No verified source on Sourcify or Blockscout.
