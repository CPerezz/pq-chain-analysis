---
id: chainflip-aggkey-schnorr-ecrecover
title: "Chainflip: a quantum attacker who recovers the validators' secp256k1 Schnorr aggregate key from KeyManager 0xcd351d36 can sign Vault transfers and FLIP redemptions (about $18.4M)"
project: chainflip
status: confirmed
severity: MEDIUM
patterns: [PQ-11]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0xcd351d3626dc244730796a3168d315168ebf08be"
  implementation: null
  name: KeyManager
  upgradeable: "no"
  admin: none for the code (no proxy); aggKey rotated by an aggKey signature or by the governance key Safe 0x38a4bcc04f5136e6408589a440f495d7ad0f34db (3 of 6) after 2 days without a signature; Vault and StateChainGateway can be repointed to a new KeyManager by an aggKey-signed updateKeyManager
  value_usd: 18403584
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 24504
families: []
fix:
  layer: new-deployment
  who_acts: Chainflip (validator network signing with the current aggKey) deploys a KeyManager with a post-quantum scheme and calls updateKeyManager on Vault 0xf5e10380213880111522dd0efd3dbb45b9f62bcc and StateChainGateway 0x6995ab7c4d7f4b03f467cf4c8e920427d9621dbd
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/chainflip-aggkey-schnorr-ecrecover
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
  who: Review03 (registry review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/chainflip-aggkey-schnorr-ecrecover/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Chainflip's Ethereum Vault and StateChainGateway release funds on a Schnorr signature by the validators' aggregate
key (a FROST threshold key on secp256k1), which KeyManager 0xcd351d36 checks with `ecrecover` used as a curve
gadget (PQ-11). The aggregate public key is stored on-chain, so a quantum attacker recovers the single aggregate
secret and signs `transfer`/`allBatch` on the Vault ($5.14M) and `registerRedemption` on the StateChainGateway
(28.1M FLIP, $13.26M), and can mint FLIP through `updateFlipSupply`: about $18.4M exposed. Rated MEDIUM (step 4):
the consumers can be repointed to a new KeyManager by one aggKey-signed call each, so Chainflip can fix it with a
new deployment.

## Mechanism

- `KeyManager.consumeKeyNonce(SigData sigData, bytes32 contractMsgHash)` hashes the message with nonce, caller,
  chain id and its own address and calls `_consumeKeyNonce`, which requires
  `verifySignature(msgHash, sig, aggKey.pubKeyX, aggKey.pubKeyYParity, kTimesGAddress)` and marks the nonce used.
- `SchnorrSECP256K1.verifySignature` (excerpt lines 102–150) computes
  `ecrecover(Q - s·PKx, parity, PKx, e·PKx)` and compares the result with the address of `k·G` (the Chainlink Schnorr
  trick). Whoever knows the aggregate secret key signs anything.
- Consumers use the `consumesKeyNonce` modifier (`AggKeyNonceConsumer.sol` line 83):
  - Vault 0xf5e10380: `transfer`, `transferBatch`, `allBatch`, `allBatchV2`, `fetchBatch`, `deployAndFetchBatch`,
    `executexSwapAndCall`, `executexCall` move the Vault's ETH and tokens (and fetch from deposit contracts).
  - StateChainGateway 0x6995ab7c: `registerRedemption` queues any FLIP amount to any address, executable after
    `REDEMPTION_DELAY` (48 h) unless the gateway is suspended; `updateFlipSupply` mints or burns FLIP to the gateway;
    `updateFlipIssuer` hands the FLIP mint right to another address.
  - Both: `updateKeyManager(sigData, keyManager, omitChecks)` repoints the consumer to another KeyManager.
- In KeyManager the aggKey also rotates itself (`setAggKeyWithAggKey`) and can replace the governance and community
  keys (`setGovKeyWithAggKey`, `setCommKeyWithAggKey`), so a forged signature also takes over key management.

## Evidence

- CHECKED (verified source, Blockscout/Sourcify): `KeyManager.sol`, `SchnorrSECP256K1.sol`, `Vault.sol`,
  `StateChainGateway.sol`, `AggKeyNonceConsumer.sol`; functions and modifiers as above
  ([`source-excerpts.md`](#source-excerpts-chainflip-aggkey-schnorr-ecrecover)).
- CHECKED (on-chain read, block 26,431,547): `getAggregateKey()` returns a set key (parity 0);
  `getGovernanceKey()` = Safe 0x38a4bcc0… (3 of 6); `getCommunityKey()` = Safe 0x57955e52… (5 of 9);
  `getKeyManager()` on Vault and StateChainGateway = 0xcd351d36…; Vault not suspended, community guard enabled
  ([`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/chainflip-aggkey-schnorr-ecrecover/escrow.json)).
- CHECKED (on-chain read, block 26,431,214): KeyManager is not a proxy and holds nothing
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/chainflip-aggkey-schnorr-ecrecover/onchain.json)).
- CHECKED (Blockscout, 2026-11-17): Vault and StateChainGateway holdings
  ([`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/chainflip-aggkey-schnorr-ecrecover/escrow.json)).
- CHECKED (Xatu, any function): 24,504 transactions reached KeyManager in 2026-10-16 to 2026-11-16, last on
  2026-11-16 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/chainflip-aggkey-schnorr-ecrecover/activity.json)); `txs_y1` = 132,687
  pre-quantum calls in `curated_contracts.csv`.
- INFERRED: the aggregate key is a FROST key held by Chainflip's validator set; a CRQC needs only the aggregate public
  key, not the individual shares.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xcd351d36…` KeyManager | no | $0 (escrow: $18.4M) | 2026-11-16 | 24,504 |

Escrow released by an aggKey signature (Blockscout, 2026-11-17):

| Contract | Holdings | USD |
|---|---|---|
| Vault `0xf5e10380…` | 608.97 ETH, 2.84M USDC, 0.81M USDT, 735,746 FLIP, 0.55 WBTC, dust | $5.14M |
| StateChainGateway `0x6995ab7c…` | 28,130,078 FLIP | $13.26M |

Not counted: funds sitting in per-swap deposit contracts before `fetchBatch`, and FLIP an attacker could mint with
`updateFlipSupply` (its sale value depends on the market). The governance Safe can `suspend()` both consumers, which
blocks `transfer` and `executeRedemption` but not the signature check itself.

## Remediation

- Post-quantum replacement: a KeyManager that verifies a post-quantum threshold signature (or a STARK proof of the
  validator set's approval) in place of secp256k1 Schnorr. The Vault and StateChainGateway do not need to be
  redeployed: each takes an aggKey-signed `updateKeyManager` call pointing at the new KeyManager.
- Who acts: Chainflip, through a validator-network signature with the current aggKey (before a CRQC exists). The
  governance Safe 0x38a4bcc0… (3 of 6) can suspend the consumers in an emergency and, with the community Safe
  0x57955e52… (5 of 9) disabling the guard, `govWithdraw` the Vault after 3 days without a signature; both Safes are
  ECDSA-owned themselves.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by a new deployment that the operator and users move to).
- 2026-11-17 review (Review03): MEDIUM unchanged (step 4: Chainflip repoints Vault and StateChainGateway to a new KeyManager with `updateKeyManager`). Alternative corrected from key-rotation-only to configurable-verifier; escrow measured at $18.4M (Vault $5.14M, StateChainGateway $13.26M).

# Source excerpts: chainflip-aggkey-schnorr-ecrecover

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xcd351d3626dc244730796a3168d315168ebf08be` — KeyManager (verified source via sourcify)

### `KeyManager.sol`

```solidity
    2  
    3  pragma solidity ^0.8.0;
    4  
    5  import "IKeyManager.sol";
    6  import "SchnorrSECP256K1.sol";
    7  import "Shared.sol";
    8  
    9  /**
   10   * @title    KeyManager contract
   11   * @notice   Holds the aggregate and governance keys, functions to update them, and
   12   *           consumeKeyNonce so other contracts can verify signatures and updates _lastValidateTime
   13   */
   14  contract KeyManager is SchnorrSECP256K1, Shared, IKeyManager {
   15      uint256 private constant _AGG_KEY_TIMEOUT = 2 days;
   16  
   17      /// @dev    The current (schnorr) aggregate key.
   18      Key private _aggKey;
  ...
```

### `SchnorrSECP256K1.sol`

```solidity
    2  
    3  pragma solidity ^0.8.0;
    4  
    5  /// @notice Slightly modified from https://github.com/smartcontractkit/chainlink/pull/1272/files
    6  abstract contract SchnorrSECP256K1 {
    7      // See https://en.bitcoin.it/wiki/Secp256k1 for this constant.
    8      // Group order of secp256k1
    9      uint256 private constant Q =
   10          // solium-disable-next-line indentation
  ...
   12      // solium-disable-next-line zeppelin/no-arithmetic-operations
   13      uint256 private constant HALF_Q = (Q >> 1) + 1;
   14  
   15      /** **************************************************************************
   16        @notice verifySignature returns true iff passed a valid Schnorr signature.
   17  
   18        @dev See https://en.wikipedia.org/wiki/Schnorr_signature for reference.
   19  
   20        @dev In what follows, let d be your secret key, PK be your public key,
   21        PKx be the x ordinate of your public key, and PKyp be the parity bit for
   22        the y ordinate (i.e., 0 if PKy is even, 1 if odd.)
  ...
   67  
   68        @dev    verifySignature(PKx, PKyp, s, msgHash,
   69                                nonceTimesGeneratorAddress)
   70        **************************************************************************
   71        @dev This signging scheme deviates slightly from the classical Schnorr
   72        signature, in that the address of k*g is used in place of k*g itself,
   73        both when calculating e and when verifying sum S as described in the
   74        verification paragraph above. This reduces the difficulty of
   75        brute-forcing a signature by trying random secp256k1 points in place of
  ...
   78        giant-step" is only 128 bits, so this weakening constitutes no compromise
   79        in the security of the signatures or the key.
   80  
   81        @dev The constraint signingPubKeyX < HALF_Q comes from Eq. (281), p. 24
   82        of Yellow Paper version 78d7b9a. ecrecover only accepts "s" inputs less
   83        than HALF_Q, to protect against a signature- malleability vulnerability in
   84        ECDSA. Schnorr does not have this vulnerability, but we must account for
   85        ecrecover's defense anyway. And since we are abusing ecrecover by putting
   86        signingPubKeyX in ecrecover's "s" argument the constraint applies to
   87        signingPubKeyX, even though it represents a value in the base field, and
   88        has no natural relationship to the order of the curve's cyclic group.
   89        **************************************************************************
   90        @param msgHash is a 256-bit hash of the message being signed.
  ...
  133          // ecrecover(-s*r,v,r,e*r) is (r⁻¹ mod Q)*(e*r*R-(-s)*r*g)=e*R+s*g, where R
  134          // is the (v,r) point. See https://crypto.stackexchange.com/a/18106
  135          //
  136          // solium-disable-next-line indentation
  137          address recoveredAddress = ecrecover(
  138              // solium-disable-next-line zeppelin/no-arithmetic-operations
  139              bytes32(Q - mulmod(signingPubKeyX, signature, Q)),
  140              // https://ethereum.github.io/yellowpaper/paper.pdf p. 24, "The
  141              // value 27 represents an even y value and 28 represents an odd
  ...
  143              (pubKeyYParity == 0) ? 27 : 28,
  144              bytes32(signingPubKeyX),
  145              bytes32(mulmod(msgChallenge, signingPubKeyX, Q))
  146          );
  147          require(recoveredAddress != address(0), "Schnorr: recoveredAddress is 0");
  148  
  149          return nonceTimesGeneratorAddress == recoveredAddress;
  150      }
  151  
  ...
```
