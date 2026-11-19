---
id: worm-proof-of-burn-groth16
title: "WORM (EIP-7503): a quantum attacker who recovers the Groth16 setup trapdoor can mint unlimited BETH through BETH.mintCoin and sell it into BETH's pools (about USD 4.8k of WETH)"
project: worm
status: confirmed
severity: CRITICAL
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x7c155d52b78799d4975417a3815cde8c5aec434f"
  implementation: null
  name: ProofOfBurnVerifier
  upgradeable: "no"
  admin: none; immutable verifier, and BETH 0x5624344235607940d4d4ee76bf8817d403eb9cf8 stores it as an immutable (no proxy, no owner), read at block 26431456
  value_usd: 4791
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-12
  txs_30d: 26
- address: "0x5745a35b9c5938b2307f0287f45df5743a9d02e6"
  implementation: null
  name: SpendVerifier
  upgradeable: "no"
  admin: none; immutable `spendVerifier` of BETH 0x5624344235607940d4d4ee76bf8817d403eb9cf8, read at block 26431456
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
families: []
fix:
  layer: new-deployment
  who_acts: WORM team (deployer 0x8dc77b145d7009752d6947b3cf6d983cafa1c0bb); BETH has no admin, so a new BETH with hash-based proofs that holders and pools move to
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/worm-proof-of-burn-groth16
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

WORM implements EIP-7503 proof-of-burn: BETH (`0x56243442…9cf8`) mints "Burned ETH" when `mintCoin` presents a
Groth16 proof, checked by `ProofOfBurnVerifier` (`0x7c155d52…434f`) with the BN254 pairing precompile, that ETH was
sent to an unspendable address (PQ-7). A quantum attacker who recovers the setup trapdoor can prove burns that never
happened and mint up to 10 BETH per proof with fresh nullifiers, without limit, then sell it for the WETH paired with
BETH (USD 4,791 in the BETH/WETH Algebra pool at 2026-11-17) and take the WORM emissions that BETH participation earns.
Both verifiers are immutable and BETH has no admin, so the only fix is a new deployment. Rated HIGH: CRITICAL by step 4
(pooled value released by a forged proof, verification cannot change), lowered one level by step 5 (under USD 50k
measured).

## Mechanism

- `BETH.mintCoin(MintParams)` (`src/BETH.sol` 163–243): checks the nullifier is unused, `revealedAmount <= MINT_CAP`
  (10 ether), builds a commitment from the block hash, nullifier, remaining coin, amounts and fees, and requires
  `proofOfBurnVerifier.verifyProof(pA, pB, pC, [commitment])` (line 222); it then mints the revealed amount to the
  receiver, prover and broadcaster and 0.5% to the reward pool.
- `ProofOfBurnVerifier.verifyProof` (snarkjs Groth16, `src/ProofOfBurnVerifier.sol` 62–170): one public signal,
  `checkPairing` against the hard-coded verifying key with `staticcall(…, 8, …)` (line 153); the setup's trapdoor
  makes any statement verify.
- `BETH.spendCoin` (lines 266–300) mints from a previously minted coin after `spendVerifier.verifyProof`
  (`SpendVerifier`, `0x5745a35b…02e6`, same snarkjs template with the pairing at line 154); same pattern.
- Both verifiers are `immutable` in BETH (lines 19–20, set in the constructor); BETH is not a proxy and has no
  owner (the only privileged variable, `initializer`, is now zero).
