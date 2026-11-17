---
id: intmax-snark-verifiers
title: "INTMAX: forged BN254 proofs claim the 162M undistributed ITX in MinterV1V3 and mint zERC20 through its teleport verifiers (USD 18.7k redeemable); both consumers can repoint their verifiers"
project: intmax
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x2ae060a830f2f6c7c1cc7d87ea7de4a8bfc707cd"
  implementation: null
  name: ClaimPlonkVerifierV2
  upgradeable: config-only
  admin: "none on the verifier; consumer MinterV1V3 0x38de07d2526ae929f1903e5f109b70c50e12a8e0 can setVerifier (DEFAULT_ADMIN_ROLE: Safe 0xcca94a453f4f69a6dfdc83ad8d8dc94fe9b75cc2, 2 of 2; read at block 26431757)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-05-11
  txs_30d: 0
- address: "0x1a44abb18c35e0104dc60b794b35c2c08e6ff773"
  implementation: null
  name: RootNovaDecider
  upgradeable: config-only
  admin: "none on the decider; consumers zERC20 Verifier proxies 0xfb786b5e6520284aa6a8dfa3b4f7a09ed423e25f and 0xdcc76debb526eef0210bd38729b803591951ab34 can setVerifiers and upgrade (owner Safe 0xb6d8b261948b097069ef926475cbb6dd698dafca, 3 of 4; read at block 26431757)"
  value_usd: 18651
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-04
  txs_30d: 5
- address: "0xf0ddf24143bf71b1f2221a58b4979ada1f07c874"
  implementation: null
  name: WithdrawGlobalGroth16Verifier
  upgradeable: config-only
  admin: "none on the verifier; singleWithdrawGlobalVerifier of zERC20 Verifier proxies 0xfb786b5e6520284aa6a8dfa3b4f7a09ed423e25f and 0xdcc76debb526eef0210bd38729b803591951ab34, which can setVerifiers (owner Safe 0xb6d8b261948b097069ef926475cbb6dd698dafca, 3 of 4; read at block 26431757)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-10-28
  txs_30d: 2
- address: "0x304141bb56d9a6b24d7b6dc5c571c3069dfa1c8f"
  implementation: null
  name: WithdrawLocalGroth16Verifier
  upgradeable: config-only
  admin: "none on the verifier; singleWithdrawLocalVerifier of the same two zERC20 Verifier proxies (owner Safe 0xb6d8b261948b097069ef926475cbb6dd698dafca; read at block 26431757)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: "INTMAX: Safe 0xcca94a453f4f69a6dfdc83ad8d8dc94fe9b75cc2 calls MinterV1V3.setVerifier; Safe 0xb6d8b261948b097069ef926475cbb6dd698dafca calls setVerifiers on both zERC20 Verifier proxies; both need a post-quantum verifier and circuits built first"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/intmax-snark-verifiers/classification.jsonl
  - evidence/intmax-snark-verifiers/onchain.json
  - evidence/intmax-snark-verifiers/activity.json
  - evidence/intmax-snark-verifiers/source-excerpts.md
  - evidence/intmax-snark-verifiers/consumers.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: review (Review01)
  ref: evidence/intmax-snark-verifiers/consumers.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Four INTMAX verifiers check pairing-based proofs on BN254 (PQ-7). `ClaimPlonkVerifierV2` gates
`MinterV1V3.claimTokens`, which pays out ITX: with the setup trapdoor anyone can prove a claim and take the 162M ITX
the minter still holds (ITX has no market price, so the value is not measured). For the zERC20 privacy tokens (zUSDC,
zETH), the two Groth16 teleport verifiers let anyone prove a withdrawal and mint zERC20, and `RootNovaDecider` lets an
allowed prover post a false transfer root; the zERC20 that can be redeemed is backed by USD 18.7k in the mainnet
liquidity managers. Both consumers store the verifier addresses and their admins can point them at post-quantum
verifiers. Rated MEDIUM (step 4: a new verifier the consumer points at; the ITX value is unmeasured, so step 5 does
not lower it).

