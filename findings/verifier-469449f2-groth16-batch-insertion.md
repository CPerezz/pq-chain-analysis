---
id: verifier-469449f2-groth16-batch-insertion
format: 2
title: World ID group 2 tree updates trust a proof a quantum computer can forge
status: candidate
severity: LOW
justification: A forged proof sets any group 2 root; the owner Safe fixes the verifier and the operator by settings
  alone.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x469449f251692e0779667583026b5a1e99512157'
  name: Verifier
  project: worldcoin
  code: verified
  code_url: https://etherscan.io/address/0x469449f251692e0779667583026b5a1e99512157#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity: {}
action: Point batch size 100 at a post-quantum verifier with updateVerifier, and move the operator with setIdentityOperator.
evidence_level: source
checks:
- id: pair
  source: '0x469449f251692e0779667583026b5a1e99512157'
  file: src/verifiers/insertion/b100.sol
  lines:
  - 552
  - 555
  has: success := staticcall(gas(), PRECOMPILE_VERIFY, f, 0x300, f, 0x20)
  says: verifyProof accepts a proof when one BN254 pairing check passes
  for:
  - evidence-1
  - justification
  - what
- id: vk
  source: '0x469449f251692e0779667583026b5a1e99512157'
  file: src/verifiers/insertion/b100.sol
  lines:
  - 83
  - 85
  has: uint256 constant DELTA_NEG_X_0 =
  says: the Groth16 verification key is a set of constants in the code
  for:
  - evidence-1
  - what
- id: sel
  selector: '0x469449f251692e0779667583026b5a1e99512157'
  fn: verifyProof(uint256[8],uint256[1])
  says: the deployed code has verifyProof(uint256[8],uint256[1])
  for:
  - evidence-1
- id: lut
  call: '0x54aef6aba7e27e3b3698549449596e0f251962c4'
  fn: getVerifierFor(uint256)(address)
  args:
  - 100
  is: '0x469449f251692e0779667583026b5a1e99512157'
  says: group 2's insertion table returns this verifier for batches of 100
  for:
  - evidence-2
  - what
- id: mgrtable
  call: '0x5fb49f5b63421bd43c72f3a9d23547e977c63285'
  fn: getRegisterIdentitiesVerifierLookupTableAddress()(address)
  is: '0x54aef6aba7e27e3b3698549449596e0f251962c4'
  says: the group 2 manager uses that insertion table
  for:
  - evidence-2
  - what
- id: impl
  storage: '0x5fb49f5b63421bd43c72f3a9d23547e977c63285'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x6c6727eaefb573c85e2e49401c4ec6f00467d412'
  says: the manager is a proxy whose implementation is 0x6c6727ea
  for:
  - evidence-2
  - what
