---
id: layer3-distributor-signer
title: "Layer3 L3Distributor: a quantum attacker who recovers the claim-signer key can only let addresses already in the immutable merkle tree claim their own allocation; the airdrop is closed and empty"
project: layer3
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: none
alternative: key-rotation-only
role: auxiliary
contracts:
- address: "0xb9b8dca169122421ba123d23bf52175d2be755c0"
  implementation: null
  name: L3Distributor
  upgradeable: config-only
  admin: owner Safe 0x49a941d7d7d40f340fabb17d25a9e2a76b72fac6 (3 of 5; updateSigner, emergencyWithdraw); read at block 26,431,747
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-08-30
  txs_30d: 0
families: []
fix:
  layer: none
  who_acts: nobody needs to act; Layer3 owner Safe 0x49a941d7d7d40f340fabb17d25a9e2a76b72fac6 would only matter if it refilled the contract
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/layer3-distributor-signer
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review18 (full Sourcify source, signer/owner/balance reads, Blockscout history)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/layer3-distributor-signer/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Layer3's L3 airdrop distributor requires, for each claim, both an ECDSA signature from one operator key (`s_signer`)
and a merkle proof against an immutable root, and both commit to the claimant's own address and amount. A quantum
attacker who recovers the signer key can therefore only let an address that is already in the tree claim its own
allocation without the operator's approval; nothing can be redirected. The distributor holds 0.087 L3 (dust) and its
last transaction was an `emergencyWithdraw` on 2025-08-30. Rated LOW (step 1: no activity in the last 12 months and
nothing held).

## Mechanism

- `claim` / `claimAndStake(amount, merkleProof, signature)` → `_claim`: `ECDSA.recover` of the eth-signed
  `keccak256(keccak256(abi.encode(msg.sender, amount)))` must equal `s_signer` (`L3Distributor.sol` lines 121–124),
  then `MerkleProof.verify` of the same leaf against `i_merkleRoot` (line 127), then `s_hasClaimed[msg.sender] = true`.
- `claimAndStake` stakes `amount` L3 for 12 months for `msg.sender` and transfers it to the staking contract;
  `claim` records the claim and emits `SmartWalletClaim`.
