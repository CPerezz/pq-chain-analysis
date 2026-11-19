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
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/cow-order-sig-scheme-select
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review18 (full GPv2Signing/GPv2Settlement source from Sourcify, on-chain reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/cow-order-sig-scheme-select/notes.md
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
- Pattern PQ-2 (the signer chooses the scheme). Excerpts: [`source-excerpts.md`](#source-excerpts-cow-order-sig-scheme-select).

## Evidence

- CHECKED (Sourcify full match, read 2026-11-17): `recoverOrderSigner`, `ecdsaRecover`, `recoverEip1271Signer`,
  `recoverPreSigner`, `settle`, `transferFromAccounts` as above; no account-code check on the ECDSA branches
  ([`notes.md`](#review-notes-cow-order-sig-scheme-select-2026-11-17-review18)).
- CHECKED (on-chain, block 26,431,214): GPv2Settlement is not a proxy and has no owner
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/cow-order-sig-scheme-select/onchain.json)).
- CHECKED (`cast`, block 26,431,454): `vaultRelayer()` = `0xc92e8bdf79f0507f65a392b0ab4667716bfe0110`;
  `authenticator()` = `0x2c4c28ddbdac9c5e7055b4c863b72ea0149d8afe`, an EIP-1967 proxy whose admin is Safe
  `0xca771eda0c70aa7d053ab1b25004559b918fe662` (3 of 5) and whose `manager()` is Safe
  `0xa03be496e67ec29bc62f01a428683d7f9c204930` (4 of 12). They control only which solvers may call `settle`.
- CHECKED (precompile trace): 1,304,431 `ecrecover` calls in the last year (`studies/top-callers-classification/results/curated_contracts.csv`,
  `txs_y1`).
- CHECKED (Xatu, any function): last active 2026-11-16, 192,582 transactions in 2026-10-16 to 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/cow-order-sig-scheme-select/activity.json)).
- INFERRED: a forged order needs an allowlisted solver to settle it; an attractive order (low limit price) is the kind
  solvers settle, so this is not a barrier the attacker has to break.
- CHECKED (executed, study `eip-8151-impact`, 2026-11-19): a real transaction,
  `0x728011aa7169ae8c51ae17a9ec04af3640108a8d0cfa60e7a6670a788f08d78a` (block 26,438,818, position 0), replayed on
  the reference implementation of the fork with only the precompile changed. Under today's rule it matches its
  receipt (2,572,945 gas); under EIP-8151 it also succeeds (2,576,045 gas). With one byte of code at the recovered
  signer `0x14f362542ce22a9cf392ecc4e95b85837fab37e6`, it reverts after that recovery returned no address; with a
  7702 delegation there it succeeds. Study family `fbd578f6` (GPv2Settlement).

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

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review18): HIGH kept, step 4. Mechanism confirmed in full source; removed the settlement's
  USD 455k `held` value (protocol buffers, not what a forged order releases); exposure is users' allowances to
  GPv2VaultRelayer, not measured.
- 2026-11-19 (study `eip-8151-impact`, reading 3): EIP-8151 as written closes this path for an account that takes
  real code (executed on a real transaction); plain and 7702-delegated accounts stay exposed, and approvals already
  given stay valid.

# Source excerpts: cow-order-sig-scheme-select

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x9008d19f58aabd9ed0d60971565aa8510560ab41` — GPv2Settlement (verified source via sourcify)

### `src/contracts/interfaces/GPv2EIP1271.sol`

```solidity
   23      /// MUST NOT modify state (using STATICCALL for solc < 0.5, view modifier for
   24      /// solc > 0.5)
   25      /// MUST allow external calls
   26      ///
   27      function isValidSignature(bytes32 _hash, bytes memory _signature)
   28          external
   29          view
   30          returns (bytes4 magicValue);
   31  }
  ...
```

### `src/contracts/mixins/GPv2Signing.sol`

```solidity
  194              // v = uint8(encodedSignature[64])
  195              v := shr(248, calldataload(add(encodedSignature.offset, 64)))
  196          }
  197  
  198          signer = ecrecover(message, v, r, s);
  199          require(signer != address(0), "GPv2: invalid ecdsa signature");
  200      }
  201  
  202      /// @dev Decodes signature bytes originating from an EIP-712-encoded
  ...
  290          // prettier-ignore
  291          bytes calldata signature = encodedSignature[20:];
  292  
  293          require(
  294              EIP1271Verifier(owner).isValidSignature(orderDigest, signature) ==
  295                  GPv2EIP1271.MAGICVALUE,
  296              "GPv2: invalid eip1271 signature"
  297          );
  298      }
  ...
```

# Review notes: cow-order-sig-scheme-select (2026-11-17, Review18)

Reads with `cast` against https://ethereum-rpc.publicnode.com at block 26,431,454:

- `GPv2Settlement(0x9008d19f…).vaultRelayer()` = `0xc92e8bdf79f0507f65a392b0ab4667716bfe0110` (GPv2VaultRelayer)
- `GPv2Settlement.authenticator()` = `0x2c4c28ddbdac9c5e7055b4c863b72ea0149d8afe` (GPv2AllowListAuthentication, proxy)
  - EIP-1967 admin slot = `0xca771eda0c70aa7d053ab1b25004559b918fe662` (Safe, threshold 3 of 5 owners; CoW DAO)
  - EIP-1967 implementation slot = `0x9e7ae8bdba9aa346739792d219a808884996db67`
  - `manager()` = `0xa03be496e67ec29bc62f01a428683d7f9c204930` (Safe, threshold 4 of 12 owners)
- GPv2Settlement itself: no proxy (runtime code, no EIP-1967 slots per `onchain.json` at block 26,431,214).

Source (Sourcify full match, `src/contracts/mixins/GPv2Signing.sol`):

- `recoverOrderSigner` (line 141): branches on `signingScheme` chosen per trade by the order owner:
  `Eip712` → `recoverEip712Signer` → `ecdsaRecover` (`ecrecover`, line 198); `EthSign` → `recoverEthsignSigner`
  → `ecdsaRecover`; `Eip1271` → `recoverEip1271Signer` (owner encoded in the first 20 bytes, full signature passed to
  `isValidSignature`, line 294); `PreSign` → `recoverPreSigner` (`preSignature[orderUid]` set on-chain by the owner via
  `setPreSignature`, line 81).
- `GPv2Settlement.settle` (line 121, `onlySolver`) → `computeTradeExecutions` → `recoverOrderFromTrade`, then
  `vaultRelayer.transferFromAccounts(inTransfers)` (line 134) pulls the sell token from the recovered owner using the
  owner's ERC-20 allowance to GPv2VaultRelayer (or Balancer Vault relayer approval / internal balance).
- An ECDSA-scheme order's owner is whatever `ecrecover` returns; account code is never consulted, so an EOA that
  delegates to post-quantum code (EIP-7702) or otherwise stops using its key stays forgeable here.

Yearly pre-quantum calls (`data/report/curated_contracts.csv`): `txs_y1` 1,304,431 ecrecover calls.

Settlement holdings in `onchain.json` (USD 455k, 97% TRU) are the protocol's own buffers, not user funds released
by a forged order signature; not the exposure.
