---
id: opensea-zone-and-drop-signers
title: "OpenSea SignedZone and SeaDrop: a quantum attacker who recovers OpenSea's zone or drop signer key can fulfil restricted Seaport orders OpenSea would refuse and mint signed-drop NFTs at the creator's floor price"
project: opensea
status: confirmed
severity: MEDIUM
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x000056f7000000ece9003ca63978907a00ffd100"
  implementation: null
  name: SignedZone
  upgradeable: config-only
  admin: "SignedZoneControllerSub1 0x000000657e498d54000053b69bdaad008a001dbf; zone owner OpenSeaSignedZoneCaptain 0x680000cf8b72fa2300d12a00008758149e00006d, owned by 5-of-7 Safe 0xc669b5f25f03be2ac0323037cb57f49eb543657a (sanitizer 0x21b8846849061a470b5177806896616cc1562abc)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 86802
- address: "0x00005ea00ac477b1030ce78506496e8c2de24bf5"
  implementation: null
  name: SeaDrop
  upgradeable: config-only
  admin: none for SeaDrop; each NFT contract (its owner) sets its allowed signers and their bounds (updateSignedMintValidationParams)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 112672
families: []
fix:
  layer: new-deployment
  who_acts: "OpenSea: deploy a zone and a SeaDrop that verify a post-quantum signer, through Safe 0xc669b5f25f03be2ac0323037cb57f49eb543657a (owner of OpenSeaSignedZoneCaptain); NFT creators repoint their drops"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/opensea-zone-and-drop-signers
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review13 (re-read verified source on Sourcify; controller and owner reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/opensea-zone-and-drop-signers/zones.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [opensea-seaport-order-sig, reservoir-signed-zone]
---

## Summary

OpenSea's SignedZone accepts a Seaport fulfilment of a restricted order only with a fresh co-signature from an
OpenSea server key, and SeaDrop accepts a signed mint only with a signature from a key the NFT creator allowed; both
are checked with `ecrecover` only (PQ-4). Both keys have signed on-chain, so a quantum attacker can recover them and
fulfil restricted orders that OpenSea would refuse (for example orders past the co-signature's expiry or meant for
another fulfiller), or mint signed-drop NFTs at the lowest price and largest quantity the creator's bounds allow. The
loss falls on makers of restricted orders and on creators; it is not measurable from balances, and nothing is pooled
in these contracts. Rated MEDIUM (step 4): the scheme is fixed, so OpenSea must deploy a new zone and a new SeaDrop,
and orders and drops must move to them.

## Mechanism

- SignedZone `0x000056f7…` (`src/main/zones/signed-zone/signed-zone-sub-1/SignedZone.sol`): Seaport calls
  `authorizeOrder(zoneParameters)` (line 148) for restricted orders. It reads `expectedFulfiller` and `expiration` from
  `extraData`, derives the EIP-712 `signedOrderHash` over (fulfiller, expiration, orderHash, context) (lines 331-344),
  calls `_recoverSigner` (inline `ecrecover`, 64-byte EIP-2098 signature, lines 669-… and 747-755) and reverts unless
  `_signers[recoveredSigner]` (lines 347-352). On success it also calls `beforeAuthorizedTransfer` on the transfer
  security registry named in `extraData` for substandards 7-9 (lines 354, 444-508). Signers are set only by the
  controller (`_updateSigner`, line 516). The offerer's own Seaport signature is still required; the zone only decides
  whether the fulfilment goes ahead.
- SeaDrop `0x00005ea0…` (`src/SeaDrop.sol`): `mintSigned` (lines 340-416) marks the digest used, recovers the signer
  with OpenZeppelin `ECDSA.recover` (line 402) and calls `_validateSignerAndParams` (lines 422-…), which accepts the
  signer only if the NFT contract stored `SignedMintValidationParams` for it and the signed `mintPrice`,
  `maxTotalMintableByWallet`, times and stage supply lie within those bounds. Public and Merkle allow-list mints need
  no signature.
- Pattern PQ-4. Excerpts: [`source-excerpts.md`](#source-excerpts-opensea-zone-and-drop-signers).

## Evidence

- CHECKED (verified source, Sourcify, re-read 2026-11-17): the two code paths above.
- CHECKED (on-chain, block 26,431,214): neither has a proxy, owner or Safe; SignedZone holds nothing, SeaDrop holds
  about USD 58 of USDT/WETH in transit ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/opensea-zone-and-drop-signers/onchain.json)).