- `updateSigner` is `onlyOwner`. Pattern PQ-4, but the signature is an extra gate on top of the merkle proof.
  Excerpts: [`source-excerpts.md`](#source-excerpts-layer3-distributor-signer).

## Evidence

- CHECKED (Sourcify full source, read 2026-11-17): `_claim`, `claim`, `claimAndStake`, `updateSigner` as above;
  immutable `i_merkleRoot`; no proxy ([`notes.md`](#review-notes-layer3-distributor-signer-2026-11-17-review18)).
- CHECKED (`cast`, block 26,431,747): `s_signer()` EOA `0x268bde7c…`; `owner()` Safe `0x49a941d7…` (3 of 5 at block
  26,431,214, [`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/layer3-distributor-signer/onchain.json)); L3 balance 0.087 L3; ETH 0.
- CHECKED (Blockscout): last transaction `emergencyWithdraw` on 2025-08-30; the last `ecrecover` call in the trace
  was at block 22,773,373 (2025-06-24). Xatu shows no transaction in 2026-10-16 to 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/layer3-distributor-signer/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xb9b8dca1…` L3Distributor | config-only | $0 (0.087 L3) | 2025-08-30 | 0 |

Even when funded, a forged signer signature released nothing beyond what the merkle tree already granted to each
claimant address; the tokens went to `msg.sender` (or were staked for it), never to an address the signer chose.

## Remediation

None needed while the distributor stays empty. A future Layer3 distribution that keeps an operator approval should
verify it with a post-quantum scheme, or rely on the merkle proof alone, which is hash-based. No protocol change is
needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1 reach: no activity in 12 months (last 2025-06-24) and nothing held).
- 2026-11-17 review (Review18): LOW kept, step 1 (last transaction 2025-08-30, holds dust). Impact funds-loss -> none
  and role core -> auxiliary: the signature is an extra gate on an immutable merkle tree bound to `msg.sender`, so a
  forged signature cannot redirect allocations. `last_active` corrected to 2025-08-30 (emergencyWithdraw).
- 2026-11-19: LOW kept, step 1 removed (dormancy no longer lowers a rating); step 4 also gives LOW: an extra gate on a fixed merkle tree; nothing can be taken.

# Source excerpts: layer3-distributor-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xb9b8dca169122421ba123d23bf52175d2be755c0` — L3Distributor (verified source via sourcify)

### `lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol`

```solidity
   41       * pair of leaves and each pair of pre-images are assumed to be sorted.
   42       *
   43       * This version handles proofs in memory with the default hashing function.
   44       */
   45      function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
   46          return processProof(proof, leaf) == root;
   47      }
   48  
   49      /**
  ...
   69       * pair of leaves and each pair of pre-images are assumed to be sorted.
   70       *
   71       * This version handles proofs in memory with a custom hashing function.
   72       */
   73      function verify(
   74          bytes32[] memory proof,
   75          bytes32 root,
   76          bytes32 leaf,
   77          function(bytes32, bytes32) view returns (bytes32) hasher
  ...
```

### `src/contracts/L3Distributor.sol`

```solidity
   16  import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';
   17  import {Ownable2Step} from '@openzeppelin/contracts/access/Ownable2Step.sol';
   18  import {IERC20} from '@openzeppelin/contracts/interfaces/IERC20.sol';
   19  
   20  import {ECDSA} from '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';
   21  import {MerkleProof} from '@openzeppelin/contracts/utils/cryptography/MerkleProof.sol';
   22  import {MessageHashUtils} from '@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol';
   23  import {Math} from '@openzeppelin/contracts/utils/math/Math.sol';
   24  
  ...
  119  
  120      // Verify the signature
  121      bytes32 _messageHash = keccak256(bytes.concat(keccak256(abi.encode(msg.sender, amount))));
  122      bytes32 _ethSignedMessageHash = _messageHash.toEthSignedMessageHash();
  123      address _recoveredSigner = _ethSignedMessageHash.recover(signature);
  124      if (_recoveredSigner != s_signer) revert L3Distributor__InvalidSigner();
  125  
  126      // Verify the merkle proof
  127      if (!MerkleProof.verify(merkleProof, i_merkleRoot, _messageHash)) revert L3Distributor__InvalidProof();
  128  
  129      // Mark as claimed
  130      s_hasClaimed[msg.sender] = true;
  131    }
  ...
```

Library files with the primitive itself (not excerpted): `lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol`

# Review notes: layer3-distributor-signer (2026-11-17, Review18)

## Source (Sourcify, `src/contracts/L3Distributor.sol`)

- Deployed in tx `0x4c8537ad…` (block 22,226,296) by `0x672541228e3469eb206caf04966db927b202d058`; header banner
  "LAYER3"; not a proxy; `Ownable2Step`; `renounceOwnership` overridden to do nothing.
- `_claim(amount, merkleProof, signature)`: `_messageHash = keccak256(bytes.concat(keccak256(abi.encode(msg.sender,
  amount))))`; `_messageHash.toEthSignedMessageHash().recover(signature)` must equal `s_signer` (line 123–124);
  `MerkleProof.verify(merkleProof, i_merkleRoot, _messageHash)` (line 127) against the immutable root; then
  `s_hasClaimed[msg.sender] = true`.
- `claim` records the claim and emits `SmartWalletClaim`; `claimAndStake` additionally stakes `amount` for 12 months
  in `i_staking` for `msg.sender` and transfers the L3 to the staking contract.
- `updateSigner`, `emergencyWithdraw`, `collectDust`: `onlyOwner`.
- Consequence for this registry: both the signature and the merkle leaf commit to `msg.sender` and `amount`, and the
  root is immutable, so a forged `s_signer` signature only lets an address that is already in the tree claim its own
  allocation without the operator's approval. It cannot redirect or enlarge anyone's allocation.

## On-chain reads (`cast`, https://ethereum-rpc.publicnode.com, block 26,431,747)

- `s_signer()` = `0x268bde7c8e2f4188ffbc0a482a641bd919c7c797`; `owner()` = Safe
  `0x49a941d7d7d40f340fabb17d25a9e2a76b72fac6` (3 of 5 at block 26,431,214, `onchain.json`); `pendingOwner()` = 0.
- `i_l3()` = L3 token `0x88909d489678dd17aa6d9609f89b0419bf78fd9a`; `i_staking()` = `0x8e02d37b…`.
- `L3.balanceOf(distributor)` = 0.087 L3 (dust); ETH 0.

## Activity (Blockscout)

- 20,453 transactions in total; the latest is `emergencyWithdraw` on 2025-08-30, before that `claim` /
  `claimAndStake` calls. Last `ecrecover` call in the precompile trace at block 22,773,373 (2025-06-24); 20,382
  `ecrecover` transactions over its life.
