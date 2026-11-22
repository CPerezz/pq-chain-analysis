---
id: rollupl1davalidator-1c715018-blob-kzg-opening
format: 2
title: Four ZK chains accept blob data for their batches on a KZG opening
status: confirmed
severity: LOW
justification: 'A calldata path without KZG is already in the contract, and the check returns hashes: nothing is
  taken through it.'
category: quantum-exposure
pattern: PQ-8
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1c715018c5565eacc758236d4a9a760162a84cbd'
  name: RollupL1DAValidator
  code: verified
  code_url: https://etherscan.io/address/0x1c715018c5565eacc758236d4a9a760162a84cbd#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: funds-locked
action: Commit batches with the calldata source, which this contract checks without KZG, once the KZG setup is at
  risk.
evidence_level: source
checks:
- id: kzg-call
  source: '0x1c715018c5565eacc758236d4a9a760162a84cbd'
  file: contracts/RollupL1DAValidator.sol
  line: 189
  has: POINT_EVALUATION_PRECOMPILE_ADDR.staticcall(precompileInput)
  says: the blob opening is checked by a call to the point-evaluation precompile
  for:
  - evidence-1
  - what
- id: kzg-required
  source: '0x1c715018c5565eacc758236d4a9a760162a84cbd'
  file: contracts/RollupL1DAValidator.sol
  lines:
  - 193
  - 199
  has: if (result != BLS_MODULUS) {
  says: the call reverts unless the precompile succeeds and returns the BLS modulus
  for:
  - evidence-1
  - what
- id: precompile-addr
  source: '0x1c715018c5565eacc758236d4a9a760162a84cbd'
  file: contracts/DAUtils.sol
  line: 34
  has: address constant POINT_EVALUATION_PRECOMPILE_ADDR = address(0x0A);
  says: the precompile called is 0x0a, the KZG point evaluation
  for:
  - evidence-1
  - what
- id: blob-branch
  source: '0x1c715018c5565eacc758236d4a9a760162a84cbd'
  file: contracts/RollupL1DAValidator.sol
  lines:
  - 76
  - 77
  has: blobCommitments = _processBlobDA(
  says: checkDA takes the blob path when the committer's input names the blob source
  for:
  - evidence-1
  - what
- id: blob-opening
  source: '0x1c715018c5565eacc758236d4a9a760162a84cbd'
  file: contracts/RollupL1DAValidator.sol
  line: 162
  has: blobsCommitments[i] = _getPublishedBlobCommitment(versionedHashIndex, commitmentData);
  says: each blob not published earlier is bound to the batch through the KZG opening
  for:
  - what
- id: calldata-branch
  source: '0x1c715018c5565eacc758236d4a9a760162a84cbd'
  file: contracts/RollupL1DAValidator.sol
  lines:
  - 78
  - 79
  has: _processCalldataDA(
  says: checkDA takes the calldata path when the committer's input names the calldata source
  for:
  - action
  - evidence-2
  - justification
  - what
- id: calldata-pure
  source: '0x1c715018c5565eacc758236d4a9a760162a84cbd'
  file: contracts/CalldataDA.sol
  lines:
  - 86
  - 91
  has: internal pure virtual
  says: the calldata check is a pure function, so it calls no precompile
  for:
  - action
  - evidence-2
  - justification
  - what
- id: calldata-hash
  source: '0x1c715018c5565eacc758236d4a9a760162a84cbd'
  file: contracts/CalldataDA.sol
  line: 109
  has: if (_fullPubdataHash != keccak256(_pubdata)) {
  says: the calldata path checks the full data against its expected keccak hash
  for:
  - action
  - evidence-2
  - justification
  - what
- id: calldata-limit
  source: '0x1c715018c5565eacc758236d4a9a760162a84cbd'
  file: contracts/CalldataDA.sol
  lines:
  - 92
  - 108
  has: if (_pubdata.length > BLOB_SIZE_BYTES) {
  says: the calldata path takes one blob's worth of data per batch at most
  for:
  - notes
- id: view-only
  source: '0x1c715018c5565eacc758236d4a9a760162a84cbd'
  file: contracts/RollupL1DAValidator.sol
  lines:
  - 58
  - 64
  has: external view returns (L1DAValidatorOutput memory output)
  says: checkDA is a view function that returns hashes; it moves nothing
  for:
  - justification
- id: setter-routed
  call: '0x32400084c286cf3e17e7b677ea9583e60a000324'
  fn: facetAddress(bytes4)(address)
  args:
  - '0x2765d079'
  is: '0x9cfa4daedbf2cdabdbff3776ddd741e48380e6f2'
  says: the chain-324 diamond routes selector 0x2765d079, setDAValidatorPair(address,uint8), to a facet
  for:
  - notes
- id: admin-324
  call: '0x32400084c286cf3e17e7b677ea9583e60a000324'
  fn: getAdmin()(address)
  is: '0x2cf3bd6a9056b39999f3883955e183f655345063'
  says: the admin of the chain-324 diamond
  for:
  - notes
- id: admin-324-owner
  call: '0x2cf3bd6a9056b39999f3883955e183f655345063'
  fn: owner()(address)
  is: '0x4e4943346848c4867f81dfb37c4ca9c5715a7828'
  says: the owner of that admin contract
  for:
  - notes
- id: chain-324
  call: '0x303a465b659cbb0ab36ee643ea362c509eeb5213'
  fn: getZKChain(uint256)(address)
  args:
  - 324
  is: '0x32400084c286cf3e17e7b677ea9583e60a000324'
  says: the Bridgehub registry names this diamond for chain id 324
  for:
  - evidence-3
  - what
- id: used-324
  call: '0x32400084c286cf3e17e7b677ea9583e60a000324'
  fn: getDAValidatorPair()(address,address)
  is:
  - '0x1c715018c5565eacc758236d4a9a760162a84cbd'
  - '0x0000000000000000000000000000000000000003'
  says: the chain-324 diamond names this contract as its L1 data validator
  for:
  - evidence-3
  - what
- id: chain-50104
  call: '0x303a465b659cbb0ab36ee643ea362c509eeb5213'
  fn: getZKChain(uint256)(address)
  args:
  - 50104
  is: '0x05ede6ad1f39b7a16c949d5c33a0658c9c7241e3'
  says: the Bridgehub registry names this diamond for chain id 50104
  for:
  - what
- id: used-50104
  call: '0x05ede6ad1f39b7a16c949d5c33a0658c9c7241e3'
  fn: getDAValidatorPair()(address,address)
  is:
  - '0x1c715018c5565eacc758236d4a9a760162a84cbd'
  - '0x0000000000000000000000000000000000000003'
  says: the chain-50104 diamond names this contract as its L1 data validator
  for:
  - what
- id: chain-2741
  call: '0x303a465b659cbb0ab36ee643ea362c509eeb5213'
  fn: getZKChain(uint256)(address)
  args:
  - 2741
  is: '0x2edc71e9991a962c7fe172212d1aa9e50480fbb9'
  says: the Bridgehub registry names this diamond for chain id 2741
  for:
  - what
- id: used-2741
  call: '0x2edc71e9991a962c7fe172212d1aa9e50480fbb9'
  fn: getDAValidatorPair()(address,address)
  is:
  - '0x1c715018c5565eacc758236d4a9a760162a84cbd'
  - '0x0000000000000000000000000000000000000003'
  says: the chain-2741 diamond names this contract as its L1 data validator
  for:
  - what
- id: chain-232
  call: '0x303a465b659cbb0ab36ee643ea362c509eeb5213'
  fn: getZKChain(uint256)(address)
  args:
  - 232
  is: '0xc29d04a93f893700015138e3e334eb828dac3cef'
  says: the Bridgehub registry names this diamond for chain id 232
  for:
  - what
- id: used-232
  call: '0xc29d04a93f893700015138e3e334eb828dac3cef'
  fn: getDAValidatorPair()(address,address)
  is:
  - '0x1c715018c5565eacc758236d4a9a760162a84cbd'
  - '0x0000000000000000000000000000000000000003'
  says: the chain-232 diamond names this contract as its L1 data validator
  for:
  - what
- id: bridgehub
  call: '0x32400084c286cf3e17e7b677ea9583e60a000324'
  fn: getBridgehub()(address)
  is: '0x303a465b659cbb0ab36ee643ea362c509eeb5213'
  says: the chain-324 diamond itself names the registry that the chain-id reads use
  for:
  - what
- id: settles-324
  call: '0x303a465b659cbb0ab36ee643ea362c509eeb5213'
  fn: settlementLayer(uint256)(uint256)
  args:
  - 324
  is: 1
  says: chain 324 settles on Ethereum (chain id 1), so its diamond here is the one in use
  for:
  - what
- id: settles-50104
  call: '0x303a465b659cbb0ab36ee643ea362c509eeb5213'
  fn: settlementLayer(uint256)(uint256)
  args:
  - 50104
  is: 1
  says: chain 50104 settles on Ethereum (chain id 1), so its diamond here is the one in use
  for:
  - what
- id: settles-2741
  call: '0x303a465b659cbb0ab36ee643ea362c509eeb5213'
  fn: settlementLayer(uint256)(uint256)
  args:
  - 2741
  is: 1
  says: chain 2741 settles on Ethereum (chain id 1), so its diamond here is the one in use
  for:
  - what
- id: settles-232
  call: '0x303a465b659cbb0ab36ee643ea362c509eeb5213'
  fn: settlementLayer(uint256)(uint256)
  args:
  - 232
  is: 1
  says: chain 232 settles on Ethereum (chain id 1), so its diamond here is the one in use
  for:
  - what
- id: safe-threshold
  call: '0x4e4943346848c4867f81dfb37c4ca9c5715a7828'
  fn: getThreshold()(uint256)
  is: 4
  says: the owner of the chain-324 admin contract is a Safe that needs four signatures
  for:
  - notes
- id: vault
  call: '0x8829ad80e425c646dab305381ff105169feece56'
  fn: nativeTokenVault()(address)
  is: '0xbed1eb542f9a5aa6419ff3deb921a372681111f6'
  says: the shared bridge's vault
  for:
  - what
  - whose
- id: tracker
  call: '0xbed1eb542f9a5aa6419ff3deb921a372681111f6'
  fn: l1AssetTracker()(address)
  is: '0x7fd8b995fc27ad7de97853e65b17cacfc0a573cc'
  says: the vault's asset tracker
  for:
  - what
  - whose
- id: ethbal
  call: '0x7fd8b995fc27ad7de97853e65b17cacfc0a573cc'
  fn: chainBalance(uint256,bytes32)(uint256)
  args:
  - 324
  - '0x05e1c3ae4b9732444ae25217ac7666e46fa365fee1768de00c9fcb65532b7609'
  is: 35429353981944143599584
  says: chain 324's ETH balance in the vault is 35,429.35 ETH
  for:
  - what
  - whose
- id: vaulteth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xbed1eb542f9a5aa6419ff3deb921a372681111f6'
  is: 43203900084978521228369
  says: the vault holds 43,203.9 ETH for all chains
  for:
  - what
  - whose
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

Four ZK rollup chains (ids 324, 50104, 2741, 232) ask this contract whether a batch's data was published. For blobs it trusts a KZG opening. With the KZG setup broken, a batch committer could pass unpublished data, locking users' deposits in the shared vault. A calldata path uses no KZG.

## Evidence

- The blob path of [checkDA](https://etherscan.io/address/0x1c715018c5565eacc758236d4a9a760162a84cbd#code) calls the point-evaluation precompile at 0x0a and reverts unless it succeeds (lines 189-199).
- The calldata path of the [same contract](https://etherscan.io/address/0x1c715018c5565eacc758236d4a9a760162a84cbd#code) compares the keccak hash of the full data and calls no precompile.
- The rollup contract of chain 324, [0x3240…0324](https://etherscan.io/address/0x32400084c286cf3e17e7b677ea9583e60a000324), names this contract as its data validator.

## Reviewer notes

### Mechanism

checkDA (RollupL1DAValidator.sol, lines 58-99) is a view called with a batch's DA input; byte 0 of the operator part picks Blob (line 76) or Calldata (line 78). Blob: _processBlobDA (132-176) -> _getPublishedBlobCommitment (105-126) -> _pointEvaluationPrecompile (182-200), a staticcall to 0x0a that must return the BLS modulus; the output keccak(versionedHash, point, value) goes back to the diamond as blobsOpeningCommitments. publishBlobs (29-47, open to anyone) pre-registers commitments through the same opening. A forged opening lets the returned commitment stand for data that is not in the blob. Calldata: _processCalldataDA (CalldataDA.sol 86-113) is pure, checks keccak(pubdata) and allows one blob's worth (126,976 bytes) per batch. The contract has no storage besides publishedBlobCommitments, no owner, holds nothing. At the block the diamonds of chains 324, 50104, 2741 and 232 return it from getDAValidatorPair() with scheme 3. The chain-324 diamond routes setDAValidatorPair(address,uint8) to a facet; its admin is 0x2cf3…5063, owned by 0x4e49…7828 (a 4-of-7 Safe by getThreshold/getOwners). The facet's source is not in the dossier, so the card does not rest on that setter.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: the address not being in use: four diamonds return it from getDAValidatorPair() at the block; the registry the chain-324 diamond names (getBridgehub) lists them and gives settlementLayer 1 for each.
- Ruled out: a proxy or other code: no delegatecall, verified name RollupL1DAValidator, and the precompile call is in this contract itself (line 189), not in a child.
- Ruled out: something being taken through the check: checkDA is a view that returns three hash fields; the state transition is proven elsewhere (the diamonds' verifier, not read here).
- Ruled out: setDAValidatorPair(address,address): not routed on the chain-324 diamond (facetAddress returns zero); the routed selector is 0x2765d079, setDAValidatorPair(address,uint8).
- Ruled out: whether the four chains post blobs or calldata today: the dossier has no transactions for this address and logs cannot be read; the card says what the code accepts.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
