---
id: "0xodex-lsag-ring-sig-bn254"
title: "0xODex: a quantum attacker can derive depositors' BN254 ring keys and withdraw any unclaimed deposit from OxODexPool"
project: "0xodex"
status: confirmed
severity: LOW
patterns: [PQ-11]
primitives: [bn254, sw_bn254]
trigger: user-key
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x3d18ad735f949febd59bbfcb5864ee0157607616"
  implementation: "0x987efaf33812745da619372c4af7a4fbaf787fc6"
  name: TransparentUpgradeableProxy -> OxODexPool
  upgradeable: "yes"
  admin: ProxyAdmin 0x8eb3e786b3a6abb5206856285b9b5c46b0bf90a6 owned by EOA 0x27a94d928bca4c846e5a1633aa496b931afd99c8 (also the factory manager)
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-09
  txs_30d: 6
families: []
fix:
  layer: contract-upgrade
  who_acts: "0xODex deployer EOA 0x27a94d928bca4c846e5a1633aa496b931afd99c8, owner of ProxyAdmin 0x8eb3e786b3a6abb5206856285b9b5c46b0bf90a6 (upgrade) and factory manager (pause)"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/0xodex-lsag-ring-sig-bn254
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review06 (Claude), 2026-11-17 review
  ref: Sourcify source of 0x987efaf3…; cast reads at block 26,431,598
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

OxODexPool is an ETH mixer whose withdrawals are authorised by an LSAG linkable ring signature over BN254 public keys
that the depositor publishes on-chain at deposit time. A quantum attacker can compute the discrete logarithm of those
public keys and sign a withdrawal of any deposit that has not yet been withdrawn, to an address of their choice. This
is not a SNARK and has no trusted setup; the keys are the users' own deposit keys. The pool held 0 ETH at block
26,431,598 (deposits are withdrawn soon after; 59 pre-quantum calls in the last year), so nothing is exposed now.
Rated LOW: step 4 gives MEDIUM (the deployer EOA can upgrade the pool), step 5 lowers it because the measured
exposure is under USD 50k.

## Mechanism

- `deposit(_amount, uint256[4] _publicKey)` stores two BN254 G1 points per deposit (checked with `AltBn128.onCurve`).
  `MAX_RING_PARTICIPANT = 2`, so each deposit fills and closes its own ring; `ringHash` is set when the ring closes.
- `withdraw(recipient, withdrawalData, relayerGasCharge)` calls `LSAG.verify(abi.encodePacked(ring.ringHash,
  recipient, withdrawalData.token), c0, keyImage, s, publicKeys)` (`OxODexPool.sol` lines 278-284; `LSAG.sol`
  `verify` at line 98, Liu-Wei-Wong LSAG). The key image only prevents a second withdrawal from the same ring. On
  success the pool sends `withdrawalData.amount` (up to `ring.amountDeposited`) to `recipient`
  (`_sendFundsWithRelayerFee`), or swaps it through Uniswap V2 in `swapOnWithdrawal`.
- The curve operations use the BN254 precompiles: `AltBn128.ecAdd` (0x06), `ecMul` (0x07) and `powmod` (0x05,
  modexp).
- Whoever knows the scalar of either ring public key can sign. A CRQC recovers it from the public key stored in
  `rings[amount][index].publicKeys`, so any ring with funds still in it can be emptied to the attacker. This is
  curve algebra used as a signature scheme (closest pattern PQ-11, with the depositor's key as the trigger).

## Evidence

- CHECKED (verified source on Sourcify, implementation 0x987efaf3…, `OxODexPool`, `LSAG`, `AltBn128`): the deposit,
  ring and withdrawal path above.
- CHECKED (cast, block 26,431,598): pool ETH balance 0; EIP-1967 admin slot = ProxyAdmin 0x8eb3e786…; its `owner()` =
  0x27a94d92…, which has no code (EOA); `factory()` = 0x7d92b7de…, `managerAddress()` = the same EOA, `paused()` =
  false ([`state.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/0xodex-lsag-ring-sig-bn254/state.json)).
- CHECKED (on-chain read at block 26,431,214): implementation and admin as above, no ETH or tokens held
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/0xodex-lsag-ring-sig-bn254/onchain.json)).
- CHECKED (Xatu, any function): 6 transactions to the pool in 2026-10-16 to 2026-11-16, last on 2026-11-09
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/0xodex-lsag-ring-sig-bn254/activity.json)).
- CHECKED (`studies/top-callers-classification/results/curated_contracts.csv`): 59 pre-quantum (bn254) calls in the last year.
- INFERRED: deposits are short-lived (balance 0 despite recent activity), so the exposure at any moment is the
  deposits not yet withdrawn.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x3d18ad73…` OxODexPool (proxy) | yes (ProxyAdmin owned by EOA) | $0 (2026-11-17) | 2026-11-09 | 6 |

- The pool holds its own deposits (ETH); there is no separate escrow. At block 26,431,598 it held 0 ETH.
- The draft listed a family of 148 contracts with code `0x0c6c7386…` (`TransparentUpgradeableProxy`, implementations
  `EthereumMultiFeedAdapterWithoutRoundsV3`). Those share only the generic OpenZeppelin proxy bytecode, not this pool;
  the family was removed.
- `factory.allPoolsLength()` = 0: the factory has no other pools registered.
- The admin EOA's own secp256k1 key is a separate quantum exposure (it controls upgrades and pausing).

## Remediation

- Replace LSAG over BN254 with a post-quantum withdrawal authorisation: a hash-based commitment/nullifier scheme
  with a STARK membership proof, or a lattice-based ring signature.
- Who acts: the deployer EOA 0x27a94d92… upgrades the implementation through ProxyAdmin 0x8eb3e786…; until then it can
  pause deposits through the factory. Moving the admin to a post-quantum-controlled account is also needed.
- No protocol change helps: the keys are BN254 points, not Ethereum accounts.
- Users: withdraw promptly after depositing; do not leave funds in an open ring.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review06): MEDIUM -> LOW, step 5: pool held 0 ETH at block 26,431,598 (MEDIUM by step 4, upgrade by one EOA). Mechanism corrected from PQ-7/trusted-setup (it is an LSAG ring signature, no SNARK) to curve algebra with the depositor's key as trigger (PQ-11, `user-key`); spurious 148-contract proxy family removed.

# Source excerpts: 0xodex-lsag-ring-sig-bn254

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x3d18ad735f949febd59bbfcb5864ee0157607616` — TransparentUpgradeableProxy (verified source via sourcify)

## Implementation `0x987efaf33812745da619372c4af7a4fbaf787fc6` — OxODexPool (verified source via sourcify)

### `contracts/OxODexPool.sol`

```solidity
  275              }
  276          }
  277      
  278          /// Attempts to verify ring signature
  279          bool signatureVerified = LSAG.verify(
  280              abi.encodePacked(ring.ringHash, recipient, withdrawalData.token), // Convert to bytes
  281              withdrawalData.c0,
  282              withdrawalData.keyImage,
  283              withdrawalData.s,
  ...
```

### `contracts/lib/LSAG.sol`

```solidity
   94      /**
   95      * Verifies the ring signature
   96      * Section 4.2 of the paper https://eprint.iacr.org/2004/027.pdf
   97      */
   98      function verify(
   99          bytes memory message,
  100          uint256 c0,
  101          uint256[2] memory keyImage,
  102          uint256[] memory s,
  ...
```
