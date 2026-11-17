---
id: unidentified-9ba0cf15-signer-key
title: "Unidentified RFQ market-maker vault 0x9ba0cf15 (1inch LOP, UniswapX, CoW, AirSwap): a forged signer key makes the vault sign any order, but the vault was emptied on 2026-05-07 and holds about USD 1"
project: unidentified-9ba0cf15
status: candidate
severity: LOW
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
  links:
  - evidence/unidentified-9ba0cf15-signer-key/classification.jsonl
  - evidence/unidentified-9ba0cf15-signer-key/onchain.json
  - evidence/unidentified-9ba0cf15-signer-key/activity.json
  - evidence/unidentified-9ba0cf15-signer-key/source-excerpts.md
  - evidence/unidentified-9ba0cf15-signer-key/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review08 (bytecode, token flows, deployer siblings, on-chain reads)
  ref: evidence/unidentified-9ba0cf15-signer-key/notes.md
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

Pattern PQ-4. No verified source ([`source-excerpts.md`](../evidence/unidentified-9ba0cf15-signer-key/source-excerpts.md)).

## Evidence

- CHECKED (bytecode: selectors, `Liq:` revert strings, the `n/2` constant) and CHECKED (`cast`, block 26,431,544):
  `owner()` is EOA `0xc493f943…`; `reactor()` is UniswapX `0x6000da47…`
  ([`notes.md`](../evidence/unidentified-9ba0cf15-signer-key/notes.md)).
- CHECKED (Blockscout token transfers): on 2026-05-07 the vault sent 1,268,771 USDC, 206,282 USDT and 1,291 WETH to
  `0xd4d5db5e…` (a small proxy contract, now empty). Fills through CoW and others stop around then.
- CHECKED (on-chain read, block 26,431,214): about USD 1.46 held, all spam tokens
  ([`onchain.json`](../evidence/unidentified-9ba0cf15-signer-key/onchain.json)).
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

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review08): MEDIUM -> LOW, step 5: the vault was emptied on 2026-05-07 and holds about USD 1 (measured), below USD 50k; owner read as EOA 0xc493f943…; project still unidentified.
