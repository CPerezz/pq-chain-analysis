---
id: morpho-permit-auth-ecdsa-only
title: "Morpho Blue and MetaMorpho vaults: a quantum attacker who recovers a user's ECDSA key can sign an authorization or permit and withdraw, borrow against or redeem that user's positions, even after the user migrates; the contracts cannot change"
project: morpho
status: confirmed
severity: HIGH
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: auxiliary
contracts:
- address: "0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb"
  implementation: null
  name: Morpho
  upgradeable: "no"
  admin: "none for the signature check (immutable, not a proxy); owner() Safe 0xcba28b38103307ec8da98377fff9816c164f9afa (6 of 10) only enables IRMs/LLTVs and sets fees"
  value_usd: 3194144815
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 242434
- address: "0xd63070114470f685b75b74d60eec7c1113d33a3d"
  implementation: null
  name: MetaMorpho
  upgradeable: "no"
  admin: "none for permit (immutable vault); owner() Safe 0x38afc3aa2c76b4ca1f8e1daba68e998e1f4782db (2 of 5) sets vault parameters only"
  value_usd: 1804166
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 136
- address: "0x777791c4d6dc2ce140d00d2828a7c93503c67777"
  implementation: null
  name: MetaMorphoV1_1
  upgradeable: "no"
  admin: "none for permit (immutable vault); owner() Safe 0xee7e9bb21d5589bf657b94083db2fa349a3918c8 (2 of 3) sets vault parameters only"
  value_usd: 1207041
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 352
- address: "0xbeefff209270748ddd194831b3fa287a5386f5bc"
  implementation: null
  name: MetaMorpho
  upgradeable: "no"
  admin: "none for permit (immutable vault); owner() Safe 0x0a0e559bc3b0950a7e448f0d4894db195b9cf8dd (5 of 10) sets vault parameters only"
  value_usd: 10453910
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 1674
- address: "0xbeef01735c132ada46aa9aa4c54623caa92a64cb"
  implementation: null
  name: MetaMorpho
  upgradeable: "no"
  admin: "none for permit (immutable vault); owner() Safe 0x0a0e559bc3b0950a7e448f0d4894db195b9cf8dd (5 of 10) sets vault parameters only"
  value_usd: 71854433
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 3105
families: []
fix:
  layer: account-migration
  who_acts: "nobody can change these contracts; each user protects themselves by moving positions to a fresh post-quantum account (Morpho can only ship new code-first versions for new deployments)"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/morpho-permit-auth-ecdsa-only
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_1.jsonl,out_2.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review23 (finding review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/morpho-permit-auth-ecdsa-only/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: HIGH
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by a person)"
  ref: "studies/eip-8151-impact, reading 3 (does EIP-8151 close this path), 2026-11-19"
  date: 2026-11-19
  verdict: confirmed
  rating: ''
related: []
---

## Summary

Morpho Blue's `setAuthorizationWithSig` and the MetaMorpho vaults' ERC-2612 `permit` accept a user's signature only
through `ecrecover` (PQ-1). A quantum attacker who recovers a user's secp256k1 key can authorize itself on Morpho Blue
and withdraw that user's supply and collateral or borrow against it, or permit itself the user's vault shares and
redeem them; this keeps working after the user moves the same address to post-quantum authorisation. A forged
authorization reaches only the signer's own positions, not the pool: the upper bound is everything users hold in
Morpho Blue ($3.19B) and in the four vaults ($85.3M of shares, overlapping with Morpho Blue). Rated HIGH (step 4):
the contracts are immutable, so only every user moving or a protocol change (EIP-8151) protects them.

## Mechanism

- Morpho Blue `setAuthorizationWithSig(authorization, signature)` (`Morpho.sol` lines 446–463): checks deadline and
  `nonce[authorizer]++`, then `ecrecover(digest, v, r, s)` must equal `authorization.authorizer`; it sets
  `isAuthorized[authorizer][authorized]`. No ERC-1271 and no account-code check.
- `_isSenderAuthorized(onBehalf)` gates `withdraw`, `borrow` and `withdrawCollateral`, which act on
  `position[id][onBehalf]` and pay any `receiver`. `borrow` and `withdrawCollateral` require the authorizer's own
  position to stay healthy, so the attacker can take the authorizer's supply, collateral, or a loan of up to LLTV
  against that collateral (the debt stays with the victim). Nothing beyond the victim's positions can be taken;
  lenders are only exposed through the normal liquidation risk of that loan.
