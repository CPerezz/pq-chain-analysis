---
id: binance-wallet-vault-signer
title: "Binance Wallet swap vaults (\"binance w3w vault\"): a quantum attacker who recovers the order-signer and a relayer ECDSA key can swap the vault's USD 623k stablecoin inventory to an address of their choice"
project: binance-wallet
status: confirmed
severity: MEDIUM
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x88649f4743a758171077b98ee2003f1989b1615a"
  implementation: "0x471a8de3eec36775d230070f9704cc86bf0f360d"
  name: ERC1967Proxy -> unverified UUPS vault (EIP-712 "binance w3w vault" 0.1.0), paused since 2026-11-01
  upgradeable: "yes"
  admin: "UUPS upgradeToAndCall: DEFAULT_ADMIN_ROLE EOA 0x9fa1e9f10ba1d9ce014196626067fe4af3e237d9 (admin of all roles); ROLE_ADMIN EOA 0xad1b7c3a742114e9724f5dfc76221c1bfac38bcb (unpause, setRouter, emergencyWithdraw); ROLE_SIGNER EOA 0x6fa9e206217e6ce7535257e44f03d23acb3044ad; read at block 26,431,537"
  value_usd: 622816
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-01
  txs_30d: 1796
- address: "0xa7323e4523959d03600c2c1fc1371320d800f872"
  implementation: "0xc01af02cf17f3dee5857da085d5f58c28375d5d3"
  name: ERC1967Proxy -> unverified UUPS vault (EIP-712 "binance w3w vault" 0.1.0)
  upgradeable: "yes"
  admin: "UUPS upgradeToAndCall: DEFAULT_ADMIN_ROLE EOA 0xee7b429ea01f76102f053213463d4e95d5d24ae8; signer EOA 0xd88165cc36d05c9d27d648e5be9f4e7ba97e5b94; read at block 26,431,537"
  value_usd: 23
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-14
  txs_30d: 46
families: []
fix:
  layer: contract-upgrade
  who_acts: "Binance Wallet: DEFAULT_ADMIN_ROLE EOAs 0x9fa1e9f10ba1d9ce014196626067fe4af3e237d9 (vault 0x88649f47) and 0xee7b429ea01f76102f053213463d4e95d5d24ae8 (vault 0xa7323e45) upgrade the implementations; ROLE_ADMIN 0xad1b7c3a742114e9724f5dfc76221c1bfac38bcb can emergencyWithdraw the paused vault's inventory"
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/binance-wallet-vault-signer
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review16)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/binance-wallet-vault-signer/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Two vault proxies whose EIP-712 domain is "binance w3w vault" hold stablecoin inventory and swap it through the
Binance Wallet DEX router for recipients named in orders that one backend ECDSA key (`ROLE_SIGNER`) signs and one of
20 relayer addresses submits. The signer's public key is in every order's calldata and the relayers sign their own
transactions, so a quantum attacker can sign and submit an order that swaps the vault's inventory to themselves.
Exposed: USD 623k in `0x88649f47…` (paused since 2026-11-01, still holding it) and USD 23 in the active vault
`0xa7323e45…` (block 26,431,537). Both are UUPS proxies the team can upgrade: MEDIUM (step 4).

## Mechanism

- Implementation `0x471a8de3…` is unverified; selectors and revert strings show OpenZeppelin 5 UUPS +
  AccessControlEnumerable + Pausable + EIP712 (`ROLE_SIGNER()`, `ROLE_OPERATOR()`, `ROLE_ADMIN()`, `signers()`,
  `operators()`, `admins()`, `owners()`, `orderIdUsed(uint256)`, `setRouter`/`getRouter`, `emergencyWithdraw`,
  `pause`/`unpause`, `upgradeToAndCall`).
- `0x3271ba8d(uint256 orderId, address tokenIn, uint256 amountIn, address tokenOut, uint256 minOut, address recipient,
  uint256 deadline, bytes routerCalldata, bytes signature)` (argument names inferred from a decoded call): requires the
  caller to hold role `0x39ba2c7e…` (20 relayer addresses), recovers the EIP-712 order signer with `ecrecover` and
  requires it to hold `ROLE_SIGNER` (else `InvalidSignature(recovered)`), checks `orderIdUsed` and the deadline, then
  approves the vault's own `tokenIn` to the router (`getRouter()` = `0xb300000b…`, Etherscan label "Binance: DEX
  Router") and calls it with `routerCalldata`; the output goes to `recipient`.
