---
id: plonkverifier-77d5c96d-forgeable-plonk-proof
format: 2
title: A forged proof for this rollup verifier would release the rollup's bridged ETH
status: confirmed
severity: LOW
justification: One live account holding the rollup's verifier-removal role can delete this verifier with a single
  call.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x77d5c96db33314244460cf89dd599525d7f3f847'
  name: PlonkVerifier
  code: verified
  code_url: https://etherscan.io/address/0x77d5c96db33314244460cf89dd599525d7f3f847#code
  copies: 1
value:
  usd: 0
  basis: held
activity: {}
impact: funds-loss
action: Remove proof type 1 from the rollup with unsetVerifierAddress(1), from the account that holds the verifier-unsetter
  role.
evidence_level: source
checks:
- id: pairing
  source: '0x77d5c96db33314244460cf89dd599525d7f3f847'
  file: src/verifiers/PlonkVerifier.sol
  line: 901
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: the final check is one call to the BN254 pairing precompile
  for:
  - evidence-1
  - what
- id: srs
  source: '0x77d5c96db33314244460cf89dd599525d7f3f847'
  file: src/verifiers/PlonkVerifier.sol
  lines:
  - 881
  - 891
  has: mstore(add(mPtr, 0x100), G2_SRS_1_X_0)
  says: the pairing uses the fixed G2 setup points of the trusted setup
  for:
  - evidence-1
  - what
- id: success
  source: '0x77d5c96db33314244460cf89dd599525d7f3f847'
  file: src/verifiers/PlonkVerifier.sol
  line: 218
  has: success := mload(add(mem, STATE_SUCCESS))
  says: Verify returns the pairing result
  for:
  - evidence-1
  - what
- id: verifiers1
  call: '0x2f3c205613d9451f88e19e011ed23775afe00c41'
  fn: verifiers(uint256)(address)
  args:
  - 1
  is: '0x77d5c96db33314244460cf89dd599525d7f3f847'
  says: the rollup lists this contract as proof type 1
  for:
  - action
  - evidence-2
  - what
- id: verifyproof
  source: '0x37139c71a739659a079576a97507d9c1a37b9eb4'
  file: src/rollup/ZkEvmV2.sol
  lines:
  - 44
  - 78
  has: address verifierToUse = verifiers[_proofType];
  says: the rollup calls the verifier of the caller's proof type and accepts when it returns true
  for:
  - what
- id: finalize
  source: '0x37139c71a739659a079576a97507d9c1a37b9eb4'
  file: src/rollup/LineaRollup.sol
  lines:
  - 461
  - 488
  has: _verifyProof(publicInput, _proofType, _aggregatedProof);
  says: finalizeBlocks finalizes after the proof of the chosen type verifies
  for:
  - what
- id: roots
  source: '0x37139c71a739659a079576a97507d9c1a37b9eb4'
  file: src/rollup/LineaRollup.sol
  line: 540
  has: _addL2MerkleRoots(_finalizationData.l2MerkleRoots, _finalizationData.l2MerkleTreesDepth);
  says: finalization stores the L2 message roots given by the caller
  for:
  - what
- id: claim
  source: '0x37139c71a739659a079576a97507d9c1a37b9eb4'
  file: src/messaging/l1/L1MessageService.sol
  lines:
  - 92
  - 127
  has: '_params.to.call{ value: _params.value }(_params.data)'
  says: claimMessageWithProof pays ETH for a message proven under a stored root
  for:
  - what
- id: fallbacksrc
  source: '0x37139c71a739659a079576a97507d9c1a37b9eb4'
  file: src/rollup/LineaRollup.sol
  lines:
  - 207
  - 221
  has: _grantRole(OPERATOR_ROLE, fallbackOperatorAddress);
  says: setFallbackOperator, open to anyone, grants the operator role to the fallback operator after six months
    without finalization
  for:
  - evidence-3
  - what
- id: fallback
  call: '0x2f3c205613d9451f88e19e011ed23775afe00c41'
  fn: setFallbackOperator(uint256,bytes32,uint256)()
  args:
  - 48
  - '0xfdcba69b844685738e24e5cd1b9f3cc59039f01418488c084265feee8ae51170'
  - 1777334507
  is: ''
  says: 'with the last finalization''s values (2026-04-28) the call does not revert: anyone can grant the fallback
    the operator role now'
  for:
  - evidence-3
  - what
- id: fallbackop
  call: '0x2f3c205613d9451f88e19e011ed23775afe00c41'
  fn: fallbackOperator()(address)
  is: '0xca11bde05977b3631167028862be2a173976ca11'
  says: the fallback operator is Multicall3
  for:
  - evidence-3
  - what
- id: multicall
  source: '0xca11bde05977b3631167028862be2a173976ca11'
  file: Multicall3.sol
  lines:
  - 41
  - 49
  has: (success, returnData[i]) = call.target.call(call.callData);
  says: Multicall3.aggregate is public and relays any call
  for:
  - evidence-3
  - what
- id: lasttx
  tx: '0x090b42a2ca27d2096b9e4eb98ae9ee4da20fefebe90dae9889fb30cec89beea7'
  to: '0x2f3c205613d9451f88e19e011ed23775afe00c41'
  ok: true
  says: the last finalizeBlocks, whose final state the fallback call uses
  for:
  - evidence-3
