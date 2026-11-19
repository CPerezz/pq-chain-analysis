---
id: zktrueup-groth16-verifier
title: "Term Structure zkTrue-up: rollup blocks are proven with Groth16 on BN254; a recovered setup trapdoor would let a forged state release the rollup's $1.7k, but the rollup has been idle since 2025-08-04"
project: term-structure
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x23369a60e5a8f422e38d799ed55e7ad8ed4a86ce"
  implementation: null
  name: Verifier (snarkJS Groth16)
  upgradeable: "no"
  admin: none; consumer ZkTrueUp diamond 0x09e01425780094a9754b2bd8a3298f73ce837cf9 can set a new verifier (admin Safe 0xa00d50a40b1635d293c87ba36503bd2504b5d818, 4 of 6)
  value_usd: 1749
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2025-08-04
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: Term Structure, through Safe 0xa00d50a40b1635d293c87ba36503bd2504b5d818 (4 of 6), admin and owner of the ZkTrueUp diamond 0x09e01425780094a9754b2bd8a3298f73ce837cf9
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zktrueup-groth16-verifier
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
  who: Review10 (source and on-chain review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zktrueup-groth16-verifier/review.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

`Verifier` is the snarkJS Groth16 verifier that Term Structure's zkTrue-up rollup diamond uses to accept block proofs (PQ-7). With the trusted-setup trapdoor, a quantum attacker could prove a false state and withdraw what the rollup holds, but block submission is limited to the rollup's committer role, so the attacker also needs that key. The rollup has not committed a block since 2025-08-04 and holds $1,749 (2026-11-17). Rated LOW (step 1): no activity in the last 12 months and almost nothing held; step 5 gives the same.

## Mechanism

- `Verifier.verifyProof(pA, pB, pC, pubSignals)` (snarkJS template, `contracts/zkTrueUp/verifier/Verifier.sol`): field checks, then `checkPairing` with the ecmul, ecadd and ecpairing precompiles against the embedded verification key.
- The ZkTrueUp diamond's `verifyBlocks` (committer/verifier role `0x0a4ab40c…`) calls the verifier from `getVerifier()`; executed blocks then allow withdrawals of the proven balances.

Source excerpts: [`source-excerpts.md`](#source-excerpts-zktrueup-groth16-verifier).

## Evidence

- CHECKED (verified source, Sourcify `Verifier.sol`): standalone, no owner, no storage.
- CHECKED (on-chain, 2026-11-17): diamond `getVerifier()` = `0x23369a60…`, `isEvacuMode()` false, `owner()` Safe `0xa00d50a4…` (threshold 4 of 6); diamond holds no ETH and $1,749 of tokens (WETH $1,025, USDT $600, USDC $77, DAI $30, WBTC $17, Blockscout) ([`review.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zktrueup-groth16-verifier/review.json)).
- CHECKED (Blockscout): the diamond's last transactions are `commitBlocks`/`verifyBlocks`/`executeBlocks` by `0x0a4ab40c…` on 2025-08-04.
- CHECKED (external, L2BEAT Term Structure page): archived; the admin multisig `0xa00d50a4…` can update the main and the evacuation verifier and upgrade the diamond without delay.
- CHECKED (precompile trace, last year): 151 transactions with ecpairing (`txs_y1`, window ending March 2026); Xatu: none 2026-10-16 to 2026-11-16 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zktrueup-groth16-verifier/activity.json)).
- NOT READ: the evacuation verifier's address (`getEvacuator()` reverted); it is not in the census.

## Impact and exposure

| Contract | Upgradeable | Escrow | Last active | 30-day txs |
|---|---|---|---|---|
| `0x23369a60…` Verifier | no | $1,749 (ZkTrueUp diamond) | 2025-08-04 | 0 |

- Escrow: ZkTrueUp diamond `0x09e01425…`, $1,749 on 2026-11-17.

## Remediation

- If the rollup resumes, Term Structure's Safe `0xa00d50a4…` points the diamond at a hash-based (STARK/FRI) verifier, and replaces the evacuation verifier too.
- The Safe's owners are ECDSA keys (PQ-12).
- No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1 reach: no activity in 12 months (last 2025-08-04) and nothing held).
- 2026-11-17 review (Review10): LOW confirmed, step 1. Escrow measured ($1,749 in the ZkTrueUp diamond) and the verifier's admin path read on-chain (diamond `getVerifier()`, Safe 4 of 6).
- 2026-11-19: LOW -> MEDIUM, step 1 removed (dormancy no longer lowers a rating); step 4 gives MEDIUM: a new verifier the consumer points at.

# Source excerpts: zktrueup-groth16-verifier

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x23369a60e5a8f422e38d799ed55e7ad8ed4a86ce` — Verifier (verified source via sourcify)

### `contracts/zkTrueUp/verifier/Verifier.sol`

```solidity
   54      uint256 constant IC1y = 6051578839656213355879425753462103734045683363771683564736102484145689240202;
   55  
   56      // Memory data
   57      uint16 constant pVk = 0;
   58      uint16 constant pPairing = 128;
   59  
   60      uint16 constant pLastMem = 896;
   61  
   62      function verifyProof(
   63          uint[2] calldata _pA,
   64          uint[2][2] calldata _pB,
   65          uint[2] calldata _pC,
   66          uint[1] calldata _pubSignals
  ...
   99                      return(0, 0x20)
  100                  }
  101              }
  102  
  103              function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
  104                  let _pPairing := add(pMem, pPairing)
  105                  let _pVk := add(pMem, pVk)
  106  
  107                  // _pVk = {IC0x, IC0y}
  108                  mstore(_pVk, IC0x)
  ...
  112                  // _pVk += {IC1x, IC1y} * pubSignals[0]
  113                  g1_mulAccC(_pVk, IC1x, IC1y, calldataload(pubSignals))
  114  
  115                  // -A
  116                  mstore(_pPairing, calldataload(pA))
  117                  mstore(add(_pPairing, 32), mod(sub(q, mod(calldataload(add(pA, 32)), q)), q))
  118  
  119                  // B
  120                  mstore(add(_pPairing, 64), calldataload(pB))
  121                  mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
  122                  mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
  123                  mstore(add(_pPairing, 160), calldataload(add(pB, 96)))
  124  
  125                  // alpha1
  126                  mstore(add(_pPairing, 192), alphax)
  127                  mstore(add(_pPairing, 224), alphay)
  128  
  129                  // beta2
  130                  mstore(add(_pPairing, 256), betax1)
  131                  mstore(add(_pPairing, 288), betax2)
  132                  mstore(add(_pPairing, 320), betay1)
  133                  mstore(add(_pPairing, 352), betay2)
  134  
  135                  // vk_x
  136                  mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
  137                  mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))
  138  
  139                  // gamma2
  140                  mstore(add(_pPairing, 448), gammax1)
  141                  mstore(add(_pPairing, 480), gammax2)
  142                  mstore(add(_pPairing, 512), gammay1)
  143                  mstore(add(_pPairing, 544), gammay2)
  144  
  145                  // C
  146                  mstore(add(_pPairing, 576), calldataload(pC))
  147                  mstore(add(_pPairing, 608), calldataload(add(pC, 32)))
  148  
  149                  // delta2
  150                  mstore(add(_pPairing, 640), deltax1)
  151                  mstore(add(_pPairing, 672), deltax2)
  152                  mstore(add(_pPairing, 704), deltay1)
  153                  mstore(add(_pPairing, 736), deltay2)
  154  
  155                  let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  156  
  157                  isOk := and(success, mload(_pPairing))
  158              }
  159  
  160              let pMem := mload(0x40)
  161              mstore(0x40, add(pMem, pLastMem))
  ...
  163              // Validate that all evaluations ∈ F
  164              checkField(calldataload(_pubSignals))
  165  
  166              // Validate all evaluations
  167              let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)
  168  
  169              mstore(0, isValid)
  170              return(0, 0x20)
  171          }
  ...
```
