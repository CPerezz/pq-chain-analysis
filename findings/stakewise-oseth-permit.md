---
id: stakewise-oseth-permit
title: "StakeWise osETH: permit accepts only ECDSA, so a quantum attacker who recovers a holder's key can sign approvals and take their osETH, even after the holder converts the address to a post-quantum account"
project: stakewise
status: confirmed
severity: HIGH
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: sole
role: auxiliary
contracts:
- address: "0xf1c9acdc66974dfb6decb12aa385b9cd01190e38"
  implementation: null
  name: OsToken (osETH)
  upgradeable: "no"
  admin: none for permit; Ownable2Step owner renounced (owner() and pendingOwner both zero at block 26,431,521); owner could only toggle mint/burn controllers
  value_usd: 290592981
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 1214
families: []
fix:
  layer: account-migration
  who_acts: nobody can change OsToken (no proxy, owner renounced); holders protect themselves by moving osETH to a fresh post-quantum account (a converted address stays forgeable); a protocol change such as EIP-8151 would protect converted addresses
  protocol_change: helps
evidence:
  level: source-read
  links:
  - evidence/stakewise-oseth-permit/classification.jsonl
  - evidence/stakewise-oseth-permit/onchain.json
  - evidence/stakewise-oseth-permit/activity.json
  - evidence/stakewise-oseth-permit/source-excerpts.md
  - evidence/stakewise-oseth-permit/token.json
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

osETH (`0xf1c9acdc…`, StakeWise V3's overcollateralised staked-ETH token) implements EIP-2612 `permit` with
OpenZeppelin 5.0 `ERC20Permit`, which accepts only an `ecrecover` signature from the holder (PQ-1). A CRQC holder who
recovers a holder's secp256k1 key from any on-chain signature can sign a permit to itself and transfer the holder's
osETH; this keeps working after the holder converts the same address to post-quantum account code, and post-quantum
accounts cannot use `permit` at all (plain `approve` still works). The token is immutable and its owner renounced. The
exposure is bounded by osETH in circulation: USD 290.6M market cap on 2026-11-17. Rated HIGH, step 4.

## Mechanism

- `ERC20Permit.permit(owner, spender, value, deadline, v, r, s)` builds the EIP-712 `Permit` digest with
  `_useNonce(owner)`, calls `ECDSA.recover(hash, v, r, s)` and requires the result to equal `owner`
  (`ERC20Permit.sol` lines 44–64), then sets the allowance. No ERC-1271 or account-code check exists.
- `OsToken` (`contracts/osToken/OsToken.sol`) adds only `mint`/`burn` for the immutable `_vaultController` and
  owner-set `controllers`, and `setController` (owner-only).
- Pattern PQ-1. Excerpts: [`source-excerpts.md`](../evidence/stakewise-oseth-permit/source-excerpts.md).

## Evidence

- CHECKED (Sourcify exact match, fetched 2026-11-17): `OsToken.sol`, OpenZeppelin v5.0.0 `ERC20Permit.sol` and
  `ECDSA.sol`, solc 0.8.22. The original classification called it unverified; it is verified.
- CHECKED (on-chain read at block 26,431,214): no EIP-1967 slots, not a proxy
  ([`onchain.json`](../evidence/stakewise-oseth-permit/onchain.json)).
- CHECKED (on-chain read at block 26,431,521): `owner()` returns zero; storage slots 0 (`_owner`) and 1
  (`_pendingOwner`) are zero; `totalSupply()` 148,455.36 osETH ([`token.json`](../evidence/stakewise-oseth-permit/token.json)).
- CHECKED (Blockscout token API, 2026-11-17): price USD 1,957.39, circulating market cap USD 290,592,981, 1,921 holders.
- CHECKED (Xatu, any function): 1,214 transactions called the token 2026-10-16 to 2026-11-16, last on 2026-11-16
  ([`activity.json`](../evidence/stakewise-oseth-permit/activity.json)).
- CHECKED (precompile trace, year to March 2026, `data/report/curated_contracts.csv`): 446 transactions with an
  `ecrecover` call by the token (`txs_y1`), about USD 274M moved in them (`usd_tx_y1`).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xf1c9acdc…` OsToken (osETH) | no | $290.6M (market cap) | 2026-11-16 | 1,214 |

The market cap is an upper bound: it counts every holder, including contracts (vaults, pools) that have no ECDSA key
and cannot be forged through `permit`. The draft's USD 371.1M came from a cached Blockscout market cap of unknown date;
the figure above was read on 2026-11-17. Only osETH is in this finding; StakeWise vaults were not assessed here.

## Remediation

- StakeWise cannot change osETH: no proxy, and the owner is renounced. A post-quantum permit (ERC-1271 for accounts
  with code first, or ERC-7913) needs a new token, which also needs a new vault controller and vaults to mint it.
- Holders: do not rely on converting an address in place; move osETH to a fresh post-quantum account, or hold it in a
  contract account.
- Protocol: EIP-8151 would make `ecrecover` fail for converted addresses with real code (`protocol_change: helps`).

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review19): HIGH kept, step 4. Source is verified on Sourcify (OZ 5.0 `ERC20Permit`); owner found renounced; market cap updated from USD 371.1M to USD 290.6M (Blockscout, 2026-11-17).