## Mechanism

- `MinterV1V3.claimTokens(isShortTerm, claims, publicInputs, proof)` (implementation `0x9e985699…`) checks the
  eligible-tree root against storage, that `depositTreeRoot` is known to `int1` (`0x0ac498bc…`), and the hash chain
  of the listed claims, then calls `verifier.Verify(proof, publicInputsHash.split())` and, per claim, marks the
  nullifier and `token.transfer(claim.recipient, claim.amount)`. Recipients and amounts are only bound by the proof.
- `ClaimPlonkVerifierV2.Verify` (line 178) is a gnark PLONK verifier; its KZG batch opening ends in
  `check_pairing_kzg` → `staticcall(gas(), 8, …)` (line 886). The trapdoor of the PLONK SRS makes any statement verify.
- zERC20 `Verifier.proveTransferRoot(proof)` (`onlyAllowedProver`, `src/Verifier.sol` line 418) calls
  `IRootDecider(rootDecider).verifyOpaqueNovaProof` on `RootNovaDecider` (Sonobe Nova decider: Groth16 plus KZG on
  BN254, pairing at line 101) and stores the new transfer root. Only an allowed prover can submit a root, so the
  attacker must be or control one.
- zERC20 `Verifier.singleTeleport(isGlobal, rootHint, gr, proof)` (public) → `_verifySingleProof` (line 559) calls
  `IWithdrawVerifier(isGlobal ? singleWithdrawGlobalVerifier : singleWithdrawLocalVerifier).verifyProof(pA, pB, pC,
  pubSignals)` (line 568) on `WithdrawGlobalGroth16Verifier` or `WithdrawLocalGroth16Verifier` (snarkJS Groth16,
  pairing `staticcall(sub(gas(), 2000), 8, …)` at line 159). The public signals are the transfer root, recipient and
  cumulative value; `_teleport` checks the root is stored and mints the increase with `IzERC20(token).teleport`. With
  the trapdoor anyone can prove any value against an existing root, then redeem the zERC20 at the `LiquidityManager`s
  for USDC or ETH. The Nova `teleport` path is disabled (`withdrawGlobalDecider()` and `withdrawLocalDecider()` are
  `0x…01`).
- Both consumers keep the verifier in storage: `MinterV1V3.setVerifier` (`DEFAULT_ADMIN_ROLE`) and zERC20
  `Verifier.setVerifiers` (`onlyOwner`, rotates all deciders).

## Evidence

- CHECKED (verified source): `ClaimPlonkVerifierV2` and `RootNovaDecider` (Sourcify), `MinterV1V3` (Sourcify),
  zERC20 `Verifier` implementation `0x6b4aafeb…` (Blockscout).
- CHECKED (Xatu call frames, then transaction `to`): the last calls reaching the verifiers came through
  `MinterV1V3.claimTokens` (`0x38de07d2…`, block 25,069,553) and `proveTransferRoot` on the zERC20 Verifier proxies
  `0xfb786b5e…` and `0xdcc76deb…` (blocks 26,340,240 and 26,291,544).
- CHECKED (block 26,431,757, [`consumers.json`](../evidence/intmax-snark-verifiers/consumers.json)): `verifier()` of
  the minter = `0x2ae060a8…`; `token()` = ITX `0xe24e207c…`, balance 162,063,166 ITX of 767,507,813 supply;
  `DEFAULT_ADMIN_ROLE` held by Safe `0xcca94a45…` (2 of 2, from `RoleGranted` logs and `hasRole`).
- CHECKED (block 26,431,757): both zERC20 proxies have `rootDecider()` = `0x1a44abb1…`, implementation `0x6b4aafeb…`,
  `owner()` Safe `0xb6d8b261…` (3 of 4), not paused; their tokens zUSDC (14,583 supply) and zETH (120.3 supply) are
  minted for redemption at LiquidityManagers `0x04be137d…` (7,316 USDC) and `0xcc10b709…` (6.26 ETH).
