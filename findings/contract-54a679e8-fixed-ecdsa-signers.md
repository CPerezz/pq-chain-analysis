---
id: contract-54a679e8-fixed-ecdsa-signers
format: 2
title: Multisig moves its funds on three of five ECDSA signer keys that cannot change
status: candidate
severity: MEDIUM
justification: Its signers cannot be replaced, so the only fix is moving the funds to a new wallet with post-quantum
  signers.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x54a679e853281a440911f72eae0e24107e9413dc'
  code: bytecode
  code_url: https://etherscan.io/address/0x54a679e853281a440911f72eae0e24107e9413dc#code
  proxy_of: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 68962093
  basis: held
activity: {}
impact: funds-loss
action: Move the funds to a new wallet with post-quantum signers; this wallet's five signers cannot be replaced.
evidence_level: bytecode
checks:
- id: clone
  code: '0x54a679e853281a440911f72eae0e24107e9413dc'
  is: contract
  bytes: 45
  says: the address is a 45-byte EIP-1167 clone
  for:
  - notes
- id: dispatch
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 60003560e01c8063abe3219c1161004e578063abe3219c146101e1578063c6044c461461020c578063ca34837b14610235578063fc0f392d1461025e576100c9565b8063158ef93e14610113578063722769911461013e578063736c0d5b146101675780637df73e27146101a4576100c956
  says: 'the dispatcher compares exactly nine selectors: abe3219c, c6044c46, ca34837b, fc0f392d, 158ef93e, 72276991,
    736c0d5b, 7df73e27'
  for:
  - action
  - evidence-2
  - justification
  - what
- id: erc20only
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b61028f3361034956
  says: the ERC20 send (0x72276991) starts by checking isSigner(msg.sender)
  for:
  - evidence-1
  - what
- id: ethonly
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b6105ac3361034956
  says: the ETH send (0xca34837b) starts by checking isSigner(msg.sender)
  for:
  - evidence-1
  - what
- id: need2
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 7369676e6174757265206e6565642032
  says: the verify routine wants exactly two signatures
  for:
  - evidence-1
  - what
- id: distinct
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 66697273745369676e65722073686f756c64206e6f7420626520657175616c20
  says: the two recovered signers must differ from each other and from the caller
  for:
  - evidence-1
  - what
- id: recover
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b60018682858560405160008152602001604052604051610e519493929190611e83565b6020604051602081039080840390855afa158015610e7357
  says: each signature is recovered by a STATICCALL to the ecrecover precompile (address 1) with all remaining gas
  for:
  - evidence-1
  - what
- id: ethcall
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b60006040518083038185875af1
  says: the ETH send makes a CALL with value and data and all remaining gas
  for:
  - what
- id: five
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b6005828290501461044557
  says: initialize requires exactly five signers
  for:
  - action
  - what
- id: initialized
  call: '0x54a679e853281a440911f72eae0e24107e9413dc'
  fn: initialized()(bool)
  is: true
  says: the wallet is set up
  for:
  - evidence-2
  - what
- id: setupclosed
  call: '0x54a679e853281a440911f72eae0e24107e9413dc'
  data: '0xc6044c460000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000005'
  reverts_with: Contract already initialized
  says: initialize cannot run again
  for:
  - action
  - evidence-2
  - justification
  - what
- id: safemode
  call: '0x54a679e853281a440911f72eae0e24107e9413dc'
  fn: safeMode()(bool)
  is: false
  says: safe mode is off
  for:
  - notes
- id: no1271
  selector: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: no ERC-1271 check
  for:
  - notes
- id: no1271old
  selector: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  fn: isValidSignature(bytes,bytes)
  absent: true
  says: no legacy ERC-1271 check
  for:
  - notes
- id: signer-1
  call: '0x54a679e853281a440911f72eae0e24107e9413dc'
  fn: isSigner(address)(bool)
  args:
  - '0x7f6a0886e9c06635802c823b1e01fa5ace23012f'
  is: true
  says: 0x7f6a0886… is one of this wallet's five signers
  for:
  - what
- id: signer-1-key
  code: '0x7f6a0886e9c06635802c823b1e01fa5ace23012f'
  is: empty
  says: 'signer 0x7f6a0886… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-1-nonce
  nonce: '0x7f6a0886e9c06635802c823b1e01fa5ace23012f'
  is: 311
  says: signer 0x7f6a0886… has sent 311 transactions, so its public key is on-chain
  for:
  - notes
- id: signer-2
  call: '0x54a679e853281a440911f72eae0e24107e9413dc'
  fn: isSigner(address)(bool)
  args:
  - '0x6761ee52d24b4519f2ad3c7b80d6d5b57b825b74'
  is: true
  says: 0x6761ee52… is one of this wallet's five signers
  for:
  - what
- id: signer-2-key
  code: '0x6761ee52d24b4519f2ad3c7b80d6d5b57b825b74'
  is: empty
  says: 'signer 0x6761ee52… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-2-nonce
  nonce: '0x6761ee52d24b4519f2ad3c7b80d6d5b57b825b74'
  is: 63
  says: signer 0x6761ee52… has sent 63 transactions, so its public key is on-chain
  for:
  - notes
