---
id: gnosissafe-cde525bd-owner-ecdsa-keys
format: 2
title: Recovering three ECDSA owner keys moves everything this Safe holds
status: confirmed
severity: MEDIUM
justification: Its owners can fix it in place, but only by replacing each ECDSA key with a post-quantum signer contract.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcde525bd723090284ee2f958c729d83cf117aff9'
  name: GnosisSafe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
value:
  usd: 36009601
  basis: held
activity:
  txs_90d: 3
impact: funds-loss
action: Swap each ECDSA owner for a post-quantum signer contract that answers isValidSignature(bytes,bytes) with
  0x20c13b0b.
evidence_level: source
checks:
- id: version
  call: '0xcde525bd723090284ee2f958c729d83cf117aff9'
  fn: VERSION()(string)
  is: 1.3.0
  says: the Safe runs version 1.3.0
  for:
  - action
  - what
- id: singleton
  storage: '0xcde525bd723090284ee2f958c729d83cf117aff9'
  slot: '0x0'
  is: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  says: slot 0 holds the Safe 1.3.0 singleton the proxy runs
  for:
  - what
- id: proxy-sload
  source: '0xcde525bd723090284ee2f958c729d83cf117aff9'
  file: GnosisSafeProxy.sol
  line: 29
  has: let _singleton := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
  says: the proxy runs whatever singleton slot 0 names
  for:
  - notes
- id: delegatecall
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/Executor.sol
  lines:
  - 15
  - 18
  has: if (operation == Enum.Operation.DelegateCall) {
  says: a Safe transaction can delegatecall, and so rewrite slot 0
  for:
  - notes
- id: exec-sigs
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  lines:
  - 143
  - 145
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction checks the owners' signatures before it executes
  for:
  - what
- id: thresh-src
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  lines:
  - 227
  - 230
  has: checkNSignatures(dataHash, data, signatures, _threshold);
  says: threshold-many signatures are required
  for:
  - what
- id: v-contract
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 257
  has: if (v == 0) {
  says: v = 0 selects a contract signature
  for:
  - evidence-1
  - what
- id: v-approved
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 286
  has: '} else if (v == 1) {'
  says: v = 1 selects an approved hash
  for:
  - evidence-1
  - what
- id: ecdsa
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: other v values recover the signer with ECDSA
  for:
  - evidence-1
  - what
- id: is-owner
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 301
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
    "GS026");
  says: the recovered address only has to be an owner, in ascending order
  for:
  - evidence-1
  - what
- id: legacy-1271
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 285
  has: require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE,
    "GS024");
  says: a contract owner is asked through isValidSignature with the full data and signature
  for:
  - action
  - evidence-3
  - justification
- id: magic
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/interfaces/ISignatureValidator.sol
  line: 6
  has: bytes4 internal constant EIP1271_MAGIC_VALUE = 0x20c13b0b;
  says: the magic value asked is the legacy 0x20c13b0b
  for:
  - action
  - evidence-3
  - justification
- id: bc-legacy
  bytecode: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  has: 20c13b0b
  says: the singleton's code holds the legacy isValidSignature(bytes,bytes) selector
  for:
  - action
  - evidence-3
- id: bc-no-1271
  bytecode: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  has: 1626ba7e
  absent: true
  says: the singleton's code holds no final ERC-1271 selector
  for:
  - action
  - evidence-3
