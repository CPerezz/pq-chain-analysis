---
id: gnosissafe-52cfa98f-owner-ecdsa-keys
format: 2
title: Two forged owner keys would let a quantum attacker empty this Safe
status: confirmed
severity: MEDIUM
justification: Two forged owner keys move all its funds; the fix needs the owners to swap in post-quantum signers.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x52cfa98fb7339f6e2e70f2f68acbb7b7dcebe46a'
  name: GnosisSafe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
value:
  usd: 30426339
  basis: held
activity:
  txs_90d: 57
impact: funds-loss
action: Swap owner keys for new post-quantum signers that answer isValidSignature(bytes,bytes); do the same in the
  delegate Safe or remove it.
evidence_level: source
checks:
- id: version
  call: '0x52cfa98fb7339f6e2e70f2f68acbb7b7dcebe46a'
  fn: VERSION()(string)
  is: 1.3.0
  says: the Safe runs version 1.3.0
  for:
  - evidence-1
- id: singleton
  storage: '0x52cfa98fb7339f6e2e70f2f68acbb7b7dcebe46a'
  slot: '0x0'
  is: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  says: the proxy's slot 0 holds the Safe 1.3.0 singleton
  for:
  - evidence-1
- id: threshold
  call: '0x52cfa98fb7339f6e2e70f2f68acbb7b7dcebe46a'
  fn: getThreshold()(uint256)
  is: 2
  says: two owner approvals are needed
  for:
  - evidence-2
  - justification
  - what
- id: owners
  call: '0x52cfa98fb7339f6e2e70f2f68acbb7b7dcebe46a'
  fn: getOwners()(address[])
  is:
  - '0xe2d605f9e12e3bef50c6b7ee83f390d9e0c179fa'
  - '0x647946c28a4f03f695a89dd16cfa032fc88c63d8'
  - '0x56bf69843265e66a92d6b7c52b0bf5897074974c'
  - '0xa6fc9b18a06f5d2c8ea150a6134b5b8033250e8e'
  - '0xbe01115590d88e4001a656d5272c05f10cad2eeb'
  says: the Safe has five owners
  for:
  - evidence-2
  - justification
  - what
- id: code-o1
  code: '0xe2d605f9e12e3bef50c6b7ee83f390d9e0c179fa'
  is: empty
  says: owner 1 holds no code
  for:
  - evidence-2
  - what
- id: code-o2
  code: '0x647946c28a4f03f695a89dd16cfa032fc88c63d8'
  is: empty
  says: owner 2 holds no code
  for:
  - evidence-2
  - what
- id: code-o3
  code: '0x56bf69843265e66a92d6b7c52b0bf5897074974c'
  is: empty
  says: owner 3 holds no code
  for:
  - evidence-2
  - what
- id: code-o4
  code: '0xa6fc9b18a06f5d2c8ea150a6134b5b8033250e8e'
  is: empty
  says: owner 4 holds no code
  for:
  - evidence-2
  - what
- id: code-o5
  code: '0xbe01115590d88e4001a656d5272c05f10cad2eeb'
  is: empty
  says: owner 5 holds no code
  for:
  - evidence-2
  - what
- id: nonce-o1
  nonce: '0xe2d605f9e12e3bef50c6b7ee83f390d9e0c179fa'
  min: 1
  says: owner 1 has sent transactions (256), so its public key is public
  for:
  - evidence-2
  - what
- id: nonce-o2
  nonce: '0x647946c28a4f03f695a89dd16cfa032fc88c63d8'
  min: 1
  says: owner 2 has sent transactions (6), so its public key is public
  for:
  - evidence-2
  - what
- id: nonce-o3
  nonce: '0x56bf69843265e66a92d6b7c52b0bf5897074974c'
  min: 1
  says: owner 3 has sent transactions (57), so its public key is public
  for:
  - evidence-2
  - what
- id: nonce-o4
  nonce: '0xa6fc9b18a06f5d2c8ea150a6134b5b8033250e8e'
  min: 1
  says: owner 4 has sent transactions (50), so its public key is public
  for:
  - evidence-2
  - what
- id: nonce-o5
  nonce: '0xbe01115590d88e4001a656d5272c05f10cad2eeb'
  min: 1
  says: owner 5 has sent transactions (512), so its public key is public
  for:
  - evidence-2
  - what
- id: execsig
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 145
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction checks the owners' signatures before it executes
  for:
  - justification
  - what
