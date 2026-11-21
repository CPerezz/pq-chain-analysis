---
id: sp1verifier-0459d576-bn254-plonk-proof
format: 2
title: Quantum attacker could forge AggLayer proofs this SP1 verifier accepts
status: confirmed
severity: LOW
justification: Polygon's freeze Safe can close both routes alone, a newer route exists, and Lido's sanity checker
  reads no Lido report.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0459d576a6223feea177fb3df53c9c77bf84c459'
  name: SP1Verifier
  project: polygon
  code: verified
  code_url: https://etherscan.io/address/0x0459d576a6223feea177fb3df53c9c77bf84c459#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity: {}
impact: funds-loss
action: From Polygon's freeze Safe, freeze routes 0x00000004 and 0x00000008 and mark rollup type 11 obsolete; route
  0x0000000e serves v6.1.0.
evidence_level: source
checks:
- id: code
  code: '0x0459d576a6223feea177fb3df53c9c77bf84c459'
  is: contract
  bytes: 13413
  says: the verifier's code is deployed at the block, 13,413 bytes
  for:
  - notes
- id: version
  call: '0x0459d576a6223feea177fb3df53c9c77bf84c459'
  fn: VERSION()(string)
  is: v5.0.0
  says: the verifier is SP1 v5.0.0
  for:
  - what
- id: vhash
  call: '0x0459d576a6223feea177fb3df53c9c77bf84c459'
  fn: VERIFIER_HASH()(bytes32)
  is: '0xd4e8ecd2357dd882209800acd6abb443d231cf287d77ba62b732ce937c8b56e7'
  says: proofs for this verifier start with 0xd4e8ecd2
  for:
  - notes
- id: verify
  source: '0x0459d576a6223feea177fb3df53c9c77bf84c459'
  file: src/v5.0.0/SP1VerifierPlonk.sol
  lines:
  - 52
  - 59
  has: bool success = this.Verify(proofBytes[4:], inputs);
  says: verifyProof passes the proof with the vkey and public-values digest to the PLONK check and reverts if it
    fails
  for:
  - evidence-1
  - what
- id: pairing
  source: '0x0459d576a6223feea177fb3df53c9c77bf84c459'
  file: src/v5.0.0/PlonkVerifier.sol
  lines:
  - 898
  - 904
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: the PLONK check ends in a call to the BN254 pairing precompile
  for:
  - evidence-1
  - what
- id: srs
  source: '0x0459d576a6223feea177fb3df53c9c77bf84c459'
  file: src/v5.0.0/PlonkVerifier.sol
  lines:
  - 27
  - 38
  has: uint256 private constant G2_SRS_0_X_0 =
  says: the trusted setup's points are constants in the code
  for:
  - evidence-1
  - what
- id: route4
  call: '0x046bb8bb98db4cecbb2929542686b74b516274b3'
  fn: pessimisticVKeyRoutes(bytes4)(address,bytes32,bool)
  args:
  - '0x00000004'
  is:
  - '0x0459d576a6223feea177fb3df53c9c77bf84c459'
  - '0x00eff0b6998df46ec388bb305618089ae3dc74e513e7676b2e1909694f49cc30'
  - false
  says: AgglayerGateway route 0x00000004 points to this verifier and is not frozen
  for:
  - action
  - evidence-2
  - what
- id: route8
  call: '0x046bb8bb98db4cecbb2929542686b74b516274b3'
  fn: pessimisticVKeyRoutes(bytes4)(address,bytes32,bool)
  args:
  - '0x00000008'
  is:
  - '0x0459d576a6223feea177fb3df53c9c77bf84c459'
  - '0x000055f14384bdb5bb092fd7e5152ec31856321c5a30306ab95836bdf5cdb639'
  - false
  says: AgglayerGateway route 0x00000008 points to this verifier and is not frozen
  for:
  - action
  - evidence-2
  - what
- id: freeze
  call: '0x046bb8bb98db4cecbb2929542686b74b516274b3'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0xca75ae4228cde6195f9fa3dbde8dc352fb30aa63780717a378ccfc50274355dd'
  - '0x242dae44f5d8fb54b198d03a94da45b5a4413e21'
  is: true
  says: Safe 0x242dae44 holds keccak('AL_FREEZE_PP_ROUTE_ROLE'), the role that freezes routes
  for:
  - action
  - justification