- id: reg
  source: '0x6c6727eaefb573c85e2e49401c4ec6f00467d412'
  file: src/WorldIDIdentityManagerImplV1.sol
  lines:
  - 397
  - 404
  has: try insertionVerifier.verifyProof(insertionProof, [reducedElement]) { // If it did verify, we need to update
    the contract's state. We set the currently valid // root to the root after the insertions. _latestRoot = postRoot;
  says: registerIdentities sets the new root when the batch verifier accepts
  for:
  - evidence-2
  - justification
  - what
- id: try
  source: '0x6c6727eaefb573c85e2e49401c4ec6f00467d412'
  file: src/WorldIDIdentityManagerImplV1.sol
  line: 401
  has: try insertionVerifier.verifyProof(insertionProof, [reducedElement]) {
  says: the manager calls the batch verifier in a try and only needs it not to revert
  for:
  - action
  - justification
- id: regmod
  source: '0x6c6727eaefb573c85e2e49401c4ec6f00467d412'
  file: src/WorldIDIdentityManagerImplV1.sol
  line: 382
  has: onlyIdentityOperator
  says: registerIdentities is restricted to the identity operator
  for:
  - what
- id: opmod
  source: '0x6c6727eaefb573c85e2e49401c4ec6f00467d412'
  file: src/WorldIDIdentityManagerImplV1.sol
  lines:
  - 701
  - 703
  has: if (msg.sender != _identityOperator) {
  says: the modifier compares the sender with the stored operator
  for:
  - justification
  - what
- id: op
  call: '0x5fb49f5b63421bd43c72f3a9d23547e977c63285'
  fn: identityOperator()(address)
  is: '0x41e8af7852c7169f2b84d7b50ec673b80b73e422'
  says: group 2's identity operator
  for:
  - justification
  - what
- id: opcode
  code: '0x41e8af7852c7169f2b84d7b50ec673b80b73e422'
  is: empty
  says: the operator is a plain account without code
  for:
  - what
- id: opnonce
  nonce: '0x41e8af7852c7169f2b84d7b50ec673b80b73e422'
  min: 10868
  says: the operator has sent at least 10,868 transactions, so its public key is on chain
  for:
  - justification
  - what
- id: shape
  source: '0x6c6727eaefb573c85e2e49401c4ec6f00467d412'
  file: src/interfaces/ITreeVerifier.sol
  line: 17
  has: function verifyProof(uint256[8] calldata proof, uint256[1] calldata input) external;
  says: the batch verifier interface is external and not view, so a replacement may keep state
  for:
  - action
  - justification
- id: mgrowner
  call: '0x5fb49f5b63421bd43c72f3a9d23547e977c63285'
  fn: owner()(address)
  is: '0xc534a745bffaf9466ed7b47fa23b0177b99a3e77'
  says: the manager's owner is the Safe
  for:
  - action
  - evidence-3
  - justification
- id: setop
  source: '0x6c6727eaefb573c85e2e49401c4ec6f00467d412'
  file: src/WorldIDIdentityManagerImplV1.sol
  lines:
  - 648
  - 658
  has: _identityOperator = newIdentityOperator;
  says: setIdentityOperator (onlyOwner) replaces the identity operator
  for:
  - action
  - evidence-3
  - justification
- id: setopsel
  selector: '0x6c6727eaefb573c85e2e49401c4ec6f00467d412'
  fn: setIdentityOperator(address)
  says: the running implementation has setIdentityOperator
  for:
  - action
  - evidence-3
  - justification
- id: upd
  source: '0x6c6727eaefb573c85e2e49401c4ec6f00467d412'
  file: src/data/VerifierLookupTable.sol
  lines:
  - 122
  - 128
  has: verifier_lut[batchSize] = verifier;
  says: updateVerifier (onlyOwner) replaces the verifier for a batch size
  for:
  - action
  - evidence-3
  - justification
- id: updsel
  selector: '0x54aef6aba7e27e3b3698549449596e0f251962c4'
  fn: updateVerifier(uint256,address)
  says: the group 2 insertion table has updateVerifier
  for:
  - action
  - evidence-3
  - justification
- id: tblowner
  call: '0x54aef6aba7e27e3b3698549449596e0f251962c4'
  fn: owner()(address)
  is: '0xc534a745bffaf9466ed7b47fa23b0177b99a3e77'
  says: the insertion table's owner is the Safe
  for:
  - action
  - evidence-3
  - justification
- id: thr
  call: '0xc534a745bffaf9466ed7b47fa23b0177b99a3e77'
  fn: getThreshold()(uint256)
  is: 4
  says: the Safe needs 4 signatures
  for:
  - evidence-3
  - justification
- id: owners
  call: '0xc534a745bffaf9466ed7b47fa23b0177b99a3e77'
  fn: getOwners()(address[])
  is:
  - '0x3ba8e8e561798e5194c898f3a2303986a7d1e901'
  - '0x0897316dfe7141db1e182551c3e8077cf5dd9695'
  - '0xb67ac19693fb89880ca5873f6a890e865b259c26'
  - '0xf0fcdb037718e1b2b52f109ae776713f9c1f730c'
  - '0x140c0227cbe493a56868ddf4ea582e92ef3e9744'
  - '0x6bbf4f7478824482f0ce2861d003bf0ef61cdbd6'
  says: the Safe has six owners
  for:
  - evidence-3
- id: member
  source: '0x6c6727eaefb573c85e2e49401c4ec6f00467d412'
  file: src/WorldIDIdentityManagerImplV1.sol
  lines:
  - 684
  - 690
  has: requireValidRoot(root);
  says: the manager's verifyProof checks a membership proof's root before verifying it
  for:
  - evidence-2
- id: rootok
  source: '0x6c6727eaefb573c85e2e49401c4ec6f00467d412'
  file: src/WorldIDIdentityManagerImplV1.sol
  lines:
  - 495
  - 499
  has: if (root == _latestRoot) {
  says: the latest root set by registerIdentities is always a valid membership root
  for:
  - evidence-2
- id: route
  call: '0x163b09b4fe21177c455d850bd815b6d583732432'
  fn: routeFor(uint256)(address)
  args:
  - 2
  is: '0x5fb49f5b63421bd43c72f3a9d23547e977c63285'
  says: the router at 0x163b09b4 sends group 2 to this manager
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
  who: Review16 (verified source of WorldIDIdentityManagerImplV2, WorldIDRouterImplV1, VerifierLookupTable, SemaphoreVerifier;
    on-chain reads; Xatu scan for consumers)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract checks the Groth16 proof World ID group 2 needs to add 100 identities and move its root. A quantum computer can derive the setup secret from the key here and forge a proof for any root. Its only sender, a plain account, has signed enough to expose its key to a quantum computer too.

## Evidence

- [verifyProof](https://etherscan.io/address/0x469449f251692e0779667583026b5a1e99512157#code) accepts a proof when one BN254 pairing check against constants in the code passes.
- [registerIdentities](https://etherscan.io/address/0x6c6727eaefb573c85e2e49401c4ec6f00467d412#code) sets group 2's root when this verifier accepts; group 2 membership proofs are checked against that root.
- [updateVerifier](https://etherscan.io/address/0x54aef6aba7e27e3b3698549449596e0f251962c4#code) and setIdentityOperator let the owner, a 4-of-6 Safe, replace this verifier and the operator.

## Reviewer notes

### Mechanism

Group 2's identity manager 0x5fb49f5b (UUPS proxy, implementation 0x6c6727ea, WorldIDIdentityManagerImplV2 inheriting V1) runs registerIdentities (V1 lines 376-419): onlyIdentityOperator (msg.sender == _identityOperator), preRoot must equal _latestRoot, the verifier is batchInsertionVerifiers.getVerifierFor(n) and, if verifyProof does not revert, _latestRoot = postRoot. At the block the insertion table 0x54aef6ab returns this address for n = 100. This contract's verifyProof runs one ecPairing over A, B, C and verification key constants; with the setup trapdoor any statement verifies. The operator 0x41e8af78 has no code and nonce 10,868, so its public key is on chain and a quantum computer recovers it; with it alone an attacker can already insert real commitments of its choice, and with the forged proof it can set an arbitrary root. No manager upgrade is needed: ITreeVerifier.verifyProof is external and not view and the manager calls it in a try, so a replacement verifier may keep state. The Safe 0xc534a745 (4 of 6) owns the table (updateVerifier) and the manager (setIdentityOperator). Rating re-derived: the first study had MEDIUM (fix by a manager upgrade); step 2 shows one known owner changing two settings, so LOW. The router 0x163b09b4 routes group 2 to this manager, whose verifyProof checks membership proofs against the latest or a recent root.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an unused copy: the group 2 insertion table returns this address for batch size 100 at the block, and the table is the manager's insertion table.
- Ruled out: a closed path: the manager's latestRoot is non-zero and the operator account has sent 10,868 transactions; I did not count recent calls through the gateway.
- Ruled out: the operator as a safeguard: it is a plain account with a public key on chain (nonce 10,868), so a quantum attacker gets the sender gate too; the action moves it.
- Ruled out: a fix that needs a manager upgrade (my earlier draft): the verifier interface is not view and is called in a try, so a stateful post-quantum-backed verifier fits the existing call through updateVerifier.
- Ruled out: a pending owner change on the table: pendingOwner is zero at the block.

### Questions

- What relies on group 2's root, and so the impact and whose: the router at 0x163b09b4 routes group 2 to this manager and the manager checks membership proofs against the root, but I could not show any mainnet app that consumes those proofs (no log scans allowed); the first study saw none since 2023-08-22 and says roots are relayed to other chains, which I did not check. Until shown, impact and whose stay unset.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
