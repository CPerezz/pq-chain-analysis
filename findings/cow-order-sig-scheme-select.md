---
id: cow-order-sig-scheme-select
title: "CoW Protocol GPv2Settlement: a quantum attacker who recovers a user's old ECDSA key can sign orders that sell the user's tokens approved to the GPv2VaultRelayer, even after the user migrates"
project: cow-protocol
status: confirmed
severity: HIGH
patterns: [PQ-2]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x9008d19f58aabd9ed0d60971565aa8510560ab41"
  implementation: null
  name: GPv2Settlement
  upgradeable: "no"
  admin: none (immutable; only the solver allowlist in GPv2AllowListAuthentication proxy 0x2c4c28dd… can change, proxy admin CoW DAO Safe 0xca771eda…)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 192582
families: []
fix:
  layer: account-migration
  who_acts: users (revoke allowances to GPv2VaultRelayer 0xc92e8bdf79f0507f65a392b0ab4667716bfe0110 or move funds to a fresh post-quantum account); CoW DAO (Safe 0xca771eda0c70aa7d053ab1b25004559b918fe662) can only deploy a new settlement that solvers and users move to
  protocol_change: helps
evidence:
  level: source-read
  links:
  - evidence/cow-order-sig-scheme-select/classification.jsonl
  - evidence/cow-order-sig-scheme-select/onchain.json
  - evidence/cow-order-sig-scheme-select/activity.json
  - evidence/cow-order-sig-scheme-select/source-excerpts.md
  - evidence/cow-order-sig-scheme-select/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review18 (full GPv2Signing/GPv2Settlement source from Sourcify, on-chain reads)
  ref: evidence/cow-order-sig-scheme-select/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: HIGH
related: []
---

## Summary

GPv2Settlement lets each order's owner choose its signing scheme, and two of the four schemes (`Eip712`, `EthSign`)
are plain `ecrecover`. A quantum attacker who derives an EOA's private key from its public key can sign a CoW order
selling that address's tokens to a receiver of their choice, and any allowlisted solver settling it pulls the tokens
through the user's allowance to GPv2VaultRelayer. This stays true after the address delegates to post-quantum code
(EIP-7702), because the settlement never looks at account code. The exposure is what users have approved to the
GPv2VaultRelayer, which is not measured. Rated HIGH (step 4): users' own funds stay forgeable in a contract that cannot
change; only each user revoking or moving, or a protocol change such as EIP-8151, protects them.

## Mechanism

- `GPv2Settlement.settle` (`onlySolver`) → `computeTradeExecutions` → `recoverOrderFromTrade` →
  `GPv2Signing.recoverOrderSigner`, which dispatches on the per-trade `signingScheme`:
  - `Eip712` / `EthSign` → `ecdsaRecover` → `ecrecover(message, v, r, s)` (GPv2Signing.sol line 198); the recovered
    address is the order owner.
  - `Eip1271` → `isValidSignature(orderDigest, signature)` on the owner encoded in the signature, with the full
    signature (line 294): usable by post-quantum smart accounts.
  - `PreSign` → `preSignature[orderUid]`, set on-chain by the owner with `setPreSignature` (line 81).
- `settle` then calls `vaultRelayer.transferFromAccounts(inTransfers)` (GPv2Settlement.sol line 134), which pulls the
  sell token from the owner via the owner's ERC-20 allowance to GPv2VaultRelayer (or Balancer Vault relayer approval).
- Pattern PQ-2 (the signer chooses the scheme). Excerpts: [`source-excerpts.md`](../evidence/cow-order-sig-scheme-select/source-excerpts.md).

## Evidence

- CHECKED (Sourcify full match, read 2026-11-17): `recoverOrderSigner`, `ecdsaRecover`, `recoverEip1271Signer`,
  `recoverPreSigner`, `settle`, `transferFromAccounts` as above; no account-code check on the ECDSA branches
  ([`notes.md`](../evidence/cow-order-sig-scheme-select/notes.md)).
- CHECKED (on-chain, block 26,431,214): GPv2Settlement is not a proxy and has no owner
  ([`onchain.json`](../evidence/cow-order-sig-scheme-select/onchain.json)).
- CHECKED (`cast`, block 26,431,454): `vaultRelayer()` = `0xc92e8bdf79f0507f65a392b0ab4667716bfe0110`;
  `authenticator()` = `0x2c4c28ddbdac9c5e7055b4c863b72ea0149d8afe`, an EIP-1967 proxy whose admin is Safe
  `0xca771eda0c70aa7d053ab1b25004559b918fe662` (3 of 5) and whose `manager()` is Safe
  `0xa03be496e67ec29bc62f01a428683d7f9c204930` (4 of 12). They control only which solvers may call `settle`.
- CHECKED (precompile trace): 1,304,431 `ecrecover` calls in the last year (`data/report/curated_contracts.csv`,
  `txs_y1`).
- CHECKED (Xatu, any function): last active 2026-11-16, 192,582 transactions in 2026-10-16 to 2026-11-16
  ([`activity.json`](../evidence/cow-order-sig-scheme-select/activity.json)).
- INFERRED: a forged order needs an allowlisted solver to settle it; an attractive order (low limit price) is the kind
  solvers settle, so this is not a barrier the attacker has to break.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x9008d19f…` GPv2Settlement | no | not measured: users' allowances to GPv2VaultRelayer `0xc92e8bdf…` | 2026-11-16 | 192,582 |

The settlement holds about USD 455k of tokens at block 26,431,214 (97% TRU); these are protocol buffers that a forged
user signature does not release, so the draft's `held` value was removed. The real exposure is, for every EOA that has
signed CoW orders (its public key is on-chain), the lesser of its balance and its allowance to GPv2VaultRelayer; this
needs an allowance scan over all holders and was not measured. Only ECDSA EOAs (including EIP-7702-delegated ones) are
exposed; smart accounts that sign through `Eip1271` or `PreSign` are not.

## Remediation

- Users: post-quantum accounts already work through `Eip1271` or `PreSign`. An address that migrates its
  authorisation must still revoke its allowances to GPv2VaultRelayer `0xc92e8bdf79f0507f65a392b0ab4667716bfe0110` (and
  Balancer Vault relayer approval) or move its funds to a fresh address, because the old ECDSA key keeps signing here.
- CoW DAO (Safe `0xca771eda0c70aa7d053ab1b25004559b918fe662`): GPv2Settlement cannot be changed. A new settlement that
  checks account code before `ecrecover` (PQ-13) would need a new deployment and new user approvals. Off-chain, the
  order book and the solver rules can refuse ECDSA-scheme orders from addresses with code, but a solver that ignores
  the rules can still settle such an order, so this cannot be counted on.
- Protocol: EIP-8151 (make `ecrecover` fail for addresses with real code) would protect migrated EIP-7702 accounts
  without any action here.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review18): HIGH kept, step 4. Mechanism confirmed in full source; removed the settlement's
  USD 455k `held` value (protocol buffers, not what a forged order releases); exposure is users' allowances to
  GPv2VaultRelayer, not measured.
