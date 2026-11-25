---
id: proxy-0632dcc3-safe-owner-ecdsa
format: 2
title: Safe wallet's funds move on two ECDSA owner keys a quantum computer could forge
status: confirmed
severity: MEDIUM
justification: Two forged owner keys can take everything; the owners can fix it by swapping in post-quantum signer
  contracts.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0632dcc37b1fabf2cad20538a5390d23c830962e'
  name: Proxy
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 24574213
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Swap each owner for a post-quantum signer contract answering isValidSignature(bytes,bytes); an owner upgraded
  in place stays forgeable.
evidence_level: source
checks:
- id: proxy-slot
  storage: '0x0632dcc37b1fabf2cad20538a5390d23c830962e'
  slot: '0x0'
  is: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  says: slot 0 of this address holds the Safe 1.3.0 singleton
  for:
  - evidence-2
  - proxy_of
  - upgradeable
  - what
- id: proxy-code
  source: '0x0632dcc37b1fabf2cad20538a5390d23c830962e'
  file: Proxy.sol
  lines:
  - 28
  - 30
  has: let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
  says: the proxy delegates every call to the address in slot 0
  for:
  - proxy_of
  - upgradeable
  - what
- id: version
  call: '0x0632dcc37b1fabf2cad20538a5390d23c830962e'
  fn: VERSION()(string)
  is: 1.3.0
  says: the Safe answers version 1.3.0
  for:
  - evidence-2
- id: threshold
  call: '0x0632dcc37b1fabf2cad20538a5390d23c830962e'
  fn: getThreshold()(uint256)
  is: 2
  says: two owner approvals are required
  for:
  - evidence-2
  - justification
  - what
- id: owners
  call: '0x0632dcc37b1fabf2cad20538a5390d23c830962e'
  fn: getOwners()(address[])
  is:
  - '0x2116f47005053ff548386cb0cc902a2141d50caa'
  - '0x2e39edd055956913f4fbe6a328106b6b83f97ddb'
  - '0xe3c0f7db1643b1fc69e5555c307b172922b56719'
  says: the Safe has three owners
  for:
  - evidence-2
  - what
- id: code-1
  code: '0x2116f47005053ff548386cb0cc902a2141d50caa'
  is: empty
  says: 'owner 1 has no code: a plain key'
  for:
  - evidence-2
  - what
- id: code-2
  code: '0x2e39edd055956913f4fbe6a328106b6b83f97ddb'
  is: empty
  says: 'owner 2 has no code: a plain key'
  for:
  - evidence-2
  - what
- id: code-3
  code: '0xe3c0f7db1643b1fc69e5555c307b172922b56719'
  is: empty
  says: 'owner 3 has no code: a plain key'
  for:
  - evidence-2
  - what
- id: nonce-1
  nonce: '0x2116f47005053ff548386cb0cc902a2141d50caa'
  min: 1
  says: owner 1 has sent transactions, so its public key is on-chain
  for:
  - what
- id: nonce-2
  nonce: '0x2e39edd055956913f4fbe6a328106b6b83f97ddb'
  min: 1
  says: owner 2 has sent transactions, so its public key is on-chain
  for:
  - what
- id: nonce-3
  nonce: '0xe3c0f7db1643b1fc69e5555c307b172922b56719'
  min: 1
  says: owner 3 has sent transactions, so its public key is on-chain
  for:
  - what
- id: guard
  storage: '0x0632dcc37b1fabf2cad20538a5390d23c830962e'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no transaction guard is set
  for:
  - evidence-2
  - what
- id: exec-sigs
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 145
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction checks the owners' signatures over the transaction hash
  for:
  - evidence-1
  - what
