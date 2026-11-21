---
id: lighter-plonk-verifier
title: "Lighter: a quantum attacker with the BN254 PLONK setup trapdoor can prove a false zkLighter batch and withdraw from the $908M rollup"
project: lighter
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xac3ce44b6ff4e402858c99d5699ff63131572baa"
  implementation: "0x329d7d7f7b3f2879991b83e1a53bce6d7ce63e6f"
  name: Proxy → ZkLighterVerifier
  upgradeable: "yes"
  admin: "UpgradeGatekeeper 0x94da8a995d0d82ef0fe7e509c6d76c22603b6f67, master Safe 0x97a90ec950b6bcd9b190b566525b2bb92a2c03a2 (3 of 5), 3-week notice that security council Safe 0x92b12c9d85bf7bd2ef5d2f53f4cd4ce0be432045 (4 of 7) can cut; read at block 26,431,454"
  value_usd: 907780551
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 19443
- address: "0x975210588389526a3a1def1628e7a4d7abdfd121"
  implementation: null
  name: DesertVerifier (desert-mode exit proofs)
  upgradeable: "no"
  admin: "none on the contract (no proxy, no owner); ZkLighter 0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7 holds its address in storage slot 5, which changes only through a ZkLighter upgrade by UpgradeGatekeeper 0x94da8a995d0d82ef0fe7e509c6d76c22603b6f67 (master Safe 0x97a90ec950b6bcd9b190b566525b2bb92a2c03a2, 3 of 5); read at block 26,431,750"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: "Lighter, through UpgradeGatekeeper 0x94da8a995d0d82ef0fe7e509c6d76c22603b6f67 (master Safe 0x97a90ec950b6bcd9b190b566525b2bb92a2c03a2, 3 of 5)"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/lighter-plonk-verifier
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
  who: Review11 (Claude), finding review
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/lighter-plonk-verifier/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [contract-3b4d794a-blob-kzg-opening]
---

## Summary

zkLighter accepts a batch's new state root when `ZkLighterVerifier.Verify` accepts a gnark PLONK proof on BN254 (PQ-7).
With the setup trapdoor, a proof of a false state transition verifies, and the forged state can credit withdrawals of
whatever the rollup contract holds: $907.8M on 2026-11-17 in ZkLighter `0x3b4d794a…`. Batches are submitted by active
validators, so the attacker also needs a validator key (an ECDSA EOA, also recoverable). Rated MEDIUM (step 4): the
verifier sits behind an upgradeable proxy that Lighter's gatekeeper can point at a post-quantum verifier.

## Mechanism

