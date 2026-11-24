---
id: axelarauthweighted-3d3c73e9-operator-quorum
format: 2
title: Forged operator signatures release the tokens locked in Axelar's gateway
status: confirmed
severity: MEDIUM
justification: Forged operator keys pay out the gateway's tokens; the fix needs a governance upgrade of the gateway.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3d3c73e91b1b0c243f1437f2d8363b1d5b093bd0'
  name: AxelarAuthWeighted
  project: axelar
  code: verified
  code_url: https://etherscan.io/address/0x3d3c73e91b1b0c243f1437f2d8363b1d5b093bd0#code
  copies: 1
  upgradeable: 'no'
  admin: '0x4f4495243837681061c4743b74b3eedf548d56a5'
value:
  usd: 0
  whose: users
  basis: held
activity:
  txs_90d: 852
impact: funds-loss
action: Upgrade the gateway through governance to an auth module that checks post-quantum signatures from the Axelar
  operators.
evidence_level: source
checks:
- id: authmod
  call: '0x4f4495243837681061c4743b74b3eedf548d56a5'
  fn: authModule()(address)
  is: '0x3d3c73e91b1b0c243f1437f2d8363b1d5b093bd0'
  says: the gateway's auth module at the block is this address
  for:
  - evidence-3
  - what
- id: owner
  call: '0x3d3c73e91b1b0c243f1437f2d8363b1d5b093bd0'
  fn: owner()(address)
  is: '0x4f4495243837681061c4743b74b3eedf548d56a5'
  says: the gateway owns this module
  for:
  - notes
- id: impl
  call: '0x4f4495243837681061c4743b74b3eedf548d56a5'
  fn: implementation()(address)
  is: '0x16c22cbdd77350b1ac88adda344f691c12f41960'
  says: the gateway runs implementation 0x16c22cbd
  for:
  - notes
- id: validate
  source: '0x16c22cbdd77350b1ac88adda344f691c12f41960'
  file: contracts/AxelarGateway.sol
  line: 519
  has: bool allowOperatorshipTransfer = IAxelarAuth(authModule).validateProof(messageHash, proof);
  says: execute asks the auth module to validate the proof of every command batch
  for:
  - what
- id: cmds
  source: '0x16c22cbdd77350b1ac88adda344f691c12f41960'
  file: contracts/AxelarGateway.sol
  lines:
  - 543
  - 557
  has: commandSelector = AxelarGateway.mintToken.selector;
  says: a validated batch runs deployToken, mintToken, approveContractCall(WithMint), burnToken and transferOperatorship
    commands
  for:
  - what
- id: rotcmd
  source: '0x16c22cbdd77350b1ac88adda344f691c12f41960'
  file: contracts/AxelarGateway.sol
  lines:
  - 553
  - 557
  has: if (!allowOperatorshipTransfer) continue;
  says: an operator change runs when the batch is signed by the current operator set
  for:
  - what
- id: mint
  source: '0x16c22cbdd77350b1ac88adda344f691c12f41960'
  file: contracts/AxelarGateway.sol
  line: 747
  has: IERC20(tokenAddress).safeTransfer(account, amount);
  says: mintToken pays an External token out of the gateway's own balance
  for:
  - justification
  - what
  - whose
- id: limit
  source: '0x16c22cbdd77350b1ac88adda344f691c12f41960'
  file: contracts/AxelarGateway.sol
  lines:
  - 864
  - 865
  has: if (limit > 0 && amount > limit) revert ExceedMintLimit(symbol);
  says: a mint limit of zero sets no cap
  for:
  - evidence-2
- id: lock
  source: '0x16c22cbdd77350b1ac88adda344f691c12f41960'
  file: contracts/AxelarGateway.sol
  line: 774
  has: IERC20(tokenAddress).safeTransferFrom(sender, address(this), amount);
  says: External tokens a user sends across are locked in the gateway
  for:
  - whose
