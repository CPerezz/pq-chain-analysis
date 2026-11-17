---
id: hyperbridge-ecdsa-beefy
title: "Hyperbridge on Ethereum: a quantum attacker who recovers 334 of Polkadot's 500 BEEFY validator ECDSA keys can sign a false consensus update and deliver forged cross-chain messages that mint or release bridged tokens"
project: hyperbridge
status: confirmed
severity: MEDIUM
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0xaec9508513ff0a7c3c80c9bac204e572ed2d1233"
  implementation: null
  name: EcdsaBeefy (proof type 0x00 of ConsensusRouter 0x64094bb4bca533c8322a9e6d6ab88e9d2a36909a)
  upgradeable: config-only
  admin: immutable client and router; EvmHost 0x620128e2b19193d6bd244a3ac8d3bba0541b19c3 consensus client is set by OwnableHostManager 0x712515887e0dff042530a120dca9e8a3c90178a5, owner Safe 0x08bcc96cec579ce2edb34e5c5d790e4a40c3e224 (2 of 2)
  value_usd: null
  value_basis: null
  value_as_of: 2026-11-17
  last_active: null
  txs_30d: null
families: []
fix:
  layer: onchain-config
  who_acts: Polytope Labs / Hyperbridge, through OwnableHostManager 0x712515887e0dff042530a120dca9e8a3c90178a5 (owner Safe 0x08bcc96cec579ce2edb34e5c5d790e4a40c3e224) pointing EvmHost at a consensus client without the ECDSA path
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431692
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/hyperbridge-ecdsa-beefy
sources:
- by: ai-assisted
  study: top-callers-classification
  who: Review07 (registry review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/hyperbridge-ecdsa-beefy/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [hyperbridge-sp1-verifier]
---

## Summary

Hyperbridge's Ethereum host routes consensus proofs that start with byte 0x00 to `EcdsaBeefy`, which accepts a
Polkadot BEEFY commitment signed with secp256k1 by at least 2/3+1 of the relay chain's authority set (PQ-5). The set
has 500 authorities, so 334 signatures are needed; their public keys are public on Polkadot. A quantum attacker who
recovers 334 keys can sign a false commitment, advance the host to fabricated Hyperbridge state, and deliver forged
ISMP messages: mint any Hyperbridge-bridged token on Ethereum or release what its applications escrow. This path
stays open even if the SP1 path is replaced. Exposure is not measured (≈ $37 of escrow measured, minting power not).
Rated MEDIUM (step 4): the host manager's Safe can point the host at a consensus client without this path.

## Mechanism

`OwnableHandler.handleConsensus` (open to any relayer) calls the host's consensus client `ConsensusRouter`
`0x64094bb4…`; `verify` strips the first proof byte and, for 0x00, calls `EcdsaBeefy.verify`. There,
`verifyMmrUpdateProof` requires `votes.length ≥ 2·len/3 + 1` (lines 143, 255–256), recovers each signer with
`ECDSA.recover(commitmentHash, vote.signature)` (line 159) and checks the recovered addresses against the authority
set root with a Merkle multi-proof (line 164); it then accepts the signed MMR root, rotates the authority set from the
MMR leaf (lines 179–181) and returns the parachain headers proven under it (lines 213–243) as new state commitments.
Messages proven against those commitments are dispatched to the destination applications. Pattern PQ-5. Lines:
[`notes.md`](#review-reads-hyperbridge-ecdsa-beefy-2026-11-17-review07).

## Evidence

- CHECKED (Blockscout verified source): `EcdsaBeefy` and `ConsensusRouter` as above; both have no admin, and the
  router's two clients are immutables.
- CHECKED (`cast` at blocks 26,431,692 and 26,431,734): host `consensusClient()` = router; host `consensusState()`:
  authority set ids 6,010/6,011, 500 authorities each.
- CHECKED (Blockscout): `EcdsaBeefy` deployed 2026-09-23; the 6 handler transactions Blockscout lists (2026-11-16)
  all used proof type 0x01 (SP1), so the ECDSA path was not seen in use; earlier use was not enumerated.
- CHECKED (sibling finding reads): OwnableHostManager owner Safe `0x08bcc96c…` (2 of 2); escrow ≈ $37
  (`https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/hyperbridge-sp1-verifier/notes.md`).
- INFERRED: Polkadot BEEFY authority keys have signed public commitments, so their public keys are known; the
  OwnableHostManager can call `updateHostParams` (its source was not read).

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xaec95085…` EcdsaBeefy | config-only | not measured (see below) | — | — |

The same as `hyperbridge-sp1-verifier`: a forged consensus update releases the escrow of `IntentGatewayV2`
`0xae041f7b…` (≈ $19) and the deprecated `TokenGateway` `0xfd413e3a…` (≈ $18) and lets forged messages mint or release
whatever issuer-owned HyperFungible tokens and LayerZero OApps on the Hyperbridge endpoint control on Ethereum, which is
not enumerated; `value_usd` stays null. Because either proof type is accepted, the weaker of the two paths sets the
bridge's exposure.

## Remediation

- Polytope Labs / Hyperbridge deploys a consensus client that accepts only a post-quantum proof (e.g. an SP1
  STARK/FRI proof of the BEEFY signatures, whose verification itself is post-quantum), drops the ECDSA route, and the
  host manager Safe `0x08bcc96c…` points `EvmHost` at it through `updateHostParams`. The router is immutable, so a new
  router is needed.
- Long term, Polkadot's BEEFY authorities need post-quantum signatures for any light client to be post-quantum.
- No Ethereum protocol change needed.

## History

- 2026-11-17 review (Review07): finding created while reviewing `hyperbridge-sp1-verifier` (the ConsensusRouter's
  second proof type). Rated MEDIUM, step 4: the host manager can switch the host's consensus client; exposure
  unmeasured, so step 5 does not lower it.

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