- id: gwroute
  call: '0x3b6041173b80e77f038f3f2c0f9744f04837185e'
  fn: routes(bytes4)(address,bool)
  args:
  - '0xd4e8ecd2'
  is:
  - '0x0459d576a6223feea177fb3df53c9c77bf84c459'
  - true
  says: Succinct's Plonk gateway maps this verifier's selector here, frozen
  for:
  - notes
- id: route14
  call: '0x046bb8bb98db4cecbb2929542686b74b516274b3'
  fn: pessimisticVKeyRoutes(bytes4)(address,bytes32,bool)
  args:
  - '0x0000000e'
  is:
  - '0xc3c6dddac8829b233dc6536ec024775a57b0af2a'
  - '0x00d14f977a6ec393014f300ad78d0761dc29435d3fa1e2626fa466bd3343578e'
  - false
  says: AgglayerGateway route 0x0000000e points to another verifier, 0xc3c6ddda, and is open
  for:
  - action
  - evidence-2
  - justification
- id: v61
  call: '0xc3c6dddac8829b233dc6536ec024775a57b0af2a'
  fn: VERSION()(string)
  is: v6.1.0
  says: the verifier behind route 0x0000000e is SP1 v6.1.0
  for:
  - action
  - evidence-2
  - justification
- id: freezefn
  source: '0xd062b7f9fbb89bda59262e77015c34a27dc9ab49'
  file: contracts/AgglayerGateway.sol
  lines:
  - 299
  - 312
  has: external onlyRole(AL_FREEZE_PP_ROUTE_ROLE)
  says: freezePessimisticVKeyRoute needs only the freeze role and sets the route's frozen flag
  for:
  - action
  - justification
- id: frozenrevert
  source: '0xd062b7f9fbb89bda59262e77015c34a27dc9ab49'
  file: contracts/AgglayerGateway.sol
  lines:
  - 232
  - 233
  has: revert RouteIsFrozen(ppSelector);
  says: verifyPessimisticProof reverts for a frozen route
  for:
  - justification
- id: impl
  storage: '0x046bb8bb98db4cecbb2929542686b74b516274b3'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x000000000000000000000000d062b7f9fbb89bda59262e77015c34a27dc9ab49'
  says: AgglayerGateway runs implementation 0xd062b7f9
  for:
  - notes
- id: safe
  call: '0x242dae44f5d8fb54b198d03a94da45b5a4413e21'
  fn: getThreshold()(uint256)
  is: 5
  says: the freeze Safe needs 5 signatures
  for:
  - notes
- id: gwaddr
  call: '0x5132a183e9f3cb7c848b0aac5ae0c4f0491b7ab2'
  fn: aggLayerGateway()(address)
  is: '0x046bb8bb98db4cecbb2929542686b74b516274b3'
  says: Polygon's rollup manager uses this AgglayerGateway
  for:
  - what
- id: bridgeaddr
  call: '0x5132a183e9f3cb7c848b0aac5ae0c4f0491b7ab2'
  fn: bridgeAddress()(address)
  is: '0x2a3dd3eb832af982ec71669e178424b10dca2ede'
  says: the rollup manager's bridge is 0x2a3dd3eb
  for:
  - what
- id: bridgebal
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x2a3dd3eb832af982ec71669e178424b10dca2ede'
  is: 3473930876436718755772
  says: the bridge holds 3,473.93 ETH
  for:
  - what
- id: rmimpl
  storage: '0x5132a183e9f3cb7c848b0aac5ae0c4f0491b7ab2'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x00000000000000000000000015caf18ded768e3620e0f656221bf6b400ad2618'
  says: the rollup manager runs implementation 0x15caf18d
  for:
  - notes
