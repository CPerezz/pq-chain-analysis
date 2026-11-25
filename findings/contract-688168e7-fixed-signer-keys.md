---
id: contract-688168e7-fixed-signer-keys
format: 2
title: Multisig wallet trusts ECDSA signer keys and its setup cannot be run again
status: candidate
severity: MEDIUM
justification: Three forged signer keys move the wallet's assets; setup is closed, so the fix is the owners moving
  to a new wallet.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x688168e7585436bf03a9cb77f378484cb7eb5267'
  code: bytecode
  code_url: https://etherscan.io/address/0x688168e7585436bf03a9cb77f378484cb7eb5267#code
  proxy_of: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity: {}
impact: funds-loss
action: Move the wallet's assets to a wallet whose signers can be post-quantum; this wallet's setup cannot be run
  again.
evidence_level: bytecode
checks:
- id: clone
  bytecode: '0x688168e7585436bf03a9cb77f378484cb7eb5267'
  has: 363d3d373d3d3d363d730d424072d658e6abd92c36f8fc16fd6479ae15a05af43d82803e903d91602b57fd5bf3
  says: the address is an EIP-1167 clone that delegates every call to 0x0d42…15a0
  for:
  - what
- id: five
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: '60058282905014'
  says: setup compares the length of the signer array with 5 (the only such sequence in the code, at 0x0400)
  for:
  - what
- id: initialized
  call: '0x688168e7585436bf03a9cb77f378484cb7eb5267'
  data: '0x158ef93e'
  is: '0x0000000000000000000000000000000000000000000000000000000000000001'
  says: the wallet's initialized flag is set
  for:
  - action
  - evidence-2
  - what
- id: init-closed
  call: '0x688168e7585436bf03a9cb77f378484cb7eb5267'
  data: '0xc6044c4600000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000'
  reverts_with: Contract already initialized
  says: 'a setup call on the wallet reverts: the signers cannot be set a second time'
  for:
  - action
  - evidence-2
  - justification
  - what
- id: only-signer-eth
  call: '0x688168e7585436bf03a9cb77f378484cb7eb5267'
  data: '0xca34837b000000000000000000000000000000000000000000000000000000000000dead000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000174876e7ff000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
  from: '0x000000000000000000000000000000000000dead'
  reverts_with: Non-signer in onlySigner method
  says: the ETH transfer function refuses a caller that is not a signer
  for:
  - justification
  - what
- id: only-signer-token
  call: '0x688168e7585436bf03a9cb77f378484cb7eb5267'
  data: '0x72276991000000000000000000000000000000000000000000000000000000000000dead0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000dead000000000000000000000000000000000000000000000000000000174876e7ff000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000000'
  from: '0x000000000000000000000000000000000000dead'
  reverts_with: Non-signer in onlySigner method
  says: the token transfer function refuses a caller that is not a signer
  for:
  - what
- id: need-two
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 7369676e6174757265206e6565642032
  says: the code carries the revert text 'signature need 2', used when the signature array is not of length 2
  for:
  - evidence-1
  - justification
  - what
- id: distinct
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 66697273745369676e65722073686f756c64206e6f7420626520657175616c20
  says: the code carries the revert text 'firstSigner should not be equal to secondSigner' / 'to msg.sender'
  for:
  - evidence-1
  - what
- id: not-sender
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 7365636f6e645369676e65722073686f756c64206e6f7420626520657175616c
  says: the code carries the revert text 'secondSigner should not be equal to msg.sender'
  for:
  - evidence-1
  - what
- id: ecrecover
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 60018682858560405160008152602001604052604051610e519493929190611e83565b6020604051602081039080840390855afa
  says: 'the signature routine pushes address 1 and makes a STATICCALL to it with (hash, v, r, s): an ecrecover
    call'
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  selector: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the code never calls or exposes ERC-1271 isValidSignature
  for:
  - evidence-3
  - what
- id: no-1271-legacy
  selector: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  fn: isValidSignature(bytes,bytes)
  absent: true
  says: nor the legacy isValidSignature
  for:
  - evidence-3
- id: safe-mode-off
  call: '0x688168e7585436bf03a9cb77f378484cb7eb5267'
  data: '0xabe3219c'
  is: '0x0000000000000000000000000000000000000000000000000000000000000000'
  says: safe mode is off, so transfers can go to any address
  for:
  - what
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x688168e7585436bf03a9cb77f378484cb7eb5267'
  is: 198800000000000
  says: the wallet holds 0.0001988 ETH
  for:
  - what
- id: signer-1
  call: '0x688168e7585436bf03a9cb77f378484cb7eb5267'
  fn: isSigner(address)(bool)
  args:
  - '0x905a5ea20c841be32b2ba7d648b325ade5f655bb'
  is: true
  says: 0x905a5ea2… is one of this wallet's five signers
  for:
  - what
- id: signer-1-key
  code: '0x905a5ea20c841be32b2ba7d648b325ade5f655bb'
  is: empty
  says: 'signer 0x905a5ea2… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-1-nonce
  nonce: '0x905a5ea20c841be32b2ba7d648b325ade5f655bb'
  is: 32
  says: signer 0x905a5ea2… has sent 32 transactions, so its public key is on-chain
  for:
  - notes
- id: signer-2
  call: '0x688168e7585436bf03a9cb77f378484cb7eb5267'
  fn: isSigner(address)(bool)
  args:
  - '0x0a3642fc66d92e3ada87ad07dc9c923ef02b3f9a'
  is: true
  says: 0x0a3642fc… is one of this wallet's five signers
  for:
  - what
- id: signer-2-key
  code: '0x0a3642fc66d92e3ada87ad07dc9c923ef02b3f9a'
  is: empty
  says: 'signer 0x0a3642fc… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-2-nonce
  nonce: '0x0a3642fc66d92e3ada87ad07dc9c923ef02b3f9a'
  is: 0
  says: signer 0x0a3642fc… has never sent a transaction
  for:
  - notes
