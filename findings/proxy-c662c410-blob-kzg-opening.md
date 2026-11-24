---
id: proxy-c662c410-blob-kzg-opening
format: 2
title: Starknet's core trusts blob data to a KZG check a quantum computer can fool
status: confirmed
severity: LOW
justification: Calldata data availability already exists and nothing can be taken through this check; it can only
  freeze exits.
category: quantum-exposure
pattern: PQ-8
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc662c410c0ecf747543f5ba90660f6abebd9c8c4'
  name: Proxy
  project: starknet
  code: verified
  code_url: https://etherscan.io/address/0x73352c6228ec1dcf737973db9822bb8e8a465c99#code
  proxy_of: '0x73352c6228ec1dcf737973db9822bb8e8a465c99'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 59
  whose: operator
  basis: held
activity: {}
impact: funds-locked
action: Upgrade the core through its governing Safe to remove the blob path before KZG's trusted setup can be broken.
evidence_level: source
checks:
- id: impl-slot
  storage: '0xc662c410c0ecf747543f5ba90660f6abebd9c8c4'
  slot: '0x177667240aeeea7e35eabe3a35e18306f336219e1386f7710a6bf8783f761b24'
  is: '0x00000000000000000000000073352c6228ec1dcf737973db9822bb8e8a465c99'
  says: the proxy's implementation slot holds 0x73352c62...
  for:
  - proxy_of
  - what
- id: impl-call
  call: '0xc662c410c0ecf747543f5ba90660f6abebd9c8c4'
  fn: implementation()(address)
  is: '0x73352c6228ec1dcf737973db9822bb8e8a465c99'
  says: the proxy reports 0x73352c62... as its implementation
  for:
  - proxy_of
- id: kzg-path
  source: '0x73352c6228ec1dcf737973db9822bb8e8a465c99'
  file: Starknet.sol
  lines:
  - 479
  - 494
  has: verifyKzgProofs(programOutput[StarknetOutput.HEADER_SIZE:], kzgProofs); bytes32 stateTransitionFact = OnchainDataFactTreeEncoder.hashMainPublicInput(programOutput);
  says: updateStateKzgDA checks the blobs by KZG and then proves only the program output
  for:
  - evidence-1
  - justification
  - what
- id: from-output
  source: '0x73352c6228ec1dcf737973db9822bb8e8a465c99'
  file: Starknet.sol
  line: 252
  has: bytes32 z = bytes32(programOutputSlice[StarknetOutput.KZG_Z_OFFSET]);
  says: the evaluation point comes from the proven program output, as do the commitments and values in the lines
    after
  for:
  - what
- id: kzg-call
  source: '0x73352c6228ec1dcf737973db9822bb8e8a465c99'
  file: Starknet.sol
  lines:
  - 295
  - 302
  has: .staticcall(abi.encodePacked(blobHash, z, y, kzgCommitment, kzgProofs[blobIndex])); require(ok, "POINT_EVALUATION_PRECOMPILE_CALL_FAILED");
  says: each blob is opened at z to y through the point-evaluation precompile
  for:
  - evidence-1
  - what
- id: precompile-addr
  source: '0x73352c6228ec1dcf737973db9822bb8e8a465c99'
  file: Starknet.sol
  line: 86
  has: POINT_EVALUATION_PRECOMPILE_ADDRESS = address(0x0A);
  says: the call goes to the KZG point-evaluation precompile
  for:
  - evidence-1
  - what
- id: proof-check
  source: '0x73352c6228ec1dcf737973db9822bb8e8a465c99'
  file: Starknet.sol
  line: 342
  has: require(IFactRegistry(verifier()).isValid(sharpFact), "NO_STATE_TRANSITION_PROOF");
  says: every state update still needs a fact accepted by the verifier
  for:
  - notes
- id: verifier
  call: '0x47312450b3ac8b5b8e247a6bb6d523e7605bdb60'
  fn: identify()(string)
  is: StarkWare_GpsStatementVerifier_2026_14
  says: the verifier the core reads from its named slot is StarkWare's statement verifier
  for:
  - notes
- id: verifier-slot
  storage: '0xc662c410c0ecf747543f5ba90660f6abebd9c8c4'
  slot: '0x04e7be39f2fb63cfd7d4fcfe19f108bc6b411ed972d99fca0a47dcaff878ce5e'
  is: '0x00000000000000000000000047312450b3ac8b5b8e247a6bb6d523e7605bdb60'
  says: the core's verifier slot holds 0x47312450...
  for:
  - notes
