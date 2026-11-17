---
id: wanchain-storeman-schnorr-bn254
title: "Wanchain bridge: recovering the storeman group's BN254 Schnorr key from its public key lets a quantum attacker sign smgRelease and empty CrossProxy (~USD 845k)"
project: wanchain
status: confirmed
severity: MEDIUM
patterns: [PQ-5]
primitives: [bn254]
trigger: committee-keys
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x84271540f80e8879826c377ebc496dfae270321a"
  implementation: null
  name: Bn128SchnorrVerifier (SignatureVerifier curveId 1)
  upgradeable: "no"
  admin: none; SignatureVerifier 0x9276ee38a5250e2f7fbe00a12ec17d09b5d28f3d register(curveId, verifier) is onlyOwner = GroupApprove 0xa1223a59a55eaad135bce9f513181c388072cc71 (proposal by foundation EOA 0x4ced9c0ea79ee6181600777d5b6bade7f3d301bf, executed with a storeman group signature)
  value_usd: 844985
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-17
  txs_30d: 246
families: []
fix:
  layer: onchain-config
  who_acts: "Wanchain: foundation 0x4ced9c0ea79ee6181600777d5b6bade7f3d301bf proposes in GroupApprove 0xa1223a59a55eaad135bce9f513181c388072cc71 and the storeman group approves registering a post-quantum verifier in SignatureVerifier 0x9276ee38a5250e2f7fbe00a12ec17d09b5d28f3d (and a CrossProxy 0xfceaaaeb8d564a9d0e71ef36f027b9d162bc334e upgrade if the curve choice must change); storeman nodes must run a post-quantum threshold scheme"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/wanchain-storeman-schnorr-bn254/classification.jsonl
  - evidence/wanchain-storeman-schnorr-bn254/onchain.json
  - evidence/wanchain-storeman-schnorr-bn254/activity.json
  - evidence/wanchain-storeman-schnorr-bn254/source-excerpts.md
  - evidence/wanchain-storeman-schnorr-bn254/escrow.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review14 (call path, SignatureVerifier and GroupApprove source, escrow)
  ref: evidence/wanchain-storeman-schnorr-bn254/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Wanchain's Ethereum bridge (CrossProxy) releases and mints tokens when the active storeman group signs the request with
a threshold Schnorr signature on BN254, verified by Bn128SchnorrVerifier. The group signs under one aggregate public
key, so a quantum attacker needs only that public key to recover the group secret and sign `smgRelease` for everything
CrossProxy holds: about USD 845k on 2026-11-17. The verifier is registered by curve ID in SignatureVerifier, which
Wanchain's GroupApprove (foundation proposal plus storeman approval) can repoint: rated MEDIUM (step 4: a new verifier
the consumer points at, plus a new threshold scheme run by the storeman nodes).

## Mechanism

- `CrossProxy.smgRelease(...)` (`0xfcea…334e`, implementation `0x86ec…a4e4`, unverified) fetches the storeman group's
  key and curve from OracleProxy `0xbb38…f228`, transfers the token through RapidityLibV4 / TokenManagerProxy, and
  calls `SignatureVerifier.verify(curveId, ...)` (observed in tx `0x94d9…26c6`, block 26,431,621).
- `SignatureVerifier.verify` dispatches to `verifierMap[curveId]` (lines 198–208); only curve ID 1 is registered,
  `0x8427…321a`. `register(curveId, verifierAddress)` is `onlyOwner` (line 212).
- `Bn128SchnorrVerifier.verify(signature, groupKeyX, groupKeyY, randomPointX, randomPointY, message)` (line 178)
  checks the Schnorr equation with the `ecadd` (0x06) and `ecmul` (0x07) precompiles against the group key.
- A CRQC computes the discrete log of the group public key; one forged signature authorises any release. Pattern PQ-5
  (committee attestation; here a threshold Schnorr group key rather than ECDSA signers).

## Evidence

- CHECKED (Sourcify verified source of Bn128SchnorrVerifier; Blockscout verified source of SignatureVerifier,
  GroupApprove and RapidityLibV4, read 2026-11-17): the functions above
  ([`source-excerpts.md`](../evidence/wanchain-storeman-schnorr-bn254/source-excerpts.md)).
- CHECKED (Blockscout internal transactions of tx `0x94d9…26c6`): the call path CrossProxy → SignatureVerifier →
  Bn128SchnorrVerifier ([`escrow.json`](../evidence/wanchain-storeman-schnorr-bn254/escrow.json)).
- CHECKED (cast via eth.drpc.org, 2026-11-17): `verifierMap(0..10)` (only 1 set); SignatureVerifier `owner()` =
  CrossProxy `owner()` = GroupApprove `0xa122…cc71`; `foundation()` = EOA `0x4ced…01bf`; CrossProxy `implementation()`
  and `getPartners()`.
- INFERRED: CrossProxy's implementation is unverified; that `smgRelease` uses the verifier was read from the call
  trace, not from source.
- CHECKED (precompile trace): 4,013 transactions in the trace year; Xatu: 246 transactions in 2026-10-16 to
  2026-11-16 ([`activity.json`](../evidence/wanchain-storeman-schnorr-bn254/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Exposed (escrow) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x84271540…` Bn128SchnorrVerifier | no (repointable via SignatureVerifier) | USD 845k | 2026-11-17 | 246 |

Escrow: CrossProxy `0xfceaaaeb…334e` holds 20.5 ETH and USD 808k in tokens (WBTC 7.20, USDC 162.6k, USDT 162.2k, …)
on 2026-11-17. Tokens that Wanchain mints on Ethereum through `smgMint` (wrapped assets from other chains) are also
mintable with a forged signature; their supply was not measured.

## Remediation

- Storeman nodes adopt a post-quantum threshold signature (or a hash-based scheme aggregated in a STARK), Wanchain
  deploys its verifier, and the foundation `0x4ced…01bf` proposes in GroupApprove `0xa122…cc71`
  `register(newCurveId, verifier)` on SignatureVerifier `0x9276…8f3d`, approved by the storeman group; the oracle's
  group config moves to the new curve ID.
- GroupApprove itself is approved with the same Schnorr signature and proposed by an ECDSA EOA, so the migration has to
  finish before a CRQC exists. No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review14): MEDIUM kept, step 4 (SignatureVerifier repointed through GroupApprove; storeman nodes change scheme). Title corrected (BN254 Schnorr group key, not ECDSA signers); escrow measured at USD 845k in CrossProxy.
