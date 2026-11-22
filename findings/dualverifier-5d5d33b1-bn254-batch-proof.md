---
id: dualverifier-5d5d33b1-bn254-batch-proof
format: 2
title: Quantum computer could forge the batch proofs this ZKsync verifier accepts
status: confirmed
severity: MEDIUM
justification: A forged proof could release a chain's bridged funds; a governance protocol upgrade can swap the
  verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5d5d33b16d9e79d9d9b8196ec760e70a31a44711'
  name: DualVerifier
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0x5d5d33b16d9e79d9d9b8196ec760e70a31a44711#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: funds-loss
action: Point every chain that uses this verifier at a hash-based proof verifier through a protocol upgrade of the
  chain type manager.
evidence_level: source
checks:
- id: route
  source: '0x5d5d33b16d9e79d9d9b8196ec760e70a31a44711'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  lines:
  - 51
  - 55
  has: uint256 verifierType = _proof[0]; if (verifierType == FFLONK_VERIFICATION_TYPE) { return FFLONK_VERIFIER.verify(_publicInputs,
    _extractProof(_proof)); } else if (verifierType == PLONK_VERIFICATION_TYPE) { return PLONK_VERIFIER.verify(_publicInputs,
    _extractProof(_proof));
  says: verify forwards the proof to the fflonk or the PLONK verifier by its first element
  for:
  - evidence-1
  - what
- id: ffimm
  call: '0x5d5d33b16d9e79d9d9b8196ec760e70a31a44711'
  fn: FFLONK_VERIFIER()(address)
  is: '0x870c0a2bd4f253dd867b2239a0d8d86f87d64128'
  says: the fflonk verifier, an immutable
  for:
  - evidence-1
- id: plimm
  call: '0x5d5d33b16d9e79d9d9b8196ec760e70a31a44711'
  fn: PLONK_VERIFIER()(address)
  is: '0x71ef07eb0bafe5342f7d9513fe7a544dc90b8001'
  says: the PLONK verifier, an immutable
  for:
  - evidence-1
- id: ffpair
  source: '0x870c0a2bd4f253dd867b2239a0d8d86f87d64128'
  file: contracts/state-transition/verifiers/EraVerifierFflonk.sol
  line: 1576
  has: let success := staticcall(gas(), 8, 0x80, mul(12, 0x20), 0x80, 0x20)
  says: the fflonk verifier ends in a call to the BN254 pairing precompile
  for:
  - evidence-1
  - what
- id: plpair
  source: '0x71ef07eb0bafe5342f7d9513fe7a544dc90b8001'
  file: contracts/state-transition/verifiers/EraVerifierPlonk.sol
  line: 1673
  has: let success := staticcall(gas(), 8, 0, 0x180, 0x00, 0x20)
  says: the PLONK verifier ends in a call to the BN254 pairing precompile
  for:
  - evidence-1
  - what
- id: plsetup
  source: '0x71ef07eb0bafe5342f7d9513fe7a544dc90b8001'
  file: contracts/state-transition/verifiers/EraVerifierPlonk.sol
  lines:
  - 249
  - 250
  has: // trusted setup g2 elements
  says: the pairing uses G2 points of a trusted setup
  for:
  - what
- id: verifier324
  call: '0x32400084c286cf3e17e7b677ea9583e60a000324'
  fn: getVerifier()(address)
  is: '0x5d5d33b16d9e79d9d9b8196ec760e70a31a44711'
  says: chain 324's diamond uses this verifier
  for:
  - action
  - evidence-2
  - what
- id: chain324
  call: '0x303a465b659cbb0ab36ee643ea362c509eeb5213'
  fn: getZKChain(uint256)(address)
  args:
  - 324
  is: '0x32400084c286cf3e17e7b677ea9583e60a000324'
  says: the Bridgehub lists this diamond as chain 324
  for:
  - notes
- id: v50104
  call: '0x05ede6ad1f39b7a16c949d5c33a0658c9c7241e3'
  fn: getVerifier()(address)
  is: '0x5d5d33b16d9e79d9d9b8196ec760e70a31a44711'
  says: chain 50104's diamond uses this verifier
  for:
  - what
- id: v2741
  call: '0x2edc71e9991a962c7fe172212d1aa9e50480fbb9'
  fn: getVerifier()(address)
  is: '0x5d5d33b16d9e79d9d9b8196ec760e70a31a44711'
  says: chain 2741's diamond uses this verifier
  for:
  - what
- id: v232
  call: '0xc29d04a93f893700015138e3e334eb828dac3cef'
  fn: getVerifier()(address)
  is: '0x5d5d33b16d9e79d9d9b8196ec760e70a31a44711'
  says: chain 232's diamond uses this verifier
  for:
  - what
- id: b50104
  call: '0x303a465b659cbb0ab36ee643ea362c509eeb5213'
  fn: getZKChain(uint256)(address)
  args:
  - 50104
  is: '0x05ede6ad1f39b7a16c949d5c33a0658c9c7241e3'
  says: the Bridgehub lists chain 50104's diamond
  for:
  - notes
- id: b2741
  call: '0x303a465b659cbb0ab36ee643ea362c509eeb5213'
  fn: getZKChain(uint256)(address)
  args:
  - 2741
  is: '0x2edc71e9991a962c7fe172212d1aa9e50480fbb9'
  says: the Bridgehub lists chain 2741's diamond
  for:
  - notes
- id: b232
  call: '0x303a465b659cbb0ab36ee643ea362c509eeb5213'
  fn: getZKChain(uint256)(address)
  args:
  - 232
  is: '0xc29d04a93f893700015138e3e334eb828dac3cef'
  says: the Bridgehub lists chain 232's diamond
  for:
  - notes
- id: verifycall
  source: '0x826729003e0b35c5343eb5bd19277b86ba2e7710'
  file: contracts/state-transition/chain-deps/facets/Executor.sol
  line: 296
  has: bool successVerifyProof = s.verifier.verify(proofPublicInput, _proof);
  says: the diamond's executor asks the chain's verifier to check each batch proof
  for:
  - evidence-2
  - justification
  - what
- id: execneedsproof
  source: '0x826729003e0b35c5343eb5bd19277b86ba2e7710'
  file: contracts/state-transition/chain-deps/facets/Executor.sol
  line: 224
  has: if (newTotalBatchesExecuted > s.totalBatchesVerified) {
  says: a batch is executed only after its proof was verified
  for:
  - what
- id: onlyvalidator
  source: '0x826729003e0b35c5343eb5bd19277b86ba2e7710'
  file: contracts/state-transition/chain-deps/facets/Executor.sol
  line: 241
  has: external nonReentrant onlyValidatorOrPriorityMode onlySettlementLayer
  says: proofs are submitted by a validator, or in priority mode by its permissionless validator
  for:
  - what
- id: logsroot
  source: '0x826729003e0b35c5343eb5bd19277b86ba2e7710'
  file: contracts/state-transition/chain-deps/facets/Executor.sol
  line: 108
  has: s.l2LogsRootHashes[currentBatchNumber] = _storedBatch.l2LogsTreeRoot;
  says: an executed batch stores the root of its L2-to-L1 logs, which withdrawals are proven against
  for:
  - what
- id: facetexec
  call: '0x32400084c286cf3e17e7b677ea9583e60a000324'
  fn: facetAddress(bytes4)(address)
  args:
  - '0x9271e450'
  is: '0x826729003e0b35c5343eb5bd19277b86ba2e7710'
  says: proveBatchesSharedBridge runs in this executor facet
  for:
  - notes
- id: batchesnow
  call: '0x32400084c286cf3e17e7b677ea9583e60a000324'
  fn: getTotalBatchesExecuted()(uint256)
  is: 520280
  says: chain 324 had executed 520,280 batches at the block
  for:
  - evidence-2
- id: batchesbefore
  call: '0x32400084c286cf3e17e7b677ea9583e60a000324'
  fn: getTotalBatchesExecuted()(uint256)
  at: 26400000
  is: 520021
  says: and 520,021 at block 26,400,000
  for:
  - evidence-2
- id: ntvwithdraw
  source: '0x5418e080b7c2cdc00b3bbbbed67fbd401a34ae68'
  file: contracts/bridge/ntv/L1NativeTokenVault.sol
  lines:
  - 328
  - 329
  has: 'function _handleBridgeFromChain(uint256 _chainId, bytes32 _assetId, uint256 _amount) internal override {
    l1AssetTracker.handleChainBalanceDecreaseOnL1({_chainId: _chainId, _assetId: _assetId, _amount: _amount});'
  says: a withdrawal from a chain is charged to that chain's balance in the vault
  for:
  - whose
- id: trackerdec
  source: '0x27f48ae3cc302b32d174d6e444bd7016da2e2a2f'
  file: contracts/bridge/asset-tracker/L1AssetTracker.sol
  line: 285
  has: _decreaseChainBalance(chainToUpdate, _assetId, _amount);
  says: the tracker lowers the chain's balance on a withdrawal
  for:
  - what
- id: decrease
  source: '0x27f48ae3cc302b32d174d6e444bd7016da2e2a2f'
  file: contracts/bridge/asset-tracker/AssetTrackerBase.sol
  lines:
  - 123
  - 124
  has: if (chainBalance[_chainId][_assetId] < _amount) { revert InsufficientChainBalance(_chainId, _assetId, _amount);
  says: withdrawals from a chain stop at that chain's recorded balance
  for:
  - justification
  - what
  - whose
- id: ntvimpl
  storage: '0xbed1eb542f9a5aa6419ff3deb921a372681111f6'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x0000000000000000000000005418e080b7c2cdc00b3bbbbed67fbd401a34ae68'
  says: the shared vault runs this implementation
  for:
  - notes
- id: atimpl
  storage: '0x7fd8b995fc27ad7de97853e65b17cacfc0a573cc'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x00000000000000000000000027f48ae3cc302b32d174d6e444bd7016da2e2a2f'
  says: the asset tracker runs this implementation
  for:
  - notes
- id: vault
  call: '0x8829ad80e425c646dab305381ff105169feece56'
  fn: nativeTokenVault()(address)
  is: '0xbed1eb542f9a5aa6419ff3deb921a372681111f6'
  says: the shared bridge's vault
  for:
  - notes
- id: tracker
  call: '0xbed1eb542f9a5aa6419ff3deb921a372681111f6'
  fn: l1AssetTracker()(address)
  is: '0x7fd8b995fc27ad7de97853e65b17cacfc0a573cc'
  says: the vault's asset tracker
  for:
  - notes
- id: ethid
  call: '0xbed1eb542f9a5aa6419ff3deb921a372681111f6'
  fn: assetId(address)(bytes32)
  args:
  - '0x0000000000000000000000000000000000000001'
  is: '0x05e1c3ae4b9732444ae25217ac7666e46fa365fee1768de00c9fcb65532b7609'
  says: the asset id of ETH
  for:
  - notes
- id: ethbal
  call: '0x7fd8b995fc27ad7de97853e65b17cacfc0a573cc'
  fn: chainBalance(uint256,bytes32)(uint256)
  args:
  - 324
  - '0x05e1c3ae4b9732444ae25217ac7666e46fa365fee1768de00c9fcb65532b7609'
  is: 35429353981944143599584
  says: chain 324's ETH balance in the vault is 35,429.35 ETH
  for:
  - justification
  - what
- id: vaulteth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xbed1eb542f9a5aa6419ff3deb921a372681111f6'
  is: 43203900084978521228369
  says: the vault holds 43,203.9 ETH for all chains
  for:
  - notes
- id: ctm
  call: '0x32400084c286cf3e17e7b677ea9583e60a000324'
  fn: getChainTypeManager()(address)
  is: '0xc2ee6b6af7d616f6e27ce7f4a451aedc2b0f5f5c'
  says: chain 324's chain type manager
  for:
  - action
  - evidence-3
- id: ctmowner
  call: '0xc2ee6b6af7d616f6e27ce7f4a451aedc2b0f5f5c'
  fn: owner()(address)
  is: '0xe30dca3047b37dc7d88849de4a4dc07937ad5ab3'
  says: the chain type manager's owner
  for:
  - action
  - evidence-3
  - justification
- id: council
  call: '0xe30dca3047b37dc7d88849de4a4dc07937ad5ab3'
  fn: securityCouncil()(address)
  is: '0x29d2e773a31c07d375c50f0110422832bd044d08'
  says: the owner names a security council
  for:
  - notes
- id: ctmimpl
  storage: '0xc2ee6b6af7d616f6e27ce7f4a451aedc2b0f5f5c'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x0000000000000000000000001bd52fdbcd714ffc48c7ce9e8437572102174734'
  says: the chain type manager runs this implementation
  for:
  - evidence-3
- id: ctmexec
  source: '0x1bd52fdbcd714ffc48c7ce9e8437572102174734'
  file: contracts/state-transition/ChainTypeManagerBase.sol
  lines:
  - 527
  - 528
  has: function executeUpgrade(uint256 _chainId, Diamond.DiamondCutData calldata _diamondCut) external onlyOwner
    { IZKChain(getZKChain(_chainId)).executeUpgrade(_diamondCut);
  says: the owner can execute a diamond upgrade on a chain
  for:
  - action
  - evidence-3
  - justification
- id: adminexec
  source: '0x9cfa4daedbf2cdabdbff3776ddd741e48380e6f2'
  file: contracts/state-transition/chain-deps/facets/Admin.sol
  lines:
  - 517
  - 518
  has: function executeUpgrade(Diamond.DiamondCutData calldata _diamondCut) external onlyChainTypeManager { _executeDiamondCut(_diamondCut);
  says: the chain applies a diamond cut sent by its chain type manager
  for:
  - action
  - evidence-3
  - justification
- id: facetadmin
  call: '0x32400084c286cf3e17e7b677ea9583e60a000324'
  fn: facetAddress(bytes4)(address)
  args:
  - '0x4dd18bf5'
  is: '0x9cfa4daedbf2cdabdbff3776ddd741e48380e6f2'
  says: the admin functions run in this facet
  for:
  - notes
- id: oldver
  call: '0x32400084c286cf3e17e7b677ea9583e60a000324'
  fn: getVerifier()(address)
  at: 25000000
  is: '0xcd279bd537c8e1a1acc46ac2205bebd8902f7a45'
  says: at block 25,000,000 the chain used another verifier
  for:
  - evidence-3
  - justification
- id: oldpv
  call: '0x32400084c286cf3e17e7b677ea9583e60a000324'
  fn: getProtocolVersion()(uint256)
  at: 25000000
  is: 124554051588
  says: protocol version then
  for:
  - evidence-3
- id: newpv
  call: '0x32400084c286cf3e17e7b677ea9583e60a000324'
  fn: getProtocolVersion()(uint256)
  is: 141733920768
  says: a higher protocol version at the block
  for:
  - evidence-3
- id: author
  source: '0x5d5d33b16d9e79d9d9b8196ec760e70a31a44711'
  file: contracts/state-transition/verifiers/DualVerifier.sol
  line: 10
  has: '@author Matter Labs'
  says: the verified source names Matter Labs, the ZKsync team
  for:
  - notes
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review06 (Claude), 2026-11-17 review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

ZKsync chain 324 and three others execute a batch only with a proof this contract approves, checked with BN254 pairings from a trusted setup. A quantum computer could recover the setup's secret, so a false batch from a validator would pass and release chain 324's 35,429 ETH in the shared vault.

## Evidence

- [verify](https://etherscan.io/address/0x5d5d33b16d9e79d9d9b8196ec760e70a31a44711#code) routes each proof to an fflonk or PLONK verifier fixed at deployment; both end in a BN254 pairing check.
- Chain 324's [diamond](https://etherscan.io/address/0x32400084c286cf3e17e7b677ea9583e60a000324) calls this verifier for every batch proof and executed 259 batches in the last 38,999 blocks.
- The chain's verifier was swapped in a protocol upgrade after block 25,000,000; the chain type manager's [owner](https://etherscan.io/address/0xe30dca3047b37dc7d88849de4a4dc07937ad5ab3) can push such upgrades.

## Reviewer notes

### Mechanism

DualVerifier.verify reads _proof[0] and forwards the rest to the immutable FFLONK_VERIFIER 0x870c0a2b (type 0) or PLONK_VERIFIER 0x71ef07eb (type 1). Both end in a staticcall to the BN254 pairing precompile 0x08 against hard-coded G2 setup points. The Era diamond 0x32400084 (chain 324, from Bridgehub 0x303a465b) calls s.verifier.verify in Executor._verifyProof from proveBatchesSharedBridge (onlyValidatorOrPriorityMode); executeBatches needs the batch verified and stores its L2 logs root, against which withdrawals are proven. Withdrawals from the chain go through L1NativeTokenVault._handleBridgeFromChain into L1AssetTracker.handleChainBalanceDecreaseOnL1, which reverts above the chain's recorded balance (35,429.35 ETH for chain 324 at the block; tokens not read). The chain type manager 0xc2ee6b6a (implementation 0x1bd52fdb) is owned by 0xe30dca30; its executeUpgrade (onlyOwner) calls the diamond's Admin.executeUpgrade (onlyChainTypeManager), a diamond cut that can set a new verifier. Between block 25,000,000 and 26,438,999 the chain's verifier changed from 0xcd279bd5 to this address while its protocol version rose.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: unused code: chain 324's diamond and chains 50104, 2741 and 232 return this address from getVerifier at the block, and chain 324 executed 259 batches between blocks 26,400,000 and 26,438,999.
- Ruled out: a proof bypass: proveBatchesSharedBridge always calls _verifyProof, and execution requires the batch to be verified (Executor lines 224 and 283).
- Ruled out: a guess about who can replace the verifier: the chain type manager's owner can execute a diamond cut on the chain, and the verifier was in fact replaced after block 25,000,000; the owner 0xe30dca30 reports security council 0x29d2e773, but its upgrade rules were not read, so the card says only that the owner can push upgrades.
- Ruled out: an attacker without a validator role: batches are proved only by validators (or the permissionless validator in priority mode); a forger also needs that role, which this card does not claim to break.
- Ruled out: value: this address holds nothing; the funds at stake are chain 324's account in the shared vault 0xbed1eb54, of which only ETH was read; the other three chains' balances are not on this card.
- Ruled out: the old card's 22-chain and USD 127M figures cover other verifiers and the whole vault, and are not repeated here.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
