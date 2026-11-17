---
id: houdini-swap-bn254-schnorr
title: "PrivateDEX test deployments (Houdini Swap, inferred): a quantum attacker who solves BN254 discrete logs can forge the Schnorr-style deposit proofs and withdraw any deposit (USD 17 held)"
project: houdini-swap
status: confirmed
severity: MEDIUM
patterns: [PQ-11]
primitives: [bn254]
trigger: user-key
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x23c5e2e0128f0bf3a8d92cda02c9d3068887b13a"
  implementation: null
  name: PrivateDEX
  upgradeable: "no"
  admin: "owner EOA 0x8a462a861e34939157c61d478e959dc18152fc2e can only edit the token whitelist; no proxy"
  value_usd: 13
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-01-23
  txs_30d: 0
- address: "0xc434c6f25ed88f5365465bd6ff9bf04d1d944500"
  implementation: null
  name: PrivateDEX (unverified; bytecode matches verified PrivateDEX 0xa88bead2 except the linked library)
  upgradeable: "no"
  admin: "owner EOA 0x8a462a861e34939157c61d478e959dc18152fc2e (whitelist only); no proxy"
  value_usd: 4
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-01-22
  txs_30d: 0
- address: "0xa88bead2811b26b5d01c8dc8ba0db1b26516735a"
  implementation: null
  name: PrivateDEX
  upgradeable: "no"
  admin: "owner EOA 0x8a462a861e34939157c61d478e959dc18152fc2e (whitelist only); no proxy"
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-01-22
  txs_30d: null
families: []
fix:
  layer: new-deployment
  who_acts: "the deployer/owner 0x8a462a861e34939157c61d478e959dc18152fc2e: redeploy with a post-quantum ownership proof (hash-based commitments with a STARK, or post-quantum signatures); depositors withdraw from the old contracts"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/houdini-swap-bn254-schnorr/classification.jsonl
  - evidence/houdini-swap-bn254-schnorr/onchain.json
  - evidence/houdini-swap-bn254-schnorr/activity.json
  - evidence/houdini-swap-bn254-schnorr/source-excerpts.md
  - evidence/houdini-swap-bn254-schnorr/review-reads.json
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

PrivateDEX is an experimental confidential-deposit DEX: a deposit is an ElGamal-style pair of BN254 G1 points, and
withdrawals, transfers and swaps are authorised by Schnorr-style proofs of knowledge of the deposit's discrete log,
checked with `ecMul`/`ecAdd` (no SNARK, no trusted setup). A quantum attacker who solves the discrete log for a
deposit's public points can produce valid proofs and withdraw that deposit, and the contracts cannot be changed. The
three deployments were used only by their deployer, for a day in January 2026, and hold USD 18 together. Rated MEDIUM:
step 4 gives HIGH (users' funds forgeable in contracts that cannot change), step 5 lowers it one level (under USD 50k).

## Mechanism

- `WithdrawERC20(D, addrContract, addr, nTokens, p, expiration)` (PrivateDEX.sol lines 458-495) looks up the deposit
  by `D.A.X`, hashes the operation with `sha256`, and calls `CryptoCore.VerifyProof(D, p, messageHashed)`, then
  transfers `nTokens` to any `addr`.
- `CryptoCore.VerifyProof` (CryptoCore.sol lines 75-90) checks `R + e·D.B == z·D.A` on BN254 G1, a Schnorr proof that
  the prover knows `x` with `D.B = x·D.A`; `VerifyPoK` (lines 59-73) is the same with the generator;
  `VerifyProofPrivate` (lines 139-165) is an OR-composition over several deposits plus a nullifier point, used by the
  private-mode withdraw, transfer and aggregate functions.
- The `BN254.pairing` helper excerpted in the draft is library code not used on these paths; the draft's PQ-7 /
  trusted-setup classification was wrong. The nearest pattern is PQ-11 (Schnorr verified with curve arithmetic),
  here on BN254 with each depositor's key as the trigger.
- Source: [`source-excerpts.md`](../evidence/houdini-swap-bn254-schnorr/source-excerpts.md) and the full
  Sourcify files.

## Evidence

- CHECKED (verified source on Sourcify, `PrivateDEX.sol`, `CryptoCore.sol`, `BN254.sol`, read 2026-11-17): the lines
  above; `Ownable` functions only set the whitelist (`setRemovehitelist`, `AddContractToWhitelist`); no proxy.
- CHECKED (bytecode, `eth_getCode` 2026-11-17): `0xc434c6f2…` (unverified) has the same 16,408-byte code as the
  verified PrivateDEX `0xa88bead2…` except the PUSH20 address of the linked CryptoCore library and the metadata hash;
  `0x23c5e2e0…` links library `0x6c35a458…` from the same deployer
  ([`review-reads.json`](../evidence/houdini-swap-bn254-schnorr/review-reads.json)).
- CHECKED (`owner()` and Blockscout, 2026-11-17): all three are owned and were created by EOA `0x8a462a86…`; every
  transaction to them (8, 3 and 3) came from that EOA on 2026-01-22/23.
- CHECKED (on-chain read at block 26,431,214): `0x23c5e2e0…` holds $13 (USDC, WETH, USDT), `0xc434c6f2…` $4 (USDC)
  ([`onchain.json`](../evidence/houdini-swap-bn254-schnorr/onchain.json)); `0xa88bead2…` holds 0.000356 WETH
  (Blockscout).
- CHECKED (precompile trace): 4 and 2 bn254 calls in the year to March 2026 (`curated_contracts.csv`).
- INFERRED: Houdini Swap attribution, from the constant `h()` = "hash to point of the string \"HoudiniSwap2025\""
  (CryptoCore.sol line 95); the deployer EOA has no label.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x23c5e2e0…` PrivateDEX | no | $13 | 2026-01-23 | 0 |
| `0xc434c6f2…` PrivateDEX (unverified) | no | $4 | 2026-01-22 | 0 |
| `0xa88bead2…` PrivateDEX | no | $1 | 2026-01-22 | not measured |

The held tokens are the deposits a forged proof releases, so `held` is the exposure. `0xa88bead2…` (verified, same
deployer) was not in the census and was added by this review.

## Remediation

- Post-quantum replacement: hash-based note commitments with a STARK (or other post-quantum) proof of ownership, in a
  new deployment; these contracts cannot be changed.
- Who acts: the deployer `0x8a462a86…` (owner of all three) for any production version; depositors withdraw.
- Protocol change: not needed and would not help.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review20): MEDIUM kept, by steps 4-5: the check is a Schnorr-style discrete-log proof on BN254,
  not a SNARK (pattern PQ-7 -> PQ-11, trigger trusted-setup -> user-key); immutable contracts make it HIGH at step 4,
  and USD 18 held lowers it to MEDIUM. Project set to `houdini-swap` (inferred from the "HoudiniSwap2025" constant);
  unverified `0xc434c6f2…` matched to verified PrivateDEX bytecode, so status candidate -> confirmed; added the
  verified sibling `0xa88bead2…`.
- 2026-11-17 integration: id renamed from `unidentified-23c5e2e0-snark-verifier` (project identified).