- id: paused1
  call: '0x2f3c205613d9451f88e19e011ed23775afe00c41'
  fn: isPaused(uint8)(bool)
  args:
  - 1
  is: false
  says: the rollup is not generally paused
  for:
  - evidence-2
- id: paused6
  call: '0x2f3c205613d9451f88e19e011ed23775afe00c41'
  fn: isPaused(uint8)(bool)
  args:
  - 6
  is: false
  says: finalization is not paused
  for:
  - evidence-2
- id: unsetsrc
  source: '0x37139c71a739659a079576a97507d9c1a37b9eb4'
  file: src/rollup/LineaRollup.sol
  lines:
  - 229
  - 233
  has: delete verifiers[_proofType];
  says: unsetVerifierAddress, gated by VERIFIER_UNSETTER_ROLE, deletes a proof type's verifier
  for:
  - action
  - justification
- id: unsetrole
  call: '0x2f3c205613d9451f88e19e011ed23775afe00c41'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0x6b5661ddfbd1fbd525c902a513e0f47d9c74f1c1ee8a2d4f1937ad305fb8f41a'
  - '0xbbef10cea9eefd021069a1fc4a348c00e799b01b'
  is: true
  says: EOA 0xbbef10ce holds VERIFIER_UNSETTER_ROLE
  for:
  - action
  - justification
- id: admincode
  code: '0xbbef10cea9eefd021069a1fc4a348c00e799b01b'
  is: empty
  says: the role holder is a plain account
  for:
  - justification
- id: adminnonce
  nonce: '0xbbef10cea9eefd021069a1fc4a348c00e799b01b'
  is: 23
  says: 'the role holder has sent transactions: a live key'
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
  who: Review16 (chain reads, Sourcify source, Rarimo docs)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract checks PLONK proofs with one BN254 pairing against a fixed trusted setup. A rollup lists it as proof type 1 and finalizes any state that a proof it accepts covers. With the setup's secret, a quantum attacker forges a proof, finalizes false withdrawals and takes the rollup's ETH.

## Evidence

- [Verify](https://etherscan.io/address/0x77d5c96db33314244460cf89dd599525d7f3f847#code) returns the result of one pairing against two fixed setup points.
- The [rollup](https://etherscan.io/address/0x2f3c205613d9451f88e19e011ed23775afe00c41#code) lists this contract as proof type 1, and its finalization is not paused.
- The rollup last finalized on [2026-04-28](https://etherscan.io/tx/0x090b42a2ca27d2096b9e4eb98ae9ee4da20fefebe90dae9889fb30cec89beea7); six months on, anyone can give the operator role to Multicall3, which relays any call.

## Reviewer notes

### Mechanism

PlonkVerifier.Verify (gnark, BN254) derives challenges, folds the openings and ends in check_pairing_kzg: a staticcall to precompile 8 with the hard-coded G2 setup points (lines 881-891, 901); Verify returns that pairing result (line 218). Rollup proxy 0x2f3c2056 (implementation 0x37139c71 via ProxyAdmin 0xb6b6e80b) stores it as verifiers(1). finalizeBlocks (OPERATOR_ROLE, LineaRollup lines 461-488) takes the proof type from the caller, and ZkEvmV2._verifyProof (lines 44-78) calls verifiers[_proofType].Verify and accepts on true. The finalization stores the L2 Merkle roots (line 540); claimMessageWithProof (L1MessageService lines 92-127) pays value to any message proven under a stored root. The operator gate does not hold: setFallbackOperator (lines 207-221) grants OPERATOR_ROLE to fallbackOperator (Multicall3) once six months pass since the last finalization; an eth_call of it at the block with the values of the last finalizeBlocks (message 48, rolling hash 0xfdcb..., timestamp 1777334507 = 2026-04-28) succeeds, and Multicall3.aggregate relays any caller's call. So whoever holds the setup trapdoor can finalize a false state through proof type 1. EOA 0xbbef10ce holds VERIFIER_UNSETTER_ROLE; unsetVerifierAddress(1) deletes the entry (lines 229-233).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: path-closed: isPaused(GENERAL) and isPaused(FINALIZATION) are false at the block, and verifiers(1) is still this address.
- Ruled out: setter: unsetVerifierAddress is onlyRole(VERIFIER_UNSETTER_ROLE) and deletes verifiers[_proofType]; EOA 0xbbef10ce holds that role, has no code and nonce 23, so it is live.
- Ruled out: operator gate as protection: the current operator 0x3cbe03d5 (OPERATOR_ROLE true, an EOA with nonce 327) aside, setFallbackOperator succeeds in an eth_call at the block, so anyone can make Multicall3 an operator.
- Ruled out: wrong-code: the verified source at this address is the gnark PlonkVerifier with the pairing call; the rollup calls Verify(bytes,uint256[]) on it.
- Ruled out: value-whose: this address holds nothing; the money at stake is the rollup proxy's ETH (1.68 ETH read with eth_getBalance at the block, no check kind re-reads a balance, so no amount is on the card and whose is left empty).
- Ruled out: Separate exposures, not folded in: proof type 3 (0xe067e013) is the verifier the rollup's last finalization used and has the same weakness; 0xbbef10ce, one ECDSA key that has signed, also holds VERIFIER_SETTER_ROLE and owns the ProxyAdmin.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
