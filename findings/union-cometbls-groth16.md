---
id: union-cometbls-groth16
title: "Union: a quantum attacker with the CometBLS Groth16 setup trapdoor (and a relayer key) can forge a Union light-client header on Ethereum and release the $12k held by Union's ZKGM bridge app"
project: union
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x7700ea295f62989d2c98721389a521c96fe3c4c0"
  implementation: "0xf2b24b085080cef91f7bffdc6358fe054999e15f"
  name: ERC1967Proxy (UUPS) → CometblsClient
  upgradeable: "yes"
  admin: "AccessManager 0x40cdff51ae7487e0b4a4d6e5f86eb15fb7c1d9f4; upgradeToAndCall needs ADMIN_ROLE, held by Safe 0x6a742078f90c2e16d8c9f83e41749410c314edd4 (5 of 8), no execution delay; read at block 26,431,454"
  value_usd: 11870
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-10-29
  txs_30d: 84
families: []
fix:
  layer: contract-upgrade
  who_acts: "Union: Safe 0x6a742078f90c2e16d8c9f83e41749410c314edd4 (5 of 8, ADMIN_ROLE in AccessManager 0x40cdff51ae7487e0b4a4d6e5f86eb15fb7c1d9f4) upgrades CometblsClient"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/union-cometbls-groth16
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review11 (Claude), finding review
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/union-cometbls-groth16/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Union's IBC light client on Ethereum accepts a new Union header when a Groth16 proof on BN254 shows that the Union
validators signed it (PQ-7). With the setup trapdoor, a quantum attacker can prove a header with any state root and then
prove fake IBC packets against it, releasing what Union's UCS03 ZKGM app `0x5fbe74a2…` holds ($11.9k on 2026-11-17) or
minting its wrapped tokens; header updates must come from a permissioned relayer account, whose ECDSA key is also
recoverable. Rated LOW: MEDIUM by step 4 (the client is a UUPS proxy that Union's 5-of-8 admin Safe can upgrade),
lowered by step 5 (escrow under $50k).

## Mechanism

- `IBCHandler.updateClient` → `CometblsClient.updateClient` (line 400, `onlyIBC`) → `verifyHeader` (line 336) →
  `internalVerifyZKP` (line 608) → `CometblsZKVerifier.verifyProof` (line 190): Groth16 with a Pedersen commitment
  (`verifyProofCommitmentPOK`, line 158), pairing precompile `0x08`. The new consensus state's root then backs
  `verifyMembership` (line 477), which the IBCHandler uses to accept packets for apps such as ZKGM.
- The circuit attests CometBLS (BN254 BLS) validator signatures on the Union chain, so the Union validator set is a
  second pre-quantum dependency behind the same check.
- Upgrades: `_authorizeUpgrade` (line 648) is `restricted` by AccessManager `0x40cdff51…`; `upgradeToAndCall` maps to
  ADMIN_ROLE.

## Evidence

- CHECKED (verified source, Sourcify): the path above
  ([`source-excerpts.md`](#source-excerpts-union-cometbls-groth16),
  [`notes.md`](#review-notes-union-cometbls-groth16-2026-11-17)).
- CHECKED (on-chain read, block 26,431,454): implementation slot, `IBC_HANDLER()`, `authority()`, upgrade function role 0,
  `hasRole(0, Safe 0x6a742078…)` = true with delay 0, Safe threshold 5 of 8; ZKGM `0x5fbe74a2…` uses the same handler and
  manager.
- CHECKED (Blockscout, 2026-11-17): ZKGM holds $11,870 in tokens and no ETH; IBCHandler holds nothing
  ([`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/union-cometbls-groth16/escrow.json)).
- CHECKED (Xatu, any function): 84 transactions reached the client 2026-10-16 to 2026-11-16; last 2026-10-29
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/union-cometbls-groth16/activity.json)).
- INFERRED: that ZKGM is the only app on this IBCHandler with funds; other ports were not enumerated.

## Impact and exposure

| Contract | Upgradeable | Escrow secured | Last active | 30-day txs |
|---|---|---|---|---|
| `0x7700ea29…` CometblsClient | yes (AccessManager admin Safe) | $11.9k in ZKGM `0x5fbe74a2…` | 2026-10-29 | 84 |

Escrow basis, 2026-11-17: ZKGM's token balances (uniBTC, U, LBTC, SolvBTC, WETH). Wrapped tokens ZKGM would mint on a
forged packet are not counted. Yearly pre-quantum count from the census: 8,096 transactions (`txs_y1`).

## Remediation

- Union replaces the Groth16/BN254 header proof with a hash-based proof (STARK/FRI or WHIR) over a post-quantum validator
  signature scheme and upgrades `0x7700ea29…` through AccessManager `0x40cdff51…` (ADMIN_ROLE Safe `0x6a742078…`, 5 of 8).
  The Union chain's CometBLS validator keys need a post-quantum replacement for the proof to mean anything.
- The admin can pause the client (`pause`, PAUSER role) in an emergency. No protocol change is needed. Users can bridge
  their assets out.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review11): MEDIUM -> LOW, step 5: escrow measured, UCS03 ZKGM 0x5fbe74a2… holds $11.9k (under $50k). Upgrade authority traced to ADMIN_ROLE Safe 0x6a742078… (5 of 8).

# Source excerpts: union-cometbls-groth16

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x7700ea295f62989d2c98721389a521c96fe3c4c0` — ERC1967Proxy (verified source via blockscout)

## Implementation `0xf2b24b085080cef91f7bffdc6358fe054999e15f` — CometblsClient (verified source via sourcify)

### `contracts/clients/CometblsClient.sol`

```solidity
  639              // See https://github.com/ConsenSys/gnark/issues/652
  640              commitmentHash
  641          ];
  642  
  643          return CometblsZKVerifier.verifyProof(
  644              zkp.proof, zkp.proofCommitment, zkp.proofCommitmentPOK, publicInputs
  645          );
  646      }
  647  
  ...
```

### `contracts/lib/CometblsZKVerifier.sol`

```solidity
  154              y := mload(add(f, 0x20))
  155          }
  156      }
  157  
  158      function verifyProofCommitmentPOK(
  159          uint256[2] calldata proofCommitment,
  160          uint256[2] calldata proofCommitmentPOK
  161      ) internal view returns (bool) {
  162          bool success = true;
  ...
  186      /// @param proof the points (A, B, C) in EIP-197 format matching the output
  187      /// of compressProof.
  188      /// @param input the public input field elements in the scalar field Fr.
  189      /// Elements must be reduced.
  190      function verifyProof(
  191          uint256[8] calldata proof,
  192          uint256[2] calldata proofCommitment,
  193          uint256[2] calldata proofCommitmentPOK,
  194          uint256[2] memory input
  ...
  198          if (!success) {
  199              return false;
  200          }
  201  
  202          if (!verifyProofCommitmentPOK(proofCommitment, proofCommitmentPOK)) {
  203              return false;
  204          }
  205  
  206          // Note: The precompile expects the F2 coefficients in big-endian order.
  ...
```

### `contracts/lib/ICS23.sol`

```solidity
   37          if (rCode != Proof.CalculateRootError.None) {
   38              return VerifyChainedNonMembershipError.InvalidProofRoot;
   39          }
   40  
   41          Proof.VerifyNonExistenceError vCode = Proof.verify(
   42              nonExistProof, UnionIcs23.getIavlProofSpec(), subroot, key
   43          );
   44  
   45          // Map non existence error to non membership error
  ...
  146              return convertExistenceError(vCode);
  147          }
  148  
  149          // This will check whether the calculated root of `proofs[1]` matches the `root`
  150          vCode = Proof.verify(
  151              proofs[1],
  152              UnionIcs23.getTendermintProofSpec(),
  153              root,
  154              prefix,
  ...
  356          return VerifyExistenceError.None;
  357      }
  358  
  359      // ExistenceProof
  360      function verify(
  361          UnionIcs23.ExistenceProof calldata proof,
  362          UnionIcs23.ProofSpec memory spec,
  363          bytes32 commitmentRoot,
  364          bytes memory key,
  ...
  474          IsLeftNeighbor
  475      }
  476  
  477      // CosmosIcs23V1NonExistenceProof
  478      function verify(
  479          UnionIcs23.NonExistenceProof calldata proof,
  480          UnionIcs23.ProofSpec memory spec,
  481          bytes32 commitmentRoot,
  482          bytes memory key
  ...
  484          bytes calldata leftKey = proof.left.key;
  485          bytes calldata rightKey = proof.right.key;
  486          // CosmosIcs23V1ExistenceProof.isNil does not work
  487          if (!UnionIcs23.empty(proof.left)) {
  488              VerifyExistenceError eCode = verify(
  489                  proof.left,
  490                  spec,
  491                  commitmentRoot,
  492                  proof.left.key,
  ...
  496                  return VerifyNonExistenceError.VerifyLeft;
  497              }
  498          }
  499          if (!UnionIcs23.empty(proof.right)) {
  500              VerifyExistenceError eCode = verify(
  501                  proof.right,
  502                  spec,
  503                  commitmentRoot,
  504                  proof.right.key,
  ...
```

# Review notes: union-cometbls-groth16 (2026-11-17)

Reads with `cast` against https://ethereum-rpc.publicnode.com at block 26,431,454; source from Sourcify
(implementation `0xf2b24b085080cef91f7bffdc6358fe054999e15f`, `contracts/clients/CometblsClient.sol`,
`contracts/lib/CometblsZKVerifier.sol`).

## Code path

- `IBCHandler.updateClient` → `CometblsClient.updateClient` (line 400, `onlyIBC`, `whenNotPaused`) → `verifyHeader`
  (line 336) → `internalVerifyZKP` (line 608) → `CometblsZKVerifier.verifyProof` (line 190): a gnark Groth16 proof with a
  Pedersen commitment (`verifyProofCommitmentPOK`, line 158) on BN254 that the Union validator set signed the header.
  The accepted consensus state's root is then used by `verifyMembership` (line 477) to prove IBC packets.
- `_authorizeUpgrade` (line 648) is `restricted` (OpenZeppelin AccessManaged).

## Who can change it

- `0x7700ea29…` EIP-1967 implementation slot = `0xf2b24b08…`; `IBC_HANDLER()` = `0xee4ea8d358473f0fcebf0329feed95d56e8c04d7`
  (ERC1967Proxy → IBCHandler); `authority()` = `0x40cdff51ae7487e0b4a4d6e5f86eb15fb7c1d9f4` (ERC1967Proxy → `Manager`,
  an OpenZeppelin AccessManager); `paused()` = false.
- AccessManager `getTargetFunctionRole(0x7700ea29…, upgradeToAndCall)` = 0 (ADMIN_ROLE).
  `hasRole(0, 0x6a742078f90c2e16d8c9f83e41749410c314edd4)` = (true, delay 0). From the manager's events (Blockscout logs):
  ADMIN_ROLE granted to `0x6a742078…` at block 23,283,375 and revoked from `0x95fb5cb304508d74d855514d7bc9bda75c304ce2` at
  block 23,283,914.
- `0x6a742078…` is a Safe 1.4.1, threshold 5 of 8 (owners `0xa55f584f…`, `0x2e06bc0e…`, `0x58ab4153…`, `0x6e8a43f1…`,
  `0x107d2d0e…`, `0x7eb1e318…`, `0xbc223488…`, `0x571aeba0…`).
- Role 1 (`RELAYER`) gates the IBCHandler entry points (`TargetFunctionRoleUpdated` for nine IBCHandler selectors); the latest
  page of events shows 23 grants of it between blocks 22,244,190 and 24,236,104 (revocations not traced). A forged
  header must be submitted by one of these relayer accounts.

## Escrow

- UCS03 ZKGM app `0x5fbe74a283f7954f10aa04c2edf55578811aeb03` (ERC1967Proxy → `UCS03Zkgm`, implementation
  `0x384932cb…`): `IBC_HANDLER()` = the same IBCHandler and `authority()` = the same AccessManager.
- Holdings (Blockscout, 2026-11-17): 0 ETH, $11,870 in tokens (uniBTC $5,228, U 63.9M = $3,961 at $0.000062, LBTC $1,203,
  SolvBTC $848, WETH $623, …), `escrow.json`. IBCHandler holds nothing.
- ZKGM can also mint wrapped tokens on a forged packet; their value is not measured.
