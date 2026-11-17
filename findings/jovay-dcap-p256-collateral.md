---
id: jovay-dcap-p256-collateral
title: "Jovay L2 (own Automata DCAP/PCCS deployment): Intel TDX attestations are checked with P-256 signatures, so a quantum attacker who recovers the attestation or Intel PCS keys can forge a TEE proof that alone finalizes a false Jovay state; the L1 escrow holds about $13k"
project: jovay
status: confirmed
severity: LOW
patterns: [PQ-9]
primitives: [p256, sw_p256]
trigger: issuer-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0xa7aded125cb4663c0ddb1a563d03df158b191c0b"
  implementation: null
  name: DCAPAttestationRouter (Jovay Rollup tee_verifier; AutomataDcapAttestationFee 0x5d3009d5 with P256VERIFY 0x100)
  upgradeable: config-only
  admin: owner EOA 0xa1e7758a84b40ba7aa1a80b3d3096e918a7950bb (setConfig); Rollup 0xe0a28b8918a62edb825055221a1df12c7c81bac1 owner (same EOA) can setMode or setTeeVerifierAddress (read at block 26431961)
  value_usd: 12985
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-17
  txs_30d: null
- address: "0x783377992fca09009ead952d4fba6519e25726b4"
  implementation: null
  name: DaimoP256Verifier (P256_VERIFIER of Jovay's first PCCS and quote verifiers, retired)
  upgradeable: "no"
  admin: none (stateless); consumers fix it as an immutable
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-03-25
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: Jovay, through owner EOA 0xa1e7758a84b40ba7aa1a80b3d3096e918a7950bb (Rollup setMode(1) to also require ZK proofs, or setTeeVerifierAddress); a post-quantum replacement needs Intel to sign TEE attestations with a post-quantum scheme
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/jovay-dcap-p256-collateral/review-reads.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode), filed under daimo-p256-verifier
  ref: data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: review (Review22)
  ref: evidence/jovay-dcap-p256-collateral/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [daimo-p256-verifier]
---

## Summary

Jovay, an Ethereum L2 (chain 5734951), runs its own copy of Automata's DCAP attestation stack. Its `Rollup` finalizes
a batch on a TEE proof alone (`mode` = 0): an Intel TDX quote whose signatures are all P-256, made by an attestation key
certified through Intel's PCS chain (root CA → PCK → QE) and checked against collateral that Intel signs. A quantum
attacker who recovers the cached attestation key, or Intel's PCK/PCS keys, can forge a quote with the right measurement
and finalize a false state root, then withdraw from the L1 bridge. The L1 escrow holds 7.17 ETH (about $13k). Rated LOW
(step 4: the owner can require ZK proofs as well with one setting; step 5: under $50k).

## Mechanism

- `Rollup.verifyBatch` (proxy `0xe0a28b89…`, verified implementation `0xbf55506b…`, `_verifyTeeProof` line 467) calls
  `tee_verifier.verifyProof(proof)` and requires the returned commitment to match the batch. With `mode == 0`, "TEE
  verification alone is sufficient to finalize a batch" (line 100).
- `tee_verifier` = `DCAPAttestationRouter` `0xa7aded12…`. A traced `verifyBatch` (tx `0x2c70b465…`, 2026-11-17) calls
  `MeasurementRegistry.verifyMeasurementTDX`, then `TEECacheVerifier` `0xea9363d7…` (`parseAttestationKey`,
  `contains`, `verifyAndAttestOnChain`), which runs the P256VERIFY precompile `0x100` on the quote signature against a
  cached attestation key. Quotes from uncached keys go through `AutomataDcapAttestationFee` `0x5d3009d5…` → V4/V5
  quote verifiers (`P256_VERIFIER` = `0x100`, PCCS router `0x3a8e4a13…`), which verify the PCK chain and the
  Intel-signed TCB, QE identity and CRL collateral with P-256. PQ-9 (issuer keys rather than passkeys).
- `0x78337799…` is a copy of Daimo's verifier, built from `script/utils/DaimoP256Verifier.sol` and deployed by the
  same EOA on 2025-09-20. It is the immutable `P256_VERIFIER` of Jovay's first PCCS (`AutomataFmspcTcbDao`
  `0xee73475b…`, `AutomataPcsDao` `0x5ecf7a66…`, `AutomataEnclaveIdentityDao` `0xb22d72df…`, PCK DAO `0xa6d7ceae…`,
  storage `0x983ad4e3…`, `PCCSRouter` `0x2857b2ea…`). It is also the verifier of the quote verifiers behind the old
  router `0x238f4daf…`. The DAOs call `verifySignature` → `ecdsaVerify` (`SigVerifyBase.sol`, `P256Verifier.sol`) on
  Intel's signatures in `upsertFmspcTcb`, `upsertEnclaveIdentity` and `upsertPckCrl`. The Rollup has since moved to
  the router `0xa7aded12…` and a second PCCS (March 2026) that uses `0x100`.