- id: execute
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 176
  has: success = execute(to, value, data, operation,
  says: then executes any call or delegatecall the owners signed
  for:
  - justification
  - what
- id: thresholdsrc
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  lines:
  - 227
  - 230
  has: checkNSignatures(dataHash, data, signatures, _threshold);
  says: the number of signatures required is the stored threshold
  for:
  - what
- id: legacy
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 285
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  says: an owner that is a contract is asked through isValidSignature with the full signature
  for:
  - action
  - evidence-1
  - justification
- id: magic
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/interfaces/ISignatureValidator.sol
  line: 6
  has: bytes4 internal constant EIP1271_MAGIC_VALUE = 0x20c13b0b;
  says: the answer it expects is the legacy isValidSignature(bytes,bytes) magic value
  for:
  - action
  - evidence-1
- id: sel-legacy
  selector: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  fn: isValidSignature(bytes,bytes)
  says: the singleton's code holds the legacy selector 0x20c13b0b
  for:
  - action
  - evidence-1
- id: sel-final
  selector: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the final ERC-1271 selector 0x1626ba7e is not in the singleton's code
  for:
  - action
  - evidence-1
- id: ethsign
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 295
  has: currentOwner = ecrecover(keccak256(abi.encodePacked(
  says: an eth_sign signature is recovered with ecrecover
  for:
  - evidence-1
- id: ecdsa
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: a plain signature is recovered with ecrecover; the owner's account is not asked
  for:
  - action
  - evidence-1
  - justification
  - what
- id: isowner
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 301
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
    "GS026");
  says: each recovered address must be a distinct owner
  for:
  - evidence-1
  - justification
  - what
- id: swap
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/OwnerManager.sol
  lines:
  - 94
  - 98
  has: address newOwner ) public authorized {
  says: swapOwner can only be called by the Safe itself
  for:
  - action
  - justification
  - what
- id: swapset
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/OwnerManager.sol
  lines:
  - 106
  - 108
  has: owners[prevOwner] = newOwner; owners[oldOwner] = address(0);
  says: swapOwner puts the new owner in place of the old one
  for:
  - action
  - what
- id: selfauth
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/common/SelfAuthorized.sol
  line: 8
  has: require(msg.sender == address(this), "GS031");
  says: authorized means a call from the Safe itself, so through execTransaction
  for:
  - action
  - justification
  - what
- id: guard
  storage: '0x52cfa98fb7339f6e2e70f2f68acbb7b7dcebe46a'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no transaction guard is set
  for:
  - notes
- id: nonce-safe
  call: '0x52cfa98fb7339f6e2e70f2f68acbb7b7dcebe46a'
  fn: nonce()(uint256)
  is: 456
  says: the Safe has executed 456 owner-signed transactions
  for:
  - notes
- id: modules
  call: '0x52cfa98fb7339f6e2e70f2f68acbb7b7dcebe46a'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 10
  is:
  - - '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  - '0x0000000000000000000000000000000000000001'
  says: one module is enabled, the allowance module
  for:
  - evidence-3
- id: modexec
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/ModuleManager.sol
  lines:
  - 68
  - 70
  has: success = execute(to, value, data, operation, gasleft());
  says: an enabled module executes from the Safe without owner signatures
  for:
  - evidence-3
- id: delegates
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getDelegates(address,uint48,uint8)(address[],uint48)
  args:
  - '0x52cfa98fb7339f6e2e70f2f68acbb7b7dcebe46a'
  - 0
  - 50
  is:
  - - '0xdf4b8041a27fcee2b255aa27d6f36303d58417df'
  - 0
  says: the module holds one delegate for this Safe
  for:
  - action
  - evidence-3
- id: tokens
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokens(address,address)(address[])
  args:
  - '0x52cfa98fb7339f6e2e70f2f68acbb7b7dcebe46a'
  - '0xdf4b8041a27fcee2b255aa27d6f36303d58417df'
  is:
  - '0xdac17f958d2ee523a2206206994597c13d831ec7'
  says: the delegate's allowance is in USDT
  for:
  - evidence-3
- id: allowance
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0x52cfa98fb7339f6e2e70f2f68acbb7b7dcebe46a'
  - '0xdf4b8041a27fcee2b255aa27d6f36303d58417df'
  - '0xdac17f958d2ee523a2206206994597c13d831ec7'
  is:
  - 2000000000000
  - 0
  - 10080
  - 29906802
  - 1
  says: allowance 2,000,000,000,000 units, none spent, reset every 10,080 minutes
  for:
  - evidence-3
- id: usdt-dec
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: decimals()(uint256)
  is: 6
  says: USDT has 6 decimals, so the allowance is 2,000,000 USDT
  for:
  - evidence-3
- id: usdt-bal
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0x52cfa98fb7339f6e2e70f2f68acbb7b7dcebe46a'
  is: 9953546680697
  says: the Safe holds 9,953,546 USDT
  for:
  - notes
- id: am-reset
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: contracts/AlowanceModule.sol
  lines:
  - 104
  - 105
  has: allowance.spent = 0;
  says: the spent amount resets once the reset time has passed
  for:
  - evidence-3
- id: am-limit
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: contracts/AlowanceModule.sol
  line: 168
  has: newSpent <= allowance.amount
  says: a transfer may not exceed the allowance
  for:
  - evidence-3
- id: am-match
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: contracts/AlowanceModule.sol
  line: 244
  has: expectedDelegate == signer && delegates[address(safe)][uint48(signer)].delegate == signer
  says: the signer must be the registered delegate
  for:
  - evidence-3
- id: am-sender
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: contracts/AlowanceModule.sol
  line: 252
  has: if (signature.length == 0) return msg.sender;
  says: with no signature the caller counts as the signer, so the delegate Safe can call it directly
  for:
  - evidence-3
- id: am-transfer
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: contracts/AlowanceModule.sol
  line: 282
  has: require(safe.execTransactionFromModule(token, 0, data, Enum.Operation.Call), "Could not execute token transfer");
  says: the module moves the tokens out of the Safe as a module transaction
  for:
  - evidence-3
- id: am-remove
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: contracts/AlowanceModule.sol
  lines:
  - 323
  - 324
  has: Delegate memory current = delegates[msg.sender][uint48(delegate)];
  says: the Safe itself removes a delegate of its own
  for:
  - action
- id: dsafe-singleton
  storage: '0xdf4b8041a27fcee2b255aa27d6f36303d58417df'
  slot: '0x0'
  is: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  says: the delegate is a Safe 1.3.0 proxy
  for:
  - evidence-3
- id: dsafe-threshold
  call: '0xdf4b8041a27fcee2b255aa27d6f36303d58417df'
  fn: getThreshold()(uint256)
  is: 2
  says: the delegate Safe needs two owners
  for:
  - evidence-3
- id: dsafe-owners
  call: '0xdf4b8041a27fcee2b255aa27d6f36303d58417df'
  fn: getOwners()(address[])
  is:
  - '0x647946c28a4f03f695a89dd16cfa032fc88c63d8'
  - '0x56bf69843265e66a92d6b7c52b0bf5897074974c'
  - '0xbe01115590d88e4001a656d5272c05f10cad2eeb'
  - '0x2d517818ace2a100e42709d0b51a769b8589d990'
  says: the delegate Safe has four owners, three of them owners here
  for:
  - evidence-3
- id: dsafe-o4code
  code: '0x2d517818ace2a100e42709d0b51a769b8589d990'
  is: empty
  says: the delegate Safe's fourth owner holds no code
  for:
  - notes
- id: dsafe-o4nonce
  nonce: '0x2d517818ace2a100e42709d0b51a769b8589d990'
  min: 1
  says: the delegate Safe's fourth owner has sent transactions
  for:
  - notes
- id: tx1
  tx: '0xbcdcc5db0361e57b4118e4dfc2e27851ce5fb10baf2fca38a5b82343288a48c9'
  to: '0x52cfa98fb7339f6e2e70f2f68acbb7b7dcebe46a'
  ok: true
  says: an execTransaction of this Safe that succeeded (gas limit 109,998, used 107,974)
  for:
  - notes
- id: tx2
  tx: '0x4c02db3721a7a52d7ec398dba3263f1c912b4ad09b14ce22e2d20509db61ea8e'
  to: '0x52cfa98fb7339f6e2e70f2f68acbb7b7dcebe46a'
  ok: true
  says: an execTransaction of this Safe that succeeded (gas limit 144,152, used 141,859)
  for:
  - notes
- id: tx3
  tx: '0x976fb68db8de6d969f4d74d5d54ab6a59104a1b81455c85b3c6628eccc47fcd2'
  to: '0x52cfa98fb7339f6e2e70f2f68acbb7b7dcebe46a'
  ok: true
  says: an execTransaction of this Safe that succeeded (gas limit 126,916, used 124,759)
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
- who: r-52cfa98f, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: A Safe 1.3.0 proxy holding about 9.95M USDT, 2 of 5 owners, all code-less keys that have sent transactions.
    MEDIUM, PQ-12: two forged owner keys move everything or replace the owners; the fix is swapOwner to signer contracts
    answering the legacy isValidSignature(bytes,bytes). The card also states the second path: the allowance module
    lets a delegate, itself a 2-of-4 Safe of ECDSA owners, move up to 2,000,000 USDT every 7 days, and the action
    covers that Safe too. Author A-52cfa98f; refuter R-52cfa98f agreed with no objection; the reader changed nothing.
    The author''s lead, three of this Safe''s transactions that left about 2,000 gas unused, gets a gas-limit row.'
related: []
---

## What happens

This Safe runs any transaction approved by two of its five owners, and all five sign with ECDSA keys. Each owner is an account with no code that has sent transactions, so its public key is on chain. A quantum attacker who recovers two of these keys can move all it holds or replace the owners.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) recovers owner signatures with ecrecover; it asks owners that are contracts via isValidSignature(bytes,bytes).
- The [Safe](https://etherscan.io/address/0x52cfa98fb7339f6e2e70f2f68acbb7b7dcebe46a#readProxyContract) needs 2 of its 5 owners; none of them holds code and each has sent transactions.
- Its [allowance module](https://etherscan.io/address/0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134#code) also lets a delegate, [a 2-of-4 Safe](https://etherscan.io/address/0xdf4b8041a27fcee2b255aa27d6f36303d58417df), move up to 2,000,000 USDT every 7 days.

## Reviewer notes

### Mechanism

Safe 1.3.0 proxy: slot 0 holds singleton 0xd9db...9552, VERSION() is 1.3.0. execTransaction (GnosisSafe.sol 111-194) calls checkSignatures (145), then executes any call or delegatecall (176). checkSignatures needs the threshold, 2 (227-230). checkNSignatures (240-304) reads 2 signature slots: v=0 asks an owner contract through the legacy isValidSignature(bytes,bytes), magic 0x20c13b0b (285; the final ERC-1271 selector 0x1626ba7e is absent from the singleton); v=1 takes msg.sender or an approveHash (291); otherwise ecrecover, eth_sign (295) or plain (299). Each result must be an owner, in ascending order (301). All five owners have empty code and nonces 6 to 512, so each approval rests on an ECDSA key whose public key is exposed. An owner that moves its own account to real code in place stays forgeable: line 299 recovers its address and never asks it. Owners change only by self-call (swapOwner 94-111, authorized: msg.sender == this), so through execTransaction with 2 owners. No guard (guard slot zero). One module is enabled, AllowanceModule 0.1.0 (0xcfbf...3134), with one delegate: Safe 0xdf4b...17df (1.3.0, 2 of 4; three owners shared with this Safe plus EOA 0x2d51...d990), allowed 2,000,000 USDT per 10,080 minutes, none spent. executeAllowanceTransfer takes the delegate as msg.sender (line 252) and transfers through execTransactionFromModule, which needs no owner signature (ModuleManager 68-70). This Safe holds 9,953,546 USDT.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path that protects owners: v=0 asks owners that are contracts (line 285), but all five owners have empty code; an owner that moves to real code at the same address is still recovered at line 299.
- Ruled out: implementation-only use: this address is a Safe proxy with its own state (threshold 2, nonce 456, 57 transactions in the 90 days to the block).
- Ruled out: a guard that limits transactions: the guard slot is zero at the block.
- Ruled out: the family replays 0x16a1d468..., 0x5b42f691... and 0xd34b6a89... call other Safes (0x237dee52..., 0x61a2c600..., 0x40a2accb...), not this one; not cited.
- Ruled out: beside this card, a possible sender-gas-limits row under EIP-8151: this Safe's execTransaction transactions 0xbcdcc5db..., 0x4c02db37... and 0x976fb68d... from owner 0xbe01...2eeb left 2,024, 2,293 and 2,157 gas unused, each recovering one owner by ECDSA; no replay of them is in the dossier.
- Ruled out: whose money: not established; the chain does not tell a team treasury from funds held for others.
- Ruled out: the delegate Safe 0xdf4b...17df is its own wallet with four ECDSA owners (EOA 0x2d51...d990 has empty code, nonce 906) and is rated on its own; here it only adds a capped second way out.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
