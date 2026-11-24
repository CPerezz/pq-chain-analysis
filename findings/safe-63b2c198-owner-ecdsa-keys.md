---
id: safe-63b2c198-owner-ecdsa-keys
format: 2
title: Two ECDSA owner keys can move everything this 2-of-2 Safe holds
status: confirmed
severity: MEDIUM
justification: 'Forged owner keys take everything; fixable in place: both owners approve swapping an owner for a
  post-quantum signer.'
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x63b2c1985e1d061fe3ff050ef44c7174292d7334'
  name: Safe
  code: verified
  code_url: https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code
  proxy_of: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  copies: 1
value:
  usd: 29717556
  basis: held
activity:
  txs_90d: 6
impact: funds-loss
action: Swap each owner for a post-quantum signer answering isValidSignature(bytes,bytes), and remove or replace
  the module's ECDSA delegates.
evidence_level: source
checks:
- id: exec
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 172
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction runs only after checkSignatures accepts the owners' approvals
  for:
  - justification
  - what
- id: ecdsa
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 329
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: an owner's signature over the transaction hash is recovered with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: ethsign
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 325
  has: currentOwner = ecrecover(keccak256(abi.encodePacked(
  says: an eth_sign signature of an owner is also recovered with ECDSA
  for:
  - evidence-1
  - what
- id: approved
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 321
  has: msg.sender == currentOwner || approvedHashes[currentOwner][dataHash] != 0
  says: the other way to approve is to send the transaction or call approveHash, both from the owner's own account
  for:
  - what
- id: isowner
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 331
  has: owners[currentOwner] != address(0)
  says: each recovered or named address must be an owner
  for:
  - what
- id: legacy
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 315
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  says: an owner that is a contract is asked through isValidSignature
  for:
  - action
  - evidence-1
  - justification
- id: magic
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/interfaces/ISignatureValidator.sol
  line: 6
  has: bytes4 internal constant EIP1271_MAGIC_VALUE = 0x20c13b0b;
  says: the answer expected is the legacy isValidSignature(bytes,bytes) magic value
  for:
  - action
  - evidence-1
  - justification
- id: sel-legacy
  selector: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  fn: isValidSignature(bytes,bytes)
  says: the singleton's code holds the legacy selector 0x20c13b0b
  for:
  - action
  - evidence-1
- id: sel-final
  selector: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the final ERC-1271 selector 0x1626ba7e is not in the singleton's code
  for:
  - action
  - evidence-1
- id: version
  call: '0x63b2c1985e1d061fe3ff050ef44c7174292d7334'
  fn: VERSION()(string)
  is: 1.4.1
  says: the Safe runs version 1.4.1
  for:
  - evidence-1
- id: singleton
  storage: '0x63b2c1985e1d061fe3ff050ef44c7174292d7334'
  slot: '0x0'
  is: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  says: slot 0 of the proxy holds the Safe 1.4.1 singleton
  for:
  - evidence-1
- id: owners
  call: '0x63b2c1985e1d061fe3ff050ef44c7174292d7334'
  fn: getOwners()(address[])
  is:
  - '0x013026a1e49de86672f1312d9b98707f3d39ce26'
  - '0x4550ee9d322a49c0e9675b7702c1d30c8d1c8bb2'
  says: the Safe has two owners
  for:
  - evidence-2
  - justification
  - what
- id: threshold
  call: '0x63b2c1985e1d061fe3ff050ef44c7174292d7334'
  fn: getThreshold()(uint256)
  is: 2
  says: both owners must approve a transaction
  for:
  - evidence-2
  - justification
  - what
- id: nonce-safe
  call: '0x63b2c1985e1d061fe3ff050ef44c7174292d7334'
  fn: nonce()(uint256)
  is: 16
  says: the Safe has executed 16 owner-approved transactions
  for:
  - notes
- id: guard
  storage: '0x63b2c1985e1d061fe3ff050ef44c7174292d7334'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no transaction guard is set
  for:
  - notes
- id: code-o1
  code: '0x013026a1e49de86672f1312d9b98707f3d39ce26'
  is: empty
  says: 'owner 0x0130…ce26 has no code: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-o2
  code: '0x4550ee9d322a49c0e9675b7702c1d30c8d1c8bb2'
  is: empty
  says: 'owner 0x4550…8bb2 has no code: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: nonce-o1
  nonce: '0x013026a1e49de86672f1312d9b98707f3d39ce26'
  is: 29
  says: owner 0x0130…ce26 has sent 29 transactions, so its public key is on-chain
  for:
  - evidence-2
- id: nonce-o2
  nonce: '0x4550ee9d322a49c0e9675b7702c1d30c8d1c8bb2'
  is: 10
  says: owner 0x4550…8bb2 has sent 10 transactions, so its public key is on-chain
  for:
  - evidence-2
- id: usdt
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0x63b2c1985e1d061fe3ff050ef44c7174292d7334'
  is: 15533729236121
  says: the Safe holds 15,533,729.24 USDT
  for:
  - what
- id: usdc
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0x63b2c1985e1d061fe3ff050ef44c7174292d7334'
  is: 14202822484591
  says: the Safe holds 14,202,822.48 USDC
  for:
  - what
- id: swap
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/base/OwnerManager.sol
  lines:
  - 99
  - 109
  has: function swapOwner(address prevOwner, address oldOwner, address newOwner) public authorized {
  says: swapOwner replaces one owner address with another
  for:
  - action
  - justification
- id: self
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/common/SelfAuthorized.sol
  line: 10
  has: require(msg.sender == address(this), "GS031");
  says: authorized functions run only as a transaction of the Safe itself, so both owners approve a swap
  for:
  - action
  - justification
- id: modules
  call: '0x63b2c1985e1d061fe3ff050ef44c7174292d7334'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 10
  is:
  - - '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  - '0x0000000000000000000000000000000000000001'
  says: the Allowance Module is the one module enabled
  for:
  - evidence-3
  - what
- id: module-exec
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/base/ModuleManager.sol
  line: 88
  has: require(msg.sender != SENTINEL_MODULES && modules[msg.sender] != address(0), "GS104");
  says: an enabled module executes transactions of the Safe without the owners' signatures
  for:
  - what
- id: delegates
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getDelegates(address,uint48,uint8)(address[],uint48)
  args:
  - '0x63b2c1985e1d061fe3ff050ef44c7174292d7334'
  - 0
  - 50
  is:
  - - '0xde48b4c6eb8b33d0806c52d72f1a099d23c07383'
    - '0x4550ee9d322a49c0e9675b7702c1d30c8d1c8bb2'
    - '0x013026a1e49de86672f1312d9b98707f3d39ce26'
  - 0
  says: 'the module lists three delegates for this Safe: 0xde48…7383 and both owners'
  for:
  - action
  - evidence-3
  - what
- id: code-dl
  code: '0xde48b4c6eb8b33d0806c52d72f1a099d23c07383'
  is: empty
  says: 'delegate 0xde48…7383 has no code: a plain ECDSA key'
  for:
  - what
- id: al-dl-usdc
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0x63b2c1985e1d061fe3ff050ef44c7174292d7334'
  - '0xde48b4c6eb8b33d0806c52d72f1a099d23c07383'
  - '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  is:
  - 100000000000
  - 0
  - 1440
  - 29915201
  - 2
  says: delegate 0xde48…7383 may send 100,000 USDC every 1,440 minutes (a day), none spent
  for:
  - evidence-3
  - what
- id: al-dl-usdt
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0x63b2c1985e1d061fe3ff050ef44c7174292d7334'
  - '0xde48b4c6eb8b33d0806c52d72f1a099d23c07383'
  - '0xdac17f958d2ee523a2206206994597c13d831ec7'
  is:
  - 100000000000
  - 0
  - 1440
  - 29915247
  - 1
  says: delegate 0xde48…7383 may send 100,000 USDT a day, none spent
  for:
  - evidence-3
  - what
- id: al-o2-usdc
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0x63b2c1985e1d061fe3ff050ef44c7174292d7334'
  - '0x4550ee9d322a49c0e9675b7702c1d30c8d1c8bb2'
  - '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  is:
  - 30000000000
  - 0
  - 1440
  - 29915245
  - 1
  says: owner 0x4550…8bb2 may send 30,000 USDC a day alone
  for:
  - evidence-3
  - what
- id: al-o2-usdt
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0x63b2c1985e1d061fe3ff050ef44c7174292d7334'
  - '0x4550ee9d322a49c0e9675b7702c1d30c8d1c8bb2'
  - '0xdac17f958d2ee523a2206206994597c13d831ec7'
  is:
  - 30000000000
  - 0
  - 1440
  - 29915250
  - 1
  says: owner 0x4550…8bb2 may send 30,000 USDT a day alone
  for:
  - evidence-3
  - what
- id: al-o1-usdc
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0x63b2c1985e1d061fe3ff050ef44c7174292d7334'
  - '0x013026a1e49de86672f1312d9b98707f3d39ce26'
  - '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  is:
  - 30000000000
  - 0
  - 1440
  - 29914976
  - 1
  says: owner 0x0130…ce26 may send 30,000 USDC a day alone
  for:
  - evidence-3
  - what
- id: al-o1-usdt
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0x63b2c1985e1d061fe3ff050ef44c7174292d7334'
  - '0x013026a1e49de86672f1312d9b98707f3d39ce26'
  - '0xdac17f958d2ee523a2206206994597c13d831ec7'
  is:
  - 30000000000
  - 0
  - 1440
  - 29914735
  - 1
  says: owner 0x0130…ce26 may send 30,000 USDT a day alone
  for:
  - evidence-3
  - what
- id: mod-ecdsa
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: contracts/AlowanceModule.sol
  line: 270
  has: owner = ecrecover(keccak256(transferHashData), v, r, s);
  says: the module recovers a delegate's transfer signature with ECDSA
  for:
  - evidence-3
  - what
- id: mod-direct
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: contracts/AlowanceModule.sol
  line: 252
  has: if (signature.length == 0) return msg.sender;
  says: without a signature the module takes the caller as the delegate, so a delegate contract can call it directly
  for:
  - action
- id: mod-delegate
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: contracts/AlowanceModule.sol
  line: 244
  has: expectedDelegate == signer && delegates[address(safe)][uint48(signer)].delegate == signer
  says: the signer must be a delegate listed for this Safe
  for:
  - what
- id: mod-limit
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: contracts/AlowanceModule.sol
  line: 168
  has: require(newSpent > allowance.spent && newSpent <= allowance.amount
  says: a transfer must fit the delegate's allowance
  for:
  - what
- id: mod-transfer
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: contracts/AlowanceModule.sol
  line: 282
  has: require(safe.execTransactionFromModule(token, 0, data, Enum.Operation.Call)
  says: the module moves the tokens out of the Safe
  for:
  - what
- id: remove-delegate
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: contracts/AlowanceModule.sol
  lines:
  - 323
  - 324
  has: function removeDelegate(address delegate, bool removeAllowances) public { Delegate memory current = delegates[msg.sender][uint48(delegate)];
  says: the Safe itself removes a delegate and its allowances
  for:
  - action
- id: tx-recent
  tx: '0x90a8b4526f100a8f3a64bd9c95d9bbd1a5d8c357243333e50ccf8a1201d519e1'
  to: '0x63b2c1985e1d061fe3ff050ef44c7174292d7334'
  ok: true
  says: an owner-approved transaction executed through this Safe in block 26,414,205
  for:
  - notes
- id: nsig
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: checkNSignatures(dataHash, data, signatures, _threshold);
  says: the number of approvals required is the threshold
  line: 262
  for:
  - justification
- id: distinct
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
    "GS026");
  says: approvals must come from distinct owners in ascending order
  line: 331
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
reviews:
- who: r-63b2c198, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: refuted
  note: 'disagree: justification: ''both owners must move to new post-quantum signers'' is not required by the code:
    with threshold 2 and distinct owners (Safe.sol 262/284/331), swapping one owner for a post-quantum signer (or
    adding one with threshold 3) already stops a forged transaction; it should say both owners must approve the
    move to post-quantum signers (and the module''s ECDSA delegates must go). Severity MEDIUM stands. (the card
    was edited after this answer)'
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: A 2-of-2 Safe on the 1.4.1 singleton holding about 15.5M USDT and 14.2M USDC; both owners are code-less
    keys that have sent transactions. MEDIUM, PQ-12: forging the two owner keys moves everything. Its Allowance
    Module also lets three ECDSA delegates, both owners among them, each send a daily amount of USDC and USDT alone
    (100,000 of each for one delegate, 30,000 for each owner); the action swaps the owners and removes or replaces
    those delegates. Author A-63b2c198. Refuter R-63b2c198 kept the rating and disagreed on the severity reason,
    rightly: the code does not need both owners to change, since every transaction needs two distinct owners and
    one post-quantum owner already stops a forged one. The reader corrected that sentence and added the point to
    ruled_out with the refuter''s two checks.'
related: []
---

## What happens

This Safe holds about 15.5M USDT and 14.2M USDC and runs any transaction both its owners approve. Both owners are ECDSA keys, so forging the two keys moves everything. Its Allowance Module also lets three ECDSA delegates, both owners among them, each send a daily amount of USDC and USDT alone.

## Evidence

- [Safe 1.4.1](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) accepts an owner's ECDSA signature, and asks an owner that is a contract only through the older isValidSignature(bytes,bytes).
- The [Safe](https://etherscan.io/address/0x63b2c1985e1d061fe3ff050ef44c7174292d7334) needs both of its 2 owners; both are accounts without code that have sent transactions, so their public keys are known.
- Its [Allowance Module](https://etherscan.io/address/0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134#code) lets one delegate send 100,000 USDC and 100,000 USDT a day, and each owner 30,000 of each, on an ECDSA signature.

## Reviewer notes

### Mechanism

execTransaction (Safe.sol 172) calls checkNSignatures (274-333) for threshold-many slots, here 2. v == 0 asks a contract owner through the legacy isValidSignature(bytes,bytes) (315); v == 1 takes the sender or an approveHash (321); v > 30 and the default recover ECDSA (325, 329); each address must be an owner, ascending (331). Both owners have no code, so each approves by ECDSA signature or by a transaction its own key signs. swapOwner (OwnerManager 99) runs only as a Safe transaction. The enabled Allowance Module 0xcfbf...3134: executeAllowanceTransfer recovers the delegate's ECDSA signature (265-270) or takes the caller (252), requires a delegate listed for this Safe (244) and an amount within the daily allowance (168), then moves tokens with execTransactionFromModule (282; ModuleManager 88). Delegates: 0xde48...7383 (100,000 USDC, 100,000 USDT, 10 ETH, 10 stETH a day) and each owner (30,000 USDC and 30,000 USDT a day); nothing spent at the block.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 for these owners: asked only of owners that are contracts (line 315); both owners have no code and are recovered with ECDSA.
- Ruled out: An owner upgrading its own account in place: the Safe still recovers its address from an ECDSA signature and never asks it; only swapOwner to a new address helps.
- Ruled out: Final ERC-1271: 0x1626ba7e is absent from the 1.4.1 singleton, so a signer answering only it does not count; the action names isValidSignature(bytes,bytes).
- Ruled out: Swapping the singleton alone: owners and delegates stay ECDSA keys.
- Ruled out: A guard: the guard slot is empty.
- Ruled out: Unused implementation: this is the proxy in use (slot 0 holds the 1.4.1 singleton, nonce 16, tx 0x90a8...19e1 succeeded in block 26,414,205).
- Ruled out: LOW: swapOwner is a setting, but both owners must move to new post-quantum signer accounts (MEDIUM: owners migrating their accounts); value plays no part.
- Ruled out: ETH and stETH allowances of 0xde48...7383 move nothing: the Safe holds 2 gwei of ETH and 1 wei of stETH.
- Ruled out: Family replay 0x09827fd9...1328 fails under EIP-8151 alone but went to 0x9641d764...02e2 with signer 0x033ac...dcdd, neither this Safe nor its owners: for the main reviewer to place.
- Ruled out: EIP-8151: an owner whose account takes real code loses only its ECDSA path here and keeps approveHash and sending the transaction itself; a separate notice, not folded in.
- Ruled out: both owners having to change: every transaction needs two distinct owners, so one post-quantum owner already stops a forged transaction; the module's ECDSA delegates must go either way.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
