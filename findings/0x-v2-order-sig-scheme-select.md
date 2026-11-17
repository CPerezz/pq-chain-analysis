---
id: "0x-v2-order-sig-scheme-select"
title: "0x v2.1 Exchange: a forged maker or taker ECDSA signature spends that address's token approvals to the 0x v2 asset proxies, even after the address moves to post-quantum authorisation"
project: "0x"
status: confirmed
severity: MEDIUM
patterns: [PQ-2]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x080bf510fcbf18b91105470639e9561022937712"
  implementation: null
  name: Exchange
  upgradeable: "no"
  admin: "ZeroExGovernor 0x7d3455421bbc5ed534a83c88fd80387dc8271392 (2 of 4, time-locked multisig; owns the Exchange and all its asset proxies, can de-authorise the Exchange on them; read at block 26,431,454)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 2331
families: []
fix:
  layer: onchain-config
  who_acts: "ZeroExGovernor 0x7d3455421bbc5ed534a83c88fd80387dc8271392 (2 of 4) removes 0x080bf510… from the authorised addresses of ERC20Proxy 0x95e6f48254609a6ee006f7d493c8e5fb97094cef, ERC721Proxy 0xefc70a1b18c432bdc64b596838b4d138f6bc6cad, MultiAssetProxy 0xef701d5389ae74503d633396c4d654eabedc9d78 and ERC1155Proxy 0x7eefbd48fd63d441ec7435d024ec7c5131019add; users revoke approvals to those proxies"
  protocol_change: helps
evidence:
  level: source-read
  links:
  - evidence/0x-v2-order-sig-scheme-select/classification.jsonl
  - evidence/0x-v2-order-sig-scheme-select/onchain.json
  - evidence/0x-v2-order-sig-scheme-select/activity.json
  - evidence/0x-v2-order-sig-scheme-select/source-excerpts.md
  - evidence/0x-v2-order-sig-scheme-select/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review08 (verified source and on-chain reads)
  ref: evidence/0x-v2-order-sig-scheme-select/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: ["0x-v4-order-sig-ecdsa-only"]
---

## Summary

The immutable 0x v2.1 Exchange lets the signature itself choose the scheme: an `EIP712` or `EthSign` signature is
checked with `ecrecover` against any maker or signer address, whether or not that address has account code (PQ-2). A
quantum attacker who recovers an address's secp256k1 key can sign orders or 0x transactions for it and spend whatever
that address has approved to the 0x v2 asset proxies (ERC20Proxy `0x95e6f482…` and three others), also after the
address has moved to post-quantum authorisation. Those approvals are the exposure; they are not measured (the Exchange
itself holds nothing). Rated MEDIUM (step 4): the Exchange cannot change, but 0x's 2-of-4 ZeroExGovernor can close the
path by de-authorising it on the asset proxies; the draft's HIGH assumed nobody could.

## Mechanism

- `MixinSignatureValidator.isValidSignature(bytes32 hash, address signerAddress, bytes signature)` (`Exchange.sol`
  lines 2521-2654) pops the last byte as `SignatureType`. `EIP712` (lines 2577-2589) and `EthSign` (2595-2607) require
  65 bytes and return `signerAddress == ecrecover(...)`. No `extcodesize` check precedes them.
- The alternatives a post-quantum account can use: `Wallet` (staticcall `isValidSignature(bytes32,bytes)` on the
  maker, which must return the 0x-specific magic `0xb0671381`, not the ERC-1271 value; the full signature is passed),
  `Validator` (a validator contract the signer approved with `setSignatureValidatorApproval`), and `PreSigned` (the
  signer called `preSign`). None of them disables the ECDSA types for that address.
- Callers: `fillOrder` checks the maker signature on the first fill (line 1611); `executeTransaction` (line 4092)
  runs any Exchange function (fills as taker, cancels) for `signerAddress` when the caller is not that address. Tokens
  move through the asset proxies with `transferFrom` on the maker's and taker's approvals.

Pattern PQ-2. Excerpts: [`source-excerpts.md`](../evidence/0x-v2-order-sig-scheme-select/source-excerpts.md).

## Evidence

- CHECKED (Sourcify full match, `Exchange.sol`, read in full around lines 2521-2790): the signature-type dispatch and the
  `ecrecover` branches above.
- CHECKED (`cast`, block 26,431,454): `owner()` is ZeroExGovernor `0x7d3455…`, a 2-of-4 multisig with a 14-day default
  time lock; `getAssetProxy` returns the four proxies; each proxy's `getAuthorizedAddresses()` still includes
  `0x080bf510…`, and each proxy's `owner()` is the same ZeroExGovernor ([`notes.md`](../evidence/0x-v2-order-sig-scheme-select/notes.md)).
- CHECKED (on-chain read at block 26,431,214): the Exchange holds no ETH or tokens; it is not a proxy
  ([`onchain.json`](../evidence/0x-v2-order-sig-scheme-select/onchain.json)).
- CHECKED (Xatu, 2026-10-16 to 2026-11-16): 2,331 transactions called the Exchange (2 directly), last on 2026-11-15
  ([`activity.json`](../evidence/0x-v2-order-sig-scheme-select/activity.json)).
- CHECKED (precompile trace, year to March 2026, `data/report/curated_contracts.csv`): 86,593 transactions with an
  `ecrecover` in this contract; their transfers total USD 1.47B (`usd_tx_y1`, a flow, not funds at risk).
- INFERRED: whether the governor's `removeAuthorizedAddressAtIndex` is exempt from the time lock was not read.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x080bf510…` Exchange (v2.1) | no | $0 (not the exposure) | 2026-11-15 | 2,331 |

The exposure is every allowance users have granted to ERC20Proxy `0x95e6f482…`, ERC721Proxy `0xefc70a1b…`,
MultiAssetProxy `0xef701d53…` and ERC1155Proxy `0x7eefbd48…`, capped by those users' balances. It is not measured
(it needs every approval to these proxies). The same ERC20Proxy is also authorised for the 0x v3 Exchange
`0x61935cbd…` and ZrxVault `0xba7f8b5f…`, which are not part of this finding.

## Remediation

- 0x: ZeroExGovernor `0x7d3455…` (2 of 4) de-authorises `0x080bf510…` on the four asset proxies. That retires v2.1
  fills; the Exchange code itself cannot be changed.
- Users: revoke approvals to the v2 asset proxies. A post-quantum account can still trade here with `PreSigned` or a
  `Validator`, but stays forgeable with its old key while its approvals stand.
- Protocol: EIP-8151 would help, since `ecrecover` would fail for addresses with real code. It does not protect
  code-less EOAs.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review08): HIGH -> MEDIUM, step 4: the asset proxies' owner (ZeroExGovernor 0x7d3455…, 2 of 4) can de-authorise the immutable Exchange, so one known multisig can close the path without a protocol change; `admin` and `fix` corrected from "nobody can change it".
