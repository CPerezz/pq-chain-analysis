---
id: hyperbridge-sp1-verifier
title: "Hyperbridge on Ethereum: with the SP1 Groth16 (BN254) setup trapdoor, a quantum attacker can prove a false Polkadot consensus update and deliver forged cross-chain messages that mint or release bridged tokens"
project: hyperbridge
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x70303aa3434e13b64f150ce72bad43e13c8ed186"
  implementation: null
  name: SP1Verifier (Groth16 v6.1.0), used by SP1Beefy 0x3683cd18cdb7c5c223f9489ac33c9c97eb176cb1
  upgradeable: config-only
  admin: immutable verifier, router and SP1Beefy; EvmHost 0x620128e2b19193d6bd244a3ac8d3bba0541b19c3 consensus client is set by OwnableHostManager 0x712515887e0dff042530a120dca9e8a3c90178a5, owner Safe 0x08bcc96cec579ce2edb34e5c5d790e4a40c3e224 (2 of 2)
  value_usd: null
  value_basis: null
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: null
- address: "0x3794de2808420ba5fc5bb07d0643379b85bbb53d"
  implementation: null
  name: SP1Verifier (Groth16 v6.0.0), retired
  upgradeable: "no"
  admin: none; no longer referenced by the Ethereum host's consensus client
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-05-15
  txs_30d: 0
- address: "0xe8bd3eee668089b8d29fcd65b8217733cb60b098"
  implementation: null
  name: SP1Verifier (Groth16 v4.0.0-rc.3), retired
  upgradeable: "no"
  admin: none; no longer referenced by the Ethereum host's consensus client
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-01-26
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: Polytope Labs / Hyperbridge, through OwnableHostManager 0x712515887e0dff042530a120dca9e8a3c90178a5 (owner Safe 0x08bcc96cec579ce2edb34e5c5d790e4a40c3e224) calling EvmHost.updateHostParams with a consensus client that verifies a post-quantum proof
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/hyperbridge-sp1-verifier/classification.jsonl
  - evidence/hyperbridge-sp1-verifier/onchain.json
  - evidence/hyperbridge-sp1-verifier/activity.json
  - evidence/hyperbridge-sp1-verifier/source-excerpts.md
  - evidence/hyperbridge-sp1-verifier/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review07 (registry review)
  ref: evidence/hyperbridge-sp1-verifier/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [hyperbridge-ecdsa-beefy]
---

## Summary

Hyperbridge's Ethereum host accepts Polkadot (BEEFY) consensus updates proven with an SP1 Groth16 proof on BN254
(PQ-7). A quantum attacker who recovers the Groth16 setup trapdoor can prove a false consensus update, then deliver
forged ISMP messages through the open `HandlerV2` path: mint any Hyperbridge-bridged token on Ethereum or release
whatever its applications escrow. Measured escrow on Ethereum is small (about $37 in the intent and deprecated token
gateways), but the minting power over issuer-owned bridged tokens is not measured, so value lowers nothing. Rated
MEDIUM (step 4): the host manager's 2-of-2 Safe can point the host at a new consensus client.

## Mechanism

`OwnableHandler.handleConsensus` (a `HandlerV2`, open to any relayer) passes the proof to the host's consensus client
`ConsensusRouter` `0x64094bb4…`, which dispatches on the first proof byte: SP1 proofs go to `SP1Beefy` `0x3683cd18…`,
whose `verifyConsensus` calls `verifier.verifyProof(verificationKey, publicInputs, proof.proof)` (line 155) on the
immutable `SP1Verifier` `0x70303aa3…` (sp1-contracts v6.1.0 `SP1VerifierGroth16`, BN254 pairing). A verified update
stores new Hyperbridge state roots; requests proven against them are dispatched to the destination app
(`onAccept`), which mints or releases tokens. The two verifiers in the draft (`0x3794de28…` v6.0.0 and `0xe8bd3eee…`
v4.0.0-rc.3) are earlier SP1 verifiers of the same consensus path, no longer referenced by the current router.
The router also accepts ECDSA BEEFY proofs (`EcdsaBeefy` `0xaec95085…`), a second pre-quantum path (PQ-5) rated in
`hyperbridge-ecdsa-beefy`. Lines:
[`notes.md`](../evidence/hyperbridge-sp1-verifier/notes.md).

