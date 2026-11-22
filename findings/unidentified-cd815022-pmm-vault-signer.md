---
id: unidentified-cd815022-pmm-vault-signer
title: "PMM market-maker vaults filled through OKX DEX router (owner Safe 0x91fd0998…): a forged operator key makes the vaults sign any order and hands over about USD 0.98M of inventory"
status: confirmed
severity: MEDIUM
patterns: [PQ-4, PQ-17, PQ-18]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0xcd81502214d405f40ff14884f2b3962a2f822d67"
  implementation: "0x2e9f95c5327e3c6c30d6601b4bb1b527defea577"
  name: PMM vault (EIP-1967 proxy, unverified implementation)
  upgradeable: "yes"
  admin: "ProxyAdmin 0x0a19711f1b1696bf1fb93478bb3e5f454a3ab07b, owned by Safe 0x91fd09982efff951df4ff80e7e78fee1981ac51d (2 of 5), which is also the vault owner (setOperator); read at block 26,431,454"
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-04-14
  txs_30d: 0
  txs_90d: 0
- address: "0x2e104fb25676c7c3e3a5a648865cca1db15dcc71"
  implementation: "0xbf95581001997a4ad56b741575cdf94820b2e113"
  name: PMM vault (EIP-1967 proxy, same deployer and design; not in the precompile census)
  upgradeable: "yes"
  admin: "ProxyAdmin 0x88e0ab3351446461f16813899fc40cce2d85aceb, owned by Safe 0x91fd09982efff951df4ff80e7e78fee1981ac51d (2 of 5); read at block 26,431,544"
  value_usd: 664607
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-18
  txs_30d: null
  txs_90d: 18980
- address: "0x8377d393cca7ee75b4e91c612a967e89442d460d"
  implementation: null
  name: PMM vault (not a proxy, same deployer and design; not in the precompile census)
  upgradeable: config-only
  admin: "owner Safe 0x91fd09982efff951df4ff80e7e78fee1981ac51d (2 of 5): setOperator, withdraw; read at block 26,431,544"
  value_usd: 315300
  value_basis: held
  value_as_of: 2026-11-18
  last_active: 2026-11-18
  txs_30d: null
  txs_90d: 4101
- address: "0xdd4bdbbb5e2e69165397f4af16ae520e549da1e4"
  implementation: "0x1bdb1d6bbe6d3bd03ec2897bcce530926493680f"
  name: PMM vault (EIP-1967 proxy, same deployer and design; not in the precompile census)
  upgradeable: "yes"
  admin: "ProxyAdmin 0xbc6eeb953c3f9879da28a8a2b3158c06c7f349a7, owned by Safe 0x91fd09982efff951df4ff80e7e78fee1981ac51d (2 of 5); read at block 26,431,544"
  value_usd: 34
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-08-16
  txs_30d: null
  txs_90d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: "vault owner Safe 0x91fd09982efff951df4ff80e7e78fee1981ac51d (2 of 5) upgrades the implementations through the ProxyAdmins, and replaces the non-proxy vault 0x8377d393…"
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-cd815022-pmm-vault-signer
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
  who: Review08 (bytecode, proxy slots, Safe reads, deployer siblings, token flows)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-cd815022-pmm-vault-signer/notes.md
  date: 2026-11-17
  verdict: reported
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 99520b6f, 44902078"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "Rubric MEDIUM: the 2-of-5 owner Safe can upgrade or replace the proxied vaults and move the inventory out of the non-upgradeable 0x8377d393. setOperator rotation alone keeps ECDSA. Operator values not read (no getter enumerated)."
related: []
---

## Summary

A market maker quoting on OKX's DEX router keeps its inventory in vault contracts that act as ERC-1271 makers. Each
vault's `isValidSignature` accepts an ECDSA signature from an address set with `setOperator` (PQ-4, from bytecode). A
quantum attacker who recovers an operator key can make a vault approve any order and drain its inventory. The listed
vault was emptied on 2026-03-25, but the same deployer and owner Safe run sibling vaults of the same design that hold
about USD 0.98M (re-read at block 26,438,999, 2026-11-18). Rated MEDIUM (step 4): the 2-of-5 owner Safe can upgrade
or replace the
vaults. OKX's ownership of the vaults is not established, so the project is recorded as unidentified.

## Mechanism

- A taker swaps through OKX `DexRouter` (`dagSwapByOrderId`, `0x5e1f62da…`). The router settles a PMM order whose
  maker is the vault and checks the maker signature with `vault.isValidSignature(hash, signature)`.