- id: signer-3
  call: '0x688168e7585436bf03a9cb77f378484cb7eb5267'
  fn: isSigner(address)(bool)
  args:
  - '0x3f7c98f33bad17fd29df2ea41fe76fe54bfbbfa1'
  is: true
  says: 0x3f7c98f3… is one of this wallet's five signers
  for:
  - what
- id: signer-3-key
  code: '0x3f7c98f33bad17fd29df2ea41fe76fe54bfbbfa1'
  is: empty
  says: 'signer 0x3f7c98f3… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-3-nonce
  nonce: '0x3f7c98f33bad17fd29df2ea41fe76fe54bfbbfa1'
  is: 0
  says: signer 0x3f7c98f3… has never sent a transaction
  for:
  - notes
- id: signer-4
  call: '0x688168e7585436bf03a9cb77f378484cb7eb5267'
  fn: isSigner(address)(bool)
  args:
  - '0xb83ac7bc5e2f69c230de87fa2ba607badbdbee09'
  is: true
  says: 0xb83ac7bc… is one of this wallet's five signers
  for:
  - what
- id: signer-4-key
  code: '0xb83ac7bc5e2f69c230de87fa2ba607badbdbee09'
  is: empty
  says: 'signer 0xb83ac7bc… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-4-nonce
  nonce: '0xb83ac7bc5e2f69c230de87fa2ba607badbdbee09'
  is: 0
  says: signer 0xb83ac7bc… has never sent a transaction
  for:
  - notes
- id: signer-5
  call: '0x688168e7585436bf03a9cb77f378484cb7eb5267'
  fn: isSigner(address)(bool)
  args:
  - '0xe89ffcb784f2719c8507e1f30904e1145d7d983b'
  is: true
  says: 0xe89ffcb7… is one of this wallet's five signers
  for:
  - what
- id: signer-5-key
  code: '0xe89ffcb784f2719c8507e1f30904e1145d7d983b'
  is: empty
  says: 'signer 0xe89ffcb7… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-5-nonce
  nonce: '0xe89ffcb784f2719c8507e1f30904e1145d7d983b'
  is: 0
  says: signer 0xe89ffcb7… has never sent a transaction
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
reviews:
- who: r-688168e7, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-12): Multisig wallet trusts ECDSA signer keys and its setup
    cannot be run again. Three forged signer keys move the wallet''s assets; setup is closed, so the fix is the
    owners moving to a new wallet. Signers read by Claude from the setup block; the fresh refuter agrees with no
    objection. Claude read the card and the answers.'
related: []
---

## What happens

This wallet is a clone that is set up once with five signers. A transfer needs a signer as sender and ECDSA signatures from two other signers. A quantum attacker who forges three signer keys can move what it holds, about 0.0002 ETH at the block.

## Evidence

- The [wallet code](https://etherscan.io/address/0x0d424072d658e6abd92c36f8fc16fd6479ae15a0#code) recovers each signature with ecrecover and requires two, from signers other than the sender.
- The [wallet](https://etherscan.io/address/0x688168e7585436bf03a9cb77f378484cb7eb5267) is set up, and a second setup call reverts with "Contract already initialized".
- The [wallet code](https://etherscan.io/address/0x0d424072d658e6abd92c36f8fc16fd6479ae15a0#code) has no ERC-1271 selector: a signer account is never asked itself.

## Reviewer notes

### Mechanism

Unverified code, read from the disassembly of the clone target 0x0d42…15a0 (7,934 bytes); the eight selectors are unnamed. 0xc6044c46 (setup, address[]) reverts if the initialized byte of slot 1 is set, requires 5 non-zero addresses, flags each in the slot-0 mapping, and has no caller check. 0xca34837b (address,uint256,bytes,uint256,uint256,bytes[]) and 0x72276991 (address,uint256,address,uint256,uint256,bytes[]) require the caller to be flagged, hash the packed arguments with the prefix ETHER or ERC20, and call the routine at 0x0817: exactly two 65-byte signatures, each recovered with ecrecover (0x0e62, the only STATICCALL), expiry not passed, both recovered addresses flagged, different from each other and from the caller; in safe mode the destination must be a signer. Then a CALL with value and data (0x0675), or token transfer(address,uint256) (0x0c64). 0xfc0f392d lets a signer turn safe mode on; nothing turns it off. The code has three SSTOREs (signer flag and initialized in setup, safe mode), so nothing changes a signer after setup.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: erc1271: neither isValidSignature selector is in the code and its only STATICCALL is the ecrecover call. A signer with code can still be the sender, but the two signatures are ECDSA.
- Ruled out: unused-implementation: this address is a clone with its own state and is initialized (0x158ef93e returns 1).
- Ruled out: setter, direct-path: none of the eight selectors writes a signer after setup; both transfer functions go through the two-signature routine. No DELEGATECALL, no SELFDESTRUCT.
- Ruled out: path-closed: safe mode is off (0xabe3219c returns 0); in safe mode transfers go only to signers.
- Ruled out: key-state: not settled, the signer mapping cannot be listed without the setup transaction (see questions).
- Ruled out: value-whose: 0.0001988 ETH through Multicall3; the tool prices its two tokens at $0. Whose it is cannot be shown.
- Ruled out: Signers: the five addresses of setup transaction 0x280fe44455… (block 22,295,371), found by Claude in that block and each confirmed by isSigner at the block; all distinct, none has code.

### Questions

- The old note says the wallet is in use (value or transactions in the year to block 26,431,520). I confirmed only that it is initialized and holds 0.0001988 ETH; its history needs logs.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