- id: calldata-path
  source: '0x73352c6228ec1dcf737973db9822bb8e8a465c99'
  file: Starknet.sol
  lines:
  - 443
  - 456
  has: uint256 onchainDataSize ) external onlyOperator {
  says: updateState, open to the same operators, takes only a hash and a size of the state data
  for:
  - action
  - evidence-1
- id: calldata-flag
  source: '0x73352c6228ec1dcf737973db9822bb8e8a465c99'
  file: Starknet.sol
  line: 456
  has: require(programOutput[StarknetOutput.USE_KZG_DA_OFFSET] == 0, "UNEXPECTED_KZG_DA_FLAG");
  says: updateState is the path without blobs
  for:
  - justification
- id: only-operator
  source: '0x73352c6228ec1dcf737973db9822bb8e8a465c99'
  file: MOperator.sol
  line: 28
  has: require(isOperator(msg.sender), "ONLY_OPERATOR");
  says: only registered operators can post state updates
  for:
  - justification
  - what
- id: operator
  call: '0xc662c410c0ecf747543f5ba90660f6abebd9c8c4'
  fn: isOperator(address)(bool)
  args:
  - '0x2c169dfe5fbba12957bdd0ba47d9cedbfe260ca7'
  is: 'true'
  says: 0x2c169dfe... is an operator
  for:
  - evidence-2
- id: kzg-tx
  tx: '0x417aa51c6daa91c85475b8a578fdf7e9a286ff8bb58f3418fd588f11a49c1d34'
  to: '0xc662c410c0ecf747543f5ba90660f6abebd9c8c4'
  ok: true
  says: a state update to the core succeeded in block 26,438,554
  for:
  - evidence-2
- id: upgrade-fn
  source: '0xc662c410c0ecf747543f5ba90660f6abebd9c8c4'
  file: Proxy.sol
  lines:
  - 282
  - 294
  has: setImplementation(newImplementation);
  says: governors can switch the implementation with upgradeTo
  for:
  - action
  - justification
  - upgradeable
- id: proxy-governor
  call: '0xc662c410c0ecf747543f5ba90660f6abebd9c8c4'
  fn: proxyIsGovernor(address)(bool)
  args:
  - '0x15e8c684fd095d4796a0c0cf678554f4c1c7c361'
  is: 'true'
  says: the Safe 0x15e8c684... governs the proxy
  for:
  - action
  - justification
  - upgradeable
- id: starknet-governor
  call: '0xc662c410c0ecf747543f5ba90660f6abebd9c8c4'
  fn: starknetIsGovernor(address)(bool)
  args:
  - '0x15e8c684fd095d4796a0c0cf678554f4c1c7c361'
  is: 'true'
  says: the same Safe governs the Starknet contract (operators, settings)
  for:
  - notes
- id: safe-threshold
  call: '0x15e8c684fd095d4796a0c0cf678554f4c1c7c361'
  fn: getThreshold()(uint256)
  is: '9'
  says: the governor Safe needs 9 signatures
  for:
  - action
  - justification
- id: no-delay
  call: '0xc662c410c0ecf747543f5ba90660f6abebd9c8c4'
  fn: getUpgradeActivationDelay()(uint256)
  is: '0'
  says: an upgrade has no waiting time
  for:
  - action
  - justification
  - upgradeable
- id: not-finalized
  call: '0xc662c410c0ecf747543f5ba90660f6abebd9c8c4'
  fn: isNotFinalized()(bool)
  is: 'true'
  says: the proxy is not finalized, so upgradeTo is open
  for:
  - action
  - justification
  - upgradeable
- id: bridge-core
  storage: '0xae0ee0a63a2ce6baeeffe56e7714fb4efe48d419'
  slot: '0x07bee3e08d8b381832be13352dae8ff3b74d9e088d726a20e7707fc558b5d615'
  is: '0x000000000000000000000000c662c410c0ecf747543f5ba90660f6abebd9c8c4'
  says: the ETH bridge's messaging-contract slot (keccak of STARKNET_TOKEN_BRIDGE_MESSAGING_CONTRACT) holds this
    core
  for:
  - what
- id: identify
  call: '0xc662c410c0ecf747543f5ba90660f6abebd9c8c4'
  fn: identify()(string)
  is: StarkWare_Starknet_2026_12
  says: the code behind the proxy is StarkWare's Starknet core
  for:
  - notes
- id: encoder-da
  source: '0x73352c6228ec1dcf737973db9822bb8e8a465c99'
  file: OnchainDataFactTreeEncoder.sol
  line: 46
  has: so we are only given its hash and length
  says: updateState's data is posted elsewhere; the core receives only its hash and length
  for:
  - action
  - evidence-1
- id: operator-eoa
  code: '0x2c169dfe5fbba12957bdd0ba47d9cedbfe260ca7'
  is: empty
  says: the operator 0x2c169dfe... is a plain account with no code
  for:
  - notes
- id: bridge-id
  call: '0xae0ee0a63a2ce6baeeffe56e7714fb4efe48d419'
  fn: identify()(string)
  is: StarkWare_StarknetEthBridge_2.0_4
  says: 0xae0ee0a6... is StarkWare's Starknet ETH bridge
  for:
  - what
- id: bridge-eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xae0ee0a63a2ce6baeeffe56e7714fb4efe48d419'
  is: '16932708452201570536036'
  says: the ETH bridge holds 16,932.7 ETH
  for:
  - what
- id: fee-held
  source: '0x73352c6228ec1dcf737973db9822bb8e8a465c99'
  file: Starknet.sol
  lines:
  - 355
  - 356
  has: // The held L1->L2 message fee will be sent to the collector address.
  says: the ETH the core holds is L1-to-L2 message fees, sent to the fee collector when the message is processed
  for:
  - whose
- id: fee-no-refund
  source: '0x73352c6228ec1dcf737973db9822bb8e8a465c99'
  file: StarknetMessaging.sol
  lines:
  - 237
  - 248
  has: l1ToL2Messages()[msgHash] = 0;
  says: cancelling a message clears it without refunding the fee
  for:
  - whose
- id: prog-setter
  source: '0x73352c6228ec1dcf737973db9822bb8e8a465c99'
  file: Starknet.sol
  lines:
  - 94
  - 110
  has: function setProgramHash(uint256 newProgramHash) external notFinalized onlyGovernance {
  says: governance can set the OS and aggregator program hashes while the contract is not finalized
  for:
  - justification
- id: starknet-not-finalized
  call: '0xc662c410c0ecf747543f5ba90660f6abebd9c8c4'
  fn: isFinalized()(bool)
  is: 'false'
  says: the Starknet contract is not finalized, so the program hash setters are open
  for:
  - notes
- id: prog-now
  call: '0xc662c410c0ecf747543f5ba90660f6abebd9c8c4'
  fn: programHash()(uint256)
  is: '569015423733809580615518794546253350390163920370934709723320624838312178729'
  says: the OS program hash the core accepts at the block
  for:
  - notes
- id: prog-2024
  call: '0xc662c410c0ecf747543f5ba90660f6abebd9c8c4'
  fn: programHash()(uint256)
  at: 19000000
  is: '2479841346739966073527450029179698923866252973805981504232089731754042431018'
  says: before blobs (block 19,000,000) the core accepted another program hash
  for:
  - notes
- id: impl-2024
  call: '0x16938e4b59297060484fa56a12594d8d6f4177e8'
  fn: identify()(string)
  at: 19000000
  is: StarkWare_Starknet_2023_6
  says: the implementation at block 19,000,000 was StarkWare_Starknet_2023_6
  for:
  - notes
- id: impl-2024-slot
  call: '0xc662c410c0ecf747543f5ba90660f6abebd9c8c4'
  fn: implementation()(address)
  at: 19000000
  is: '0x16938e4b59297060484fa56a12594d8d6f4177e8'
  says: the proxy ran 0x16938e4b... at block 19,000,000
  for:
  - notes
- id: old-no-kzg
  selector: '0x16938e4b59297060484fa56a12594d8d6f4177e8'
  fn: updateStateKzgDA(uint256[],bytes[])
  absent: true
  at: 19000000
  says: the pre-blob implementation had no blob path
  for:
  - notes
- id: cur-header
  source: '0x73352c6228ec1dcf737973db9822bb8e8a465c99'
  file: Output.sol
  lines:
  - 51
  - 55
  has: uint256 internal constant HEADER_SIZE = 10;
  says: this implementation reads a 10-word output header with the program hash, config hash and KZG flag at words
    6-8
  for:
  - justification
- id: old-header
  ref: https://github.com/starkware-libs/cairo-lang/blob/70fbe1d2e1a68954ee8bd2b24cf3ca299e855caa/src/starkware/starknet/solidity/Output.sol#L29-L33
  says: the pre-blob OS output (v0.12.3) had a 5-word header
  for:
  - justification
- id: os-flag-14
  ref: https://github.com/starkware-libs/cairo-lang/blob/6d99011f6ef2a3dc178f7c8db4f0ddc6e836f303/src/starkware/starknet/core/os/os.cairo#L114-L123
  says: in OS v0.14.0 use_kzg_da is a nondeterministic value the prover chooses
  for:
  - justification
- id: os-flag-131
  ref: https://github.com/starkware-libs/cairo-lang/blob/efa9648f57568aad8f8a13fbf027d2de7c63c2c0/src/starkware/starknet/core/os/os.cairo#L124
  says: in OS v0.13.1, the first with blobs, use_kzg_da is a nondeterministic value the prover chooses
  for:
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review01)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews:
- who: r-c662c410, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: 'kept: Kev''s first-study finding (old LOW), LOW (PQ-8): Starknet''s core binds blob-DA state updates to
    the proven output only through a KZG point-evaluation opening, so the setup trapdoor plus an operator key could
    post a proven state whose data the blob lacks; calldata data availability (updateState) already exists and is
    usable with the OS in force, and nothing can be taken through the check (exits can only freeze): the rubric''s
    LOW row. Claude''s earlier MEDIUM feedback misread the rubric and was reversed. Final card: a fresh refuter
    agrees; the refuter whose LOW reading it applies agreed on every other part. Claude read the sheet.'
related: []
---

## What happens

Starknet's core accepts state updates with data in blobs, tied to the proven state only by a KZG opening. With the setup's trapdoor, an operator can post a proven state without its data, which nobody else can then rebuild. The ETH bridge that takes its messages from this core holds 16,932.7 ETH.

## Evidence

- [updateStateKzgDA](https://etherscan.io/address/0x73352c6228ec1dcf737973db9822bb8e8a465c99#code) opens each blob by KZG; updateState gets only a hash and size of data posted elsewhere.
- [An operator's state update](https://etherscan.io/tx/0x417aa51c6daa91c85475b8a578fdf7e9a286ff8bb58f3418fd588f11a49c1d34) in block 26,438,554 uses the blob path.

## Reviewer notes

### Mechanism

The proxy runs 0x73352c62... (slot 0x1776...1b24; StarkWare_Starknet_2026_12). updateStateKzgDA (Starknet.sol 479-501, onlyOperator) requires USE_KZG_DA == 1, calls verifyKzgProofs (247-304) and then sets the fact to hashMainPublicInput(programOutput) (494). verifyKzgProofs takes z, the commitments and y from the proven program output (252-291), reads blobhash(i), and staticcalls 0x0A (86, 295-302) requiring the fixed success output. The blob content is tied to the proven output only by that opening. With the setup trapdoor an opening of the real blob commitment to any y passes, so a state whose diff is not in the blob is accepted. updateStateInternal (315-380) still requires IFactRegistry(verifier()).isValid(sharpFact) (342); the verifier at the named slot is 0x47312450... (StarkWare_GpsStatementVerifier_2026_14). updateState (443-468, onlyOperator) requires USE_KZG_DA == 0, binding only a hash and size of data posted elsewhere (OnchainDataFactTreeEncoder 34-64). Both paths stay open to every operator; which one runs is the operator's own choice, proven either way, so only an upgrade removes the blob path. The Safe governing both proxy and Starknet (0x15e8c684..., 9 of 12) can upgradeTo (Proxy.sol 282-316, notFinalized notFrozen) with no activation delay. The cited tx calls updateStateKzgDA (0x507ee528) from operator 0x2c169dfe....

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: wrong code: slot 0x1776...1b24 and implementation() both give 0x73352c62..., the source the card cites.
- Ruled out: path closed: the blob path is in use at the block (tx in block 26,438,554), the contract is not frozen or finalized.
- Ruled out: theft through the opening: the update still needs a fact accepted by the statement verifier (line 342); a forged opening withholds data, it does not change what the proof allows.
- Ruled out: copies: the dossier lists none; Paradex's core is a separate row.
- Ruled out: updateState as a fix: no, updateStateKzgDA stays callable by any operator; operator 0x2c169dfe... has no code, so its key is forgeable too (not rated here).
- Ruled out: bridge funds: 16,932.7 ETH sit in the ETH bridge 0xae0ee0a6..., not here; this core's own ETH is held message fees (not refunded on cancel).
- Ruled out: a fix by setProgramHash (notFinalized onlyGovernance, isFinalized() false): no usable hash closes the path. Since OS v0.13.1, use_kzg_da is a prover choice, not fixed by the program hash (os.cairo v0.13.1:124, v0.14.0:115-123); the pre-blob program (block 19,000,000, StarkWare_Starknet_2023_6) emitted a 5-word header (Output.sol v0.12.3:33) this 10-word reader rejects (Output.sol 51-55), so it cannot run today's chain. Closing the path needs a new OS build, a release, not a setting.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
