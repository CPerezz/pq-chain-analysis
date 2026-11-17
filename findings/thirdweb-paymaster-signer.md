---
id: thirdweb-paymaster-signer
title: "thirdweb (inferred) Shielded verifying paymasters: a quantum attacker who recovers the sponsorship signer key can spend the paymasters' EntryPoint gas deposits (≈ $430)"
project: thirdweb
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x6442f4729ee8c890d310ef92845d43184a12ee6a"
  implementation: null
  name: ShieldedVerifyingPaymasterV6
  upgradeable: config-only
  admin: owner 0x6dd80d80dad8a7b687ac4d3bfde4cbd85954fc01 (EOA; signers and bundler allowlist)
  value_usd: 176
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 11878
- address: "0x5fa66dfe8a3983e55071e8c4631ab43b5f33a4ab"
  implementation: null
  name: ShieldedVerifyingPaymasterV7
  upgradeable: config-only
  admin: owner 0x6dd80d80dad8a7b687ac4d3bfde4cbd85954fc01 (EOA; signers and bundler allowlist)
  value_usd: 254
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 134
families: []
fix:
  layer: new-deployment
  who_acts: the paymasters' operator (inferred thirdweb; owner 0x6dd80d80dad8a7b687ac4d3bfde4cbd85954fc01) deploys paymasters that verify sponsorship through ERC-1271 or a post-quantum scheme and moves its deposits
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/thirdweb-paymaster-signer
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_2.jsonl,out_3.jsonl,out_4.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review07 (registry review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/thirdweb-paymaster-signer/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [thirdweb-signature-mint-signer]
---

## Summary

Two ERC-4337 verifying paymasters, `ShieldedVerifyingPaymasterV6` and `V7`, sponsor a user operation when it carries
an ECDSA signature from a key in their `signers` set (PQ-4). A quantum attacker who recovers that key (its public key
follows from any sponsored operation) can sponsor its own operations and spend the paymasters' EntryPoint deposits as
gas, collected by a bundler it runs (the signed config can allow any bundler). The deposits are ≈ $430
(2026-11-17). The operator is inferred to be thirdweb. Rated LOW: a fix by new deployment (MEDIUM, step 4), lowered
for under $50k exposed (step 5).

## Mechanism

`ShieldedVerifyingPaymasterV6._validatePaymasterUserOp` parses `(allowAllBundlers, validUntil, validAfter, extraData,
signature)` from `paymasterAndData`, enforces the bundler allowlist unless `allowAllBundlers` is set, and accepts the
operation if `ECDSA.recover(toEthSignedMessageHash(getHash(userOp)), signature)` is in `signers`; the hash covers the
`allowAllBundlers` flag, so the signer decides it. The EntryPoint then charges the paymaster's deposit; `_postOp`
emits `TransactionSponsored(userOpHash, extraData)`. V7 is the same for EntryPoint v0.7. The owner adds and removes
signers (`MultiSigner`) but any signer is an ECDSA key. Lines:
[`source-excerpts.md`](#source-excerpts-thirdweb-paymaster-signer),
[`notes.md`](#review-reads-thirdweb-paymaster-signer-2026-11-17-review07).

## Evidence

- CHECKED (verified source: Sourcify for V6, Blockscout for V7): the path above.
- CHECKED (`cast` at block 26,431,569): `owner()` = `0x6dd80d80…` (EOA) on both; signer `0x2454…86f` active on both.
- CHECKED (`cast` EntryPoint `balanceOf` at block 26,431,527): deposits 0.0974 ETH (v0.6) and 0.1400 ETH (v0.7).
- CHECKED (precompile trace to March 2026): 195,023 and 35,243 transactions with `ecrecover` in the last year; Xatu:
  11,878 and 134 transactions in 2026-10-16 to 2026-11-16.
- CHECKED (Blockscout): deployed by `0xdaabdaac…` (ENS `0xfirekeeper.eth`); `TransactionSponsored` `extraData` in the
  latest 50 events of V6 decodes to `team_…-prj_…` identifiers.
- INFERRED: the operator is thirdweb: the deployer name is that of a thirdweb SDK maintainer (NuGet `Thirdweb`
  package author) and the sponsorship tags have the form of thirdweb dashboard team and project ids. No thirdweb
  document listing these addresses was found.

## Impact and exposure

| Contract | Upgradeable | Exposure (EntryPoint deposit) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x6442f472…` ShieldedVerifyingPaymasterV6 | config-only | $176 (escrow) | 2026-11-16 | 11,878 |
| `0x5fa66dfe…` ShieldedVerifyingPaymasterV7 | config-only | $254 (escrow) | 2026-11-15 | 134 |

The escrow is each paymaster's deposit in EntryPoint v0.6 `0x5ff137d4…` and v0.7 `0x00000000…a032`, $430 together;
the operator refills it, so each loss is bounded by the running balance. Users' funds are not at risk through this
check.

## Remediation

- The operator deploys paymasters that verify sponsorship through ERC-1271 (a signer contract with a post-quantum key)
  or a post-quantum scheme, withdraws the old deposits and points its sponsorship service at the new addresses. The
  owner `0x6dd80d80…` is itself an ECDSA key and should move to a post-quantum account.
- No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: drafted by `scripts/15_findings.py` inside `pimlico-paymaster-signer` (rated MEDIUM there, step 4).
- 2026-11-17 review (Review07): split out of `pimlico-paymaster-signer`: deployed by `0xfirekeeper.eth`, not Pimlico's
  deployers, with thirdweb-style sponsorship tags; project set to `thirdweb` (inferred). MEDIUM -> LOW, step 5:
  EntryPoint deposits $430.

# Source excerpts: thirdweb-paymaster-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x6442f4729ee8c890d310ef92845d43184a12ee6a` — ShieldedVerifyingPaymasterV6 (verified source via blockscout)

### `src/paymaster/ShieldedVerifyingPaymasterV6.sol`

```solidity
    5  import {IEntryPoint} from "account-abstraction-v0.6/interfaces/IEntryPoint.sol";
    6  
    7  import {BasePaymasterV6} from "./BasePaymasterV6.sol";
    8  import "account-abstraction-v0.6/interfaces/IPaymaster.sol";
    9  import {ECDSA} from "solady/utils/ECDSA.sol";
   10  import {SafeTransferLib} from "solady/utils/SafeTransferLib.sol";
   11  import {SignatureCheckerLib} from "solady/utils/SignatureCheckerLib.sol";
   12  
   13  contract ShieldedVerifyingPaymasterV6 is BasePaymasterV6 {
   14  
   15      event TransactionSponsored(bytes32 identifier, bytes extraData);
  ...
   49          if (!allowAllBundlers && !isBundlerAllowed[tx.origin]) {
   50              revert BundlerNotAllowed(tx.origin);
   51          }
   52  
   53          bytes32 hash = SignatureCheckerLib.toEthSignedMessageHash(getHash(_userOp));
   54          address recoveredSigner = ECDSA.recover(hash, signature);
   55  
   56          bool isSignatureValid = signers[recoveredSigner];
   57          uint256 validationData = _packValidationData(!isSignatureValid, validUntil, validAfter);
   58  
  ...
```

Library files with the primitive itself (not excerpted): `lib/solady/src/utils/ECDSA.sol`, `lib/solady/src/utils/SignatureCheckerLib.sol`


## Contract `0x5fa66dfe8a3983e55071e8c4631ab43b5f33a4ab` — ShieldedVerifyingPaymasterV7 (verified source via blockscout)

### `src/paymaster/ShieldedVerifyingPaymasterV7.sol`

```solidity
    8  import {PackedUserOperation} from "account-abstraction-v0.7/interfaces/PackedUserOperation.sol";
    9  
   10  import {BasePaymasterV7} from "./BasePaymasterV7.sol";
   11  import "account-abstraction-v0.7/interfaces/IPaymaster.sol";
   12  import {ECDSA} from "solady/utils/ECDSA.sol";
   13  import {SafeTransferLib} from "solady/utils/SafeTransferLib.sol";
   14  import {SignatureCheckerLib} from "solady/utils/SignatureCheckerLib.sol";
   15  
   16  using UserOperationLib for PackedUserOperation;
   17  
   18  contract ShieldedVerifyingPaymasterV7 is BasePaymasterV7 {
  ...
   53          if (!allowAllBundlers && !isBundlerAllowed[tx.origin]) {
   54              revert BundlerNotAllowed(tx.origin);
   55          }
   56  
   57          bytes32 hash = SignatureCheckerLib.toEthSignedMessageHash(getHash(_userOp));
   58          address recoveredSigner = ECDSA.recover(hash, signature);
   59  
   60          bool isSignatureValid = signers[recoveredSigner];
   61          uint256 validationData = _packValidationData(!isSignatureValid, validUntil, validAfter);
   62  
  ...
```

Library files with the primitive itself (not excerpted): `lib/solady/src/utils/ECDSA.sol`, `lib/solady/src/utils/SignatureCheckerLib.sol`

# Review reads: thirdweb-paymaster-signer (2026-11-17, Review07)

Split from `pimlico-paymaster-signer` (see that finding's `evidence/pimlico-paymaster-signer/notes.md` for the shared
reads below).

## Operator (INFERRED thirdweb)

- Both contracts were deployed 2025-06-18 through the CREATE2 factory `0x4e59b448…956c` by
  `0xdaabdaac8073a7dabdc96f6909e8476ab4001b34`, ENS `0xfirekeeper.eth` (Blockscout). "0xfirekeeper" publishes the
  thirdweb .NET SDK on NuGet (`nuget.org/profiles/0xfirekeeper`, package `Thirdweb`) and contributes to
  `thirdweb-dev/js`.
- `TransactionSponsored(bytes32 identifier, bytes extraData)` events of `0x6442f472…` (Blockscout logs, latest 50,
  blocks up to 26,426,173): `extraData` decodes to ASCII `team_cll5mvyyt0kwx3n0um7zjdxoh-prj_clv08989h02jr86q694h8b795`
  (36) and `team_cmae0fozm01yd9s0kev4pt4fs-prj_cmbs7e55n00ay760k5nk1aryt` (14): thirdweb dashboard team and project
  identifiers.
- Not found: a thirdweb document listing these addresses.

## Source

- `ShieldedVerifyingPaymasterV6` `0x6442f4729ee8c890d310ef92845d43184a12ee6a` (Sourcify,
  `src/paymaster/ShieldedVerifyingPaymasterV6.sol`): `_validatePaymasterUserOp` → `bundler allowlist check`, then
  `ECDSA.recover(SignatureCheckerLib.toEthSignedMessageHash(getHash(userOp)), signature)`; valid iff
  `signers[recovered]`; `_parseVerifyingConfig` rejects signatures that are not 64 or 65 bytes. `BasePaymasterV6`:
  `Ownable`, `MultiSigner`. `_postOp` emits `TransactionSponsored(userOpHash, extraData)`.
- `ShieldedVerifyingPaymasterV7` `0x5fa66dfe8a3983e55071e8c4631ab43b5f33a4ab`: Blockscout-verified, same structure
  for EntryPoint v0.7 (not on Sourcify).

## On-chain reads

- `cast` at block 26,431,569: `owner()` = `0x6dd80d80dad8a7b687ac4d3bfde4cbd85954fc01` (no code) on both;
  `signers(0x2454266295e8e25f46b2c5c8016eb21da43af86f)` = true on both (that signer address has nonce 0).
- Constructor args (Blockscout): owner `0x13317c81…bb29`, signers `[0x2454…86f]`; `0x13317c81…` transferred ownership
  to `0x6dd80d80…` on 2026-08-11; `0x6dd80d80…` last changed the bundler allowlists on 2026-11-11.
- EntryPoint deposits (`balanceOf`, block 26,431,527, ETH $1,811.62): `0x6442…` 0.09735 ETH on v0.6
  `0x5ff137d4…2789` ($176); `0x5fa6…` 0.13998 ETH on v0.7 `0x00000000…a032` ($254).
- Yearly pre-quantum use (`data/report/curated_contracts.csv`): `txs_y1` 195,023 (V6) and 35,243 (V7).
