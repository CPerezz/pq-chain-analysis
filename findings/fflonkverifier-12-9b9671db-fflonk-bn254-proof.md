---
id: fflonkverifier-12-9b9671db-fflonk-bn254-proof
format: 2
title: Forged proofs for three Agglayer chains could drain the shared bridge
status: confirmed
severity: MEDIUM
justification: A forged proof could release pooled bridge funds; the timelock can move the chains to a new verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9b9671db83cfcb4508bf361942488c5ca2b1286d'
  name: FflonkVerifier_12
  project: polygon
  code: verified
  code_url: https://etherscan.io/address/0x9b9671db83cfcb4508bf361942488c5ca2b1286d#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: funds-loss
action: Deploy a hash-based verifier, add it as a rollup type and move rollups 8, 13 and 15 onto it through the
  timelock.
evidence_level: source
checks:
- id: pairing
  source: '0x9b9671db83cfcb4508bf361942488c5ca2b1286d'
  file: contracts/verifiers/FflonkVerifier_12.sol
  lines:
  - 2106
  - 2113
  has: let success := staticcall( sub(gas(), 2000), 8, mIn, 384, mIn, 0x20 )
  says: verifyProof's final check is one call to the BN254 pairing precompile 0x08
  for:
  - evidence-1
  - what
- id: curve
  source: '0x9b9671db83cfcb4508bf361942488c5ca2b1286d'
  file: contracts/verifiers/FflonkVerifier_12.sol
  lines:
  - 80
  - 82
  has: uint256 constant q = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
  says: the proof system works over the BN254 scalar field
  for:
  - evidence-1
  - what
- id: vk
  source: '0x9b9671db83cfcb4508bf361942488c5ca2b1286d'
  file: contracts/verifiers/FflonkVerifier_12.sol
  lines:
  - 70
  - 72
  has: // Verifier preprocessed input x·[1]_2 uint256 constant X2x1 =
  says: the setup's public point x·[1]_2 is a constant in the code
  for:
  - evidence-1
- id: rollup-8
  call: '0x5132a183e9f3cb7c848b0aac5ae0c4f0491b7ab2'
  fn: rollupIDToRollupDataV2Deserialized(uint32)(address,uint64,address,uint64,bytes32,uint64,uint64,uint64,uint64,uint8,bytes32,bytes32)
  args:
  - 8
  is:
  - '0x78253e2e6120164bd826668a4c96db20f78a94c9'
  - 31415
  - '0x9b9671db83cfcb4508bf361942488c5ca2b1286d'
  - 12
  - '0x800b74cc35bf4a144cf70bc391c77822458509cc0d40d15e8643fc03c513df97'
  - 48194
  - 46689
  - 30379
  - 7
  - 0
  - '0x0000000000000000000000000000000000000000000000000000000000000000'
  - '0x0000000000000000000000000000000000000000000000000000000000000000'
  says: rollup 8 (chain 31415) is a state-transition chain verified by this address, with batches sequenced but
    not yet verified
  for:
  - evidence-2
  - justification
  - what
- id: rollup-13
  call: '0x5132a183e9f3cb7c848b0aac5ae0c4f0491b7ab2'
  fn: rollupIDToRollupDataV2Deserialized(uint32)(address,uint64,address,uint64,bytes32,uint64,uint64,uint64,uint64,uint8,bytes32,bytes32)
  args:
  - 13
  is:
  - '0x7ff0b5ff6eb8b789456639ac2a02487c338c1789'
  - 752025
  - '0x9b9671db83cfcb4508bf361942488c5ca2b1286d'
  - 12
  - '0x96afdf5da5a1c194a421fbef61c229c9f27dbdf1792c9dcad0578afa596f6101'
  - 32477
  - 32477
  - 0
  - 7
  - 0
  - '0x0000000000000000000000000000000000000000000000000000000000000000'
  - '0x0000000000000000000000000000000000000000000000000000000000000000'
  says: rollup 13 (chain 752025) is a state-transition chain verified by this address
  for:
  - evidence-2
  - justification
  - what
- id: rollup-15
  call: '0x5132a183e9f3cb7c848b0aac5ae0c4f0491b7ab2'
  fn: rollupIDToRollupDataV2Deserialized(uint32)(address,uint64,address,uint64,bytes32,uint64,uint64,uint64,uint64,uint8,bytes32,bytes32)
  args:
  - 15
  is:
  - '0xb4ceb70e8778a9928fed6ecba1b03706a57b0ce8'
  - 623
  - '0x9b9671db83cfcb4508bf361942488c5ca2b1286d'
  - 12
  - '0x0000000000000000000000000000000000000000000000000000000000000000'
  - 1
  - 0
  - 0
  - 7
  - 0
  - '0x0000000000000000000000000000000000000000000000000000000000000000'
  - '0x0000000000000000000000000000000000000000000000000000000000000000'
  says: rollup 15 (chain 623) is a state-transition chain verified by this address
  for:
  - evidence-2
  - justification
  - what