- id: swap
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/OwnerManager.sol
  lines:
  - 94
  - 98
  has: address newOwner ) public authorized {
  says: swapOwner is open only to the Safe itself
  for:
  - action
  - evidence-3
  - justification
- id: swap-write
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/OwnerManager.sol
  lines:
  - 106
  - 108
  has: owners[prevOwner] = newOwner; owners[oldOwner] = address(0);
  says: swapOwner puts the new owner in the old one's place
  for:
  - action
  - evidence-3
  - justification
- id: self
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/common/SelfAuthorized.sol
  line: 8
  has: require(msg.sender == address(this), "GS031");
  says: authorized means a call by the Safe itself, that is a Safe transaction
  for:
  - action
  - evidence-3
  - justification
- id: threshold
  call: '0xcde525bd723090284ee2f958c729d83cf117aff9'
  fn: getThreshold()(uint256)
  is: 3
  says: three owner approvals are needed
  for:
  - evidence-2
  - justification
  - what
- id: owners
  call: '0xcde525bd723090284ee2f958c729d83cf117aff9'
  fn: getOwners()(address[])
  is:
  - '0x705199fe234a7a2f1bc8b95dd7d08284c8f467f1'
  - '0x0c047b2464b7808eea627226f45fad5aadcb0002'
  - '0xa9759e90a05561eee54bbde65cf93d76d75500fa'
  - '0xdf6bb6cfe86f0c320940eca1cc239e477bc9c777'
  - '0x261fca35b06afa59ea446c1f679f32f58b9536f6'
  - '0x3d7a4667db561aeb767dfab018f6afe791a0e04d'
  says: the Safe has six owners
  for:
  - evidence-2
  - justification
  - what
- id: nonce-safe
  call: '0xcde525bd723090284ee2f958c729d83cf117aff9'
  fn: nonce()(uint256)
  is: 30
  says: the Safe has executed 30 transactions
  for:
  - notes
- id: guard
  storage: '0xcde525bd723090284ee2f958c729d83cf117aff9'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no transaction guard is set
  for:
  - what
- id: modules
  call: '0xcde525bd723090284ee2f958c729d83cf117aff9'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 10
  is:
  - []
  - '0x0000000000000000000000000000000000000001'
  says: no module is enabled
  for:
  - notes
- id: o1-code
  code: '0x0c047b2464b7808eea627226f45fad5aadcb0002'
  is: empty
  says: owner 0x0c04...0002 has no code
  for:
  - evidence-2
  - justification
  - what
- id: o2-code
  code: '0xa9759e90a05561eee54bbde65cf93d76d75500fa'
  is: empty
  says: owner 0xa975...00fa has no code
  for:
  - evidence-2
  - justification
  - what
- id: o3-code
  code: '0xdf6bb6cfe86f0c320940eca1cc239e477bc9c777'
  is: empty
  says: owner 0xdf6b...c777 has no code
  for:
  - evidence-2
  - justification
  - what
- id: o4-code
  code: '0x261fca35b06afa59ea446c1f679f32f58b9536f6'
  is: empty
  says: owner 0x261f...36f6 has no code
  for:
  - evidence-2
  - justification
  - what
- id: o5-code
  code: '0x3d7a4667db561aeb767dfab018f6afe791a0e04d'
  is: empty
  says: owner 0x3d7a...e04d has no code
  for:
  - evidence-2
  - justification
  - what
- id: o1-nonce
  nonce: '0x0c047b2464b7808eea627226f45fad5aadcb0002'
  min: 1
  says: owner 0x0c04...0002 has sent transactions, so its public key is on chain
  for:
  - evidence-2
  - what
- id: o2-nonce
  nonce: '0xa9759e90a05561eee54bbde65cf93d76d75500fa'
  min: 1
  says: owner 0xa975...00fa has sent transactions, so its public key is on chain
  for:
  - evidence-2
  - what
- id: o3-nonce
  nonce: '0xdf6bb6cfe86f0c320940eca1cc239e477bc9c777'
  min: 1
  says: owner 0xdf6b...c777 has sent transactions, so its public key is on chain
  for:
  - evidence-2
  - what
- id: o4-nonce
  nonce: '0x261fca35b06afa59ea446c1f679f32f58b9536f6'
  min: 1
  says: owner 0x261f...36f6 has sent transactions, so its public key is on chain
  for:
  - evidence-2
  - what
- id: o5-nonce
  nonce: '0x3d7a4667db561aeb767dfab018f6afe791a0e04d'
  min: 1
  says: owner 0x3d7a...e04d has sent transactions, so its public key is on chain
  for:
  - evidence-2
  - what
- id: os-code
  code: '0x705199fe234a7a2f1bc8b95dd7d08284c8f467f1'
  is: contract
  bytes: 171
  says: the sixth owner is a contract of the Safe proxy's size
  for:
  - evidence-2
- id: os-singleton
  storage: '0x705199fe234a7a2f1bc8b95dd7d08284c8f467f1'
  slot: '0x0'
  is: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  says: the sixth owner is a Safe proxy on the same 1.3.0 singleton
  for:
  - evidence-2
- id: os-threshold
  call: '0x705199fe234a7a2f1bc8b95dd7d08284c8f467f1'
  fn: getThreshold()(uint256)
  is: 3
  says: the owner Safe needs three of its owners
  for:
  - notes
- id: os-owners
  call: '0x705199fe234a7a2f1bc8b95dd7d08284c8f467f1'
  fn: getOwners()(address[])
  is:
  - '0x2149ea7bd59c0e3fc1c7f162efd8721e2d399e3d'
  - '0x96a670afc529bad89a48919e7ce383c9dad11620'
  - '0x3dd4b4dbe6aee6f49a65f0c1ac508deff761c195'
  - '0x2f10e2358594fd72c7d9e2eea137ef1222c03bd5'
  - '0x18c04b30c3bc7f49b9cb7483da349d757b50b54a'
  - '0x828424517f9f04015db02169f4026d57b2b07229'
  - '0x2cdd560058d5ac32dc416aaa09eaf93230c0b7b3'
  - '0x3cc3a225769900e003e264dd4cb43e90896bc21a'
  - '0xd367f8322b64f29faf71ddb5c1877dc9ed6ec644'
  - '0xe3df2cceac61b1afa311372ecc5b40a3a6585a9e'
  says: the owner Safe has ten owners
  for:
  - notes
- id: os-o1
  code: '0x2149ea7bd59c0e3fc1c7f162efd8721e2d399e3d'
  is: empty
  says: an owner of the owner Safe has no code
  for:
  - notes
- id: os-o2
  code: '0x96a670afc529bad89a48919e7ce383c9dad11620'
  is: empty
  says: an owner of the owner Safe has no code
  for:
  - notes
- id: os-o3
  code: '0x3dd4b4dbe6aee6f49a65f0c1ac508deff761c195'
  is: empty
  says: an owner of the owner Safe has no code
  for:
  - notes
- id: os-o4
  code: '0x2f10e2358594fd72c7d9e2eea137ef1222c03bd5'
  is: empty
  says: an owner of the owner Safe has no code
  for:
  - notes
- id: os-o5
  code: '0x18c04b30c3bc7f49b9cb7483da349d757b50b54a'
  is: empty
  says: an owner of the owner Safe has no code
  for:
  - notes
- id: os-o6
  code: '0x828424517f9f04015db02169f4026d57b2b07229'
  is: empty
  says: an owner of the owner Safe has no code
  for:
  - notes
- id: os-o7
  code: '0x2cdd560058d5ac32dc416aaa09eaf93230c0b7b3'
  is: empty
  says: an owner of the owner Safe has no code
  for:
  - notes
- id: os-o8
  code: '0x3cc3a225769900e003e264dd4cb43e90896bc21a'
  is: empty
  says: an owner of the owner Safe has no code
  for:
  - notes
- id: os-o9
  code: '0xd367f8322b64f29faf71ddb5c1877dc9ed6ec644'
  is: empty
  says: an owner of the owner Safe has no code
  for:
  - notes
- id: os-o10
  code: '0xe3df2cceac61b1afa311372ecc5b40a3a6585a9e'
  is: empty
  says: an owner of the owner Safe has no code
  for:
  - notes
- id: last-tx
  tx: '0x4a5ff735573a9dab2ca5313377590a2b3a606f79c100ae586c19d5c9e158bfaa'
  to: '0xcde525bd723090284ee2f958c729d83cf117aff9'
  ok: true
  says: the Safe's latest transaction, at block 26,302,122, succeeded
  for:
  - notes
- id: rp1-to
  tx: '0xd34b6a89c4e4edd787f11ac5bf8591f3b1114ecbe3669650f6b98cf8fc673581'
  to: '0x40a2accbd92bca938b02010e17a5b8929b49130d'
  says: the family's first replay was sent to another address
  for:
  - notes
- id: rp2-to
  tx: '0x16a1d468122d1a5ae05007fb587fdefc8ef631d4fc6ee7f4c714340835a16208'
  to: '0x237dee529a47750becdfa8a59a1d766e3e7b5f91'
  says: the family's second replay was sent to another Safe
  for:
  - notes
- id: rp3-to
  tx: '0x5b42f691ac82b8a12e4cc736e5bfc85fa9d46fd1e34ce373948d334cd697acf9'
  to: '0x61a2c600081bf0d5c4c4d7b4a9240ec0a9093cb2'
  says: the family's third replay was sent to another Safe
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
- who: r-cde525bd, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: A Safe 1.3.0 proxy holding about 36.2M USD, 3 of 6 owners: five code-less keys that have sent transactions
    and a sixth owner that is itself a Safe (0x705199fe…, its own row). MEDIUM, PQ-12: three forged owner keys move
    everything; the fix is swapOwner to signer contracts answering the legacy isValidSignature(bytes,bytes). Author
    A-cde525bd counted only the five keys as forgeable here and left the sixth owner to its own row; refuter R-cde525bd
    agreed with no objection; the reader changed nothing and links the two findings at filing, since the owner Safe''s
    three-of-ten keys fill one seat here.'
related: [gnosissafe-705199fe-owner-ecdsa-keys]
---

## What happens

This Safe multisig runs any transaction that three of its six owners approve, and counts an owner's ECDSA signature as approval. Five owners are ECDSA keys that have sent transactions; recovering three with a quantum computer moves all it holds. Upgrading an owner's account in place does not help.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) takes the scheme from each signature's v byte; for ECDSA it recovers the signer and checks only that it is an owner.
- The [Safe](https://etherscan.io/address/0xcde525bd723090284ee2f958c729d83cf117aff9) needs 3 of 6 owners; five are accounts without code that have sent transactions, the sixth is another Safe.
- [swapOwner](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) replaces an owner by a Safe transaction; a contract owner is asked through isValidSignature(bytes,bytes) for 0x20c13b0b.

## Reviewer notes

### Mechanism

execTransaction (line 145) increments the nonce and calls checkSignatures, which needs threshold (3) signatures through checkNSignatures (lines 240-303). The v byte of each 65-byte slot, chosen by whoever submits, picks the path: 0 asks a contract owner through legacy isValidSignature(bytes,bytes) with the full data and signature (line 285, magic 0x20c13b0b); 1 accepts the sender itself or an approveHash (line 291); above 30 eth_sign ecrecover (line 295); otherwise ecrecover of the hash (line 299). The result must be an owner, ascending (line 301). Nothing reads the owner's code on the ECDSA paths, so an owner whose account moves to post-quantum keys at the same address still counts by ECDSA. No guard and no module is set. Owners: five accounts without code (nonces 10 to 222) and 0x7051...67f1, a Safe 1.3.0 proxy (3 of 10) whose ten owners have no code. Its latest transaction 0x4a5f...bfaa (block 26,302,122, a token transfer) was sent by owner 0x3d7a...e04d (v = 1) and carried two ECDSA signatures (v = 27 and 28; the trace lead names 0x261f...36f6 and 0xdf6b...c777). swapOwner (OwnerManager lines 94-111) is authorized: only a Safe transaction reaches it. Fix: replace each EOA owner with a contract that verifies a post-quantum signature in isValidSignature(bytes,bytes); the singleton never asks the newer 0x1626ba7e.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an unused address: a proxy set up as a 3-of-6 Safe with nonce 30; called three times in 90 days, the last an execTransaction at block 26,302,122 that succeeded.
- Ruled out: the contract-signature and approved-hash paths as a defence: they let contract owners sign, but the submitter picks each slot's v byte, so a forged ECDSA signature still counts for an owner without code (lines 257-301).
- Ruled out: a guard or module that could stop a forged transaction: the guard slot is empty and getModulesPaginated returns none.
- Ruled out: a singleton swap as the fix: 1.3.0 has no changeMasterCopy; a delegatecall Safe transaction can rewrite slot 0, but the ECDSA owners stay.
- Ruled out: an EIP-8151 replay of this Safe: the family's three replays are other Safes' transactions (to 0x40a2...130d, 0x237d...5f91, 0x61a2...3cb2), so no sender-gas-limit case is shown for this address.
- Ruled out: whose money: no project, label or other check shows who the owners are, so whose is left empty.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
