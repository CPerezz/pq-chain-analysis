---
id: unidentified-cd815022-pmm-vault-signer
title: "PMM market-maker vaults filled through OKX DEX router (owner Safe 0x91fd0998…): a forged operator key makes the vaults sign any order and hands over about USD 0.94M of inventory"
project: unidentified-cd815022
status: candidate
severity: MEDIUM
patterns: [PQ-4]
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
- address: "0x2e104fb25676c7c3e3a5a648865cca1db15dcc71"
  implementation: "0xbf95581001997a4ad56b741575cdf94820b2e113"
  name: PMM vault (EIP-1967 proxy, same deployer and design; not in the precompile census)
  upgradeable: "yes"
  admin: "ProxyAdmin 0x88e0ab3351446461f16813899fc40cce2d85aceb, owned by Safe 0x91fd09982efff951df4ff80e7e78fee1981ac51d (2 of 5); read at block 26,431,544"
  value_usd: 664607
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: null
- address: "0x8377d393cca7ee75b4e91c612a967e89442d460d"
  implementation: null
  name: PMM vault (not a proxy, same deployer and design; not in the precompile census)
  upgradeable: config-only
  admin: "owner Safe 0x91fd09982efff951df4ff80e7e78fee1981ac51d (2 of 5): setOperator, withdraw; read at block 26,431,544"
  value_usd: 272652
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: null
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
families: []
fix:
  layer: contract-upgrade
  who_acts: "vault owner Safe 0x91fd09982efff951df4ff80e7e78fee1981ac51d (2 of 5) upgrades the implementations through the ProxyAdmins, and replaces the non-proxy vault 0x8377d393…"
  protocol_change: not-needed
evidence:
  level: bytecode
  links:
  - evidence/unidentified-cd815022-pmm-vault-signer/classification.jsonl
  - evidence/unidentified-cd815022-pmm-vault-signer/onchain.json
  - evidence/unidentified-cd815022-pmm-vault-signer/activity.json
  - evidence/unidentified-cd815022-pmm-vault-signer/source-excerpts.md
  - evidence/unidentified-cd815022-pmm-vault-signer/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review08 (bytecode, proxy slots, Safe reads, deployer siblings, token flows)
  ref: evidence/unidentified-cd815022-pmm-vault-signer/notes.md
  date: 2026-11-17
  verdict: reported
  rating: MEDIUM
related: []
---

## Summary

A market maker quoting on OKX's DEX router keeps its inventory in vault contracts that act as ERC-1271 makers. Each
vault's `isValidSignature` accepts an ECDSA signature from an address set with `setOperator` (PQ-4, from bytecode). A
quantum attacker who recovers an operator key can make a vault approve any order and drain its inventory. The listed
vault was emptied on 2026-03-25, but the same deployer and owner Safe run sibling vaults of the same design that hold
about USD 0.94M (Blockscout, 2026-11-17). Rated MEDIUM (step 4): the 2-of-5 owner Safe can upgrade or replace the
vaults. OKX's ownership of the vaults is not established, so the project is recorded as unidentified.

## Mechanism

- A taker swaps through OKX `DexRouter` (`dagSwapByOrderId`, `0x5e1f62da…`). The router settles a PMM order whose
  maker is the vault and checks the maker signature with `vault.isValidSignature(hash, signature)`.
- Vault bytecode: `isValidSignature(bytes32,bytes)`, `setOperator(address,bool)` / `isOperator`,
  `setWhitelist` / `isWhitelist`, `withdraw`, `multiSend`, `wrap` / `unwrap`, the string `at least 65 sig` and the
  OpenZeppelin `ECDSA` constant. INFERRED: a 65-byte signature that recovers to an operator returns the magic value,
  and the router then moves the vault's tokens.
- Rotating operators keeps the scheme; only new vault code removes it.

Pattern PQ-4. No verified source ([`source-excerpts.md`](../evidence/unidentified-cd815022-pmm-vault-signer/source-excerpts.md)).

## Evidence

- CHECKED (`cast`, block 26,431,454): `0xcd815022…` implementation slot `0x2e9f95c5…`, admin slot ProxyAdmin
  `0x0a19711f…`, ProxyAdmin `owner()` and vault `owner()` Safe `0x91fd0998…`, Safe threshold 2 of 5
  ([`notes.md`](../evidence/unidentified-cd815022-pmm-vault-signer/notes.md)).
- CHECKED (bytecode of all five implementations or vaults): the same selector set and `ECDSA` constant.
- CHECKED (Blockscout): all vaults were created by EOA `0x2900cb55…` (no ENS or tag). On 2026-03-25 the Safe moved the
  listed vault's 190k USDC, 655k USDT, 267.5 WETH and 2.43 WBTC to the newer vault `0xdd4bdbbb…`. `0x2e104fb2…` and
  `0x8377d393…` traded on 2026-11-16.
- CHECKED (Blockscout token balances, 2026-11-17): `0x2e104fb2…` about USD 664,607; `0x8377d393…` about USD 272,652;
  `0xdd4bdbbb…` about USD 16 plus 0.01 ETH; the listed vault 0.
- CHECKED (precompile trace, year to March 2026, `curated_contracts.csv`): 19,874 transactions with `ecrecover` in the
  listed vault. INFERRED for the siblings: they were created after the census window, so `ecrecover` was not traced
  there.
- CHECKED (Xatu): no transaction to the listed vault in 2026-10-16 to 2026-11-16; last on 2026-04-14.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xcd815022…` vault (listed) | yes | $0 | 2026-04-14 | 0 |
| `0x2e104fb2…` vault | yes | $664,607 | 2026-11-16 | not measured |
| `0x8377d393…` vault | config-only | $272,652 | 2026-11-16 | not measured |
| `0xdd4bdbbb…` vault | yes | $34 | 2026-08-16 | not measured |

Total held about USD 937k (held basis; the vaults' own inventory is what a forged operator signature releases).
Also checked: `0x65ec88a7…` and `0x803e2981…`, same design, owner EOA `0xe893e2a5…` (one of the Safe's signers),
hold nothing; they were not added. The three added vaults were not in the census list.

## Remediation

- Vault owner Safe `0x91fd0998…` (2 of 5): upgrade the proxied vaults through their ProxyAdmins to code that verifies a
  post-quantum operator signature (ERC-7913 verifier) in `isValidSignature`; move the inventory out of the
  non-upgradeable `0x8377d393…`. The Safe's signers are themselves ECDSA keys.
- No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review08): MEDIUM unchanged (step 4: upgrade by the 2-of-5 owner Safe 0x91fd0998…; step 5 does not apply because the sibling vaults of the same deployer and owner hold about USD 937k). Added sibling vaults 0x2e104fb2…, 0x8377d393…, 0xdd4bdbbb… (bytecode evidence; not in the census); the listed vault was emptied on 2026-03-25. project okx -> unidentified-cd815022: fills go through OKX's DexRouter, but neither the deployer nor the Safe is linked to OKX.
- 2026-11-17 integration: id renamed from `okx-pmm-vault-signer` (the OKX attribution was not established); `related` link to the OKX wallet-link finding removed for the same reason.