- id: signer-3
  call: '0x54a679e853281a440911f72eae0e24107e9413dc'
  fn: isSigner(address)(bool)
  args:
  - '0x1458e52d23b531df0e5a2b0d8db43d85018069f9'
  is: true
  says: 0x1458e52d… is one of this wallet's five signers
  for:
  - what
- id: signer-3-key
  code: '0x1458e52d23b531df0e5a2b0d8db43d85018069f9'
  is: empty
  says: 'signer 0x1458e52d… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-3-nonce
  nonce: '0x1458e52d23b531df0e5a2b0d8db43d85018069f9'
  is: 0
  says: signer 0x1458e52d… has never sent a transaction
  for:
  - notes
- id: signer-4
  call: '0x54a679e853281a440911f72eae0e24107e9413dc'
  fn: isSigner(address)(bool)
  args:
  - '0xd59a643bbb558cdbfdc1f9747aa171218bdc3357'
  is: true
  says: 0xd59a643b… is one of this wallet's five signers
  for:
  - what
- id: signer-4-key
  code: '0xd59a643bbb558cdbfdc1f9747aa171218bdc3357'
  is: empty
  says: 'signer 0xd59a643b… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-4-nonce
  nonce: '0xd59a643bbb558cdbfdc1f9747aa171218bdc3357'
  is: 0
  says: signer 0xd59a643b… has never sent a transaction
  for:
  - notes
- id: signer-5
  call: '0x54a679e853281a440911f72eae0e24107e9413dc'
  fn: isSigner(address)(bool)
  args:
  - '0xe4af0df01622386bf1d3589ba325c66293850632'
  is: true
  says: 0xe4af0df0… is one of this wallet's five signers
  for:
  - what
- id: signer-5-key
  code: '0xe4af0df01622386bf1d3589ba325c66293850632'
  is: empty
  says: 'signer 0xe4af0df0… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-5-nonce
  nonce: '0xe4af0df01622386bf1d3589ba325c66293850632'
  is: 0
  says: signer 0xe4af0df0… has never sent a transaction
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
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: CRITICAL
reviews: []
related: []
---

## What happens

This wallet sends ETH, tokens or any call when one of its five signers calls it with ECDSA signatures of two other signers. The signers were set once at setup and no function replaces them. Whoever forges three signer keys with a quantum computer can move everything it holds.

## Evidence

- [The wallet code](https://etherscan.io/address/0x0d424072d658e6abd92c36f8fc16fd6479ae15a0#code) recovers two signatures with ECDSA and requires them and the caller to be three different signers.
- [Setup](https://etherscan.io/address/0x54a679e853281a440911f72eae0e24107e9413dc#code) is closed: it reverts with "Contract already initialized", and no other function of the code writes a signer.

## Reviewer notes

### Mechanism

The address is an EIP-1167 clone of 0x0d424072 (unverified; read from the disassembly and the decompiled reading). The dispatcher has nine selectors: initialized 0x158ef93e, signers 0x736c0d5b, isSigner 0x7df73e27, safeMode 0xabe3219c, activateSafeMode 0xfc0f392d, initialize 0xc6044c46, an ERC20 send 0x72276991 and an ETH/arbitrary-call send 0xca34837b. Both sends first require isSigner(msg.sender) ("Non-signer in onlySigner method"), hash a prefix ("ERC20" or "ETHER") with the arguments, then call the verify routine at 0x0817: exactly two signatures ("signature need 2"), each recovered by STATICCALL to precompile 1 with all gas (OpenZeppelin-style s and length checks); in safe mode the destination must be a signer; expiry checked against the timestamp; both recovered addresses must be signers, differ from each other and from msg.sender. Then token.transfer, or CALL{value} with data and all gas. initialize takes exactly five non-zero signers and is guarded by the initialized flag (slot 1 byte 1 = 1 at the block). The only SSTOREs are in initialize (signer map, flag) and activateSafeMode (slot 1 byte 0). No DELEGATECALL, no ERC-1271 path. So the signer set is fixed for good: 3 of 5 ECDSA keys (caller + two signatures) move everything.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271: neither isValidSignature(bytes32,bytes) nor isValidSignature(bytes,bytes) is in the code; the only external check is the ecrecover precompile.
- Ruled out: unused implementation: this address is the initialized clone (initialized() is true) and holds the tool's value; it is the address in use, not the implementation.
- Ruled out: setter: initialize reverts with "Contract already initialized"; the only other storage write is activateSafeMode, which sets a flag. The arbitrary-call path cannot reach a setter either (none exists, no DELEGATECALL).
- Ruled out: safe mode (off at the block) only limits destinations to signer addresses, which a forger of those keys controls; it does not stop the forgery.
- Ruled out: EIP-8151 gas: the recovery forwards all gas, so no fixed-gas break here; the second study's rating is not carried over.
- Ruled out: Signers: the five addresses of setup transaction 0x99b24ba954… (block 19,146,263), found by Claude in that block and each confirmed by isSigner at the block; all distinct, none has code.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