- CHECKED (on-chain, block 26,431,457, [`zones.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/opensea-zone-and-drop-signers/zones.json)):
  SignedZone was created by SignedZoneControllerSub1 `0x000000657e498d54000053b69bdaad008a001dbf`;
  `ownerOf(zone)` = OpenSeaSignedZoneCaptain `0x680000cf8b72fa2300d12a00008758149e00006d`, whose `owner()` and rotator
  is the 5-of-7 Safe `0xc669b5f25f03be2ac0323037cb57f49eb543657a` and whose sanitizer is
  `0x21b8846849061a470b5177806896616cc1562abc`; one active signer `0x2f16c6d67bbe8920117093ead9bc3310d81c8fd2`.
- CHECKED (precompile trace, 12 months to March 2026, `curated_contracts.csv` `txs_y1`): `ecrecover` in 967,309
  transactions through SignedZone and 293,714 through SeaDrop.
- CHECKED (Xatu, any function, 2026-10-16 to 2026-11-16): SignedZone 86,802 and SeaDrop 112,672 transactions
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/opensea-zone-and-drop-signers/activity.json)).
- INFERRED: the SeaDrop signers allowed by most drops are OpenSea server keys; the per-drop signer list was not
  enumerated.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x000056f7…` SignedZone (OpenSea) | config-only | — | 2026-11-16 | 86,802 |
| `0x00005ea0…` SeaDrop (OpenSea) | config-only | — (USD 58 in transit) | 2026-11-16 | 112,672 |

Nothing is pooled. A forged zone co-signature lets an attacker fill restricted orders on their signed terms when the
operator would have refused (stale orders, wrong fulfiller); the maker's loss is the gap between
the order price and the market. A forged SeaDrop signature mints at `minMintPrice` up to the creator's caps, so a
creator loses the gap to the intended price. Neither total can be measured from balances; `value_usd` is `null`
(SeaDrop's USD 58 is fee flow in transit, not the exposure).

Attribution: SignedZoneV16 `0x2d1a340cd83434243d090931afabf95b7d3078b0`, drafted here, is Reservoir's Seaport Oracle
zone and is now in `reservoir-signed-zone`.

## Remediation

- SignedZone: OpenSea deploys a zone that verifies a post-quantum server signature (an ERC-7913 verifier, or a
  contract signer checked through ERC-1271) and points new restricted orders at it; the sanitizer or the Safe removes
  the ECDSA signers from the old zone, which leaves old restricted orders unfillable until makers re-sign.
- SeaDrop: OpenSea deploys a SeaDrop that verifies a post-quantum signer; each NFT creator moves its drop to it
  (`updateAllowedSeaDrop` on the NFT contract) or clears its signer from the old SeaDrop. Creators can stop the exposure
  today by removing signed-mint parameters, at the cost of signed mints.
- No protocol change needed. Users cannot protect themselves beyond not leaving restricted orders open.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review13): MEDIUM unchanged, step 4: one known operator (OpenSea Safe) must deploy a new zone and SeaDrop with a post-quantum signer and orders and drops move to them. Read controller, zone owner and signers; removed SeaDrop's USD 58 `held` value (not the exposure); SignedZoneV16 re-attributed to Reservoir (should move to a `reservoir` finding).
- 2026-11-17 review (Review13): moved SignedZoneV16 `0x2d1a340c…` and its evidence to `reservoir-signed-zone`; rating unchanged (MEDIUM, step 4).

# Source excerpts: opensea-zone-and-drop-signers

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x000056f7000000ece9003ca63978907a00ffd100` — SignedZone (verified source via sourcify)

### `src/main/zones/signed-zone/signed-zone-sub-1/SignedZone.sol`

```solidity
  747                      // address if the signature is invalid.
  748                      pop(
  749                          staticcall(
  750                              gas(),
  751                              Ecrecover_precompile, // Call ecrecover precompile.
  752                              wordBeforeSignaturePtr, // Use data memory location.
  753                              Ecrecover_args_size, // Size of digest, v, r, and s.
  754                              0, // Write result to scratch space.
  755                              OneWord // Provide size of returned result.
  ...
```


## Contract `0x00005ea00ac477b1030ce78506496e8c2de24bf5` — SeaDrop (verified source via sourcify)

### `lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol`

```solidity
   23       * defined by `root`. For this, a `proof` must be provided, containing
   24       * sibling hashes on the branch from the leaf to the root of the tree. Each
   25       * pair of leaves and each pair of pre-images are assumed to be sorted.
   26       */
   27      function verify(
   28          bytes32[] memory proof,
   29          bytes32 root,
   30          bytes32 leaf
   31      ) internal pure returns (bool) {
  ...
```

### `lib/solmate/src/tokens/ERC20.sol`

```solidity
  112      /*//////////////////////////////////////////////////////////////
  113                               EIP-2612 LOGIC
  114      //////////////////////////////////////////////////////////////*/
  115  
  116      function permit(
  117          address owner,
  118          address spender,
  119          uint256 value,
  120          uint256 deadline,
  ...
  126  
  127          // Unchecked because the only math done is incrementing
  128          // the owner's nonce which cannot realistically overflow.
  129          unchecked {
  130              address recoveredAddress = ecrecover(
  131                  keccak256(
  132                      abi.encodePacked(
  133                          "\x19\x01",
  134                          DOMAIN_SEPARATOR(),
  ...
```

### `src/SeaDrop.sol`

```solidity
   29  } from "openzeppelin-contracts/contracts/utils/introspection/IERC165.sol";
   30  
   31  import {
   32      ECDSA
   33  } from "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";
   34  
   35  import {
   36      MerkleProof
   37  } from "openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";
  ...
  298          );
  299  
  300          // Verify the proof.
  301          if (
  302              !MerkleProof.verify(
  303                  proof,
  304                  _allowListMerkleRoots[nftContract],
  305                  keccak256(abi.encode(minter, mintParams))
  306              )
  ...
  398              // Use the recover method to see what address was used to create
  399              // the signature on this data.
  400              // Note that if the digest doesn't exactly match what was signed we'll
  401              // get a random recovered address.
  402              address recoveredAddress = digest.recover(signature);
  403              _validateSignerAndParams(nftContract, mintParams, recoveredAddress);
  404          }
  405  
  406          // Mint the token(s), split the payout, emit an event.
  ...
```

Library files with the primitive itself (not excerpted): `lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol`
