---
id: stakemanagerproxy-5e3ef299-checkpoint-validator-keys
format: 2
title: Forged validator keys could pass false Polygon checkpoints and drain the bridge
status: confirmed
severity: MEDIUM
justification: Forged validator keys could release bridge funds; the fix is a contract upgrade by the owning Timelock.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  name: StakeManagerProxy
  project: polygon
  code: verified
  code_url: https://etherscan.io/address/0x1d9ee26f794676acf56bac9a479f766403d0f5cc#code
  proxy_of: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  copies: 1
  upgradeable: 'yes'
  admin: '0xcaf0aa768a3ae1297df20072419db8bb8b5c8cef'
value:
  usd: 499
  basis: held
activity: {}
impact: funds-loss
action: Upgrade checkpoint verification to a post-quantum scheme through the Timelock, and have validators register
  post-quantum keys.
evidence_level: source
checks:
- id: impl
  call: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  fn: implementation()(address)
  is: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  says: the proxy runs StakeManager at 0x1d9e…f5cc
  for:
  - evidence-1
  - proxy_of
- id: owner
  call: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  fn: owner()(address)
  is: '0xcaf0aa768a3ae1297df20072419db8bb8b5c8cef'
  says: the proxy's owner is the Timelock 0xcaf0…8cef
  for:
  - action
  - evidence-3
  - justification
  - upgradeable
