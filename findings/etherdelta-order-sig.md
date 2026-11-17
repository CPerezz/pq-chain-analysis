---
id: etherdelta-order-sig
title: "EtherDelta: a quantum attacker who recovers a depositor's ECDSA key can sign orders that trade away that user's deposit in the immutable exchange (USD 39.8M deposited)"
project: etherdelta
status: confirmed
severity: HIGH
patterns: [PQ-2]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x8d12a197cb00d4747a1fe03395095ce2a5cc6819"
  implementation: null
  name: EtherDelta
  upgradeable: "no"
  admin: "admin() EOA 0x1ed014aec47fae44c9e55bac7662c0b78ae61798 can only change the admin, fee account, account-levels contract and lower fees; no upgrade (read at block 26431459)"
  value_usd: 39827526
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 311
families: []
fix:
  layer: account-migration
  who_acts: "nobody can change the contract; each depositor withdraws (withdraw/withdrawToken by msg.sender) or moves funds to a fresh post-quantum account; EIP-8151 would protect migrated accounts with code"
  protocol_change: helps
evidence:
  level: source-read
  links:
  - evidence/etherdelta-order-sig/classification.jsonl
  - evidence/etherdelta-order-sig/onchain.json
  - evidence/etherdelta-order-sig/activity.json
  - evidence/etherdelta-order-sig/source-excerpts.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

EtherDelta (2017 order-book DEX) fills an off-chain order when the maker either posted it on-chain with `order()` or
signed it with ECDSA (PQ-2: the signer chooses the scheme). A quantum attacker who recovers a depositor's key from any
of its on-chain signatures can sign an order that sells the depositor's balance for almost nothing and fill it,
including for addresses that have moved to post-quantum authorisation. The contract holds USD 39.8M of users'
deposits and has no upgrade path. Rated HIGH: step 4 (users' own funds stay forgeable in a contract that cannot
change; only every user withdrawing, or a protocol change such as EIP-8151, protects them).

## Mechanism

- `trade(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s, amount)` (source lines 252-260)
  hashes the order with `sha256(this, …)` and accepts it if `orders[user][hash]` is set **or**
  `ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user`; `tradeBalances` (lines 265-279) then
  moves `tokenGive` from `user`'s internal balance to `msg.sender`.
- `order(...)` (lines 246-250) sets `orders[msg.sender][hash] = true`, so a contract or post-quantum account can make
  orders without a signature; that path does not disable the ECDSA path for the same address.
- `cancelOrder` (line 308) uses the same either-or check; `availableVolume`/`testTrade` are views.
- No ERC-1271 call exists. Pattern PQ-2 (signer-chosen scheme); excerpts in
  [`source-excerpts.md`](../evidence/etherdelta-order-sig/source-excerpts.md).

## Evidence

- CHECKED (verified source on Sourcify, full file read 2026-11-17): the lines above; admin functions
  `changeAdmin`, `changeAccountLevelsAddr`, `changeFeeAccount`, `changeFeeMake/Take/Rebate` (fees can only go down);
  `withdraw`/`withdrawToken` pay `msg.sender` only.
- CHECKED (`cast call` at block 26,431,459): no proxy (code 6,613 bytes, no EIP-1967 slots per `onchain.json`);
  `admin()` = `0x1ed014ae…`, an EOA (no code, nonce 3,347); `feeAccount()` `0xa6dad410…`; `accountLevelsAddr()` zero;
  `feeTake()` 0.3%, `feeMake()` 0; ETH balance 15,154.04 ETH.
- CHECKED (on-chain read at block 26,431,214): holdings 15,154 ETH plus $12.37M of priced tokens (LINK $4.74M, BNB
  $4.48M, P2PS $1.82M, TRAC $0.43M, NEXO $0.11M), $39.8M in total ([`onchain.json`](../evidence/etherdelta-order-sig/onchain.json)).
- CHECKED (precompile trace): 179 `ecrecover` calls in the year to March 2026 (`curated_contracts.csv`, `txs_y1`).
- CHECKED (Xatu, any function): 311 transactions touched the contract in 2026-10-16 to 2026-11-16, last 2026-11-15
  ([`activity.json`](../evidence/etherdelta-order-sig/activity.json)).
- INFERRED: the balances are users' deposits (the contract has no protocol-owned funds besides fees credited to
  `feeAccount`); much of it likely belongs to dormant addresses, whose keys are exposed only if they ever signed.

## Impact and exposure

| Contract | Upgradeable | Held now (users' deposits) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x8d12a197…` EtherDelta | no | $39.8M | 2026-11-15 | 311 |

The held balance is the exposure here: it is the depositors' own funds, which a forged maker signature hands to the
taker. Only depositors whose public key is on-chain (any address that ever sent a transaction or signed an order) can
be forged. No sibling deployments were checked beyond this address; older EtherDelta contracts are not in the census.

## Remediation

- Post-quantum replacement: none in this contract (immutable, admin cannot change verification).
- Who acts: each depositor withdraws with `withdraw`/`withdrawToken` (authorised by `msg.sender`, so a post-quantum
  account can do it) or stops depositing; EtherDelta's admin `0x1ed014ae…` can do nothing about the check.
- Protocol change: helps. EIP-8151 would make `ecrecover` fail for migrated accounts that have code; addresses that
  stay plain EOAs remain only as safe as their key.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review20): HIGH kept, step 4. Full source read: the alternative is on-chain `order()`, not
  ERC-1271; admin read as EOA `0x1ed014ae…` with fee-only powers; the $39.8M held is users' deposits, which forged
  maker signatures release, so it stays as the exposure.
