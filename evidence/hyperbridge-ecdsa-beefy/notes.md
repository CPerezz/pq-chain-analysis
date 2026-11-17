# Review reads: hyperbridge-ecdsa-beefy (2026-11-17, Review07)

## Source (Blockscout verified, solc 0.8.30)

`EcdsaBeefy` `0xaec9508513ff0a7c3c80c9bac204e572ed2d1233`, `src/consensus/EcdsaBeefy.sol`:

```solidity
   99      function verify(bytes calldata previousState, bytes calldata proof)
  ...
  113          (BeefyConsensusState memory newState, bytes32 headsRoot) = verifyMmrUpdateProof(consensusState, relay);
  114          IntermediateState[] memory intermediates = verifyParachainHeaderProof(headsRoot, parachain);
  ...
  143          if (!checkParticipationThreshold(sigLen, authoritySet.len)) revert SuperMajorityRequired();
  ...
  155          bytes32 commitmentHash = keccak256(Codec.Encode(commitment));
  157          for (uint256 i = 0; i < sigLen; i++) {
  158              Vote memory vote = relayProof.signedCommitment.votes[i];
  159              address authority = ECDSA.recover(commitmentHash, vote.signature);
  160              authorities[i] =
  161                  MerkleMultiProof.Leaf({index: vote.authorityIndex, hash: keccak256(abi.encodePacked(authority))});
  162          }
  164          bool valid = MerkleMultiProof.VerifyProof(authoritySet.root, relayProof.proof, authorities, authoritySet.len);
  ...
  179          if (relayProof.latestMmrLeaf.nextAuthoritySet.id > trustedState.nextAuthoritySet.id) {
  180              trustedState.currentAuthoritySet = trustedState.nextAuthoritySet;
  181              trustedState.nextAuthoritySet = relayProof.latestMmrLeaf.nextAuthoritySet;
  ...
  255      function checkParticipationThreshold(uint256 len, uint256 total) internal pure returns (bool) {
  256          return len >= ((2 * total) / 3) + 1;
```

`ConsensusRouter` `0x64094bb4bca533c8322a9e6d6ab88e9d2a36909a` (Blockscout verified): `verify` reads the first proof
byte; 0x00 → `ecdsaBeefy.verify`, 0x01 → `sp1Beefy.verify`; both addresses are immutables (constructor args
`_sp1Beefy` = `0x3683cd18cdb7c5c223f9489ac33c9c97eb176cb1`, `_ecdsaBeefy` = `0xaec95085…1233`).

## On-chain reads (`cast`, publicnode)

- Block 26,431,692: EvmHost `0x620128e2b19193d6bd244a3ac8d3bba0541b19c3` `consensusClient()` = router `0x64094bb4…`.
- Block 26,431,734: EvmHost `consensusState()` decodes to latestHeight 33,908,595, beefyActivationBlock 19,551,000,
  current authority set id 6,010 / len 500, next id 6,011 / len 500 (root `0x6006b2be…9bbc` for both). A proof needs
  ≥ 334 authority signatures.
- Host manager and admin: see `evidence/hyperbridge-sp1-verifier/notes.md` (OwnableHostManager owner Safe
  `0x08bcc96c…`, 2 of 2).

## Deployment and use (Blockscout)

- `EcdsaBeefy` created 2026-09-23 (block 26,040,472, tx `0x21f0eaee…fb47`) via the CREATE2 factory; the router one
  block later (26,040,473).
- The 6 `handleConsensus` transactions Blockscout lists for handler `0x3568374f…0726` (all 2026-11-16) carry proofs
  starting with byte 0x01 (SP1); none used the ECDSA path. Older usage of `EcdsaBeefy` was not enumerated; the
  precompile trace (to March 2026) predates its deployment.