- Signer rotation is a role grant by `DEFAULT_ADMIN_ROLE`; the scheme is fixed in the implementation:
  `alternative: key-rotation-only`. Pattern PQ-4. No verified source
  ([`source-excerpts.md`](#source-excerpts-binance-wallet-vault-signer)).

## Evidence

- CHECKED (drpc `debug_traceTransaction`, tx `0x36ab57e3…`, block 26,301,290): relayer `0xb156d0f3…` →
  `0x3271ba8d` → `ecrecover` returns `0x6fa9e206…` (the only `ROLE_SIGNER`) → vault approves 45.58 USDT to the router
  and calls it → output token delivered to the order's recipient.
- CHECKED (`eth_call` replay at block 26,301,289): the same input with one signature byte changed reverts
  `InvalidSignature(0x73a80ad4…)`; from a non-relayer it reverts `AccessControlUnauthorizedAccount(…, 0x39ba2c7e…)`.
  At block 26,431,537 the original input reverts `EnforcedPause`.
- CHECKED (`eth_call` at block 26,431,537): EIP-1967 implementation `0x471a8de3…`, admin slot empty; `paused()` true
  (paused by `ROLE_OPERATOR` `0x30606ae9…`, tx `0x0a243443…`, block 26,317,413); role members as in the header, every
  role administered by `DEFAULT_ADMIN_ROLE`; the admin, operator and signer holders have no code (nor do relayers
  `0xb156d0f3…` and `0xd08c4598…`, checked). `upgradeToAndCall` succeeds only from
  `0x9fa1e9f1…`; `unpause`, `setRouter` and `emergencyWithdraw` only from `0xad1b7c3a…`.
- CHECKED (identification): `eip712Domain()` = ("binance w3w vault", "0.1.0", chain 1); router `0xb300000b…` carries
  the Etherscan public label "Binance: DEX Router" (web search). Proxy created 2025-03-22 by `0x28962968…`, current
  implementation set 2025-04-18 by `0x9fa1e9f1…`; implementation deployed by `0xee7b429e…`, which also deploys the
  router Diamond `0x4d76b13d…` and upgrades `0xa7323e45…`. `findings_map.csv` has no note for this address.
- CHECKED (sibling, block 26,431,537): `0xa7323e45…` has the same EIP-712 domain, `signers()` = `0xd88165cc…`,
  `owners()`/`DEFAULT_ADMIN_ROLE` = `0xee7b429e…` (only it can `upgradeToAndCall`), 4 relayers, router `0x4d76b13d…`,
  not paused; trace of tx `0x03589cd9…` (block 26,412,283) shows `ecrecover` → `0xd88165cc…` before the vault spends
  its USDT through the router.
- CHECKED (balances, `eth_call` at block 26,431,537; prices Blockscout `exchange_rate`): see the table;
  [`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/binance-wallet-vault-signer/escrow.json).
- CHECKED ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/binance-wallet-vault-signer/activity.json), Xatu): 1,796 transactions to
  `0x88649f47…` in 2026-10-16 to 2026-11-16, last 2026-11-01 (the pause). For `0xa7323e45…`: 46 direct transactions
  in the same window from the Blockscout list (not in Xatu output). Yearly pre-quantum calls of `0x88649f47…`
  (`curated_contracts.csv`, `txs_y1`): 97,083.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x88649f47…` vault (paused) | yes | USD 623k | 2026-11-01 | 1,796 |
| `0xa7323e45…` vault | yes | USD 23 | 2026-11-14 | 46 |

`0x88649f47…` at block 26,431,537: USDT 566,270.52 (USD 565,871 at 0.999294), USDC 56,898.30 (USD 56,877 at
0.999622), XAUT 0.016375 (USD 63), other tokens USD 4, ETH 0.001 (USD 2 at USD 1,811.62). Total USD 622,816: the
vault's own inventory, which a forged order converts and sends to the attacker. The pause blocks the swap function
today (`EnforcedPause` for `0x3271ba8d` at block 26,431,537), but it is lifted by `ROLE_ADMIN`, and
`DEFAULT_ADMIN_ROLE` `0x9fa1e9f1…` (an EOA that has sent transactions, so its public key is on-chain) can grant that
role or upgrade the vault outright; a quantum attacker therefore reaches these funds with or without the signer key.
`0xa7323e45…` held USDT 6.19, USDC 7.94 and ETH 0.005 (USD 23). Siblings checked: `0x28962968…` also created
`0x77eb3bd5…` and `0xfa27388e…`, earlier vault implementations (same EIP-712 name, not proxies, no ETH or tokens);
the three other ERC1967 proxies on the latest page of `0xee7b429e…`'s transactions have EIP-712 name
"EthenaMintRedeemProxy" or none. No other "binance w3w vault" proxy was found, but no full search by domain was
possible.

## Remediation

- Replacement: upgrade the vault implementations to verify a post-quantum order signature (for example through an
  ERC-7913 verifier for an ML-DSA or SLH-DSA backend key) for every order that spends inventory; relayers and admins
  would also need post-quantum accounts for the role checks to hold.
- Who acts: Binance Wallet, through `DEFAULT_ADMIN_ROLE` `0x9fa1e9f10ba1d9ce014196626067fe4af3e237d9` (vault
  `0x88649f47…`) and `0xee7b429ea01f76102f053213463d4e95d5d24ae8` (vault `0xa7323e45…`); for the paused vault,
  `ROLE_ADMIN` `0xad1b7c3a742114e9724f5dfc76221c1bfac38bcb` can `emergencyWithdraw` the USD 623k, which removes the
  exposure without an upgrade.
- Protocol change: not needed; EIP-8151 does not help (all keys are code-less EOAs). Users cannot act: the funds are
  the vault's.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review16): MEDIUM -> MEDIUM, step 4: signer check confirmed by trace and replay (`ecrecover` against `ROLE_SIGNER` `0x6fa9e206…`, relayer role required); fix is a UUPS upgrade by the `DEFAULT_ADMIN_ROLE` EOA; USD 622,816 held at block 26,431,537 (step 5 does not lower). Project identified as Binance Wallet (EIP-712 domain "binance w3w vault", router labelled "Binance: DEX Router"); added sibling vault `0xa7323e45…`; recorded the pause (2026-11-01) and the role holders; status candidate -> confirmed.
- 2026-11-17 integration: id renamed from `unidentified-88649f47-signer-key` (project identified).

# Source excerpts: binance-wallet-vault-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x88649f4743a758171077b98ee2003f1989b1615a` — ERC1967Proxy (verified source via sourcify)

## Implementation `0x471a8de3eec36775d230070f9704cc86bf0f360d`

No verified source on Sourcify or Blockscout.
