---
id: sky-dai-permit-ecdsa-only
title: "DAI token (Sky): a quantum attacker who recovers a holder's ECDSA key can sign a DAI permit for that holder's balance, even after the holder migrates the address to post-quantum authorisation; the contract cannot be changed"
project: sky
status: confirmed
severity: HIGH
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: auxiliary
contracts:
- address: "0x6b175474e89094c44da98b954eedeac495271d0f"
  implementation: null
  name: Dai
  upgradeable: "no"
  admin: "none: no proxy and no upgrade function; wards can only rely/deny and mint, not change permit"
  value_usd: 4435351449
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 336639
families: []
fix:
  layer: account-migration
  who_acts: "nobody can change 0x6b175474e89094c44da98b954eedeac495271d0f; holders who migrate must also move their DAI to a fresh address (or convert to USDS); EIP-8151 would protect migrated addresses without them moving"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/sky-dai-permit-ecdsa-only
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
  who: Review15 (finding review)
  ref: findings/sky-dai-permit-ecdsa-only.md
  date: 2026-11-17
  verdict: confirmed
  rating: HIGH
related: [sky-usds-permit-ecdsa-first]
---

## Summary

DAI's `permit` accepts only an `ecrecover` signature from the holder (PQ-1) and sets an unlimited allowance. A quantum
attacker who recovers a holder's secp256k1 key from its public key can sign a permit for their own spender and drain
the holder's DAI; this keeps working after the holder moves the address to post-quantum authorisation (EIP-7702/8141),
because the DAI contract has no proxy and no admin. Exposure is the holders' balances, at most the supply of
4.44B DAI (USD 4.44B, market-cap basis, 2026-11-17). Rated HIGH (step 4: users' own funds stay forgeable after they
migrate, in a contract that cannot change).

## Mechanism

`Dai.permit(holder, spender, nonce, expiry, allowed, v, r, s)` (`dai.sol` lines 118–138) builds an EIP-712 digest and
requires `holder == ecrecover(digest, v, r, s)`; on success it sets `allowance[holder][spender]` to `uint(-1)`
(or 0). There is no ERC-1271 branch and no code check, so the check is the holder's ECDSA key alone. With the
allowance, the attacker's spender calls `transferFrom` for the full balance. Pattern PQ-1. Excerpt:
[`source-excerpts.md`](#source-excerpts-sky-dai-permit-ecdsa-only).

Post-quantum accounts are not locked out of DAI: `approve` and `transfer` are plain calls, so a smart account can
approve on-chain instead of signing a permit; only the permit path is unavailable to them.

## Evidence

- CHECKED (verified source, Sourcify, `dai.sol`): `permit` checks only `ecrecover`; no `isValidSignature` anywhere.
- CHECKED (on-chain read at block 26,431,214): `0x6b17…1d0f` has 7,904 bytes of code and no EIP-1967/other proxy
  slot set ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/sky-dai-permit-ecdsa-only/onchain.json)). The contract has no upgrade
  function; `wards` can only `rely`/`deny` and `mint` (verified source, function list of `dai.sol`).
- CHECKED (`totalSupply()` at block 26,431,426): 4,435,351,448.85 DAI.
- CHECKED (precompile trace, all mainnet transactions to March 2026): `ecrecover` only; 17,519 pre-quantum calls in the
  last year, carrying USD 2.03B of transfers in those transactions (`studies/top-callers-classification/results/curated_contracts.csv`, `txs_y1`,
  `usd_tx_y1`).
- CHECKED (Xatu, any function): 336,639 transactions called DAI from 2026-10-16 to 2026-11-16; last active 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/sky-dai-permit-ecdsa-only/activity.json)). This is DAI use in general, not permit use.
- INFERRED: the forgeable set that matters is holders who keep DAI at an address they have migrated; for a holder who
  has not migrated, the recovered key can already send transactions directly, so permit adds nothing.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x6b175474…` Dai | no | USD 4.44B (market cap, upper bound) | 2026-11-16 | 336,639 |

The exposure is holders' balances, bounded by the total supply above (DAI priced at USD 1). The USD 4.46M of tokens
the DAI contract itself holds (`onchain.json`, almost all DAI held at the token's own address) is not reachable
through `permit` and is not the exposure. The successor tokens USDS and sUSDS are covered by
[`sky-usds-permit-ecdsa-first`](sky-usds-permit-ecdsa-first.md).

## Remediation

- The contract cannot be fixed: no proxy, no admin. Sky governance (pause proxy
  `0xbe8e3e3618f7474f8cb1d074a26affef007e98fb`) can only encourage holders to convert to USDS, whose `permit` can be
  upgraded.
- Holders: when migrating an address to post-quantum authorisation, move DAI to a fresh post-quantum account or convert
  it to USDS (and see the USDS finding); revoking past permits does not help, since a new permit can be signed.
- Protocol change helps: EIP-8151 (make `ecrecover` fail for addresses with real code) would stop permits signed with
  the old key for migrated addresses without holders moving.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review15): HIGH confirmed (step 4). Market cap replaced by `totalSupply()` at block 26,431,426 (USD 4.44B); `alternative` sole -> alternative-exists (on-chain `approve` is open to post-quantum accounts; it does not stop forging); linked to the USDS finding.

# Source excerpts: sky-dai-permit-ecdsa-only

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x6b175474e89094c44da98b954eedeac495271d0f` — Dai (verified source via sourcify)

### `/nix/store/w5qm70gq7qwa3087hknnddpy3acn8fnp-dss/dapp/dss/src/dai.sol`

```solidity
  114          transferFrom(src, dst, wad);
  115      }
  116  
  117      // --- Approve by signature ---
  118      function permit(address holder, address spender, uint256 nonce, uint256 expiry,
  119                      bool allowed, uint8 v, bytes32 r, bytes32 s) external
  120      {
  121          bytes32 digest =
  122              keccak256(abi.encodePacked(
  ...
  130                                       allowed))
  131          ));
  132  
  133          require(holder != address(0), "Dai/invalid-address-0");
  134          require(holder == ecrecover(digest, v, r, s), "Dai/invalid-permit");
  135          require(expiry == 0 || now <= expiry, "Dai/permit-expired");
  136          require(nonce == nonces[holder]++, "Dai/invalid-nonce");
  137          uint wad = allowed ? uint(-1) : 0;
  138          allowance[holder][spender] = wad;
  ...
```