- id: tagg
  source: '0x15caf18ded768e3620e0f656221bf6b400ad2618'
  file: contracts/AgglayerManager.sol
  lines:
  - 1300
  - 1307
  has: external onlyRole(_TRUSTED_AGGREGATOR_ROLE) nonReentrant {
  says: pessimistic proofs are submitted only by the trusted-aggregator role
  for:
  - notes
- id: exitroot
  source: '0x15caf18ded768e3620e0f656221bf6b400ad2618'
  file: contracts/AgglayerManager.sol
  lines:
  - 1369
  - 1392
  has: globalExitRootManager.updateExitRoot(getRollupExitRoot());
  says: after the gateway accepts the proof, the manager records the new local exit root and updates the global
    exit root
  for:
  - notes
- id: mantle
  call: '0x31d543e7be1da6efdc2206ef7822879045b9f481'
  fn: verifier()(address)
  is: '0x3b6041173b80e77f038f3f2c0f9744f04837185e'
  says: Mantle's OP Succinct output oracle uses Succinct's Plonk gateway, not this verifier directly
  for:
  - notes
- id: pp-events
  logs: '0x5132a183e9f3cb7c848b0aac5ae0c4f0491b7ab2'
  topic: '0xdf47e7dbf79874ec576f516c40bc1483f7c8ddf4b45bfd4baff4650f1229a711'
  from: 24900000
  to: 26438999
  count: 11561
  says: every pessimistic proof the manager accepted in the window
  for:
  - notes
- id: tx-r8
  tx: '0x2e53e07a448c46987051c2c478e5e3c2ba679e6a6e88132687c1d8b1bfda2395'
  to: '0x5132a183e9f3cb7c848b0aac5ae0c4f0491b7ab2'
  ok: true
  says: the last pessimistic proof on route 0x00000008, at block 25,329,889, succeeded
  for:
  - notes
- id: tx-r14
  tx: '0xd2b868bbbf6c7e13ee18b5a13606b2e33593affaa818b2ee6f4842c580694866'
  to: '0x5132a183e9f3cb7c848b0aac5ae0c4f0491b7ab2'
  ok: true
  says: the last pessimistic proof in the window, at block 26,438,980, went through route 0x0000000e and succeeded
  for:
  - notes
- id: lido-before
  call: '0x135d38482397c2e1050213f7f9290cdd9ad956bd'
  fn: verifier_parameters_before_pivot()(address,bytes32)
  is:
  - '0x0459d576a6223feea177fb3df53c9c77bf84c459'
  - '0x0047a30a0bc519cf142388456b11fedd33183d3c4acab0f73ba3096d33d16732'
  says: Lido's report contract uses this verifier before its pivot slot
  for:
  - evidence-3
  - what
- id: lido-after
  call: '0x135d38482397c2e1050213f7f9290cdd9ad956bd'
  fn: verifier_parameters_after_pivot()(address,bytes32)
  is:
  - '0x0459d576a6223feea177fb3df53c9c77bf84c459'
  - '0x00266fe04f4feade7542c410190e5038f57b22c794f4bbebe1ff0b2f0ed51993'
  says: Lido's report contract uses this verifier after its pivot slot too
  for:
  - evidence-3
  - what
- id: lido-s4
  storage: '0x135d38482397c2e1050213f7f9290cdd9ad956bd'
  slot: '0x4'
  is: '0x0000000000000000000000000459d576a6223feea177fb3df53c9c77bf84c459'
  says: slot 4 of Lido's report contract holds this verifier
  for:
  - notes
- id: lido-s6
  storage: '0x135d38482397c2e1050213f7f9290cdd9ad956bd'
  slot: '0x6'
  is: '0x0000000000000000000000000459d576a6223feea177fb3df53c9c77bf84c459'
  says: slot 6 of Lido's report contract holds this verifier
  for:
  - notes
- id: lido-submit
  source: '0x135d38482397c2e1050213f7f9290cdd9ad956bd'
  file: src/Sp1LidoAccountingReportContract.sol
  lines:
  - 207
  - 239
  has: try ISP1Verifier(sp1_parameters.verifier).verifyProof(sp1_parameters.vkey, publicValues, proof) {
  says: anyone can submit a report; it is recorded once this verifier accepts the proof
  for:
  - evidence-3
- id: lido-paused
  call: '0x135d38482397c2e1050213f7f9290cdd9ad956bd'
  fn: isPaused()(bool)
  is: false
  says: Lido's report contract is not paused
  for:
  - notes
- id: lido-pivotfn
  source: '0x135d38482397c2e1050213f7f9290cdd9ad956bd'
  file: src/Sp1LidoAccountingReportContract.sol
  lines:
  - 254
  - 262
  has: onlyRole(PIVOT_SP1_PARAMETERS_ROLE)
  says: setVerifierParametersPivot lets the pivot role switch the verifier from a future slot
  for:
  - notes
- id: lido-pivotrole
  call: '0x135d38482397c2e1050213f7f9290cdd9ad956bd'
  fn: getRoleMember(bytes32,uint256)(address)
  args:
  - '0xb6e352e4c9c6fc5427ba5da5b3dd4cbc07e361a226ebc90326b62adad3433971'
  - 0
  is: '0xed196e43b32384416f6fdfe61270e249a842d803'
  says: account 0xed196e43 holds the pivot role
  for:
  - notes
- id: lido-pivotcount
  call: '0x135d38482397c2e1050213f7f9290cdd9ad956bd'
  fn: getRoleMemberCount(bytes32)(uint256)
  args:
  - '0xb6e352e4c9c6fc5427ba5da5b3dd4cbc07e361a226ebc90326b62adad3433971'
  is: 1
  says: the pivot role has one holder
  for:
  - notes
- id: lido-admcode
  code: '0xed196e43b32384416f6fdfe61270e249a842d803'
  is: empty
  says: the pivot role holder is an account without code
  for:
  - notes
- id: locator-lido
  call: '0xc1d0b3de6792bf6b4b37eccdcc24e45978cfd2eb'
  fn: lido()(address)
  is: '0xae7ab96520de3a18e5e111b5eaab095312d7fe84'
  says: this locator is Lido's (it points to stETH)
  for:
  - what
- id: locator-sc
  call: '0xc1d0b3de6792bf6b4b37eccdcc24e45978cfd2eb'
  fn: oracleReportSanityChecker()(address)
  is: '0x147f8d3cf3004faf9bf94e88b54b6c06de507be9'
  says: Lido's oracle report sanity checker is 0x147f8d3c
  for:
  - evidence-3
  - justification
  - what
- id: sc-oracle
  call: '0x147f8d3cf3004faf9bf94e88b54b6c06de507be9'
  fn: secondOpinionOracle()(address)
  is: '0x0000000000000000000000000000000000000000'
  says: Lido's sanity checker has no second-opinion oracle set
  for:
  - evidence-3
  - justification
  - what
- id: sc-use
  source: '0x147f8d3cf3004faf9bf94e88b54b6c06de507be9'
  file: contracts/0.8.9/sanity_checks/OracleReportSanityChecker.sol
  lines:
  - 1139
  - 1148
  has: if (address(secondOpinionOracle) == address(0)) {
  says: the second opinion is asked only when a reported balance drop exceeds the limit, which otherwise reverts
  for:
  - justification
- id: sc-ask
  source: '0x147f8d3cf3004faf9bf94e88b54b6c06de507be9'
  file: contracts/0.8.9/sanity_checks/OracleReportSanityChecker.sol
  lines:
  - 1257
  - 1287
  has: revert NegativeRebaseFailedCLBalanceMismatch(
  says: the second opinion can only confirm or reject the main oracle's report, not supply a value
  for:
  - notes
- id: type11
  call: '0x5132a183e9f3cb7c848b0aac5ae0c4f0491b7ab2'
  fn: rollupTypeMap(uint32)(address,address,uint64,uint8,bool,bytes32,bytes32)
  args:
  - 11
  is:
  - '0x18c45dd422f6587357a6d3b23307e75d42b2bc5b'
  - '0x0459d576a6223feea177fb3df53c9c77bf84c459'
  - 12
  - 1
  - false
  - '0x0000000000000000000000000000000000000000000000000000000000000000'
  - '0x00eff0b6998df46ec388bb305618089ae3dc74e513e7676b2e1909694f49cc30'
  says: rollup type 11 is Pessimistic, uses this verifier and is not obsolete
  for:
  - action
  - what
- id: attach
  source: '0x15caf18ded768e3620e0f656221bf6b400ad2618'
  file: contracts/AgglayerManager.sol
  lines:
  - 681
  - 686
  has: rollup.verifier = rollupType.verifier;
  says: a chain created from a non-gateway type gets that type's verifier
  for:
  - what
- id: safe-obsolete
  call: '0x5132a183e9f3cb7c848b0aac5ae0c4f0491b7ab2'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0xab66e11c4f712cd06ab11bf9339b48bef39e12d4a22eeef71d2860a0c90482bd'
  - '0x242dae44f5d8fb54b198d03a94da45b5a4413e21'
  is: true
  says: the same Safe can obsolete rollup types
  for:
  - action
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review11 (Claude), finding review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This SP1 v5.0.0 verifier accepts any proof passing a BN254 pairing check on a fixed setup; a quantum attacker could forge one. Two open gateway routes for Polygon's 3,474 ETH bridge point here, and so does rollup type 11. So does a Lido report contract that Lido's sanity checker ignores.

## Evidence

- [verifyProof](https://etherscan.io/address/0x0459d576a6223feea177fb3df53c9c77bf84c459#code) passes the proof to a PLONK check ending in the BN254 pairing precompile, with setup points fixed in code.
- [AgglayerGateway](https://etherscan.io/address/0x046bb8bb98db4cecbb2929542686b74b516274b3#readProxyContract) routes proof types 0x00000004 and 0x00000008 here, unfrozen; 0x0000000e goes to v6.1.0.
- [Lido's report contract](https://etherscan.io/address/0x135d38482397c2e1050213f7f9290cdd9ad956bd#code) records reports this verifier accepts; Lido's sanity checker has no second-opinion oracle set.

## Reviewer notes

### Mechanism

verifyProof (SP1VerifierPlonk.sol 41-60) checks the 0xd4e8ecd2 prefix and calls the gnark PLONK verifier, which ends in pairing precompile 0x08 (PlonkVerifier.sol 898-904) against constant setup points (27-38); with the setup trapdoor any (vkey, public values) verifies. No proxy, owner or storage. Polygon: rollup manager 0x5132a183 calls the AgglayerGateway from verifyPessimisticTrustedAggregator (trusted-aggregator role); the gateway routes on the first 4 proof bytes and reverts if frozen. Routes 4 and 8 point here, unfrozen; 0x0e to v6.1.0. On success the manager updates the exit roots bridge 0x2a3dd3eb relies on. The freeze role is held by Safe 0x242dae44 (5 signatures). Of the 11,561 pessimistic proofs from block 24,900,000 to 26,438,999, the main reviewer's decoding of proof selectors puts 2,607 on route 8 (last at 25,329,889), 8,954 on route 0x0e and none on route 4. Lido: Sp1LidoAccountingReportContract 0x135d3848 calls this verifier for both pivot parameter sets (slots 4 and 6); submitReportData is open to anyone and records the report once the proof verifies. Its admin and pivot role is account 0xed196e43 (no code), which can switch the verifier from a future slot. Lido's sanity checker asks a second opinion only to confirm an oversized balance drop the main oracle already reported, and its secondOpinionOracle is unset at the block.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an upgrade path on the verifier: no proxy, no owner; VERSION and VERIFIER_HASH are constants (code, version, vhash).
- Ruled out: Succinct's Plonk gateway: its route here is frozen (gwroute); Mantle's oracle 0x31d543e7, a direct caller in the old trace table, now uses that gateway (mantle).
- Ruled out: a rollup pinned here: rollupIDToRollupData(1..31) shows none with this verifier (read by the author, not a check).
- Ruled out: a permissionless submission: the manager calls the gateway only from verifyPessimisticTrustedAggregator (tagg), so a forger also needs that role's key.
- Ruled out: the v6.1.0 verifier behind route 0x0e is also BN254 PLONK: another row.
- Ruled out: Lido's report contract as a MEDIUM path: a forged report reaches no Lido check at the block (sc-oracle); once set, it could only confirm or block a balance drop the main oracle reported (sc-use, sc-ask), and its pivot-role holder can repoint it (lido-pivotfn, lido-pivotrole).
- Ruled out: MEDIUM (earlier rating): one known operator, the freeze Safe, closes both Polygon routes and an alternative route exists; the Lido path takes nothing: LOW.
- Ruled out: Route use: Claude's decoding of all 11,561 proofs since block 24,900,000 (pp-events) found route 0x00000008's last at block 25,329,889 and none on 0x00000004; no check can show a last use, so the card gives no date.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
