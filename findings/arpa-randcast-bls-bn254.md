---
id: arpa-randcast-bls-bn254
title: "ARPA Randcast Adapter: a quantum attacker who recovers a node group's BN254 BLS key can compute every mainnet randomness output in advance; only ARPA's own test consumers have used it"
project: arpa
status: confirmed
severity: MEDIUM
patterns: [PQ-6]
primitives: [bn254, sw_bn254]
trigger: committee-keys
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x4363154e1ec107f81239a4f0b1cb3ab5161129ca"
  implementation: "0x2b4045c4ad431cefeb93518ed2a87fecc03aeac3"
  name: ERC1967Proxy → Adapter
  upgradeable: "yes"
  admin: UUPS owner 0xfdeede3aa92583a46a419190c3e58d035b1fe060 (EOA, ARPA deployer)
  value_usd: 182
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 13
families: []
fix:
  layer: contract-upgrade
  who_acts: ARPA, through the Adapter's UUPS owner 0xfdeede3aa92583a46a419190c3e58d035b1fe060 (an EOA, itself an ECDSA key)
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/arpa-randcast-bls-bn254
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
  who: Review07 (registry review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/arpa-randcast-bls-bn254/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Randcast delivers randomness as the hash of a node group's threshold BLS signature on BN254, checked in
`Adapter.fulfillRandomness` with a pairing (PQ-6). A quantum attacker who recovers the group key from its public key
can compute the (unique) signature for any request seed as soon as the request is made, so it knows every output
before it is delivered and can act on consumer contracts (lotteries, games) accordingly; it can also deliver the
output itself. On mainnet the Adapter holds 0.10 ETH ($182) and only two consumers, both ARPA's own and both empty,
have ever received randomness (4 fulfilments). Rated LOW: a fix by the owner's UUPS upgrade (MEDIUM, step 4),
lowered one level for under $50k measured exposure (step 5).

## Mechanism

`fulfillRandomness(groupIndex, requestId, signature, requestDetail, partialSignatures)` (Adapter.sol line 530)
checks the request commitment, then `_verifySignature` verifies the group signature with
`BLS.verifySingle(BLS.decompress(signature), g.publicKey, BLS.hashToPoint(actualSeed))` (line 998) and the members'
partials with `BLS.verifyPartials` (line 1014), both BN254 pairing checks. The output is
`keccak256(abi.encode(signature))` (line 587), passed to the consumer's callback (line 593). A BLS signature is unique
for a key and message, so a forger cannot choose the output, but with the group secret key it learns it early; with
members' keys it can also produce the partials and fulfil. `_authorizeUpgrade` is `onlyOwner` (line 187). Lines:
[`notes.md`](#review-reads-arpa-randcast-bls-bn254-2026-11-17-review07).

## Evidence

- CHECKED (verified source, Sourcify, implementation `0x2b4045c4…`): the path above.
- CHECKED (`cast` at block 26,431,574): implementation slot = `0x2b4045c4…`; `owner()` = `0xfdeede3a…` (EOA, nonce
  207, deployer of proxy and implementation); `getRandomnessCount()` = 4; 0.1002 ETH held.
- CHECKED (Blockscout, all 44 Adapter transactions): successful fulfilments on 2024-07-31, 2024-08-09, 2025-11-15 and
  2025-12-23, all for subscription 1 owned by `0xfdeede3a…`, consumers `0xa265737e…` and `0x8acfc64b…` (created by
  the owner; 0 ETH and no tokens on 2026-11-17). Eleven new subscriptions were funded 2026-11-14 to 2026-11-16 with no
  consumer or fulfilment yet.
- CHECKED (precompile trace to March 2026): 2 transactions with BN254 pairing in the last year.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x4363154e…` ERC1967Proxy → Adapter | yes | $182 | 2026-11-16 | 13 |

The funds that depend on Randcast are in consumer contracts, not the Adapter. On mainnet the only consumers that have
received randomness are ARPA's two test consumers, which hold nothing (2026-11-17), so the measured exposure is the
Adapter's $182 of subscription balances, which a forged fulfilment cannot redirect (payment goes to the group members
whose partials verify). If the new subscriptions add funded consumers, the exposure grows to what those consumers stake
on the outcome.

## Remediation

- ARPA upgrades the Adapter (UUPS, owner `0xfdeede3a…`) to a post-quantum randomness source: e.g. a threshold
  scheme on lattice or hash-based signatures, or a commit-reveal beacon with a STARK-verified proof; node software must
  change with it.
- The owner is a single EOA: it is itself an ECDSA key a quantum attacker could recover to upgrade the Adapter, so
  moving ownership to a post-quantum account is part of the fix.
- Consumers should not use Randcast output to settle value until then. No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review07): MEDIUM -> LOW, step 5: measured exposure is the Adapter's $182; the only consumers
  ever served are ARPA's own and hold nothing. Owner identified as an EOA.
- 2026-11-19: LOW -> MEDIUM, step 5 removed (value no longer lowers a rating); step 4 gives MEDIUM.

# Source excerpts: arpa-randcast-bls-bn254

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x4363154e1ec107f81239a4f0b1cb3ab5161129ca` — ERC1967Proxy (verified source via sourcify)

## Implementation `0x2b4045c4ad431cefeb93518ed2a87fecc03aeac3` — Adapter (verified source via sourcify)

### `lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol`

```solidity
   62       * section].
   63       *
   64       * CAUTION: See Security Considerations above.
   65       */
   66      function permit(
   67          address owner,
   68          address spender,
   69          uint256 value,
   70          uint256 deadline,
  ...
```

### `lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol`

```solidity
  102          bytes32 r,
  103          bytes32 s
  104      ) internal {
  105          uint256 nonceBefore = token.nonces(owner);
  106          token.permit(owner, spender, value, deadline, v, r, s);
  107          uint256 nonceAfter = token.nonces(owner);
  108          require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
  109      }
  110  
  ...
```

### `src/Adapter.sol`

```solidity
    9  import {IAdapterOwner} from "./interfaces/IAdapterOwner.sol";
   10  import {IController} from "./interfaces/IController.sol";
   11  import {IBasicRandcastConsumerBase} from "./interfaces/IBasicRandcastConsumerBase.sol";
   12  import {RequestIdBase} from "./utils/RequestIdBase.sol";
   13  import {BLS} from "./libraries/BLS.sol";
   14  // solhint-disable-next-line no-global-import
   15  import "./utils/Utils.sol" as Utils;
   16  import {ChainHelper} from "./libraries/ChainHelper.sol";
   17  
  ...
  975          uint256 blockNum,
  976          uint256 signature,
  977          PartialSignature[] memory partialSignatures
  978      ) internal view returns (address[] memory participantMembers) {
  979          if (!BLS.isValid(signature)) {
  980              revert BLS.InvalidSignatureFormat();
  981          }
  982  
  983          if (partialSignatures.length == 0) {
  984              revert BLS.EmptyPartialSignatures();
  985          }
  986  
  987          IController.Group memory g = _controller.getGroup(groupIndex);
  988  
  ...
  991          }
  992  
  993          bytes memory actualSeed = abi.encodePacked(seed, blockNum);
  994  
  995          uint256[2] memory message = BLS.hashToPoint(actualSeed);
  996  
  997          // verify tss-aggregation signature for randomness
  998          if (!BLS.verifySingle(BLS.decompress(signature), g.publicKey, message)) {
  999              revert BLS.InvalidSignature();
 1000          }
 1001  
 1002          // verify bls-aggregation signature for incentivizing worker list
 1003          uint256[2][] memory partials = new uint256[2][](partialSignatures.length);
 1004          uint256[4][] memory pubkeys = new uint256[4][](partialSignatures.length);
 1005          participantMembers = new address[](partialSignatures.length);
 1006          for (uint256 i = 0; i < partialSignatures.length; i++) {
 1007              if (!BLS.isValid(partialSignatures[i].partialSignature)) {
 1008                  revert BLS.InvalidPartialSignatureFormat();
 1009              }
 1010              partials[i] = BLS.decompress(partialSignatures[i].partialSignature);
 1011              pubkeys[i] = g.members[partialSignatures[i].index].partialPublicKey;
 1012              participantMembers[i] = g.members[partialSignatures[i].index].nodeIdAddress;
 1013          }
 1014          if (!BLS.verifyPartials(partials, pubkeys, message)) {
 1015              revert BLS.InvalidPartialSignatures();
 1016          }
 1017      }
 1018  }
  ...
```

### `src/libraries/BLS.sol`

```solidity
    9   * @dev Homepage: https://github.com/ARPA-Network/BLS-TSS-Network
   10   *      Signature and Point hashed to G1 are represented by affine coordinate in big-endian order, deserialized from compressed format.
   11   *      Public key is represented and serialized by affine coordinate Q-x-re(x0), Q-x-im(x1), Q-y-re(y0), Q-y-im(y1) in big-endian order.
   12   */
   13  library BLS {
   14      // Field order
   15      uint256 public constant N = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
   16  
   17      // Negated genarator of G2
  ...
  282              callSuccess := staticcall(sub(gas(), 2000), 5, freemem, 0xC0, freemem, 0x20)
  283              x := mload(freemem)
  284              hasRoot := eq(xx, mulmod(x, x, N))
  285          }
  286          require(callSuccess, "BLS: sqrt modexp call failed");
  287      }
  288  
  289      /// @notice Add two points in G1
  290      function addPoints(uint256[2] memory p1, uint256[2] memory p2) internal view returns (uint256[2] memory ret) {
  ...
```

# Review reads: arpa-randcast-bls-bn254 (2026-11-17, Review07)

## Source (Sourcify, implementation `0x2b4045c4ad431cefeb93518ed2a87fecc03aeac3`, `Adapter`)

`src/Adapter.sol`:

- `fulfillRandomness(groupIndex, requestId, signature, requestDetail, partialSignatures)` (line 530): checks the
  stored request commitment (lines 539–562), then `_verifySignature(...)` (line 583): `BLS.verifySingle(
  BLS.decompress(signature), g.publicKey, BLS.hashToPoint(actualSeed))` (line 998) for the group's threshold
  signature and `BLS.verifyPartials(partials, pubkeys, message)` (line 1014) for members' partial signatures (BN254
  pairing, `src/libraries/BLS.sol`).
- `randomness = uint256(keccak256(abi.encode(signature)))` (line 587), delivered to the consumer callback (line 593);
  the subscription pays the participating members (lines 595–599).
- `_authorizeUpgrade(address) internal override onlyOwner` (line 187): UUPS, owner-only.

## On-chain reads (`cast`, publicnode, block 26,431,574)

- Proxy `0x4363154e1ec107f81239a4f0b1cb3ab5161129ca`: EIP-1967 implementation slot = `0x2b4045c4…aeac3`.
- `owner()` = `0xfdeede3aa92583a46a419190c3e58d035b1fe060`: no code (EOA), nonce 207; it deployed both the proxy
  and the implementation (Blockscout creator).
- `getRandomnessCount()` = 4 (randomness ever delivered on mainnet).
- ETH balance 0.10019141 ETH (subscription balances), $182.

## Activity (Blockscout `addresses/…/transactions`, 44 transactions, all pages)

- Successful `fulfillRandomness`: 2024-07-31, 2024-08-09, 2025-11-15, 2025-12-23; all for subscription 1, created
  by the owner on 2024-07-31, with consumers `0xa265737e4f76d38c1378049697005081599f3d43` and
  `0x8acfc64bf976488e9b83c517d4185fd4d8a9d683`, both created by the owner. Blockscout 2026-11-17: both hold 0 ETH and
  no ERC-20 tokens.
- 2026-11-14 to 2026-11-16: 11 new `createSubscription` + `fundSubscription` pairs from 11 EOAs; no consumer added
  and no request fulfilled for them yet.
