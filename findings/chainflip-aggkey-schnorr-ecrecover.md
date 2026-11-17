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
  links:
  - evidence/chainflip-aggkey-schnorr-ecrecover/classification.jsonl
  - evidence/chainflip-aggkey-schnorr-ecrecover/onchain.json
  - evidence/chainflip-aggkey-schnorr-ecrecover/activity.json
  - evidence/chainflip-aggkey-schnorr-ecrecover/source-excerpts.md
  - evidence/chainflip-aggkey-schnorr-ecrecover/escrow.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review03 (registry review)
  ref: evidence/chainflip-aggkey-schnorr-ecrecover/escrow.json
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
  ([`source-excerpts.md`](../evidence/chainflip-aggkey-schnorr-ecrecover/source-excerpts.md)).
- CHECKED (on-chain read, block 26,431,547): `getAggregateKey()` returns a set key (parity 0);
  `getGovernanceKey()` = Safe 0x38a4bcc0… (3 of 6); `getCommunityKey()` = Safe 0x57955e52… (5 of 9);
  `getKeyManager()` on Vault and StateChainGateway = 0xcd351d36…; Vault not suspended, community guard enabled
  ([`escrow.json`](../evidence/chainflip-aggkey-schnorr-ecrecover/escrow.json)).
- CHECKED (on-chain read, block 26,431,214): KeyManager is not a proxy and holds nothing
  ([`onchain.json`](../evidence/chainflip-aggkey-schnorr-ecrecover/onchain.json)).
- CHECKED (Blockscout, 2026-11-17): Vault and StateChainGateway holdings
  ([`escrow.json`](../evidence/chainflip-aggkey-schnorr-ecrecover/escrow.json)).
- CHECKED (Xatu, any function): 24,504 transactions reached KeyManager in 2026-10-16 to 2026-11-16, last on
  2026-11-16 ([`activity.json`](../evidence/chainflip-aggkey-schnorr-ecrecover/activity.json)); `txs_y1` = 132,687
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

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by a new deployment that the operator and users move to).
- 2026-11-17 review (Review03): MEDIUM unchanged (step 4: Chainflip repoints Vault and StateChainGateway to a new KeyManager with `updateKeyManager`). Alternative corrected from key-rotation-only to configurable-verifier; escrow measured at $18.4M (Vault $5.14M, StateChainGateway $13.26M).
