---
id: lifi-backend-signer
title: "LI.FI: a quantum attacker who derives the backend quote key can pass the quote check of six LiFiDiamond bridge facets, but can move only funds of the caller"
project: lifi
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: none
alternative: sole
role: auxiliary
contracts:
- address: "0x1231deb6f5749ef6ce6943a275a1d3e7486f4eae"
  implementation: null
  name: LiFiDiamond
  upgradeable: "yes"
  admin: diamond owner LiFiTimelockController 0x55117eccc867db72aeb25f728ccf57c3c3b4faee (min delay 3 h); diamondCut replaces facets
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 203037
families: []
fix:
  layer: contract-upgrade
  who_acts: "LI.FI, through diamond owner LiFiTimelockController 0x55117eccc867db72aeb25f728ccf57c3c3b4faee: diamondCut new versions of AcrossV4SwapFacet, SymbiosisFacet, LayerSwapFacet, UnitFacet, EcoFacet and NEARIntentsFacet that verify a post-quantum backend signature"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/lifi-backend-signer/classification.jsonl
  - evidence/lifi-backend-signer/onchain.json
  - evidence/lifi-backend-signer/activity.json
  - evidence/lifi-backend-signer/source-excerpts.md
  - evidence/lifi-backend-signer/facets.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review06 (Claude), 2026-11-17 review
  ref: Blockscout-verified facet sources; cast reads on 2026-11-17
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Six bridge facets of the LI.FI diamond require an EIP-712 signature from one backend key (EOA 0xaf4b7a83…) over the
bridge parameters before they forward the caller's tokens to Across, Symbiosis, LayerSwap, Unit, Eco or NEAR Intents.
A quantum attacker who derives that key can produce quotes the facets accept, but every one of these paths moves only
tokens deposited by `msg.sender` in the same transaction; the diamond holds no pooled funds, and other users'
approvals cannot be pulled through these paths. Nothing can be taken through the check that the caller could not
already send. Rated LOW: step 4: the check guards quote integrity, not funds; LI.FI fixes it by replacing six facets
through its timelock.

## Mechanism

- `AcrossV4SwapFacet` (`_verify…`, lines 303-308), `SymbiosisFacet` (line 473, OnchainSwapV3 path), `LayerSwapFacet`
  (262-267), `UnitFacet` (203-206), `EcoFacet` (452-457) and `NEARIntentsFacet._verifySignature` (297-331) each
  compute an EIP-712 digest over the bridge data (transaction id, amount, receiver, deposit address or route,
  deadline, quote id, minimum output, refund recipient) and require `ECDSA.recover(digest, signature) ==
  BACKEND_SIGNER`, an `immutable` set in the facet constructor. All six use the same signer, 0xaf4b7a83….
- Funds enter through `LibAsset.depositAsset` from `msg.sender` (e.g. `startBridgeTokensViaUnit`, line 99) and
  leave to the bridge named in the signed payload. The signature binds an off-chain quote (for NEAR Intents, the 1Click
  deposit address and destination asset) to the caller's calldata so that it cannot be altered after LI.FI's API
  produced it.
- Pattern PQ-4 (one operator key), but with no pooled value behind it. Post-quantum users are not affected: users are
  `msg.sender`, not signers.

## Evidence

- CHECKED (cast, 2026-11-17): `facetAddresses()` returns 42 facets; `owner()` = LiFiTimelockController 0x55117ecc…,
  `getMinDelay()` = 10,800 s; backend signer 0xaf4b7a83… has no code and nonce 0 (EOA that only signs off-chain; its
  signatures are public in calldata) ([`facets.json`](../evidence/lifi-backend-signer/facets.json)).
- CHECKED (Blockscout-verified source and constructor arguments of the six facets listed above): the check and the
  signer address; no other facet of the 42 contains `ecrecover`/`ECDSA.recover` against a stored signer.
- CHECKED (on-chain read at block 26,431,214): the diamond holds dust (USD 0.00002 of tokens)
  ([`onchain.json`](../evidence/lifi-backend-signer/onchain.json)).
- CHECKED (Xatu, any function): 203,037 transactions in 2026-10-16 to 2026-11-16, last on 2026-11-16
  ([`activity.json`](../evidence/lifi-backend-signer/activity.json)); `curated_contracts.csv`: 431,459 ecrecover
  calls in the last year (all diamond paths, including user-permit paths that are not part of this finding).
- INFERRED: any off-chain use LI.FI or its partners make of a signed quote (accounting, fee sharing) is not visible
  on-chain and was not assessed.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x1231deb6…` LiFiDiamond | yes (diamondCut by timelock) | dust | 2026-11-16 | 203,037 |

- Value: none exposed through this check. The diamond's own balance is dust, and the six facets pull only from the
  caller; `value_usd` is left null because there is no escrow behind the check.
- Siblings: LI.FI's diamonds on other chains are outside this registry.

## Remediation

- Replace the six facets (diamondCut by the timelock) with versions that verify a post-quantum signature from the
  backend, or an ERC-1271 call to a backend verifier contract, so the signer can later move to ML-DSA or a hash-based
  scheme without another facet change.
- Who acts: LI.FI through LiFiTimelockController 0x55117ecc…; the backend must generate the new key.
- No protocol change is needed or would help.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review06): MEDIUM -> LOW, step 4: the backend signature only binds a quote to the caller's own deposit; nothing pooled can be taken through it (impact funds-loss -> none, role core -> auxiliary). Facets, signer and timelock read on-chain.