- Vault bytecode: `isValidSignature(bytes32,bytes)`, `setOperator(address,bool)` / `isOperator`,
  `setWhitelist` / `isWhitelist`, `withdraw`, `multiSend`, `wrap` / `unwrap`, the string `at least 65 sig` and the
  OpenZeppelin `ECDSA` constant. INFERRED: a 65-byte signature that recovers to an operator returns the magic value,
  and the router then moves the vault's tokens.
- Rotating operators keeps the scheme; only new vault code removes it.

Pattern PQ-4. No verified source ([`source-excerpts.md`](#source-excerpts-unidentified-cd815022-pmm-vault-signer)).

## Evidence

- CHECKED (`cast`, block 26,431,454): `0xcd815022…` implementation slot `0x2e9f95c5…`, admin slot ProxyAdmin
  `0x0a19711f…`, ProxyAdmin `owner()` and vault `owner()` Safe `0x91fd0998…`, Safe threshold 2 of 5
  ([`notes.md`](#review-notes-review08-2026-11-17)).
- CHECKED (bytecode of all five implementations or vaults): the same selector set and `ECDSA` constant.
- CHECKED (Blockscout): all vaults were created by EOA `0x2900cb55…` (no ENS or tag). On 2026-03-25 the Safe moved the
  listed vault's 190k USDC, 655k USDT, 267.5 WETH and 2.43 WBTC to the newer vault `0xdd4bdbbb…`. `0x2e104fb2…` and
  `0x8377d393…` traded on 2026-11-16.
- CHECKED (Blockscout token balances, 2026-11-17 unless noted): `0x2e104fb2…` about USD 664,607; `0x8377d393…`
  about USD 315,300 at block 26,438,999 (USDT 114.7k, USDC 100k, WETH 55.76 ≈ USD 100.6k; the original finding's
  notes listed no USDT, undercounting it at USD 272,652); `0xdd4bdbbb…` about USD 16 plus 0.01 ETH; the listed vault 0.
- CHECKED (precompile trace, year to March 2026, `curated_contracts.csv`): 19,874 transactions with `ecrecover` in the
  listed vault. INFERRED for the siblings: they were created after the census window, so `ecrecover` was not traced
  there.
- CHECKED (Xatu): no transaction to the listed vault in 2026-10-16 to 2026-11-16; last on 2026-04-14.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xcd815022…` vault (listed) | yes | $0 | 2026-04-14 | 0 |
| `0x2e104fb2…` vault | yes | $664,607 | 2026-11-18 | not measured |
| `0x8377d393…` vault | config-only | $315,300 | 2026-11-18 | not measured |
| `0xdd4bdbbb…` vault | yes | $34 | 2026-08-16 | not measured |

Total held about USD 979.5k (held basis; the vaults' own inventory is what a forged operator signature releases).
Also checked: `0x65ec88a7…` and `0x803e2981…`, same design, owner EOA `0xe893e2a5…` (one of the Safe's signers),
hold nothing; they were not added. The three added vaults were not in the census list.

## Remediation

- Vault owner Safe `0x91fd0998…` (2 of 5): upgrade the proxied vaults through their ProxyAdmins to code that verifies a
  post-quantum operator signature (ERC-7913 verifier) in `isValidSignature`; move the inventory out of the
  non-upgradeable `0x8377d393…`. The Safe's signers are themselves ECDSA keys.
- No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review08): MEDIUM unchanged (step 4: upgrade by the 2-of-5 owner Safe 0x91fd0998…; step 5 does not apply because the sibling vaults of the same deployer and owner hold about USD 937k). Added sibling vaults 0x2e104fb2…, 0x8377d393…, 0xdd4bdbbb… (bytecode evidence; not in the census); the listed vault was emptied on 2026-03-25. project okx -> unidentified-cd815022: fills go through OKX's DexRouter, but neither the deployer nor the Safe is linked to OKX.
- 2026-11-17 integration: id renamed from `okx-pmm-vault-signer` (the OKX attribution was not established); `related` link to the OKX wallet-link finding removed for the same reason.
- 2026-11-19 (study `eip-8151-impact`, PQ-17, PQ-18): under EIP-8151 a real transaction fails as sent and passes with more gas: whoever sends it must add gas on activation day; the signer key can be replaced; it must be rotated before its account takes code. Executed: a real transaction ends without error but with other logs when its signer has code.
- 2026-11-20: moved to triage with the rest of the pool and reviewed; state re-read at block 26,438,999; filed confirmed, MEDIUM; corrected 0x8377d393's held value to ~$315.3k (USDT 114.7k, USDC 100k, WETH 55.76 ≈ $100.6k; the finding's own notes listed no USDT), not $272,652; total held is ~$979.5k, not ~$937k.

# Source excerpts: unidentified-cd815022-pmm-vault-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xcd81502214d405f40ff14884f2b3962a2f822d67`

No verified source on Sourcify or Blockscout.

## Implementation `0x2e9f95c5327e3c6c30d6601b4bb1b527defea577`

No verified source on Sourcify or Blockscout.

# Review notes (Review08, 2026-11-17)

Unverified implementations. Reads at block 26,431,454 (listed vault) and 26,431,544 (siblings).

Listed vault `0xcd81502214d405f40ff14884f2b3962a2f822d67`:

| Read | Result |
|---|---|
| EIP-1967 implementation slot | `0x2e9f95c5327e3c6c30d6601b4bb1b527defea577` |
| EIP-1967 admin slot | `0x0a19711f1b1696bf1fb93478bb3e5f454a3ab07b` (ProxyAdmin, created by the proxy itself) |
| ProxyAdmin `owner()` and vault `owner()` | `0x91fd09982efff951df4ff80e7e78fee1981ac51d` (SafeProxy) |
| Safe `getThreshold()` / `getOwners()` | 2 / `0xf3747464…`, `0xe893e2a5…`, `0x544f54b9…`, `0x2be56f64…`, `0x9af1025d…` |
| Creator (Blockscout) | EOA `0x2900cb559cf7034f92dbf43d0c13da89fdb4fc7c` (no ENS or tag), 2026-01-07 |

Implementation bytecode: `isValidSignature(bytes32,bytes)`, `setOperator(address,bool)` / `isOperator(address)`,
`setWhitelist` / `isWhitelist`, `withdraw(address,address,uint256)`, `multiSend(address[],address)`, `wrap` / `unwrap`,
`initialize(address,address[],address[],uint256)`, `maxNum()`; strings `at least 65 sig`, `not permitted`,
`recipient not in whitelist`, `unwrap too frequently`; OpenZeppelin `ECDSA` `n/2` constant present. INFERRED:
`isValidSignature` returns the magic value when the signature recovers to an operator.

Fills: `dagSwapByOrderId` on OKX `DexRouter` `0x5e1f62dac767b0491e3ce72469c217365d5b48cc` (e.g. tx `0x2b4a332d25…`).
On 2026-03-25 the Safe (`execTransaction` from owner `0xe893e2a5…`) moved 190,259 USDC, 654,614 USDT, 267.5 WETH and
2.43 WBTC from the vault to `0xdd4bdbbb…`. Last activity on 2026-04-14 (a pass-through of 4 BBTC).

Same deployer, same owner Safe, same selector set (`isValidSignature`, `setOperator`, `n/2` constant):

| Vault | Kind | Implementation | Admin / owner | Priced tokens (Blockscout) | ETH | Last token transfer |
|---|---|---|---|---|---|---|
| `0x2e104fb25676c7c3e3a5a648865cca1db15dcc71` | EIP-1967 proxy | `0xbf95581001997a4ad56b741575cdf94820b2e113` | ProxyAdmin `0x88e0ab33…`, owner Safe `0x91fd0998…` | about USD 664,607 (USDC 466k, USDT 153k, WETH 46k) | 0 | 2026-11-16 |
| `0x8377d393cca7ee75b4e91c612a967e89442d460d` | not a proxy | — | owner Safe `0x91fd0998…` | about USD 272,652 (WETH 173k, USDC 100k) | 0 | 2026-11-16 (via a contract Blockscout names `DexRouter`, `0x8feab81d…`) |
| `0xdd4bdbbb5e2e69165397f4af16ae520e549da1e4` | EIP-1967 proxy | `0x1bdb1d6bbe6d3bd03ec2897bcce530926493680f` | ProxyAdmin `0xbc6eeb95…`, owner Safe `0x91fd0998…` | about USD 16 | 0.01 | 2026-08-16 |
| `0x65ec88a7eeee54a6b4cf6604d43edae415043fd2` | EIP-1967 proxy | `0x67458375dbe3427874f204d96d2b0ea0522efa69` | owner EOA `0xe893e2a5…` (a Safe signer) | 0 | — | 2026-08-08 |
| `0x803e29813751e6583f8e416bffeb52a99f1df69d` | EIP-1967 proxy | `0xfa355f61cf2e0c8919e825c8e390376a58a2cadd` | owner EOA `0xe893e2a5…` | 0 | — | none |

The first three were created after the precompile census window (to March 2026); `0x65ec88a7…` (2025-12-11) was not
in the census list either. `ecrecover` use in these siblings is INFERRED from the bytecode, not traced.
Attribution: fills go through OKX's DEX router, but the deployer and the Safe carry no OKX label; ownership by OKX is
not established.