- Pattern PQ-7. Excerpts: [`source-excerpts.md`](#source-excerpts-worm-proof-of-burn-groth16).

## Evidence

- CHECKED (verified source, Sourcify): `ProofOfBurnVerifier`, `SpendVerifier` and `BETH` (`src/BETH.sol`), lines
  above.
- CHECKED (on-chain read at block 26,431,456): BETH `proofOfBurnVerifier()` = `0x7c155d52…`, `spendVerifier()` =
  `0x5745a35b…`, `rewardPool()` = Staking `0x03d4702b…60b7`, `initializer()` = zero, `totalSupply()` = 80.74 BETH;
  EIP-1967 implementation and admin slots of BETH and WORM empty at block 26,431,584, and Sourcify resolves BETH as
  not a proxy ([`consumer.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/worm-proof-of-burn-groth16/consumer.json)).
- CHECKED (block 26,431,456): BETH/WETH Algebra pool `0x17f72aff…6452` holds 2.839 BETH and 2.645 WETH; WETH/WORM
  Algebra pool `0x2dba10df…2ec3` holds 41.94 WETH; at block 26,431,579 the Uniswap v4 PoolManager holds 0.992 BETH
  across all BETH v4 pools.
- CHECKED (Blockscout): both verifiers were created by `0x8dc77b14…c0bb`, which also interacts with BETH and WORM;
  the last 50 BETH transactions are 43 `mintCoin` and 7 `approve`.
- CHECKED (precompile trace to March 2026): 609 BN254 calls by `ProofOfBurnVerifier` (blocks 24,439,495–24,683,129);
  none by `SpendVerifier` (no `spendCoin` proof verified in that window). 203 pre-quantum transactions in the last
  year (`txs_y1`).
- CHECKED (Xatu, any function): 26 transactions 2026-10-16 to 2026-11-16 reached the verifier, last 2026-11-12
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/worm-proof-of-burn-groth16/activity.json)).
- INFERRED: the v4 BETH pools' paired side is of the order of their 0.99 BETH (about 1 ETH), so it does not change the
  step 5 outcome; not measured per pool.

## Impact and exposure

| Contract | Upgradeable | Escrow (WETH paired with BETH) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x7c155d52…` ProofOfBurnVerifier | no | USD 4,791 (2026-11-17) | 2026-11-12 | 26 |
| `0x5745a35b…` SpendVerifier | no | (same BETH) | — | — |

- Escrow: forged BETH is worth what it can be sold for. The BETH/WETH Algebra pool `0x17f72aff…` holds 2.645 WETH
  (USD 4,791 at USD 1,811.62/ETH); the v4 pools hold 0.99 BETH against an unmeasured paired side.
- WORM emissions: `WORM` (`0xfc9d98cd…5b29`) mints each 10-minute epoch's reward (44.05 WORM now, about USD 1 at
  Blockscout's USD 0.024) pro rata to BETH participation, so unlimited forged BETH captures almost all future
  emissions, diluting honest participants; this is slow (about USD 150 a day) and bounded by the 41.94 WETH in the
  WORM/WETH pool, so it is not counted as escrow.
- BETH holders (80.74 BETH supply, mostly held by the WORM contract and staking) are diluted; BETH has no market
  price on Blockscout, so no market cap is given.
- The verifier contracts hold nothing.

## Remediation

- Post-quantum replacement: a proof-of-burn and spend circuit proved with a hash-based system (STARK/FRI or WHIR) and
  a new BETH (and a new WORM, which stores BETH as `immutable bethContract`) that verifies it.
- Who must act: the WORM team (deployer `0x8dc77b14…c0bb`). BETH's verifiers are immutable and it has no admin, so
  holders, liquidity providers and the WORM token must move to the new deployment; no protocol change needed.
- Users: liquidity providers in BETH pools carry the loss; withdrawing liquidity before a CRQC exists removes it.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated CRITICAL (step 4: pooled funds released by a forged proof or attestation, and the verification cannot change).
- 2026-11-17 review (Review05): CRITICAL -> HIGH, step 5: the consumer is BETH `0x56243442…` (immutable verifiers, no
  admin, so CRITICAL by step 4), but the value a forged mint can release is the WETH paired with BETH, USD 4,791
  measured. Added BETH's `SpendVerifier` `0x5745a35b…` (same mechanism, not in the precompile trace); escrow set on the
  main entry.
- 2026-11-19: HIGH -> CRITICAL, step 5 removed (value no longer lowers a rating); step 4 gives CRITICAL.

# Source excerpts: worm-proof-of-burn-groth16

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x7c155d52b78799d4975417a3815cde8c5aec434f` — ProofOfBurnVerifier (verified source via sourcify)

### `src/ProofOfBurnVerifier.sol`

```solidity
   54      uint256 constant IC1y = 4337927348627762737716573764479116035835752494896815665271950728388327337221;
   55  
   56      // Memory data
   57      uint16 constant pVk = 0;
   58      uint16 constant pPairing = 128;
   59  
   60      uint16 constant pLastMem = 896;
   61  
   62      function verifyProof(
   63          uint256[2] calldata _pA,
   64          uint256[2][2] calldata _pB,
   65          uint256[2] calldata _pC,
   66          uint256[1] calldata _pubSignals
  ...
   98                      return(0, 0x20)
   99                  }
  100              }
  101  
  102              function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
  103                  let _pPairing := add(pMem, pPairing)
  104                  let _pVk := add(pMem, pVk)
  105  
  106                  mstore(_pVk, IC0x)
  107                  mstore(add(_pVk, 32), IC0y)
  ...
  110  
  111                  g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))
  112  
  113                  // -A
  114                  mstore(_pPairing, calldataload(pA))
  115                  mstore(add(_pPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))
  116  
  117                  // B
  118                  mstore(add(_pPairing, 64), calldataload(pB))
  119                  mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
  120                  mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
  121                  mstore(add(_pPairing, 160), calldataload(add(pB, 96)))
  122  
  123                  // alpha1
  124                  mstore(add(_pPairing, 192), alphax)
  125                  mstore(add(_pPairing, 224), alphay)
  126  
  127                  // beta2
  128                  mstore(add(_pPairing, 256), betax1)
  129                  mstore(add(_pPairing, 288), betax2)
  130                  mstore(add(_pPairing, 320), betay1)
  131                  mstore(add(_pPairing, 352), betay2)
  132  
  133                  // vk_x
  134                  mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
  135                  mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))
  136  
  137                  // gamma2
  138                  mstore(add(_pPairing, 448), gammax1)
  139                  mstore(add(_pPairing, 480), gammax2)
  140                  mstore(add(_pPairing, 512), gammay1)
  141                  mstore(add(_pPairing, 544), gammay2)
  142  
  143                  // C
  144                  mstore(add(_pPairing, 576), calldataload(pC))
  145                  mstore(add(_pPairing, 608), calldataload(add(pC, 32)))
  146  
  147                  // delta2
  148                  mstore(add(_pPairing, 640), deltax1)
  149                  mstore(add(_pPairing, 672), deltax2)
  150                  mstore(add(_pPairing, 704), deltay1)
  151                  mstore(add(_pPairing, 736), deltay2)
  152  
  153                  let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  154  
  155                  isOk := and(success, mload(_pPairing))
  156              }
  157  
  158              let pMem := mload(0x40)
  159              mstore(0x40, add(pMem, pLastMem))
  ...
  162  
  163              checkField(calldataload(add(_pubSignals, 0)))
  164  
  165              // Validate all evaluations
  166              let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)
  167  
  168              mstore(0, isValid)
  169              return(0, 0x20)
  170          }
  ...
```

### `src/interfaces/IVerifier.sol`

```solidity
    1  // SPDX-License-Identifier: UNLICENSED
    2  pragma solidity ^0.8.13;
    3  
    4  interface IVerifier {
    5      function verifyProof(
    6          uint256[2] calldata _pA,
    7          uint256[2][2] calldata _pB,
    8          uint256[2] calldata _pC,
    9          uint256[1] calldata _pubSignals
  ...
```
