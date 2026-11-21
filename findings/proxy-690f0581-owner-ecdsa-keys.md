---
id: proxy-690f0581-owner-ecdsa-keys
format: 2
title: 'Safe multisig: forging 3 of its 7 owners'' ECDSA keys moves all it holds'
status: candidate
severity: MEDIUM
justification: Three forged owner keys move everything; the fix needs the owners to replace their keys, three of
  them acting.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x690f0581ececcf8389c223170778cd9d029606f2'
  name: Proxy
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 4087226
  basis: held
activity: {}
impact: funds-loss
action: Swap ECDSA owners for post-quantum signers (swapOwner), remove ECDSA allowance delegates, and replace or
  disable the Roles callers.
evidence_level: source
checks:
- id: singleton
  storage: '0x690f0581ececcf8389c223170778cd9d029606f2'
  slot: 0
  is: '0x000000000000000000000000d9db270c1b5e3bd161e8c8503c55ceabee709552'
  says: slot 0 of this proxy holds the Safe 1.3.0 singleton, the code every call runs
  for:
  - evidence-1
  - proxy_of
  - upgradeable
- id: version
  call: '0x690f0581ececcf8389c223170778cd9d029606f2'
  fn: VERSION()(string)
  is: 1.3.0
  says: the Safe answers version 1.3.0
  for:
  - proxy_of
- id: threshold
  call: '0x690f0581ececcf8389c223170778cd9d029606f2'
  fn: getThreshold()(uint256)
  is: 3
  says: 3 owner approvals are needed
  for:
  - evidence-1
  - justification
  - what
- id: owners
  call: '0x690f0581ececcf8389c223170778cd9d029606f2'
  fn: getOwners()(address[])
  is:
  - '0x08cb835bd7d1d39c87b272e57878d02bfd889580'
  - '0x866b3c4994e1416b7c738b9818b31dc246b95eee'
  - '0x311a9ef07f16ad45e6aa6b9787e0e173e3ce3623'
  - '0xb8c2c29ee19d8307cb7255e1cd9cbde883a267d5'
  - '0xb6e040c9ecaae172a89bd561c5f73e1c48d28cd9'
  - '0x36aac472c224440741f292895bd659bca997309a'
  - '0x82eb45562f991329ed2867f43fc60f0ba52c3dab'
  says: the Safe has 7 owners
  for:
  - justification
  - what
- id: o1
  code: '0x08cb835bd7d1d39c87b272e57878d02bfd889580'
  is: empty
  bytes: 0
  says: owner 0x08cb835bd7d1d39c87b272e57878d02bfd889580 is an account without code
  for:
  - what
- id: o2
  code: '0x866b3c4994e1416b7c738b9818b31dc246b95eee'
  is: empty
  bytes: 0
  says: owner 0x866b3c4994e1416b7c738b9818b31dc246b95eee is an account without code
  for:
  - what
- id: o3
  code: '0x311a9ef07f16ad45e6aa6b9787e0e173e3ce3623'
  is: empty
  bytes: 0
  says: owner 0x311a9ef07f16ad45e6aa6b9787e0e173e3ce3623 is an account without code
  for:
  - what
- id: o4
  code: '0xb8c2c29ee19d8307cb7255e1cd9cbde883a267d5'
  is: empty
  bytes: 0
  says: owner 0xb8c2c29ee19d8307cb7255e1cd9cbde883a267d5 is an account without code
  for:
  - what
- id: o5
  code: '0xb6e040c9ecaae172a89bd561c5f73e1c48d28cd9'
  is: empty
  bytes: 0
  says: owner 0xb6e040c9ecaae172a89bd561c5f73e1c48d28cd9 is an account without code
  for:
  - what
- id: o6
  code: '0x36aac472c224440741f292895bd659bca997309a'
  is: empty
  bytes: 0
  says: owner 0x36aac472c224440741f292895bd659bca997309a is an account without code
  for:
  - what