- CHECKED: ITX has no price on Blockscout, DefiLlama or CoinGecko.
- INFERRED: attribution. The ITX minter is INTMAX's (token name, `Int1` deposit roots); zERC20 is attributed to the
  INTMAX team in `findings_map.csv`, and an owner of the minter's Safe (`0xe3c72c10…`) is also a top zUSDC holder.
- CHECKED (verified source, Sourcify and Blockscout; block 26,431,757): `WithdrawGlobalGroth16Verifier` and
  `WithdrawLocalGroth16Verifier`, 1,551-byte snarkJS Groth16 verifiers with three public signals, no proxy, no owner,
  no ETH; both zERC20 proxies return them as `singleWithdrawGlobalVerifier()` and `singleWithdrawLocalVerifier()`.
- CHECKED (precompile corpus): `0xf0ddf241…` made 57 pairing calls in blocks 24,374,384–24,668,218; `0x304141bb…`
  none. CHECKED (Blockscout transactions to the proxies): 135 `singleTeleport` calls in total; the two in 2026-10-16 to
  2026-11-16 (blocks 26,266,430 and 26,291,518 on `0xdcc76deb…`) and the last on `0xfb786b5e…` (block 25,528,238)
  pass `isGlobal = true`. No use of the local verifier was identified.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x2ae060a8…` ClaimPlonkVerifierV2 | config-only (consumer repoints) | 162M ITX, unpriced | 2026-05-11 | 0 |
| `0x1a44abb1…` RootNovaDecider | config-only (consumer repoints) | USD 18.7k (escrow: LiquidityManagers) | 2026-11-04 | 5 |
| `0xf0ddf241…` WithdrawGlobalGroth16Verifier | config-only (consumer repoints) | same escrow | 2026-10-28 | 2 |
| `0x304141bb…` WithdrawLocalGroth16Verifier | config-only (consumer repoints) | same escrow | — | 0 |

- Minter `0x38de07d2526ae929f1903e5f109b70c50e12a8e0` holds the undistributed ITX; no claim since block 25,069,553
  (2026-05), but the path is open.
- zERC20 escrow: `0x04be137df79be7b5f3314c4a84d1c5e0d99bd477` (7,316 USDC) and
  `0xcc10b7098fef1ab2f0ff3be91d2a7b3230b90cf0` (6.26 ETH), USD 18,651 at block 26,431,757. Tokens bridged to other
  chains are not counted.

## Remediation

- Replacement: hash-based (STARK/FRI or WHIR) verifiers for the ITX claim circuit and for zERC20's root and teleport
  circuits; then the admins repoint the consumers. No upgrade of the consumers is needed.
- Who acts: INTMAX. Safe `0xcca94a453f4f69a6dfdc83ad8d8dc94fe9b75cc2` (`MinterV1V3.setVerifier`, or `migrate` to move the
  ITX out); Safe `0xb6d8b261948b097069ef926475cbb6dd698dafca` (`setVerifiers` on `0xfb786b5e…` and `0xdcc76deb…`).
- No protocol change is needed. zERC20 holders can redeem to USDC/ETH; ITX claimants can claim before the switch.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review01): MEDIUM kept, step 4: consumers identified (MinterV1V3, two zERC20 Verifier proxies) and both can repoint their verifiers; ITX exposure unpriced so step 5 does not lower; status candidate -> confirmed, evidence level bytecode -> source-read (both verifiers verified on Sourcify).
- 2026-11-17 review (Review01): added the zERC20 single-teleport Groth16 verifiers `0xf0ddf241…` and `0x304141bb…` on Main's instruction (singleWithdraw verifiers of both zERC20 proxies, reachable by anyone through `singleTeleport`); same escrow, MEDIUM unchanged.
