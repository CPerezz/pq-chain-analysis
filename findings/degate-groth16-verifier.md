---
id: degate-groth16-verifier
title: "DeGate (shut down): a recovered BN254 Groth16 setup trapdoor would let forged block proofs pass the exchange's BlockVerifier; the exchange stopped in June 2025 and its deposit contract holds about $160"
project: degate
status: confirmed
severity: CRITICAL
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xe3b7fe3ce0fa54c5ac7f48e7ed9e52da045be4d6"
  implementation: null
  name: BlockVerifier
  upgradeable: "no"
  admin: "owner() EOA 0xacd3a62f3eed1bfe4ff0ec8240d645c1f5477f82; verification keys hard-coded; set once as blockVerifier of exchange 0x9c07a72177c5a05410ca338823e790876e79d73b (proxy owned by Timelock 0x0d2ec0a5858730e7d49f5b4ae6f2c665e46c1d9d)"
  value_usd: 160
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2025-06-27
  txs_30d: 0
families: []
fix:
  layer: none
  who_acts: "none needed while the exchange stays shut down; a restart would need DeGate (Timelock 0x0d2ec0a5858730e7d49f5b4ae6f2c665e46c1d9d) to upgrade ExchangeV3, since the verifier cannot be repointed"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/degate-groth16-verifier
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review23 (finding review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/degate-groth16-verifier/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

`BlockVerifier` `0xe3b7fe3c…` checks Groth16 proofs on BN254 (PQ-7) for DeGate's exchange `0x9c07a721…`, a Loopring
fork. With the setup trapdoor, a block that steals balances would verify, and the deposit contract would pay out.
But the exchange is shut down (`isShutdown()` = true), its last block was submitted on 2025-06-27, more than 12 months
ago, and the deposit contract `0x54d7ae42…` holds about $160. Rated LOW (step 1): no activity in 12 months and nothing
of value held.

## Mechanism

- `ExchangeBlocks.submitBlocks` (called by the exchange owner `LoopringIOExchangeOwner` `0x9b93e47b…`) batches blocks
  and requires `blockVerifier.verifyProofs(blockType, blockSize, blockVersion, publicInputs, proofs)`; the verifier
  runs the Groth16 pairing check with hard-coded verification keys (`VerificationKeys.sol`, `Verifier.sol`).
- Verified blocks update balances and approve withdrawals that `DefaultDepositContract` `0x54d7…` pays out.
- The verifier is set once at genesis from `LoopringV3.blockVerifierAddress()`; ExchangeV3 has no function to change
  it, so only an upgrade of the exchange proxy could swap it.
- Pattern PQ-7. Excerpts: [`source-excerpts.md`](#source-excerpts-degate-groth16-verifier).

## Evidence

- CHECKED (verified source, Sourcify, ExchangeV3 `0xc56c1dfe…` bundle): `submitBlocks` → `verifyProofs`, genesis
  verifier assignment, `BlockVerifier` functions ([`notes.md`](#review-notes-review23-2026-11-17)).
- CHECKED (on-chain read, block ~26,431,700): exchange `0x9c07…` storage `blockVerifier` = `0xe3b7fe3c…`,
  `depositContract` = `0x54d7…`; `isShutdown()` = true, `isInWithdrawalMode()` = false; BlockVerifier `owner()` =
  EOA `0xacd3a62f…`; exchange and deposit proxies owned by Timelocks `0x0d2ec0a5…` and `0xf2991507…`.
- CHECKED (Blockscout): last `submitBlocks` 2025-06-27, last exchange transaction 2025-06-28.
- CHECKED (Blockscout tokens + ETH balance): deposit contract holds $159.57 (USDC 147.9, USDT 10.0, dust).
- CHECKED (block 26,431,214): verifier holds nothing ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/degate-groth16-verifier/onchain.json)).

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xe3b7fe3c…` BlockVerifier | no | $160 escrow in DepositContract `0x54d7ae42…` | 2025-06-27 | 0 |

The escrow is DeGate's `DefaultDepositContract` `0x54d7ae423edb07282645e740c046b9373970a168` (`value_basis:
escrow`). No other DeGate deployment points at this verifier in the registry.

## Remediation

- Nothing is needed while the exchange stays shut down. If DeGate restarted it, the exchange proxy owner (Timelock
  `0x0d2ec0a5…`) would have to upgrade ExchangeV3 to a hash-based (STARK/FRI) verifier, since the verifier address
  cannot be changed.
- Remaining users can withdraw their dust balances.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1 reach: no activity in 12 months (last 2025-06-27) and nothing held).
- 2026-11-17 review (Review23): LOW kept, step 1: exchange `0x9c07…` shut down, last block 2025-06-27, escrow `0x54d7…` holds $160. Corrected `upgradeable` config-only -> no and `alternative` configurable-verifier -> sole (keys hard-coded; the exchange cannot repoint the verifier); owner read as EOA `0xacd3a62f…` (not a DAO).
- 2026-11-19: LOW -> CRITICAL, step 1 removed (dormancy no longer lowers a rating); step 4 gives CRITICAL: pooled funds released by a forged proof; the verifier's keys are hard-coded and cannot change.

# Source excerpts: degate-groth16-verifier

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xe3b7fe3ce0fa54c5ac7f48e7ed9e52da045be4d6` — BlockVerifier (verified source via sourcify)

### `./contracts/aux/access/LoopringIOExchangeOwner.sol`

```solidity
   63          open = _open;
   64          emit SubmitBlocksAccessOpened(_open);
   65      }
   66  
   67      function isValidSignature(
   68          bytes32        signHash,
   69          bytes   memory signature
   70          )
   71          external
  ...
   75      {
   76          // Role system used a bit differently here.
   77          return hasAccessTo(
   78              signHash.recoverECDSASigner(signature),
   79              this.isValidSignature.selector
   80          ) ? ERC1271_MAGICVALUE : bytes4(0);
   81      }
   82  
   83      function canDrain(address drainer, address /* token */)
  ...
```

### `./contracts/core/iface/IBlockVerifier.sol`

```solidity
   35      /// @param blockVersion The block version (i.e. which circuit version needs to be used)
   36      /// @param publicInputs The hash of all the public data of the blocks
   37      /// @param proofs The ZK proofs proving that the blocks are correct
   38      /// @return True if the block is valid, false otherwise
   39      function verifyProofs(
   40          uint8  blockType,
   41          uint16 blockSize,
   42          uint8  blockVersion,
   43          uint[] calldata publicInputs,
  ...
```

### `./contracts/core/impl/BlockVerifier.sol`

```solidity
   24      mapping (uint8 => mapping (uint16 => mapping (uint8 => Circuit))) public circuits;
   25  
   26      constructor() Claimable() {}
   27  
   28      function verifyProofs(
   29          uint8  blockType,
   30          uint16 blockSize,
   31          uint8  blockVersion,
   32          uint[] calldata publicInputs,
  ...
```

### `./contracts/core/impl/libexchange/ExchangeBlocks.sol`

```solidity
  174              }
  175  
  176              // Verify the proofs
  177              require(
  178                  blockVerifier.verifyProofs(
  179                      uint8(firstBlock.blockType),
  180                      firstBlock.blockSize,
  181                      firstBlock.blockVersion,
  182                      publicInputs,
  ...
```

### `./contracts/thirdparty/verifiers/Verifier.sol`

```solidity
   56          vk_x = ic[0]
   57          for i, s in enumerate(inputs):
   58              vk_x = add(vk_x, multiply(ic[i + 1], s))
   59  
   60          check_1 = pairing(proof_B, proof_A)
   61          check_2 = pairing(vk_beta, neg(vk_alpha))
   62          check_3 = pairing(vk_gamma, neg(vk_x))
   63          check_4 = pairing(vk_delta, neg(proof_C))
   64  
   65          ok = check_1 * check_2 * check_3 * check_4
   66          assert ok == FQ12.one()
   67      */
  ...
```

### `./contracts/lib/ERC1271.sol`

```solidity
    6  abstract contract ERC1271 {
    7      // bytes4(keccak256("isValidSignature(bytes32,bytes)")
    8      bytes4 constant internal ERC1271_MAGICVALUE = 0x1626ba7e;
    9  
   10      function isValidSignature(
   11          bytes32      _hash,
   12          bytes memory _signature)
   13          external
   14          view
  ...
```

### `./contracts/lib/ERC2612.sol`

```solidity
   16          view
   17          virtual
   18          returns (uint);
   19  
   20      function permit(
   21          address        owner,
   22          address        spender,
   23          uint256        value,
   24          uint256        deadline,
  ...
```

### `./contracts/lib/SignatureUtil.sol`

```solidity
   95          if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
   96              return address(0);
   97          }
   98          if (v == 27 || v == 28) {
   99              return ecrecover(signHash, v, r, s);
  100          } else {
  101              return address(0);
  102          }
  103      }
  ...
  151          view
  152          returns (bool)
  153      {
  154          bytes memory callData = abi.encodeWithSelector(
  155              ERC1271.isValidSignature.selector,
  156              signHash,
  157              signature
  158          );
  159          (bool success, bytes memory result) = signer.staticcall(callData);
  ...
```

# Review notes (Review23, 2026-11-17)

Reads at block ~26,431,700 (https://ethereum-rpc.publicnode.com):

- DeGate exchange `0x9c07a72177c5a05410ca338823e790876e79d73b` (OwnedUpgradabilityProxy → ExchangeV3
  `0xc56c1dfe…`, verified): storage slot 6 (`ExchangeData.State.blockVerifier`) =
  `0xe3b7fe3ce0fa54c5ac7f48e7ed9e52da045be4d6`; slot 8 (`depositContract`) = `0x54d7ae423edb07282645e740c046b9373970a168`;
  `LoopringV3 0x9385acd9….blockVerifierAddress()` = `0xe3b7fe3c…`. ExchangeV3 has no function to change the
  verifier after genesis (`ExchangeGenesis.initializeGenesisBlock` sets it once).
- `isShutdown()` = true; `isInWithdrawalMode()` = false; `getBlockHeight()` = 13,434.
- Last `submitBlocks` (via exchange owner `LoopringIOExchangeOwner 0x9b93e47b…`, `open()` = false, owner MultiSigWallet
  `0x2028834b…`, required 4 of 6): 2025-06-27; last exchange transactions `withdrawFromApprovedWithdrawals` 2025-06-28.
- `BlockVerifier 0xe3b7fe3c….owner()` = `0xacd3a62f3eed1bfe4ff0ec8240d645c1f5477f82` (EOA); verification keys are
  hard-coded (`VerificationKeys.sol`); the contract exposes only `verifyProofs`, `isCircuitRegistered`,
  `isCircuitEnabled`, `getVerificationKey`.
- Proxy owners: exchange `0x9c07…` → Timelock `0x0d2ec0a5…`; deposit contract `0x54d7…` → Timelock `0xf2991507…`.

Escrow: DefaultDepositContract `0x54d7…` holds $159.57 of Blockscout-priced ERC-20s (USDC 147.9, USDT 10.0, dust) and
0.0000009 ETH; unpriced tokens not counted.