- id: upgrade
  source: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  file: StakeManagerProxy.sol
  line: 201
  has: function updateImplementation(address _newProxyTo) public onlyProxyOwner {
  says: the proxy owner can replace the implementation
  for:
  - action
  - evidence-3
  - justification
  - upgradeable
- id: ecdsa
  source: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  file: contracts/staking/stakeManager/StakeManager.sol
  line: 546
  has: address signer = ECVerify.ecrecovery(voteHash, sigs[i]);
  says: each checkpoint signature is recovered with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: quorum
  source: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  file: contracts/staking/stakeManager/StakeManager.sol
  line: 766
  has: require(signedStakePower >= currentTotalStake.mul(2).div(3).add(1), "2/3+1 non-majority!");
  says: the signers must hold two thirds of the stake plus one
  for:
  - evidence-1
  - justification
  - what
- id: rotate
  source: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  file: contracts/staking/stakeManager/StakeManager.sol
  line: 501
  has: function updateSigner(uint256 validatorId, bytes memory signerPubkey) public onlyStaker(validatorId) {
  says: a validator changes its signer by giving a new public key
  for:
  - action
  - evidence-3
- id: pubkey
  source: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  file: contracts/staking/stakeManager/StakeManager.sol
  lines:
  - 672
  - 673
  has: address signer = address(uint160(uint256(keccak256(pub))));
  says: the new signer must be a 64-byte secp256k1 public key, hashed to an address
  for:
  - action
  - evidence-3
- id: rootcall
  source: '0x536c55cfe4892e581806e10b38dfe8083551bd03'
  file: RootChain.sol
  lines:
  - 869
  - 870
  has: uint256 _reward = stakeManager.checkSignatures(
  says: RootChain asks the registered stake manager to check each checkpoint's signatures
  for:
  - evidence-2
  - what
- id: submit
  source: '0x536c55cfe4892e581806e10b38dfe8083551bd03'
  file: RootChain.sol
  line: 861
  has: function submitCheckpoint(bytes calldata data, uint[3][] calldata sigs) external {
  says: anyone can submit a checkpoint; no access modifier
  for:
  - evidence-2
  - what
- id: chainid
  source: '0x536c55cfe4892e581806e10b38dfe8083551bd03'
  file: RootChain.sol
  line: 695
  has: uint256 constant public CHAINID = 137;
  says: checkpoints are for chain id 137, Polygon PoS
  for:
  - what
- id: regslot
  storage: '0x86e4dc95c7fbdbf52e33d563bbdb00823894c287'
  slot: 6
  is: '0x33a02e6cc863d393d6bf231b697b82f6e499ca71'
  says: RootChainProxy's registry is 0x33a0…ca71
  for:
  - evidence-2
- id: regsm
  call: '0x33a02e6cc863d393d6bf231b697b82f6e499ca71'
  fn: getStakeManagerAddress()(address)
  is: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  says: the registry names this proxy as the stake manager
  for:
  - evidence-2
  - what
- id: rcimpl
  call: '0x86e4dc95c7fbdbf52e33d563bbdb00823894c287'
  fn: implementation()(address)
  is: '0x536c55cfe4892e581806e10b38dfe8083551bd03'
  says: RootChainProxy runs RootChain at 0x536c…bd03
  for:
  - notes
- id: rootchain
  call: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  fn: rootChain()(address)
  is: '0x86e4dc95c7fbdbf52e33d563bbdb00823894c287'
  says: only RootChainProxy can call checkSignatures
  for:
  - notes
- id: cpm
  call: '0xa0c68c638235ee32657e8f720a23cec1bfc77c77'
  fn: checkpointManagerAddress()(address)
  is: '0x86e4dc95c7fbdbf52e33d563bbdb00823894c287'
  says: the PoS bridge's RootChainManager reads checkpoints from RootChainProxy
  for:
  - what
- id: headers
  source: '0xf0235dca8fb0d3999685724dcbb9dd00c5d62dfa'
  file: contracts/root/RootChainManager/RootChainManager.sol
  line: 507
  has: = _checkpointManager.headerBlocks(headerNumber);
  says: exits are proven against RootChain's stored checkpoints
  for:
  - what
- id: exit
  source: '0xf0235dca8fb0d3999685724dcbb9dd00c5d62dfa'
  file: contracts/root/RootChainManager/RootChainManager.sol
  lines:
  - 418
  - 431
  has: ITokenPredicate(predicateAddress).exitTokens(
  says: after the checkpoint proof the predicate releases the tokens
  for:
  - what
- id: usdc
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0x40ec5b33f54e0e8a33a975908c5ba1c14e5bbbdf'
  is: 1046805900240577
  says: the ERC20 predicate holds 1,046,805,900 USDC
  for:
  - what
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x8484ef722627bf18ca5ae6bcf031c23e6e922b30'
  is: 89027181396170765219159
  says: the Ether predicate holds 89,027 ETH
  for:
  - what
- id: pred20
  call: '0xa0c68c638235ee32657e8f720a23cec1bfc77c77'
  fn: typeToPredicate(bytes32)(address)
  args:
  - '0x8ae85d849167ff996c04040c44924fd364217285e4cad818292c7ac37c0a345b'
  is: '0x40ec5b33f54e0e8a33a975908c5ba1c14e5bbbdf'
  says: the bridge's ERC20 predicate is 0x40ec…bbdf
  for:
  - what
- id: predeth
  call: '0xa0c68c638235ee32657e8f720a23cec1bfc77c77'
  fn: typeToPredicate(bytes32)(address)
  args:
  - '0xa234e09165f88967a714e2a476288e4c6d88b4b69fe7c300a03190b858990bfc'
  is: '0x8484ef722627bf18ca5ae6bcf031c23e6e922b30'
  says: the bridge's Ether predicate is 0x8484…2b30
  for:
  - what
- id: mindelay
  call: '0xcaf0aa768a3ae1297df20072419db8bb8b5c8cef'
  fn: getMinDelay()(uint256)
  is: 0
  says: the Timelock has no minimum delay
  for:
  - notes
- id: threshold
  call: '0xfa7d2a996ac6350f4b56c043112da0366a59b74c'
  fn: getThreshold()(uint256)
  is: 5
  says: the Safe that proposes to the Timelock needs 5 signatures
  for:
  - notes
- id: proposer
  call: '0xcaf0aa768a3ae1297df20072419db8bb8b5c8cef'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0xb09aa5aeb3702cfd50b6b62bc4532604938f21248a27a1d5ca736082b6819cc1'
  - '0xfa7d2a996ac6350f4b56c043112da0366a59b74c'
  is: true
  says: Safe 0xfa7d…b74c holds the Timelock's proposer role
  for:
  - notes
- id: polbal
  call: '0x455e53cbb86018ac2b8092fdcd39d8444affc3f6'
  fn: balanceOf(address)(uint256)
  args:
  - '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  is: 3970443943541359351217550800
  says: this address holds 3,970,443,943 POL, unpriced in the value line
  for:
  - notes
- id: ethusd
  call: '0x5f4ec3df9cbd43714fe2740f5e3616155c5b8419'
  fn: latestAnswer()(int256)
  is: 180456000258
  says: the Chainlink ETH/USD feed answers 1,804.56 at the block
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
  who: Review14 (StakeManager, RootChain and RootChainManager source; on-chain reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

Polygon PoS checkpoints pass when validators holding two thirds of the stake sign them with ECDSA keys. The bridge pays exits proven against them; its predicates hold 1.05 billion USDC and 89,027 ETH. Forging those keys proves a false checkpoint and takes that money.

## Evidence

- [checkSignatures](https://etherscan.io/address/0x1d9ee26f794676acf56bac9a479f766403d0f5cc#code) recovers each checkpoint signature with ECDSA and needs two thirds of the stake plus one.
- [submitCheckpoint](https://etherscan.io/address/0x536c55cfe4892e581806e10b38dfe8083551bd03#code) is open to anyone and stores a checkpoint once this contract accepts its signatures.
- The [Timelock](https://etherscan.io/address/0xcaf0aa768a3ae1297df20072419db8bb8b5c8cef) that owns this proxy can upgrade its code; a validator can only change to another ECDSA key.

## Reviewer notes

### Mechanism

RootChain.submitCheckpoint (RootChainProxy 0x86e4…c287, implementation 0x536c…bd03, no access check) decodes the checkpoint, requires bor chain id 137, stores the header block and calls checkSignatures on the stake manager it reads from its Registry 0x33a0…ca71 (storage slot 6), which returns this proxy. checkSignatures (onlyRootChain; rootChain() is RootChainProxy) recovers each uint[3] signature with ECVerify.ecrecovery (ecrecover, reverts on zero), maps the signer through signerToValidator, sums stake plus delegated stake of active validators, and _increaseRewardAndAssertConsensus requires signedStakePower >= totalStake*2/3+1; a zero reward reverts the checkpoint. RootChainManager 0xa0c6…7c77 (checkpointManagerAddress = RootChainProxy) proves each exit's receipt against headerBlocks of RootChain, then calls the predicate's exitTokens. Validators rotate with updateSigner, which accepts only a 64-byte secp256k1 public key, once per signerUpdateLimit (100) epochs. The proxy's owner (Timelock 0xcaf0…8cef, getMinDelay 0, PROPOSER_ROLE held by Safe 0xfa7d…b74c, 5 of 9) can updateImplementation.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: unused implementation: this is the live proxy; the window shows 1,098 transactions with 100 distinct recovered signers, and currentValidatorSetSize() is 100.
- Ruled out: a non-ECDSA path for checkpoints: submitCheckpoint has only checkSignatures; submitHeaderBlock reverts unconditionally (RootChain lines 857-859).
- Ruled out: rotating keys as a fix: updateSigner takes only a secp256k1 public key, so rotation stays ECDSA.
- Ruled out: a rating of LOW: changing the verification needs new code behind the proxy, not a setting.
- Ruled out: value: the header shows the tool's held value ($499); the proxy also holds 3.97e9 POL of validator and delegator stake (POL balanceOf), which the tool does not price and a forged checkpoint does not release directly; the escrow at stake is in the bridge predicates (USDC and ETH read, other tokens not counted).
- Ruled out: EIP-8151 side, separate from this card: ECVerify reverts when ecrecover returns zero, so a validator signer with real code would make the whole checkpoint revert rather than be skipped; the old file also listed a sender-gas-limits note. These belong to rows of the EIP-8151 study.
- Ruled out: Value: the card states what a forged checkpoint could release from the bridge's predicates (1,046,805,900 USDC and 89,027 ETH at 1,804.56), not this contract's own $499. The 3,970,443,943 POL this address holds, and the fee pool claimFee pays from, are unpriced and are not in the figure (checks usdc, eth, ethusd, polbal).

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