## Evidence

- CHECKED (Blockscout verified source, Sourcify for `0xe8bd3eee…`): `SP1Beefy.verifyConsensus` → `SP1Verifier`
  Groth16; `ConsensusRouter` immutables; `OwnableHandler` = `HandlerV2` with an owner-only `setConsensusState`;
  `EvmHost.updateHostParams` restricted to the host manager.
- CHECKED (`cast` at blocks 26,431,692–26,431,699): host `consensusClient()` = router `0x64094bb4…`;
  `SP1Beefy.verifier()` = `0x70303aa3…` (`VERSION()` "v6.1.0"); host `admin()` = EOA `0xd15007f5…`; host manager
  and handler `owner()` = Safe `0x08bcc96c…`, threshold 2 of 2.
- CHECKED (precompile trace `data/agg/alltime_caller.parquet`): the retired verifiers made BN254 pairing calls until
  blocks 24,682,920 (v6.0.0) and 24,318,221 (v4.0.0-rc.3); `activity.json`: last called 2026-05-15 and 2026-01-26.
  The current verifier was deployed 2026-05-12, after the trace window; its own call count is not measured.
- CHECKED (Blockscout, 2026-11-17): the 6 handler `handleConsensus` transactions listed (2026-11-16) all carry proof
  type 0x01, i.e. they went through SP1Beefy to this verifier; last active 2026-11-16.
- CHECKED (Blockscout tokens and `cast`, 2026-11-17): `IntentGatewayV2` `0xae041f7b…` holds ≈ $19; deprecated
  `TokenGateway` `0xfd413e3a…` ≈ $18.
- INFERRED: `OwnableHostManager` lets its owner call `updateHostParams` (from its name and `owner()`; its source was
  not read).

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x70303aa3…` SP1Verifier v6.1.0 (current) | config-only | not measured (see below) | 2026-11-16 | — |
| `0x3794de28…` SP1Verifier v6.0.0 (retired) | no | none (not referenced) | 2026-05-15 | 0 |
| `0xe8bd3eee…` SP1Verifier v4.0.0-rc.3 (retired) | no | none (not referenced) | 2026-01-26 | 0 |

What a forged consensus update releases on Ethereum: the escrow of `IntentGatewayV2` (≈ $19) and the deprecated
`TokenGateway` (≈ $18), plus whatever issuer-owned HyperFungible tokens and LayerZero OApps on the Hyperbridge
endpoint mint or release on Hyperbridge messages, which is not enumerated here (the April 2026 incident showed a
forged message can mint a bridged token's supply). `value_usd` stays null because the minting exposure is unmeasured.
Other chains' hosts are out of scope.

## Remediation

- Polytope Labs / Hyperbridge deploys a consensus client that verifies a post-quantum proof (SP1's STARK/FRI proof
  directly, or a hash-based wrapper) and the host manager Safe `0x08bcc96c…` points `EvmHost` at it through
  `updateHostParams`; the router and verifiers are immutable, so a new router is needed. The ECDSA BEEFY path in the
  router must be removed in the same change, or the new client is bypassable.
- Bridged-token issuers can rate-limit or pause their HyperFungible contracts (issuer-owned keys).
- No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review07): MEDIUM unchanged (step 4). The drafted verifiers are retired; added the current
  verifier `0x70303aa3…` (v6.1.0) that the host's consensus client uses; identified the admin path (host manager Safe
  2 of 2); escrow measured at ≈ $37 but minting exposure unmeasured. Noted the router's ECDSA BEEFY path (PQ-5), not
  yet in the registry.
- 2026-11-17 review (Review07): the ECDSA BEEFY path now has its own finding, `hyperbridge-ecdsa-beefy`; current
  verifier last active 2026-11-16 (SP1 proof type in the handler's latest transactions).