- id: immutable
  source: '0x16c22cbdd77350b1ac88adda344f691c12f41960'
  file: contracts/AxelarGateway.sol
  line: 85
  has: address public immutable authModule;
  says: the auth module is fixed in the gateway implementation
  for:
  - action
  - evidence-3
  - justification
- id: upgrade
  source: '0x16c22cbdd77350b1ac88adda344f691c12f41960'
  file: contracts/AxelarGateway.sol
  lines:
  - 435
  - 439
  has: external override onlyGovernance {
  says: only governance can upgrade the gateway implementation
  for:
  - action
  - evidence-3
  - justification
- id: nopause
  source: '0x16c22cbdd77350b1ac88adda344f691c12f41960'
  file: contracts/AxelarGateway.sol
  line: 512
  has: function execute(bytes calldata input) external override {
  says: execute has no pause modifier
  for:
  - notes
- id: gov
  call: '0x4f4495243837681061c4743b74b3eedf548d56a5'
  fn: governance()(address)
  is: '0x7acbae6cba67d78aaf69e47000884ae00f9b2525'
  says: the gateway's governance is AxelarServiceGovernance
  for:
  - action
  - evidence-3
  - justification
- id: govtx
  tx: '0x412a5698beb96a03e4927b8cbedf35e3399699e0312a9d3b2bbaeab4dc1fd169'
  to: '0x7acbae6cba67d78aaf69e47000884ae00f9b2525'
  ok: true
  says: governance's operator executed the proposal that upgraded the gateway and switched it to this module (block
    26,395,170)
  for:
  - action
  - evidence-3
- id: oldmod
  call: '0x4f4495243837681061c4743b74b3eedf548d56a5'
  fn: authModule()(address)
  at: 26395160
  is: '0xe3b83f79fbf01b25659f8a814945ab82186a8ad0'
  says: ten blocks before that transaction the gateway used the previous auth module
  for:
  - evidence-3
- id: govgate
  source: '0x7acbae6cba67d78aaf69e47000884ae00f9b2525'
  file: contracts/executable/AxelarExecutable.sol
  line: 46
  has: if (!gateway().validateContractCall(commandId, sourceChain, sourceAddress, payloadHash))
  says: governance proposals arrive as contract calls the gateway approved
  for:
  - notes
- id: timelock
  call: '0x7acbae6cba67d78aaf69e47000884ae00f9b2525'
  fn: minimumTimeLockDelay()(uint256)
  is: 259200
  says: governance timelock proposals wait at least 3 days
  for:
  - notes
- id: paused
  call: '0x4f4495243837681061c4743b74b3eedf548d56a5'
  fn: paused()(bool)
  is: false
  says: the gateway is not paused
  for:
  - notes
- id: recover
  source: '0x3d3c73e91b1b0c243f1437f2d8363b1d5b093bd0'
  file: contracts/auth/AxelarAuthWeighted.sol
  line: 105
  has: address signer = ECDSA.recover(messageHash, signatures[i]);
  says: each signature is recovered with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: match
  source: '0x3d3c73e91b1b0c243f1437f2d8363b1d5b093bd0'
  file: contracts/auth/AxelarAuthWeighted.sol
  line: 107
  has: signer != operators[operatorIndex]
  says: the recovered address is matched against the operator list of the proof
  for:
  - evidence-1
  - what
- id: threshold
  source: '0x3d3c73e91b1b0c243f1437f2d8363b1d5b093bd0'
  file: contracts/auth/AxelarAuthWeighted.sol
  lines:
  - 111
  - 113
  has: if (weight >= threshold) return;
  says: the matched operators' weights must reach the threshold
  for:
  - evidence-1
  - what
- id: epoch
  source: '0x3d3c73e91b1b0c243f1437f2d8363b1d5b093bd0'
  file: contracts/auth/AxelarAuthWeighted.sol
  line: 40
  has: if (operatorsEpoch == 0 || epoch - operatorsEpoch >= OLD_KEY_RETENTION) revert InvalidOperators();
  says: the operator list must be one of the stored sets, no more than 15 rotations old
  for:
  - notes
- id: retention
  source: '0x3d3c73e91b1b0c243f1437f2d8363b1d5b093bd0'
  file: contracts/auth/AxelarAuthWeighted.sol
  line: 14
  has: uint256 internal constant OLD_KEY_RETENTION = 16;
  says: old operator sets stay valid for 16 epochs
  for:
  - notes
- id: curepoch
  call: '0x3d3c73e91b1b0c243f1437f2d8363b1d5b093bd0'
  fn: currentEpoch()(uint256)
  is: 21
  says: 21 operator sets have been stored
  for:
  - notes
- id: rotate
  source: '0x3d3c73e91b1b0c243f1437f2d8363b1d5b093bd0'
  file: contracts/auth/AxelarAuthWeighted.sol
  lines:
  - 59
  - 63
  has: (address[] memory newOperators, uint256[] memory newWeights, uint256 newThreshold) = abi.decode(
  says: an operator change installs new ECDSA addresses, not another scheme
  for:
  - action
- id: ownerrot
  source: '0x3d3c73e91b1b0c243f1437f2d8363b1d5b093bd0'
  file: contracts/auth/AxelarAuthWeighted.sol
  line: 51
  has: function transferOperatorship(bytes calldata params) external onlyOwner {
  says: only the owner (the gateway) changes the operators
  for:
  - notes
- id: exectx
  tx: '0x8979dbf6005859f138c72778300498036d8a0b5f112e8c9e87328c4acb67ced1'
  to: '0x4f4495243837681061c4743b74b3eedf548d56a5'
  ok: true
  says: 'a real execute batch: operator signatures are public in its calldata'
  for:
  - what
- id: signer
  code: '0xc1667f1e9ebdbe8086d307261d65b2018a7e5c93'
  is: empty
  says: an operator recovered in real batches is a plain account
  for:
  - notes
- id: r8151
  replay: '0x8bf3257a0bed627c7a7873246f887e489dd5105c8d499e02f441e8801352ff2e'
  run: eip8151
  ok: true
  says: a real batch still succeeds under EIP-8151 alone
  for:
  - notes
- id: rcode
  replay: '0x738f34c2674c185f0c647f4ad525cd859d128a5fdb93fe6caf290ca9d52829fc'
  run: eip8151_signer_code
  ok: false
  says: a real batch reverts when its signer has real code
  for:
  - notes
- id: bal-usdc
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0x4f4495243837681061c4743b74b3eedf548d56a5'
  is: 13227593661004
  says: the gateway holds 13,227,593.66 USDC
  for:
  - evidence-2
  - whose
- id: bal-wbtc
  call: '0x2260fac5e5542a773aa44fbcfedf7c193bc2c599'
  fn: balanceOf(address)(uint256)
  args:
  - '0x4f4495243837681061c4743b74b3eedf548d56a5'
  is: 4794818706
  says: the gateway holds 47.948 WBTC
  for:
  - evidence-2
  - whose
- id: bal-weth
  call: '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
  fn: balanceOf(address)(uint256)
  args:
  - '0x4f4495243837681061c4743b74b3eedf548d56a5'
  is: 908983505769109728446
  says: the gateway holds 908.98 WETH
  for:
  - evidence-2
  - whose
- id: bal-zig
  call: '0xb2617246d0c6c0087f18703d576831899ca94f01'
  fn: balanceOf(address)(uint256)
  args:
  - '0x4f4495243837681061c4743b74b3eedf548d56a5'
  is: 540343340541400456368555378
  says: the gateway holds 540,343,340 ZIG
  for:
  - evidence-2
  - whose
- id: addr-usdc
  call: '0x4f4495243837681061c4743b74b3eedf548d56a5'
  fn: tokenAddresses(string)(address)
  args:
  - USDC
  is: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  says: the gateway's USDC is token 0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48
  for:
  - evidence-2
- id: type-usdc
  call: '0x4f4495243837681061c4743b74b3eedf548d56a5'
  fn: getUint(bytes32)(uint256)
  args:
  - '0xde147d16f39fcc0d7dce90c1e9a4f4629e92f2bbe2e7978f9e3559412bbfb088'
  is: 2
  says: 'USDC is registered as External (type 2): mintToken transfers it from the gateway''s balance'
  for:
  - what
- id: lim-usdc
  call: '0x4f4495243837681061c4743b74b3eedf548d56a5'
  fn: tokenMintLimit(string)(uint256)
  args:
  - USDC
  is: 0
  says: no mint limit is set for USDC
  for:
  - evidence-2
- id: addr-wbtc
  call: '0x4f4495243837681061c4743b74b3eedf548d56a5'
  fn: tokenAddresses(string)(address)
  args:
  - WBTC
  is: '0x2260fac5e5542a773aa44fbcfedf7c193bc2c599'
  says: the gateway's WBTC is token 0x2260fac5e5542a773aa44fbcfedf7c193bc2c599
  for:
  - evidence-2
- id: type-wbtc
  call: '0x4f4495243837681061c4743b74b3eedf548d56a5'
  fn: getUint(bytes32)(uint256)
  args:
  - '0xfabbacfe45b9e84d45e42840c2356aafbea18aa8e9f2b1f9dc4804513c532a4f'
  is: 2
  says: 'WBTC is registered as External (type 2): mintToken transfers it from the gateway''s balance'
  for:
  - what
- id: lim-wbtc
  call: '0x4f4495243837681061c4743b74b3eedf548d56a5'
  fn: tokenMintLimit(string)(uint256)
  args:
  - WBTC
  is: 0
  says: no mint limit is set for WBTC
  for:
  - evidence-2
- id: addr-weth
  call: '0x4f4495243837681061c4743b74b3eedf548d56a5'
  fn: tokenAddresses(string)(address)
  args:
  - WETH
  is: '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
  says: the gateway's WETH is token 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2
  for:
  - evidence-2
- id: type-weth
  call: '0x4f4495243837681061c4743b74b3eedf548d56a5'
  fn: getUint(bytes32)(uint256)
  args:
  - '0x64d21d59258dd9b5e7de7df06e8d6b8fdb12ae113710eac1be8e5e28a34348ba'
  is: 2
  says: 'WETH is registered as External (type 2): mintToken transfers it from the gateway''s balance'
  for:
  - what
- id: lim-weth
  call: '0x4f4495243837681061c4743b74b3eedf548d56a5'
  fn: tokenMintLimit(string)(uint256)
  args:
  - WETH
  is: 0
  says: no mint limit is set for WETH
  for:
  - evidence-2
- id: addr-zig
  call: '0x4f4495243837681061c4743b74b3eedf548d56a5'
  fn: tokenAddresses(string)(address)
  args:
  - ZIG
  is: '0xb2617246d0c6c0087f18703d576831899ca94f01'
  says: the gateway's ZIG is token 0xb2617246d0c6c0087f18703d576831899ca94f01
  for:
  - evidence-2
- id: type-zig
  call: '0x4f4495243837681061c4743b74b3eedf548d56a5'
  fn: getUint(bytes32)(uint256)
  args:
  - '0x080c5391ffb9ecad9671e25de2ab17ce92031f87d505eb482fe91276a8a77e81'
  is: 2
  says: 'ZIG is registered as External (type 2): mintToken transfers it from the gateway''s balance'
  for:
  - what
- id: lim-zig
  call: '0x4f4495243837681061c4743b74b3eedf548d56a5'
  fn: tokenMintLimit(string)(uint256)
  args:
  - ZIG
  is: 0
  says: no mint limit is set for ZIG
  for:
  - evidence-2
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review18 (gateway and both auth modules from Sourcify, historical authModule reads, gateway escrow)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-3d3c73e9, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Axelar''s auth module for its Ethereum gateway: a command batch runs only with ECDSA signatures of
    operators whose weights reach the threshold; no ERC-1271 path; 16,701 recoveries in the traced two weeks. MEDIUM,
    PQ-5: enough forged operator keys make the gateway pay out its tokens (13.2M USDC, 47.9 WBTC, 909 WETH, 540M
    ZIG, with no mint limit on any at the block; the old card assumed a cap) and replace the operators; only a governance
    upgrade of the gateway changes the module, and governance has done one before. Author A-3d3c73e9; refuter R-3d3c73e9
    agreed with no objection; the reader changed nothing. The module holds nothing itself, so the header shows nothing
    held. The author''s lead, a rotate-before-migrating notice for the operators, gets its own row.'
related: []
---

## What happens

Axelar's Ethereum gateway runs a signed command batch only if this module finds ECDSA signatures of operators whose weights reach the threshold. A quantum attacker who derives enough operator keys from their public signatures can make the gateway pay out its tokens and replace the operators.

## Evidence

- [validateProof](https://etherscan.io/address/0x3d3c73e91b1b0c243f1437f2d8363b1d5b093bd0#code) recovers each signature with ECDSA and adds the matched operators' weights until they reach the threshold.
- The [gateway](https://etherscan.io/address/0x4f4495243837681061c4743b74b3eedf548d56a5) holds 13.2 million USDC, 47.9 WBTC, 909 WETH and 540 million ZIG, with no mint limit on any of them.
- [Governance](https://etherscan.io/address/0x7acbae6cba67d78aaf69e47000884ae00f9b2525) can change the module only by upgrading the gateway, as it did in [this transaction](https://etherscan.io/tx/0x412a5698beb96a03e4927b8cbedf35e3399699e0312a9d3b2bbaeab4dc1fd169).

## Reviewer notes

### Mechanism

AxelarGateway.execute (implementation 0x16c22cbd, line 512) hashes the batch and calls validateProof on its auth module (line 519), an immutable fixed in the implementation (line 85) and equal to this address at the block. validateProof decodes operators, weights, threshold and signatures from the proof, requires the hash of the first three to be one of the stored operator sets no more than 15 rotations old (lines 36-40; currentEpoch 21), then _validateSignatures recovers each signature with ECDSA (line 105), walks the sorted operator list for a match (line 107) and returns once the matched weights reach the threshold (line 113). The gateway then runs the batch: mintToken pays External tokens out of its balance (line 747), capped only where a mint limit is set (lines 864-867; zero for USDC, WBTC, WETH and ZIG); approveContractCall lets destination contracts, among them the gateway's own governance (AxelarExecutable line 46), act on a message; transferOperatorship runs only when signed by the current set (lines 553-557) and installs new ECDSA addresses (auth lines 59-63). The module can be swapped only by a governance upgrade of the gateway (lines 435-439), as in tx 0x412a5698 at block 26,395,170.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or other non-ECDSA path for operators: _validateSignatures has none (lines 91-119); the recovered operator is a plain account.
- Ruled out: an unused or retired address: the gateway's immutable authModule is this address at the block; the previous module 0xe3b83f79 (different code) is no longer called.
- Ruled out: a mint limit stopping a payout: tokenMintLimit is 0 (no cap) for USDC, WBTC, WETH and ZIG, all registered as External.
- Ruled out: a pause: the gateway is not paused, and execute has no pause modifier.
- Ruled out: rotating the operators as a fix: transferOperatorship installs new ECDSA keys, and the old sets stay valid for 16 epochs.
- Ruled out: the governance path as an independent fix: its proposals arrive through gateway-approved calls signed by the same operators; timelock proposals wait 3 days.
- Ruled out: EIP-8151 by itself: replay 0x8bf3257a succeeds under EIP-8151 alone; replay 0x738f34c2 reverts with real code at its signer. That is a separate migration notice (operators rotate before moving to real code) for the reviewer to link.
- Ruled out: this module holds no ETH or priced tokens itself; the money at stake is the gateway's, and tokens behind gateway-approved calls (Interchain Token Service) are not counted.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