- id: exec-any
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 176
  has: success = execute(to, value, data, operation,
  says: execTransaction then executes the call or delegatecall the owners signed, with any target, value and data
  for:
  - evidence-1
  - justification
  - upgradeable
  - what
- id: delegatecall
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/Executor.sol
  lines:
  - 15
  - 18
  has: success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
  says: a DelegateCall operation runs other code on the Safe's storage, which can rewrite slot 0
  for:
  - upgradeable
- id: ecdsa
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: the default branch recovers the owner's address from an ECDSA signature
  for:
  - action
  - evidence-1
  - justification
  - what
- id: ecdsa-ethsign
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 295
  has: currentOwner = ecrecover(keccak256(abi.encodePacked(
  says: the eth_sign branch also recovers the owner's address with ecrecover
  for:
  - what
- id: approved
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 291
  has: require(msg.sender == currentOwner || approvedHashes[currentOwner][dataHash] != 0, "GS025");
  says: an owner can also approve by sending the transaction or by an earlier approveHash
  for:
  - what
- id: owner-match
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 301
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
    "GS026");
  says: the recovered address counts if it is an owner
  for:
  - action
  - evidence-1
  - justification
  - what
- id: contract-owner
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 285
  has: require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE,
    "GS024");
  says: a contract owner is asked through isValidSignature with the full signature
  for:
  - action
  - evidence-3
  - justification
- id: legacy-sel
  selector: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  fn: isValidSignature(bytes,bytes)
  says: the singleton uses the legacy isValidSignature(bytes,bytes) selector 0x20c13b0b
  for:
  - action
  - evidence-3
- id: final-sel
  selector: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the final ERC-1271 selector 0x1626ba7e is not in the singleton
  for:
  - action
  - evidence-3
- id: swap
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/OwnerManager.sol
  lines:
  - 94
  - 108
  has: owners[prevOwner] = newOwner;
  says: swapOwner (authorized) puts a new owner in place of an old one
  for:
  - action
  - evidence-3
  - justification
- id: self-only
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/common/SelfAuthorized.sol
  line: 8
  has: require(msg.sender == address(this), "GS031");
  says: authorized functions run only when the Safe calls itself, that is through an owner-approved transaction
  for:
  - action
  - evidence-3
  - justification
- id: safe-nonce
  call: '0x0632dcc37b1fabf2cad20538a5390d23c830962e'
  fn: nonce()(uint256)
  is: 201
  says: the Safe has executed 201 owner-approved transactions
  for:
  - notes
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x0632dcc37b1fabf2cad20538a5390d23c830962e'
  is: '4598549319000000000000'
  says: the Safe holds 4,598.55 ETH
  for:
  - notes
- id: modules
  call: '0x0632dcc37b1fabf2cad20538a5390d23c830962e'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 10
  is:
  - - '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  - '0x0000000000000000000000000000000000000001'
  says: AllowanceModule is the only enabled module
  for:
  - notes
- id: delegates
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getDelegates(address,uint48,uint8)(address[],uint48)
  args:
  - '0x0632dcc37b1fabf2cad20538a5390d23c830962e'
  - 0
  - 50
  is:
  - - '0x4e64c2d06d19d13061e62e291b2c4e9fe5679b93'
    - '0x07a7a2f3307a7537de4b03b534bd71b3c7abe22a'
  - 0
  says: the module lists two delegates for this Safe
  for:
  - notes
- id: tokens-1
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokens(address,address)(address[])
  args:
  - '0x0632dcc37b1fabf2cad20538a5390d23c830962e'
  - '0x4e64c2d06d19d13061e62e291b2c4e9fe5679b93'
  is:
  - '0x6b175474e89094c44da98b954eedeac495271d0f'
  - '0x0000000000000000000000000000000000000000'
  says: delegate 1 was ever given allowances in DAI and ETH only
  for:
  - notes
- id: tokens-2
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokens(address,address)(address[])
  args:
  - '0x0632dcc37b1fabf2cad20538a5390d23c830962e'
  - '0x07a7a2f3307a7537de4b03b534bd71b3c7abe22a'
  is:
  - '0x0000000000000000000000000000000000000000'
  says: delegate 2 was ever given an allowance in ETH only
  for:
  - notes
- id: allow-1-dai
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0x0632dcc37b1fabf2cad20538a5390d23c830962e'
  - '0x4e64c2d06d19d13061e62e291b2c4e9fe5679b93'
  - '0x6b175474e89094c44da98b954eedeac495271d0f'
  is:
  - 0
  - 0
  - 0
  - 0
  - 1
  says: delegate 1's DAI allowance amount is 0
  for:
  - notes
- id: allow-1-eth
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0x0632dcc37b1fabf2cad20538a5390d23c830962e'
  - '0x4e64c2d06d19d13061e62e291b2c4e9fe5679b93'
  - '0x0000000000000000000000000000000000000000'
  is:
  - 0
  - 0
  - 0
  - 0
  - 1
  says: delegate 1's ETH allowance amount is 0
  for:
  - notes
- id: allow-2-eth
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0x0632dcc37b1fabf2cad20538a5390d23c830962e'
  - '0x07a7a2f3307a7537de4b03b534bd71b3c7abe22a'
  - '0x0000000000000000000000000000000000000000'
  is:
  - 0
  - 0
  - 0
  - 0
  - 1
  says: delegate 2's ETH allowance amount is 0
  for:
  - notes
- id: allow-list
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: AlowanceModule.sol
  lines:
  - 79
  - 82
  has: tokens[msg.sender][delegate].push(token);
  says: every token a delegate is given an allowance in is added to its token list
  for:
  - notes
- id: allow-cap
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: AlowanceModule.sol
  line: 168
  has: newSpent <= allowance.amount
  says: a delegate transfer must stay within the allowance amount
  for:
  - notes
- id: replay-to-1
  tx: '0x16a1d468122d1a5ae05007fb587fdefc8ef631d4fc6ee7f4c714340835a16208'
  to: '0x237dee529a47750becdfa8a59a1d766e3e7b5f91'
  says: the family's failing replay was sent to another Safe, not this address
  for:
  - notes
- id: replay-to-2
  tx: '0x5b42f691ac82b8a12e4cc736e5bfc85fa9d46fd1e34ce373948d334cd697acf9'
  to: '0x61a2c600081bf0d5c4c4d7b4a9240ec0a9093cb2'
  says: the family's other failing replay was sent to another Safe, not this address
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
  pattern: PQ-12
reviews:
- who: r-0632dcc3, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: A Safe 1.3.0 proxy, 2 of 3 owners, all code-less keys that have sent transactions; no guard; 4,598.55
    ETH and stETH at the block. MEDIUM, PQ-12: two forged owner keys move everything; the fix is swapOwner to signer
    contracts answering the legacy isValidSignature(bytes,bytes). The only module, the AllowanceModule, has no live
    allowance for any delegate, so it is not a second path today. Author A-0632dcc3; refuter R-0632dcc3 agreed with
    no objection; the reader changed nothing.'
related: []
---

## What happens

This Safe runs any transaction that two of its three owners approve; all three owners are plain keys that approve with ECDSA. Each has sent transactions, so its public key is on-chain. A quantum computer that recovers two of these keys can move everything the Safe holds.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) counts an owner whose address ecrecover returns; execTransaction then runs any call or delegatecall.
- [This Safe](https://etherscan.io/address/0x0632dcc37b1fabf2cad20538a5390d23c830962e) runs Safe 1.3.0 with a threshold of 2 of 3; its three owners are plain accounts with empty code; no guard is set.
- [Safe 1.3.0](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) asks a contract owner through isValidSignature(bytes,bytes); swapOwner replaces an owner by a self-call.

## Reviewer notes

### Mechanism

The address is a 110-byte Proxy that delegates every call to the address in slot 0, the Safe 1.3.0 singleton 0xd9db270c (VERSION 1.3.0). execTransaction hashes the Safe transaction with the nonce, calls checkSignatures (threshold 2), then executes any call or delegatecall. checkNSignatures reads one 65-byte slot per required signature: v = 0 asks the owner contract through isValidSignature(bytes,bytes) for 0x20c13b0b; v = 1 accepts the owner as msg.sender or by an earlier approveHash; v > 30 recovers the eth_sign hash with ecrecover; otherwise ecrecover of the hash. The address found must be an owner, in ascending order (GS026). The three owners (0x2116f470, 0x2e39edd0, 0xe3c0f7db) have empty code and nonces 2, 293 and 286, so each has published its public key; a quantum attacker who derives two private keys signs any execTransaction. No guard is set. Owners change through swapOwner, addOwnerWithThreshold and removeOwner, guarded by authorized (msg.sender is the Safe), so the same threshold can replace each key with a post-quantum signer contract that answers the legacy isValidSignature(bytes,bytes); the singleton has no isValidSignature(bytes32,bytes) selector, so a signer that answers only that one does not count. An owner that moves its own account to post-quantum code at the same address stays forgeable: the ECDSA branches recover the address and never ask it. The same delegatecall path lets the owners replace the singleton.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: erc1271: a contract owner is asked via isValidSignature(bytes,bytes) only for v = 0; the two ECDSA branches recover the address without asking its code; all three owners have empty code.
- Ruled out: unused-implementation / wrong-code: this address has its own owners, threshold 2 and Safe nonce 201; slot 0 is the 1.3.0 singleton it runs, so it is a wallet in use, and the card describes that code.
- Ruled out: key-state: getOwners returns three addresses, each empty code (no 7702 delegation) and nonce at least 1.
- Ruled out: direct-path: an owner can also approve on-chain (approveHash, or sending execTransaction itself); that is a transaction signed with the same ECDSA key, so it protects nothing.
- Ruled out: modules: AllowanceModule's two delegates have allowance amount 0 for every token they were ever given (DAI, ETH); a transfer needs spent <= amount, so a delegate signature moves nothing now.
- Ruled out: guard: none (the guard slot is zero).
- Ruled out: whose: left empty; nothing on chain shows whether the Safe's funds are its owners' own or held for others.
- Ruled out: EIP-8151: a migrated owner loses only its ECDSA signature here, not its right to approve on-chain; a separate notice, not this card. Replays 0x16a1d468 and 0x5b42f691 were sent to other Safes, not cited.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
