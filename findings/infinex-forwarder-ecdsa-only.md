---
id: infinex-forwarder-ecdsa-only
title: "Infinex: a quantum attacker who recovers an Infinex account key can act on that account through the ECDSA-only InfinexERC2771Forwarder until its owner rotates keys or drops the forwarder; post-quantum keys cannot use the relayed path"
project: infinex
status: confirmed
severity: MEDIUM
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x884dbad85355edd71fac528fe613eb4cd1b4e3a9"
  implementation: null
  name: InfinexERC2771Forwarder
  upgradeable: "no"
  admin: none (no proxy, no owner); each Infinex account chooses to trust it (addTrustedForwarder/removeTrustedForwarder, sudo key)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 455
families: []
fix:
  layer: account-migration
  who_acts: nobody can change the forwarder; Infinex must ship an account implementation that accepts post-quantum keys (accounts are UUPSProxy -> AccountsRouter 0x5bfa6ff9e71031844fd241aa54a10b953e247bee, upgraded by each account's sudo key to the beacon's latest implementation); each account's sudo key then rotates to a post-quantum key and can call removeTrustedForwarder
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/infinex-forwarder-ecdsa-only
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

`InfinexERC2771Forwarder` (`0x884dbad8…e3a9`) relays meta-transactions to Infinex accounts and accepts a request only if
`ECDSA.tryRecover` over the EIP-712 `ForwardRequest` returns `from` (PQ-1). Infinex accounts
trust it and treat `from` as the caller, so a quantum attacker who recovers a sudo or operation key of an account can
act as that key through the forwarder. That key is ECDSA throughout the account (direct calls and `requiresSudoKey`
also use it), so the forwarder adds no new key; it keeps an old ECDSA key usable only while the account still lists it
or trusts the forwarder. Post-quantum keys (contracts) cannot use the relayed path; they can call the account
directly. Exposure: funds in Infinex accounts that trust the forwarder, not measured. Rated MEDIUM (step 3/4): the
forwarder is immutable, but each account's owner removes the exposure by rotating keys or removing the forwarder,
once Infinex ships post-quantum key support.

## Mechanism

- `_recoverForwardRequestSigner` (excerpt lines 228–244) hashes `ForwardRequest(from,to,value,gas,nonce,data)` and
  calls `tryRecover(request.signature)`; `_validate`/`verify` (line 118) accept when the recovered address equals
  `from`; `execute`/`executeBatch` then call `to` with `data` and `from` appended (ERC-2771). There is no ERC-1271 path.
- Consumers: Infinex accounts (`UUPSProxy` → `AccountsRouter` `0x5bfa6ff9…7bee`, `BaseModule` `0xecbdaa33…55ec`).
  `ERC2771Context._msgSender()` returns the appended `from` when `msg.sender` is in the account's
  `trustedForwarders`; `requiresSudoKeySender` and `requiresAuthorizedOperationsParty` (`SecurityModifiers.sol`) then
  authorise withdrawals, transfers, bridging and key changes for sudo or operation keys.
- Pattern PQ-1. Excerpts: [`source-excerpts.md`](#source-excerpts-infinex-forwarder-ecdsa-only).

## Evidence

- CHECKED (verified source, Sourcify `exact_match`, read 2026-11-17): the forwarder as above; no owner or upgrade
  function. Account side: `AccountsRouter` `0x5bfa6ff9…` and `BaseModule` `0xecbdaa33…` (Sourcify `exact_match`):
  `ERC2771Context`, `SecurityModifiers`, `add/removeTrustedForwarder` (sudo-key signature), `setSudoKeyStatus`,
  `setOperationKeyStatus`, `upgradeTo` (sudo key, to the latest implementation).
- CHECKED (on-chain read at block 26,431,214): forwarder has 4,117 bytes of code, no EIP-1967 slots, no `owner()`,
  holds under USD 0.01 ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/infinex-forwarder-ecdsa-only/onchain.json)).