## Evidence

- CHECKED (verified source: Rollup implementation `0xbf55506b…` and AutomataFmspcTcbDao `0xee73475b…` on Blockscout,
  `0x78337799…` on Sourcify; bytecode selectors for `0xa7aded12…`, `0x5d3009d5…` and the quote verifiers): the paths
  above.
- CHECKED (RPC at block 26,431,961; [`review-reads.json`](../evidence/jovay-dcap-p256-collateral/review-reads.json)):
  Rollup `tee_verifier` = `0xa7aded12…`, `zk_verifier` = `0xb941a925…`, `mode` = 0, `lastZkVerifiedBatch` = 0,
  `lastFinalizedBatchIndex` = `lastTeeVerifiedBatch` = 10,106, `layer2ChainId` = 5,734,951, `owner()` = EOA
  `0xa1e7758a…`; `DCAPAttestationRouter.dcapAttestation()` = `0x5d3009d5…`; quote verifiers v4/v5 `P256_VERIFIER()` =
  `0x100`; old DAOs and old quote verifiers `P256_VERIFIER()` = `0x78337799…`; storage `0x983ad4e3…` owner
  `0xa1e7758a…`, authorized reader only `PCCSRouter` `0x2857b2ea…`.
- CHECKED (Jovay docs, network information): L1 bridge `0x922248db…` and L1 ERC20 bridge `0xbb2517a6…`; both point at
  Rollup `0xe0a28b89…` and Mailbox `0x9869a90f…`.
- CHECKED (balances): Mailbox `0x9869a90f…` 7.1674 ETH; ETH bridge 0; ERC20 bridges 0 (Blockscout, priced tokens).
- CHECKED (Xatu): 3 calls to `0x78337799…` since block 24,700,000, all Intel collateral updates, the last on 2026-03-25.
  There were 3,958 pre-quantum calls in the year to March 2026 (`curated_contracts.csv`).
- INFERRED: the cached attestation key is a P-256 public key visible in submitted quotes, so recovering it is enough to
  sign proofs without touching Intel's keys. How keys enter the cache was not traced.

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0xa7aded12…` DCAPAttestationRouter (live) | config-only (owner EOA) | $13k (escrow: Jovay Mailbox `0x9869a90f…` 7.17 ETH) | 2026-11-17 | not measured |
| `0x78337799…` DaimoP256Verifier (old PCCS) | no | $0 (no longer on the Rollup's path) | 2026-03-25 | 0 |

- A forged TEE proof finalizes a state root; withdrawals then release what the L1 bridge holds.
- Jovay's owner is a single ECDSA EOA (`0xa1e7758a…`) that controls the Rollup, the bridges, the DCAP contracts and
  the PCCS storage; that is a separate pre-quantum exposure of the same funds.
- The PCCS DAOs accept collateral from anyone with a valid Intel signature; other users of this PCCS were not found
  (its only authorized reader is Jovay's PCCSRouter).

## Remediation

- Jovay's owner can call `Rollup.setMode(1)` to require a ZK proof in addition to the TEE proof (ZK proving is not
  running today: `lastZkVerifiedBatch` = 0), or switch `tee_verifier` while paused. This removes the single P-256
  dependency, though the ZK verifier must itself be post-quantum to remove the exposure.
- Post-quantum TEE attestation needs Intel to sign PCK certificates, collateral and quotes with a post-quantum scheme;
  until then TEE proofs cannot be made post-quantum on-chain.
- Protocol change: not needed.

## History

- 2026-11-04: `0x78337799…` classified as a Daimo passkey verifier (hand classification pass; `data/curation/`), filed under `daimo-p256-verifier`.
- 2026-11-17 review (Review22): moved here from `daimo-p256-verifier` at Main's request; identified as the P-256 verifier of Jovay's first Automata PCCS (Intel collateral, issuer keys); added Jovay's live TEE verifier `0xa7aded12…` (P256VERIFY precompile). Rated LOW, step 4: one known operator (Jovay owner EOA) can require ZK proofs with `setMode(1)`; step 5 would also apply (escrow $13k).
- 2026-11-17 integration: id renamed from `automata-dcap-p256-collateral` (project is Jovay, not Automata).