- `ZkLighterVerifier.Verify(bytes proof, uint256[] public_inputs)` (implementation `0x329d7d7f…`, verified) is generated
  by gnark: it folds the PLONK openings and ends in `check_pairing_kzg`, a `staticcall` to the BN254 pairing precompile
  `0x08` (ZkLighterVerifier.sol lines 901–910, [`source-excerpts.md`](#source-excerpts-lighter-plonk-verifier)).
- ZkLighter `0x3b4d794a…` stores this verifier proxy in storage slot 4 and calls it from `verifyBatch`; after
  verification `executeBatches` applies the batch, including withdrawals.
- DesertVerifier `0x97521058…` (verified, not proxied, no owner; ZkLighter slot 5; created at block 26,320,128) is a
  second gnark PLONK verifier: `Verify(bytes proof, uint256[] public_inputs)` (DesertVerifier.sol line 188) ends in the
  same pairing call (line 904). [INFERENCE from the unverified ZkLighter selectors] ZkLighter uses it for desert-mode
  exits (`performDesert`, after `activateDesertMode`), paying a user's proven balance out of ZkLighter, so a forged exit
  proof could claim more than that balance once desert mode is active. It has never been called.

## Evidence

- CHECKED (verified source, Sourcify): `Verify` and the pairing call in ZkLighterVerifier.
- CHECKED (on-chain read, block 26,431,454): proxy target `0x329d7d7f…`, master UpgradeGatekeeper `0x94da8a99…`, whose
  master is Safe `0x97a90ec9…` (3 of 5); security council Safe `0x92b12c9d…` (4 of 7); notice period 3 weeks; ZkLighter
  slot 4 holds this proxy ([`notes.md`](#review-notes-lighter-plonk-verifier-2026-11-17)).
- CHECKED (on-chain read, block 26,431,214): ZkLighter holds $907.8M
  ([`lighter-blob-kzg/onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/lighter-blob-kzg/onchain.json)).
- CHECKED (Xatu, any function): 19,443 transactions reached the verifier proxy 2026-10-16 to 2026-11-16; last 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/lighter-plonk-verifier/activity.json)).
- CHECKED (verified source, Sourcify; on-chain read, block 26,431,750): DesertVerifier `Verify` and pairing call; no
  EIP-1967 slots, no `owner()`; ZkLighter slot 5 = `0x97521058…`. `trace_filter` blocks 23,803,750–26,431,750: no calls
  ([`desertverifier-trace.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/lighter-plonk-verifier/desertverifier-trace.json)).
- INFERRED: that only active validators can call `verifyBatch` (Governance `isActiveValidator` is referenced in the
  unverified ZkLighter bytecode).

## Impact and exposure

| Contract | Upgradeable | Escrow secured | Last active | 30-day txs |
|---|---|---|---|---|
| `0xac3ce44b…` Proxy → ZkLighterVerifier | yes (gatekeeper, 3-week notice) | $907.8M in ZkLighter `0x3b4d794a…` | 2026-11-16 | 19,443 |
| `0x97521058…` DesertVerifier | no (replaced by a ZkLighter upgrade) | same ZkLighter balance (not added again) | never called | 0 |

The verifiers hold nothing; the value is the rollup contract's balance (escrow basis, 2026-11-17), counted once on the
verifier proxy. Yearly pre-quantum count from the census: 146,040 transactions (`txs_y1`); DesertVerifier is not in the
census (never called, created after the trace). The blob opening in ZkLighter is `lighter-blob-kzg`.

## Remediation

- Replace the gnark PLONK wrapper with a hash-based (STARK/FRI or WHIR) verifier and upgrade the verifier proxy
  `0xac3ce44b…` through UpgradeGatekeeper `0x94da8a99…` (master Safe `0x97a90ec9…`, 3 of 5; 3-week notice unless the
  security council Safe `0x92b12c9d…` cuts it). DesertVerifier needs the same replacement through a ZkLighter upgrade.
- No protocol change is needed. Users can only reduce exposure by withdrawing.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review11): MEDIUM unchanged (step 4: gatekeeper upgrade). Escrow measured: ZkLighter 0x3b4d794a… $907.8M. Admin traced from the gatekeeper to the 3-of-5 master Safe and 4-of-7 security council; DesertVerifier 0x97521058… found as an uncensused sibling.
- 2026-11-17 follow-up (Review11): added DesertVerifier `0x97521058…` to contracts (immutable, never called; reachable only in desert mode; replaced through a ZkLighter upgrade by the same gatekeeper). MEDIUM unchanged (step 4).

# Source excerpts: lighter-plonk-verifier

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xac3ce44b6ff4e402858c99d5699ff63131572baa` — Proxy (verified source via sourcify)

## Implementation `0x329d7d7f7b3f2879991b83e1a53bce6d7ce63e6f` — ZkLighterVerifier (verified source via sourcify)

### `contracts/ZkLighterVerifier.sol`

```solidity
  288          mstore(add(ptError, 0x44), "openings bigger than r")
  289          revert(ptError, 0x64)
  290        }
  291  
  292        function error_pairing() {
  293          let ptError := mload(0x40)
  294          mstore(ptError, ERROR_STRING_ID) // selector for function Error(string)
  295          mstore(add(ptError, 0x4), 0x20)
  296          mstore(add(ptError, 0x24), 0xd)
  297          mstore(add(ptError, 0x44), "error pairing")
  298          revert(ptError, 0x64)
  299        }
  300  
  301        function error_verify() {
  ...
  890          mstore(add(mPtr, 0x100), G2_SRS_1_X_0)
  891          mstore(add(mPtr, 0x120), G2_SRS_1_X_1)
  892          mstore(add(mPtr, 0x140), G2_SRS_1_Y_0)
  893          mstore(add(mPtr, 0x160), G2_SRS_1_Y_1)
  894          check_pairing_kzg(mPtr)
  895        }
  896  
  897        /// @notice check_pairing_kzg checks the result of the final pairing product of the batched
  898        /// kzg verification. The purpose of this function is to avoid exhausting the stack
  899        /// in the function batch_verify_multi_points.
  900        /// @param mPtr pointer storing the tuple of pairs
  901        function check_pairing_kzg(mPtr) {
  902          let state := mload(0x40)
  903  
  904          let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  905          if iszero(l_success) {
  906            error_pairing()
  907          }
  908          let res_pairing := mload(0x00)
  909          mstore(add(state, STATE_SUCCESS), res_pairing)
  910        }
  911  
  912        /// @notice Fold the opening proofs at ζ:
  913        /// * at state+state_folded_digest we store: [Linearised_polynomial]+γ[L] + γ²[R] + γ³[O] + γ⁴[S₁] +γ⁵[S₂] + ∑ᵢγ⁵⁺ⁱ[Pi_{i}]
  ...
```

# Review notes: lighter-plonk-verifier (2026-11-17)

Reads with `cast` against https://ethereum-rpc.publicnode.com at block 26,431,454.

- Verifier proxy `0xac3ce44b6ff4e402858c99d5699ff63131572baa`: `getTarget()` = `0x329d7d7f7b3f2879991b83e1a53bce6d7ce63e6f`
  (ZkLighterVerifier, verified on Sourcify; creator `0x06ed0b0bd3a9e0c517b6cd7c8b851cc1e8e1a90a`, one of the security
  council owners); `getMaster()` = UpgradeGatekeeper `0x94da8a995d0d82ef0fe7e509c6d76c22603b6f67`.
- `ZkLighterVerifier.Verify(bytes proof, uint256[] public_inputs)` is a gnark PLONK verifier on BN254: the final KZG
  pairing check is `check_pairing_kzg`, `staticcall(gas(), 8, …)` (ZkLighterVerifier.sol lines 901–910); `initialize` and
  `upgrade` are empty.
- Consumer: ZkLighter proxy `0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7` storage slot 4 =
  `0x000…ac3ce44b6ff4e402858c99d5699ff63131572baa`; slot 5 = DesertVerifier `0x975210588389526a3a1def1628e7a4d7abdfd121`.
- DesertVerifier `0x97521058…` (verified on Sourcify, not proxied): another gnark PLONK verifier (26 `staticcall`s,
  including `staticcall(gas(), 8, …)`), used for desert-mode exits. Not in the census (no calls in the trace).
- UpgradeGatekeeper: master Safe `0x97a90ec950b6bcd9b190b566525b2bb92a2c03a2` (3 of 5); security council Safe
  `0x92b12c9d85bf7bd2ef5d2f53f4cd4ce0be432045` (4 of 7) can cut the 3-week (1,814,400 s) notice; `managedContracts` =
  Governance `0xa464da0b…`, this verifier proxy, ZkLighter `0x3b4d794a…`. Details: `evidence/lighter-blob-kzg/notes.md`.
- Escrow: ZkLighter `0x3b4d794a…` held $907,780,551 at block 26,431,214 (11,171.69 ETH; USDC $471.2M, LIT $411.4M,
  XAUT $4.1M, …), from `evidence/lighter-blob-kzg/onchain.json`.

## Follow-up: DesertVerifier `0x975210588389526a3a1def1628e7a4d7abdfd121` (block 26,431,750)

- Verified on Sourcify (`contracts/DesertVerifier.sol`): `Verify(bytes proof, uint256[] public_inputs)` at line 188,
  gnark PLONK, pairing `staticcall(gas(), 8, …)` at line 904; `initialize`/`upgrade` empty.
- EIP-1967 implementation and admin slots are zero; `owner()` reverts; `getTarget()`/`getMaster()` revert (not a proxy).
- Created at block 26,320,128 by `0x06ed0b0bd3a9e0c517b6cd7c8b851cc1e8e1a90a` (a security council owner).
- ZkLighter `0x3b4d794a…` storage slot 5 = `0x…975210588389526a3a1def1628e7a4d7abdfd121`.
- `trace_filter` blocks 23,803,750–26,431,750 (`desertverifier-trace.json`): no calls.
