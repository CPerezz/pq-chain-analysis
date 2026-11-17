---
id: ondo-gm-attestation-signer
title: "Ondo Global Markets: a quantum attacker who recovers the attestation signer's ECDSA key can sign quotes that let a registered account mint or redeem tokenized stocks up to 10% off the oracle price through GMTokenManager"
project: ondo
status: confirmed
severity: MEDIUM
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x2c158bc456e027b2affccadf1bdbd9f5fc4c5c8c"
  implementation: null
  name: GMTokenManager
  upgradeable: config-only
  admin: "DEFAULT_ADMIN_ROLE = TimelockController 0x3715b2154d2ff4c5b027c7a1f734b53f27bc34f1 (min delay 7,200 s), which grants ATTESTATION_SIGNER_ROLE; no proxy (read at block 26431459)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 46011
families: []
fix:
  layer: new-deployment
  who_acts: "Ondo Finance: deploy a GMTokenManager that verifies a post-quantum attestation signature and move the GM token and USDon minting roles to it, through the TimelockController 0x3715b2154d2ff4c5b027c7a1f734b53f27bc34f1; meanwhile PAUSER_ROLE holders can pause mints and redemptions"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/ondo-gm-attestation-signer/classification.jsonl
  - evidence/ondo-gm-attestation-signer/onchain.json
  - evidence/ondo-gm-attestation-signer/activity.json
  - evidence/ondo-gm-attestation-signer/source-excerpts.md
  - evidence/ondo-gm-attestation-signer/review-reads.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

Ondo Global Markets mints and redeems its tokenized-stock (GM) tokens against USDon only with a price quote signed by
one ECDSA key holding `ATTESTATION_SIGNER_ROLE` (PQ-4). A quantum attacker who recovers that key (its signatures are
in every mint and redeem transaction) can sign quotes for an Ondo-registered account at any price the sanity-check
oracle allows (10% from the posted price by default), buying GM tokens cheap or redeeming them dear, repeatedly within
the rate limiter. The loss is bounded per trade but not measured. Rated MEDIUM: step 4 (the check is hard-coded, so the
fix is a new deployment by Ondo).

## Mechanism

- `mintWithAttestation(quote, signature, depositToken, depositTokenAmount)` and `redeemWithAttestation(quote,
  signature, receiveToken, minimumReceiveAmount)` (GMTokenManager.sol lines 171-316) look up the caller's Ondo ID,
  call `_verifyQuote`, then burn USDon and mint `quote.quantity` GM tokens, or burn GM tokens and mint
  `quantity × price` USDon to the caller.
- `_verifyQuote` (lines 325-366) checks replay, expiry, `quote.userId`, issuance hours,
  `sanityCheckOracle.validatePrice(asset, price)`, token registration and chain id, then
  `ECDSA.recover(digest, signature)` must hold `ATTESTATION_SIGNER_ROLE` (lines 363-365).
- Limits on a forged quote: the caller must be registered in `ondoIDRegistry`; the price must be within
  `allowedDeviationBps` of the oracle's posted price (`OndoSanityCheckOracle.validatePrice`, default 1,000 bps); and
  `ondoRateLimiter.checkAndUpdateRateLimit` caps volume per window.
- Pattern PQ-4; excerpt in [`source-excerpts.md`](../evidence/ondo-gm-attestation-signer/source-excerpts.md).

## Evidence

- CHECKED (verified source on Sourcify, full GMTokenManager.sol and OndoSanityCheckOracle.sol read 2026-11-17): the
  lines above; no proxy, `ECDSA.recover` hard-coded; admin functions only swap oracle, registry, rate limiter, USDon
  manager and roles.
- CHECKED (`cast call` at block 26,431,459): `getRoleMember` for `DEFAULT_ADMIN_ROLE` = `0x3715b215…` (Blockscout:
  verified TimelockController, `getMinDelay()` 7,200 s); `ATTESTATION_SIGNER_ROLE` = one member, `0xff2d04f6…` (EOA,
  nonce 0); `ADMIN_MINT_ROLE` `0x71a4d411…`; sanity oracle `defaultDeviationBps()` 1,000 and
  `defaultMaxTimeDelay()` 172,800 s ([`review-reads.json`](../evidence/ondo-gm-attestation-signer/review-reads.json)).
- CHECKED (on-chain read at block 26,431,214): the contract holds nothing (USDC dust)
  ([`onchain.json`](../evidence/ondo-gm-attestation-signer/onchain.json)).
- CHECKED (precompile trace): 365,708 `ecrecover` calls in the year to March 2026 (`curated_contracts.csv`, `txs_y1`).
- CHECKED (Xatu, any function): 46,011 transactions in 2026-10-16 to 2026-11-16, last 2026-11-16
  ([`activity.json`](../evidence/ondo-gm-attestation-signer/activity.json)).
- INFERRED: per-token deviation overrides and rate-limit settings were not read, so the extractable amount per window
  is not established.

## Impact and exposure

| Contract | Upgradeable | Exposed | Last active | 30-day txs |
|---|---|---|---|---|
| `0x2c158bc4…` GMTokenManager | config-only | not measured | 2026-11-16 | 46,011 |

What a forged quote releases: newly minted GM tokens (claims on Ondo's stock holdings) or newly minted USDon, at a
price up to the allowed deviation in the attacker's favour, for every trade the rate limiter lets through. There is no
pool in this contract to measure; the exposure is the deviation times the rate-limited volume, which was not read.
`value_usd` stays null.

## Remediation

- Post-quantum replacement: verify attestations with a post-quantum signature (for example through an ERC-7913
  verifier contract) in a new GMTokenManager; `ECDSA.recover` cannot be swapped in place.
- Who acts: Ondo Finance, through TimelockController `0x3715b215…`, deploys the new manager and moves the GM token and
  USDon mint/burn permissions to it. Rotating the signer key does not help. Pausers can stop the path in an emergency.
- Protocol change: not needed. Users have no action to take.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review20): MEDIUM kept, step 4: no proxy, signer check hard-coded, fix is a new deployment by
  Ondo. Roles read on-chain (admin = TimelockController `0x3715b215…`, one signer EOA); forged quotes are bounded by the
  sanity oracle (default 10%) and rate limiter, so the exposure is not a pool and stays unmeasured.
