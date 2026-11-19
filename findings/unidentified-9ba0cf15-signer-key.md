---
id: unidentified-9ba0cf15-signer-key
title: "Unidentified RFQ market-maker vault 0x9ba0cf15 (1inch LOP, UniswapX, CoW, AirSwap): a forged signer key makes the vault sign any order, but the vault was emptied on 2026-05-07 and holds about USD 1"
project: unidentified-9ba0cf15
status: candidate
severity: MEDIUM
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x9ba0cf1588e1dfa905ec948f7fe5104dd40eda31"
  implementation: null
  name: unverified market-maker ERC-1271 vault (revert prefix "Liq:")
  upgradeable: config-only
  admin: "owner EOA 0xc493f943a1fd910d01dcabea86e61415ce43e787 (setOwner, signer registry, setReactor, setLimitOrderProtocol, withdrawals); read at block 26,431,544"
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-05-28
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: "owner EOA 0xc493f943a1fd910d01dcabea86e61415ce43e787: keep the vault empty or deploy a vault whose isValidSignature verifies a post-quantum signer"
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-9ba0cf15-signer-key
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
  who: Review08 (bytecode, token flows, deployer siblings, on-chain reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-9ba0cf15-signer-key/notes.md
  date: 2026-11-17
  verdict: reported
  rating: LOW
related: []
---

## Summary

This unverified market-maker vault is the maker on RFQ and limit orders across 1inch Limit Order Protocol, UniswapX,
CoW Protocol and AirSwap. It approves orders through `isValidSignature` (ERC-1271), which by bytecode recovers an
ECDSA signature from its registered signer keys (PQ-4). A quantum attacker who recovers a signer key could make the
vault sign orders that hand its inventory to the attacker. The vault held millions until 2026-05-07, when its
inventory was withdrawn; it now holds about USD 1. Rated LOW (step 5): a fix is a new deployment by the single owner
(MEDIUM at step 4), and less than USD 50k is held.

## Mechanism

- Venues call `isValidSignature(bytes32,bytes)` on the vault as the order maker: 1inch LOP (also
  `takerInteraction`), UniswapX `ExclusiveDutchOrderReactor` `0x6000da47…` (`reactor()`), CoW settlement
  `0x9008d19f…`, and AirSwap (`swapERC20`). INFERRED from bytecode (OpenZeppelin `ECDSA`, the unresolved
  `0x2f0dd388(address,address,bool)` registry setter): the vault returns the magic value when the signature recovers
  to a registered signer. The venue then pulls the vault's tokens through its approvals.
- The owner manages the signer registry, venues, cashier and withdrawal allow-lists (`Liq: onlyOwner`).
- The draft named `registerAllowedOrderSigner`; that selector is not in this bytecode. It is the 0x v4 function a
  maker contract calls, so the vault may have used it on 0x as a maker.

Pattern PQ-4. No verified source ([`source-excerpts.md`](#source-excerpts-unidentified-9ba0cf15-signer-key)).

## Evidence

- CHECKED (bytecode: selectors, `Liq:` revert strings, the `n/2` constant) and CHECKED (`cast`, block 26,431,544):
  `owner()` is EOA `0xc493f943…`; `reactor()` is UniswapX `0x6000da47…`
  ([`notes.md`](#review-notes-review08-2026-11-17)).
- CHECKED (Blockscout token transfers): on 2026-05-07 the vault sent 1,268,771 USDC, 206,282 USDT and 1,291 WETH to
  `0xd4d5db5e…` (a small proxy contract, now empty). Fills through CoW and others stop around then.
- CHECKED (on-chain read, block 26,431,214): about USD 1.46 held, all spam tokens
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-9ba0cf15-signer-key/onchain.json)).
- CHECKED (precompile trace, year to March 2026, `curated_contracts.csv`): 524,574 transactions with `ecrecover` here.
  The USD 23B of transfers in them is trading flow, not holdings.
- CHECKED (Xatu): no transaction in 2026-10-16 to 2026-11-16; last on 2026-05-28.
- Not identified: deployer EOA `0x9e056868…` and owner `0xc493f943…` have no ENS or tag; the `Liq:` prefix alone does
  not establish the team.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x9ba0cf15…` MM vault | config-only | $1 | 2026-05-28 | 0 |

Held value is the exposure: a forged signer signature can only give away what the vault holds or what its approvals
let venues pull from it. Siblings by the same deployer with identical selectors: `0x935cd8c1…` (2025-12-11, owner EOA
`0xfb61bf30…`, about USD 1) and `0xb02f39e3…` (older, USD 0). Where the inventory went after `0xd4d5db5e…` was not
traced; if it now sits in another vault of this design, that vault belongs in this finding.

## Remediation

- Owner `0xc493f943…`: keep this vault empty and revoke its venue approvals; a new vault should verify a
  post-quantum signer in `isValidSignature` (ERC-7913 verifier). Rotating the ECDSA signer keys does not help. The
  owner is itself an ECDSA EOA.
- No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review08): MEDIUM -> LOW, step 5: the vault was emptied on 2026-05-07 and holds about USD 1 (measured), below USD 50k; owner read as EOA 0xc493f943…; project still unidentified.
- 2026-11-19: LOW -> MEDIUM, step 5 removed (value no longer lowers a rating); step 4 gives MEDIUM.

# Source excerpts: unidentified-9ba0cf15-signer-key

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x9ba0cf1588e1dfa905ec948f7fe5104dd40eda31`

No verified source on Sourcify or Blockscout.

# Review notes (Review08, 2026-11-17)

Unverified. Reads at block 26,431,544 unless noted.

| Call | Result |
|---|---|
| `owner()` | `0xc493f943a1fd910d01dcabea86e61415ce43e787` (EOA, 0.26 ETH) |
| `reactor()` | `0x6000da47483062a0d734ba3dc7576ce6a0b645c4` (Blockscout name `ExclusiveDutchOrderReactor`, UniswapX) |
| `wNATIVE()` | WETH |
| `0x092fd7e9`, `0x8d5c93bd`, `0x99757fce`, `0xc2182878` (no args) | revert `Liq: onlyOwner` |
| holdings | about USD 1.46 of spam tokens, no ETH (onchain.json, block 26,431,214) |

Bytecode selectors: `isValidSignature(bytes32,bytes)`, `takerInteraction(...)` (1inch Limit Order Protocol v4 taker
hook), `setLimitOrderProtocol`, `setReactor`/`reactor` (UniswapX), `swapERC20()` (AirSwap), `cashier(address)`,
`withdrawalWhitelist(address)`, `withdrawNative`, `setOwner`, unresolved `0x2f0dd388(address,address,bool)`.
OpenZeppelin `ECDSA` `n/2` constant present. INFERRED: `isValidSignature` returns the magic value when an ECDSA
signature recovers to a registered signer, which makes the vault the maker of RFQ orders on these venues.

Deployer: EOA `0x9e056868b204ffe34351eb00a404e3fc9eec5192` (no ENS or tag). It created this vault on 2025-03-07 and
configured it, and created siblings with identical selectors:

| Address | Created | owner | Priced holdings | Last token transfer |
|---|---|---|---|---|
| `0xb02f39e382c90160eb816de5e0e428ac771d77b5` | 2024 (older version) | `0xc493f943…` | 0 | 2026-10-31 (incoming dust) |
| `0x935cd8c1b23b0a9f02428e3792e797165e3ca8b2` | 2025-12-11 | `0xfb61bf3079f47f644bce9c4d36b55d608a186778` (EOA) | about USD 1 | 2026-09-29 |

Flows (Blockscout token transfers): the vault filled orders through CoW Protocol `0x9008d19f…` and other venues until
2026-05-07. That day it sent 1,268,771 USDC, 206,282 USDT and 1,291 WETH to `0xd4d5db5ec65272b26f756712247281515f211e95`
(a 68-byte proxy contract created by `0xc3ebddea…`, now empty). Later inflows are small exchange-payout dust.

Usage: `curated_contracts.csv`: 524,574 transactions with `ecrecover` in this contract in the year to March 2026.