- id: manager-impl
  storage: '0x5132a183e9f3cb7c848b0aac5ae0c4f0491b7ab2'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x15caf18ded768e3620e0f656221bf6b400ad2618'
  says: the rollup manager runs implementation 0x15ca…2618, whose source the other manager checks cite
  for:
  - notes
- id: aggregator-gate
  source: '0x15caf18ded768e3620e0f656221bf6b400ad2618'
  file: contracts/AgglayerManager.sol
  lines:
  - 1156
  - 1165
  has: ) external onlyRole(_TRUSTED_AGGREGATOR_ROLE) {
  says: verifyBatchesTrustedAggregator can only be called by the trusted aggregator role
  for:
  - what
- id: verify-call
  source: '0x15caf18ded768e3620e0f656221bf6b400ad2618'
  file: contracts/AgglayerManager.sol
  lines:
  - 1263
  - 1266
  has: '!IVerifierRollup(rollup.verifier).verifyProof(proof, [inputSnark])'
  says: the manager accepts a batch range when the rollup's verifier approves the proof
  for:
  - what
- id: exit-root
  source: '0x15caf18ded768e3620e0f656221bf6b400ad2618'
  file: contracts/AgglayerManager.sol
  lines:
  - 1191
  - 1194
  has: rollup.lastLocalExitRoot = newLocalExitRoot; // Interact with globalExitRootManager globalExitRootManager.updateExitRoot(getRollupExitRoot());
  says: after the proof passes, the submitted exit root is stored and pushed to the global exit root
  for:
  - what
- id: bridge-impl
  storage: '0x2a3dd3eb832af982ec71669e178424b10dca2ede'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x66e0120e3c965552a89acc37b03f762624bac5ad'
  says: the bridge runs implementation 0x66e0…c5ad
  for:
  - notes
- id: bridge-manager
  call: '0x2a3dd3eb832af982ec71669e178424b10dca2ede'
  fn: polygonRollupManager()(address)
  is: '0x5132a183e9f3cb7c848b0aac5ae0c4f0491b7ab2'
  says: the bridge belongs to this rollup manager
  for:
  - evidence-3
  - what
- id: bridge-claim
  source: '0x66e0120e3c965552a89acc37b03f762624bac5ad'
  file: contracts/AgglayerBridge.sol
  lines:
  - 604
  - 616
  has: '(bool success, ) = destinationAddress.call{value: amount}('
  says: once the leaf is verified against an exit root, claimAsset pays the claimed amount to the destination from
    the bridge's own balance
  for:
  - evidence-3
  - justification
  - what
  - whose
- id: bridge-eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x2a3dd3eb832af982ec71669e178424b10dca2ede'
  is: 3473930876436718755772
  says: the bridge holds 3,473.9 ETH
  for:
  - evidence-3
- id: add-src
  source: '0x15caf18ded768e3620e0f656221bf6b400ad2618'
  file: contracts/AgglayerManager.sol
  lines:
  - 515
  - 523
  has: ) external onlyRole(_ADD_ROLLUP_TYPE_ROLE) {
  says: addNewRollupType registers a rollup type with any verifier address, for ADD_ROLLUP_TYPE_ROLE
  for:
  - action
- id: update-src
  source: '0x15caf18ded768e3620e0f656221bf6b400ad2618'
  file: contracts/AgglayerManager.sol
  lines:
  - 948
  - 953
  has: rollup.verifier = newRollupType.verifier;
  says: updating a rollup to a new type replaces its verifier
  for:
  - action
  - justification
- id: add-role
  call: '0x5132a183e9f3cb7c848b0aac5ae0c4f0491b7ab2'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0xac75d24dbb35ea80e25fab167da4dea46c1915260426570db84f184891f5f590'
  - '0xef1462451c30ea7ad8555386226059fe837ca4ef'
  is: true
  says: the timelock holds ADD_ROLLUP_TYPE_ROLE
  for:
  - action
  - justification
- id: update-role
  call: '0x5132a183e9f3cb7c848b0aac5ae0c4f0491b7ab2'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0x66156603fe29d13f97c6f3e3dff4ef71919f9aa61c555be0182d954e94221aac'
  - '0xef1462451c30ea7ad8555386226059fe837ca4ef'
  is: true
  says: the timelock holds UPDATE_ROLLUP_ROLE (updateRollup, line 899)
  for:
  - action
  - justification
- id: min-delay
  call: '0xef1462451c30ea7ad8555386226059fe837ca4ef'
  fn: getMinDelay()(uint256)
  is: 259200
  says: the timelock acts after at least three days
  for:
  - action
- id: r-agg-role
  call: '0x5132a183e9f3cb7c848b0aac5ae0c4f0491b7ab2'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0x084e94f375e9d647f87f5b2ceffba1e062c70f6009fdbcf80291e803b5c9edd4'
  - '0x20a53dcb196cd2bcc14ece01f358f1c849aa51de'
  is: true
  says: 0x20a5…51de holds TRUSTED_AGGREGATOR_ROLE
  for:
  - what
- id: r-agg-eoa
  code: '0x20a53dcb196cd2bcc14ece01f358f1c849aa51de'
  is: empty
  says: the aggregator is a plain ECDSA account, so a CRQC can also recover its key
  for:
  - what
- id: r-agg-nonce
  nonce: '0x20a53dcb196cd2bcc14ece01f358f1c849aa51de'
  min: 104752
  says: the aggregator has sent transactions, so its public key is on chain
  for:
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review14 (AgglayerManager and AgglayerBridge source, rollup registry and bridge reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

Polygon's rollup manager accepts new exit roots for three chains when this BN254 fflonk verifier approves the trusted aggregator's proof. With the setup trapdoor and the trusted aggregator's key (a plain ECDSA account) a false proof passes, and the shared bridge pays claims against the false root.

## Evidence

- [verifyProof](https://etherscan.io/address/0x9b9671db83cfcb4508bf361942488c5ca2b1286d#code) ends in one BN254 pairing check against setup keys fixed in the code.
- The [rollup manager](https://etherscan.io/address/0x5132a183e9f3cb7c848b0aac5ae0c4f0491b7ab2#readProxyContract) points chains 31415, 752025 and 623 at this verifier.
- The [bridge](https://etherscan.io/address/0x2a3dd3eb832af982ec71669e178424b10dca2ede) holds 3,473 ETH and pays claims proven against the exit roots the manager posts.

## Reviewer notes

### Mechanism

AgglayerManager (proxy 0x5132…7ab2, implementation 0x15ca…2618) verifyBatchesTrustedAggregator (onlyRole TRUSTED_AGGREGATOR_ROLE, line 1165) calls _verifyAndRewardBatches, which calls IVerifierRollup(rollup.verifier).verifyProof(proof, [inputSnark]) (line 1264); on success it stores newLocalExitRoot (line 1191) and pushes getRollupExitRoot() to the global exit root manager 0x580b…3CFb (line 1194). FflonkVerifier_12.verifyProof is a snarkjs fflonk verifier on BN254 (scalar field q, line 81) whose final step is one call to the pairing precompile 0x08 (lines 2106-2113) against the verification key constants (x·[1]_2, lines 70-78). Rollups 8 (chain 31415), 13 (752025) and 15 (623) use it (rollup types 6 and 7). AgglayerBridge (proxy 0x2a3d…2EDe, implementation 0x66e0…c5ad) claimAsset checks the leaf against a global exit root from that manager (_verifyLeafBridge, lines 580-593) and then pays from its own balance (lines 604-645). Fix path: addNewRollupType (ADD_ROLLUP_TYPE_ROLE, line 523) and updateRollup (UPDATE_ROLLUP_ROLE, line 899) rewrite rollup.verifier (line 952); timelock 0xef14…a4ef holds both roles, minimum delay 259,200 s. This needs a new verifier deployment plus a timelock action: MEDIUM under the quantum-exposure table.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an EIP-8151 effect: the verifier calls only precompiles 6, 7 and 8 (lines 1918-1970, 2106-2113); there is no signature recovery in it.
- Ruled out: an unused address: the manager's rollups 8, 13 and 15 name this address as their verifier at the block.
- Ruled out: a closed path: neither the manager nor the bridge is in emergency state, and rollup 8 has 1,505 batches sequenced but not verified (48,194 vs 46,689), so a proof can still be submitted for it.
- Ruled out: an upgradeable verifier: no EIP-1967 implementation and no upgradeTo in the code; only the manager can repoint chains.
- Ruled out: the old card's USD 126M escrow figure: not re-read here; only the bridge's ETH balance (3,473.9 ETH) was read. Sibling verifiers 0x0775…df81 and 0x455a…35ab are their own rows.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