- CHECKED (on-chain read at block 26,431,491): accounts `0xa852dcfa…9825` and `0x242bc125…1d27`, both recent
  forwarder targets, return `trustedForwarders() = [0x884dbad8…e3a9]` and `accountVersion() = 4`; their Synthetix proxy
  slot points to `AccountsRouter` `0x5bfa6ff9…7bee`. Both were created by `AccountFactory`
  `0x665766368ee511ebd3cd5f9300520dac915e941c` (Blockscout) ([`consumers.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/infinex-forwarder-ecdsa-only/consumers.json)).
- CHECKED (Blockscout internal transactions, 2026-11-17): the forwarder is called by relayer
  `0x1183a82bce632739385d2037f2e33020a786598e` (EIP-7702 account delegated to Kernel) and calls Infinex account proxies.
- CHECKED (precompile trace to March 2026): `ecrecover`; 25,907 pre-quantum calls in the last year (`txs_y1`).
- CHECKED (Xatu, any function): 455 transactions 2026-10-16 to 2026-11-16, last 2026-11-15
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/infinex-forwarder-ecdsa-only/activity.json)).
- INFERRED: the total held by Infinex accounts on mainnet; not measured (no list of accounts was built).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x884dbad8…` InfinexERC2771Forwarder | no | dust (< USD 0.01) | 2026-11-15 | 455 |

- Exposure: ETH and tokens held by every Infinex account that lists the forwarder in `trustedForwarders` (accounts
  created by `AccountFactory` `0x6657…941c`). Not measured, so `value_usd` stays null.
- What the forwarder adds beyond each key's own exposure: a key that stays listed in an account after its holder
  moves the address to post-quantum authorisation (EIP-7702 code) is still forgeable here. Rotating the key out of the
  account, or removing the forwarder, ends that.
- The wider issue, outside this finding: Infinex accounts authorise sudo, operation and recovery keys by address and
  check signatures with `ECDSA.recover` (`requiresSudoKey`, `isValidSignature`); no finding covers the account
  implementation yet.
- Yearly pre-quantum use: 25,907 transactions, USD 26.3 million `usd_tx_y1` (transfers in those transactions).

## Remediation

- Post-quantum replacement: relaying through EIP-8141 frame transactions or a forwarder that verifies ERC-1271 with
  the full signature; in the account, keys verified by a post-quantum scheme (ERC-7913 verifier).
- Who must act: Infinex ships the account implementation (the forwarder itself cannot change); each account's sudo
  key upgrades, rotates sudo and operation keys to post-quantum signers and can call `removeTrustedForwarder`.
- Users: rotate keys or remove the forwarder once supported; a post-quantum key can already call its account directly.
- Protocol change: helps only for keys kept as EIP-7702 addresses (EIP-8151); not needed otherwise.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review21): HIGH -> MEDIUM, step 3: the forwarder is immutable, but it only speaks for keys that an
  Infinex account lists and trusts; each account's owner removes the exposure by rotating keys or calling
  `removeTrustedForwarder` (owners migrating), and post-quantum keys can call accounts directly. `alternative` sole ->
  alternative-exists.

# Source excerpts: infinex-forwarder-ecdsa-only

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x884dbad85355edd71fac528fe613eb4cd1b4e3a9` — InfinexERC2771Forwarder (verified source via sourcify)

### `src/forwarder/InfinexERC2771Forwarder.sol`

```solidity
    5  // In addition, when using Cannon, the `invalid()` opcode doesn't work, so it was replaced with a specific revert.
    6  
    7  pragma solidity ^0.8.21;
    8  
    9  import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
   10  import { EIP712 } from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
   11  import { Address } from "@openzeppelin/contracts/utils/Address.sol";
   12  
   13  /**
  ...
  114       *
  115       * NOTE: A request may return false here but it won't cause {executeBatch} to revert if a refund
  116       * receiver is provided.
  117       */
  118      function verify(ForwardRequestData calldata request) public view virtual returns (bool) {
  119          (bool active, bool signerMatch,) = _validate(request);
  120          return active && signerMatch;
  121      }
  122  
  ...
  225       *
  226       * NOTE: The signature is considered valid if {ECDSA-tryRecover} indicates no recover error for it.
  227       */
  228      function _recoverForwardRequestSigner(ForwardRequestData calldata request) internal view virtual returns (bool, address) {
  229          (address recovered, ECDSA.RecoverError err,) = _hashTypedDataV4(
  230              keccak256(
  231                  abi.encode(
  232                      _FORWARD_REQUEST_TYPEHASH,
  233                      request.from,
  ...
  237                      request.nonce,
  238                      keccak256(request.data)
  239                  )
  240              )
  241          ).tryRecover(request.signature);
  242  
  243          return (err == ECDSA.RecoverError.NoError, recovered);
  244      }
  245  
  246      /**
  247       * @dev Validates and executes a signed request returning the request call `success` value.
  ...
```

Library files with the primitive itself (not excerpted): `lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol`