- id: o7
  code: '0x82eb45562f991329ed2867f43fc60f0ba52c3dab'
  is: delegation
  bytes: 23
  target: '0x5a7fc11397e9a8ad41bf10bf13f22b0a63f96f6d'
  says: owner 0x82eb…3dab is an account with an EIP-7702 delegation, still controlled by its ECDSA key
  for:
  - what
- id: execsig
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 145
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction checks the owners' signatures before it executes
  for:
  - what
- id: nsig
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 230
  has: checkNSignatures(dataHash, data, signatures, _threshold);
  says: threshold-many signatures are checked
  for:
  - what
- id: ecdsa
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: an owner signature is recovered with ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: ethsign
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 295
  has: currentOwner = ecrecover(keccak256(abi.encodePacked(
  says: eth_sign-style owner signatures are also recovered with ecrecover
  for:
  - notes
- id: ownercheck
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 301
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
    "GS026");
  says: each recovered or named signer must be a distinct owner
  for:
  - evidence-1
  - justification
  - what
- id: approved
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 291
  has: require(msg.sender == currentOwner || approvedHashes[currentOwner][dataHash] != 0, "GS025");
  says: an owner can also approve by sending a transaction or calling approveHash
  for:
  - notes
- id: erc1271
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 285
  has: require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE,
    "GS024");
  says: an owner that is a contract is asked through ERC-1271 with the full signature
  for:
  - action
  - evidence-2
- id: execute
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 176
  has: success = execute(to, value, data, operation,
  says: the approved transaction is executed with any target, value, data and operation
  for:
  - justification
  - upgradeable
  - what
- id: delegatecall
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/Executor.sol
  line: 18
  has: success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
  says: a delegatecall operation runs foreign code in the Safe's storage, so it can rewrite slot 0
  for:
  - upgradeable
- id: swap
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/OwnerManager.sol
  lines:
  - 94
  - 111
  has: function swapOwner( address prevOwner, address oldOwner, address newOwner ) public authorized {
  says: swapOwner replaces one owner with another address
  for:
  - action
  - evidence-2
  - justification
  - what
- id: selfcall
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/common/SelfAuthorized.sol
  line: 8
  has: require(msg.sender == address(this), "GS031");
  says: authorized functions run only when the Safe calls itself, i.e. through an approved transaction
  for:
  - action
  - evidence-2
  - justification
  - what
- id: modules
  call: '0x690f0581ececcf8389c223170778cd9d029606f2'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 20
  is:
  - - '0xdca57e6e47dc0fdda693ce4884ec0e274a6ffbda'
    - '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  - '0x0000000000000000000000000000000000000001'
  says: two modules are enabled
  for:
  - evidence-3
  - what
- id: guard
  storage: '0x690f0581ececcf8389c223170778cd9d029606f2'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no transaction guard is set
  for:
  - notes
- id: rolesowner
  call: '0xdca57e6e47dc0fdda693ce4884ec0e274a6ffbda'
  fn: owner()(address)
  is: '0x690f0581ececcf8389c223170778cd9d029606f2'
  says: the Roles module is owned by this Safe
  for:
  - action
- id: delegates
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getDelegates(address,uint48,uint8)(address[],uint48)
  args:
  - '0x690f0581ececcf8389c223170778cd9d029606f2'
  - 0
  - 50
  is:
  - - '0x7c32d6cff23552dfda25c3495b2be542f8f0abcb'
    - '0x1cac6999a021840d341de9ee858d7ec0db2808f2'
    - '0x82eb45562f991329ed2867f43fc60f0ba52c3dab'
    - '0xb6e040c9ecaae172a89bd561c5f73e1c48d28cd9'
    - '0x311a9ef07f16ad45e6aa6b9787e0e173e3ce3623'
    - '0x255a13cda0b21259315d1527e47ba4fa19409799'
  - 0
  says: the allowance module lists 6 delegates for this Safe
  for:
  - what
- id: nonce
  call: '0x690f0581ececcf8389c223170778cd9d029606f2'
  fn: nonce()(uint256)
  is: 522
  says: the Safe has executed 522 owner-approved transactions
  for:
  - notes
- id: n-255a
  nonce: '0x255a13cda0b21259315d1527e47ba4fa19409799'
  min: 1
  says: 'non-owner Roles caller and delegate has sent transactions: a key controls it'
  for:
  - what
- id: safe-modexec
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/ModuleManager.sol
  line: 68
  has: modules[msg.sender] != address(0), "GS104");
  says: an enabled module executes from the Safe with no owner signature
  for:
  - what
- id: disable-module
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/ModuleManager.sol
  line: 47
  has: function disableModule(address prevModule, address module) public authorized {
  says: owners can disable a module by a Safe transaction
  for:
  - action
- id: am-sig
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: contracts/AlowanceModule.sol
  line: 184
  has: checkSignature(delegate, signature, transferHashData, safe);
  says: an allowance transfer is authorised by the delegate's signature
  for:
  - evidence-3
  - what
- id: am-check
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: contracts/AlowanceModule.sol
  line: 244
  has: expectedDelegate == signer && delegates[address(safe)][uint48(signer)].delegate == signer
  says: the recovered signer must be a registered delegate of the Safe
  for:
  - evidence-3
  - what
- id: am-ecrecover
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: contracts/AlowanceModule.sol
  line: 270
  has: owner = ecrecover(keccak256(transferHashData), v, r, s);
  says: the delegate signature is recovered with ecrecover
  for:
  - evidence-3
  - what
- id: am-no1271
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: contracts/AlowanceModule.sol
  line: 261
  has: revert("Contract signatures are not supported by this module");
  says: the module accepts no ERC-1271 contract signatures
  for:
  - notes
- id: am-exec
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: contracts/AlowanceModule.sol
  line: 282
  has: require(safe.execTransactionFromModule(token, 0, data, Enum.Operation.Call), "Could not execute token transfer");
  says: the module moves the Safe's tokens via execTransactionFromModule
  for:
  - evidence-3
  - what
- id: remove-delegate
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: contracts/AlowanceModule.sol
  line: 323
  has: function removeDelegate(address delegate, bool removeAllowances) public {
  says: the Safe can remove a delegate (msg.sender = the Safe)
  for:
  - action
- id: al-7c32
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0x690f0581ececcf8389c223170778cd9d029606f2'
  - '0x7c32d6cff23552dfda25c3495b2be542f8f0abcb'
  - '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  is:
  - 2000000000
  - 0
  - 43200
  - 29912667
  - 16
  says: non-owner delegate 0x7c32 may spend 2,000 USDC per 30 days, none spent
  for:
  - evidence-3
  - what
- id: al-1cac-eth
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0x690f0581ececcf8389c223170778cd9d029606f2'
  - '0x1cac6999a021840d341de9ee858d7ec0db2808f2'
  - '0x0000000000000000000000000000000000000000'
  is:
  - 3000000000000000000
  - 0
  - 10080
  - 29907937
  - 1
  says: non-owner delegate 0x1cac may spend 3 ETH per week
  for:
  - evidence-3
  - what
- id: al-1cac-usdc
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0x690f0581ececcf8389c223170778cd9d029606f2'
  - '0x1cac6999a021840d341de9ee858d7ec0db2808f2'
  - '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  is:
  - 5000000000
  - 0
  - 10080
  - 29907938
  - 1
  says: non-owner delegate 0x1cac may spend 5,000 USDC per week
  for:
  - evidence-3
  - what
- id: al-82eb
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0x690f0581ececcf8389c223170778cd9d029606f2'
  - '0x82eb45562f991329ed2867f43fc60f0ba52c3dab'
  - '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  is:
  - 5000000000
  - 0
  - 43200
  - 29905782
  - 1
  says: delegate 0x82eb may spend 5,000 USDC per 30 days
  for:
  - evidence-3
  - what
- id: al-b6e0
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0x690f0581ececcf8389c223170778cd9d029606f2'
  - '0xb6e040c9ecaae172a89bd561c5f73e1c48d28cd9'
  - '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  is:
  - 5000000000
  - 0
  - 43200
  - 29905781
  - 1
  says: delegate 0xb6e0 may spend 5,000 USDC per 30 days
  for:
  - evidence-3
  - what
- id: al-311a
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0x690f0581ececcf8389c223170778cd9d029606f2'
  - '0x311a9ef07f16ad45e6aa6b9787e0e173e3ce3623'
  - '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  is:
  - 5000000000
  - 0
  - 43200
  - 29905780
  - 2
  says: delegate 0x311a may spend 5,000 USDC per 30 days
  for:
  - evidence-3
  - what
- id: d-7c32
  code: '0x7c32d6cff23552dfda25c3495b2be542f8f0abcb'
  is: empty
  bytes: 0
  says: non-owner delegate 0x7c32 is a key-controlled account
  for:
  - notes
- id: d-1cac
  code: '0x1cac6999a021840d341de9ee858d7ec0db2808f2'
  is: empty
  bytes: 0
  says: non-owner delegate 0x1cac is a key-controlled account
  for:
  - notes
- id: d-255a
  code: '0x255a13cda0b21259315d1527e47ba4fa19409799'
  is: empty
  bytes: 0
  says: non-owner Roles caller 0x255a is a key-controlled account
  for:
  - what
- id: roles-avatar
  call: '0xdca57e6e47dc0fdda693ce4884ec0e274a6ffbda'
  fn: avatar()(address)
  is: '0x690f0581ececcf8389c223170778cd9d029606f2'
  says: the Roles modifier acts for this Safe
  for:
  - what
- id: roles-target
  call: '0xdca57e6e47dc0fdda693ce4884ec0e274a6ffbda'
  fn: target()(address)
  is: '0x690f0581ececcf8389c223170778cd9d029606f2'
  says: the Roles modifier executes on this Safe
  for:
  - what
- id: roles-modules
  call: '0xdca57e6e47dc0fdda693ce4884ec0e274a6ffbda'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 20
  is:
  - - '0x82eb45562f991329ed2867f43fc60f0ba52c3dab'
    - '0x36aac472c224440741f292895bd659bca997309a'
    - '0xb6e040c9ecaae172a89bd561c5f73e1c48d28cd9'
    - '0x311a9ef07f16ad45e6aa6b9787e0e173e3ce3623'
    - '0x255a13cda0b21259315d1527e47ba4fa19409799'
    - '0xb8c2c29ee19d8307cb7255e1cd9cbde883a267d5'
  - '0x0000000000000000000000000000000000000001'
  says: 6 accounts may call the Roles modifier, one (0x255a) not an owner
  for:
  - what
- id: roles-moduleonly
  source: '0xd8dfc1d938d7d163c5231688341e9635e9011889'
  file: '@gnosis.pm/zodiac/contracts/core/Modifier.sol'
  line: 60
  has: require(modules[msg.sender] != address(0), "Module not authorized");
  says: callers are authorised by msg.sender alone
  for:
  - action
  - what
- id: roles-exec
  source: '0xd8dfc1d938d7d163c5231688341e9635e9011889'
  file: contracts/Roles.sol
  lines:
  - 376
  - 378
  has: Permissions.check(roles[role], multisend, to, value, data, operation); success = exec(to, value, data, operation);
  says: a caller's role-permitted transaction is executed from the Safe
  for:
  - what
- id: roles-member
  source: '0xd8dfc1d938d7d163c5231688341e9635e9011889'
  file: contracts/Permissions.sol
  line: 184
  has: if (!role.members[msg.sender]) {
  says: role membership is by msg.sender, no signature
  for:
  - what
- id: al-255a
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0x690f0581ececcf8389c223170778cd9d029606f2'
  - '0x255a13cda0b21259315d1527e47ba4fa19409799'
  - '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  is:
  - 0
  - 0
  - 0
  - 0
  - 24
  says: delegate 0x255a has no live USDC allowance
  for:
  - what
- id: am-direct
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: contracts/AlowanceModule.sol
  line: 252
  has: if (signature.length == 0) return msg.sender;
  says: a delegate can also spend by calling the module from its own address, with no signature
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
  who: review (Review04)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (source of 1.3.0 read, two real transactions replayed four ways; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews: []
related: []
---

## What happens

This Safe executes any transaction that 3 of its 7 owners approve; all 7 are ECDSA-key accounts. 3 forged owner keys move everything. One forged delegate key spends its allowance (22,000 USDC and 3 ETH per period in all); one of 6 Roles callers' keys sends what its role allows.

## Evidence

- The [Safe code](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) recovers each owner signature with ecrecover and accepts it if the signer is an owner; this Safe needs 3.
- [swapOwner](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code), run by an owner-approved transaction, can put in a contract owner that the Safe asks through ERC-1271.
- Its [AllowanceModule](https://etherscan.io/address/0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134#code) pays from the Safe on one delegate's ecrecover signature; 5 delegates hold live allowances.

## Reviewer notes

### Mechanism

The address is a 170-byte Gnosis Proxy whose slot 0 holds the Safe 1.3.0 singleton 0xd9db…9552; every call is delegated to it (VERSION 1.3.0). execTransaction hashes the Safe transaction with the nonce and calls checkSignatures, which needs the stored threshold (3) and calls checkNSignatures. Each 65-byte slot is a contract signature (v=0, ERC-1271 isValidSignature on the owner), an approval (v=1, msg.sender or approveHash), an eth_sign signature (v>30, ecrecover of the prefixed hash) or a plain signature (ecrecover of the hash); the signer must be a distinct owner in ascending order. The transaction runs with any target, value, data and operation, so 3 owners can move all funds or change owners. Two modules are enabled and execute through execTransactionFromModule with no owner signature: AllowanceModule 0xcfbf…3134 (executeAllowanceTransfer checks one delegate signature, ecrecover at line 270, v=0 refused at 261, empty signature means msg.sender at 252; limits 2,000+5,000×4 USDC per 30 days or week and 3 ETH per week) and Zodiac Roles 0xdca5…2bda (minimal proxy to 0xd8df…1889; execTransactionWithRole checks msg.sender is an enabled module and a role member, then executes from the Safe).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271: the Safe asks only owners that are contracts (v=0); all 7 owners are ECDSA-key accounts. The AllowanceModule refuses v=0 (line 261) but accepts a direct call from the delegate (line 252), so a post-quantum delegate account still works.
- Ruled out: wrong code: slot 0 holds the 1.3.0 singleton and VERSION answers 1.3.0; the tool missed it because the Safe proxy uses slot 0, not EIP-1967.
- Ruled out: unused address: nonce 522; 2 owners recovered in the study window.
- Ruled out: value: the tool's $4.09M at the block, not the old $18.0M. Whose it is no check shows; whose left empty, project left empty.
- Ruled out: replays 0x16a1d468…, 0x5b42f691… belong to other Safes and fail on their sender's gas limit; not cited. Safe 1.3.0 passes all gas to ecrecover.
- Ruled out: EIP-7702 owner 0x82eb…3dab still recovers under EIP-8151; its ECDSA key controls it.
- Ruled out: delegate 0x255a… has a 0 USDC allowance at the block: 5 delegates hold live allowances (3 are owners).

### Questions

- What the Roles module's roles permit cannot be read at the block (no getter for role scopes), so how much one Roles caller's key can move is open.
- Whose money the $4.09M is (the owners' own or held for others) is not shown by any check.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