- MetaMorpho / MetaMorphoV1_1 inherit OpenZeppelin v5 `ERC20Permit.permit`: `ECDSA.recover(hash, v, r, s) == owner`
  (excerpt line 61), then `_approve`. A forged permit lets the attacker `transferFrom` and `redeem` the holder's shares.
- Alternatives exist: `setAuthorization` and `approve` work by `msg.sender`, so post-quantum accounts are not locked
  out; the problem is only the old key of migrated addresses.
- Pattern PQ-1. Excerpts: [`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/morpho-permit-auth-ecdsa-only/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify `src/Morpho.sol`): `setAuthorizationWithSig`, `_isSenderAuthorized`, `borrow`,
  `withdrawCollateral` health checks; owner functions cannot touch the signature check
  ([`notes.md`](#review-notes-review23-2026-11-17)).
- CHECKED (verified source excerpts): the four vaults use OpenZeppelin `ERC20Permit` with `ECDSA.recover` only.
- CHECKED (on-chain read, block 26,431,214): no proxy on any of the five; owners are Safes (Morpho 6/10,
  `0xd6307011` 2/5, `0x777791c4` 2/3, `0xbeefff20` and `0xbeef0173` 5/10); Morpho Blue holds $3.19B
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/morpho-permit-auth-ecdsa-only/onchain.json)).
- CHECKED (on-chain read, block 26,431,500): vault `asset()` = USDC and `totalAssets()` for each vault (table below).
- CHECKED (Xatu, any function): 30-day transactions in the table, 2026-10-16 to 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/morpho-permit-auth-ecdsa-only/activity.json)). Pre-quantum use over a year
  (`curated_contracts.csv`, `txs_y1`): Morpho 11,559; vaults 5,632, 2,385, 2,368, 1,811 ecrecover transactions.
- CHECKED (executed, study `eip-8151-impact`, 2026-11-19): a real transaction,
  `0xbaf1b6a48c4cfa77d14888885eb206b5e24ef112651dc21fb8e3023ff2ab56fc` (block 26,351,677, position 25), replayed on
  the reference implementation of the fork with only the precompile changed. Under today's rule it matches its
  receipt (60,030 gas); under EIP-8151 it also succeeds (63,130 gas). With one byte of code at the recovered signer
  `0x37b6be5538ef5a3a0ae0e188292c0074c3def696`, it reverts after that recovery returned no address; with a 7702
  delegation there it succeeds. Study family `2984b11f` (Morpho).

## Impact and exposure

| Contract | Upgradeable | Exposure (upper bound, users' own funds) | Last active | 30-day txs |
|---|---|---|---|---|
| `0xbbbbbbbb…` Morpho (Blue) | no | $3.19B held (collateral + unlent supply) | 2026-11-16 | 242,434 |
| `0xd6307011…` MetaMorpho Usual Boosted USDC | no | $1.80M (vault `totalAssets`) | 2026-11-16 | 136 |
| `0x777791c4…` MetaMorphoV1_1 Hyperithm USDC Apex | no | $1.21M (vault `totalAssets`) | 2026-11-15 | 352 |
| `0xbeefff20…` MetaMorpho Smokehouse USDC | no | $10.45M (vault `totalAssets`) | 2026-11-15 | 1,674 |
| `0xbeef0173…` MetaMorpho Steakhouse USDC | no | $71.85M (vault `totalAssets`) | 2026-11-16 | 3,105 |

Morpho Blue's $3.19B is pooled lending liquidity plus collateral, but a forged authorization cannot take it as a pool:
each user's key reaches only that user's supply, collateral and borrowing capacity. The figure is the upper bound if
every depositor's key were forged, comparable to a token's market cap for `permit`. Vault values are the USDC behind
each vault's shares (USDC at $1); that USDC is supplied into Morpho Blue by the vault contract, so it overlaps with
the $3.19B. Only users whose address has signed on-chain (public key known) and who keep funds there are exposed;
for a plain EOA this adds nothing beyond its own key, the loss specific to this finding is for addresses that migrate
in place. Other MetaMorpho vaults with the same code exist on mainnet and were not enumerated here; only these four
were in the census.

## Remediation

- The contracts cannot change: Morpho Blue and the vaults are immutable, and their owner Safes cannot alter the
  signature checks. Morpho (and vault curators) can only ship future versions that check account code first and
  verify ERC-1271 / ERC-7913 with the full signature (PQ-13).
- Users: a migrated address must move its Morpho positions and vault shares to a fresh post-quantum account; until
  then, post-quantum accounts should use `setAuthorization` / `approve` directly.
- Protocol change: helps. EIP-8151 would make `ecrecover` fail for addresses with real account code, protecting
  migrated users here without any action by Morpho.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review23): HIGH kept, step 4: immutable contracts, users' own funds forgeable after migration. Checked that a forged `setAuthorizationWithSig` reaches only the authorizer's positions (health check on `onBehalf`), so Morpho Blue's $3.19B is an upper bound on users' own funds, not a pooled loss. `alternative` sole -> alternative-exists (`setAuthorization`, `approve`). Vault values re-measured as `totalAssets` (two were missing).
- 2026-11-19 (study `eip-8151-impact`, reading 3): EIP-8151 as written closes this path for an account that takes
  real code (executed on a real transaction); plain and 7702-delegated accounts stay exposed, and approvals already
  given stay valid.

# Review notes (Review23, 2026-11-17)

## Morpho Blue `0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb` (verified source, Sourcify `src/Morpho.sol`)

- `setAuthorizationWithSig(Authorization, Signature)` (line 446): deadline, `nonce[authorizer]++`,
  `ecrecover(digest, v, r, s)`, requires `signatory != 0 && signatory == authorization.authorizer`, then sets
  `isAuthorized[authorizer][authorized]`. No ERC-1271, no code check. `setAuthorization` (line 437) is the
  msg.sender alternative.
- `_isSenderAuthorized(onBehalf)` = `msg.sender == onBehalf || isAuthorized[onBehalf][msg.sender]` gates exactly
  `withdraw` (line 212), `borrow` (line 247) and `withdrawCollateral` (line 331); each acts on `position[id][onBehalf]`
  and sends to an arbitrary `receiver`.
- `borrow` and `withdrawCollateral` require `_isHealthy(marketParams, id, onBehalf)`: the debt is the authorizer's and
  is bounded by the authorizer's collateral times LLTV; `withdraw` is bounded by the authorizer's supply shares (and
  market liquidity). So a forged authorization takes at most that user's own positions (supply + collateral);
  other users' supply is only lent against the victim's collateral under the normal health check.
- Owner-only functions (`setOwner`, `enableIrm`, `enableLltv`, `setFee`, `setFeeRecipient`) cannot change the
  signature check. Not a proxy. Owner Safe `0xcba28b38…` (6 of 10, onchain.json).

## MetaMorpho vaults (OpenZeppelin v5 `ERC20Permit.permit`: `ECDSA.recover(hash, v, r, s) == owner`)

Reads at block 26,431,500 (2026-11-17 01:32 UTC), https://ethereum-rpc.publicnode.com:

| Vault | name() | asset | totalAssets (USDC) | owner() |
|---|---|---|---|---|
| 0xd63070114470f685b75b74d60eec7c1113d33a3d | Usual Boosted USDC | USDC | 1,804,165.58 | 0x38afc3aa… (Safe 2/5) |
| 0x777791c4d6dc2ce140d00d2828a7c93503c67777 | Hyperithm USDC Apex | USDC | 1,207,041.11 | 0xee7e9bb2… (Safe 2/3) |
| 0xbeefff209270748ddd194831b3fa287a5386f5bc | Smokehouse USDC | USDC | 10,453,910.41 | 0x0a0e559b… (Safe 5/10) |
| 0xbeef01735c132ada46aa9aa4c54623caa92a64cb | Steakhouse USDC | USDC | 71,854,433.22 | 0x0a0e559b… (Safe 5/10) |

A forged `permit` gives the attacker an allowance over the holder's vault shares; `transferFrom` + `redeem` takes
them. The vaults' USDC sits in Morpho Blue as the vault's own supply positions (the vault is a contract and signs
nothing), so the vault value overlaps with Morpho Blue's holdings and is not additive.

Yearly pre-quantum use (`data/report/curated_contracts.csv`, `txs_y1` ecrecover transactions):
Morpho 11,559; 0xd6307011 5,632; 0x777791c4 2,385; 0xbeefff20 2,368; 0xbeef0173 1,811.
