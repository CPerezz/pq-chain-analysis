---
id: contract-dbe46a02-fixed-owner-keys
format: 2
title: Fixed-signer multisig stays forgeable through its signers' ECDSA keys
status: candidate
severity: MEDIUM
justification: 'Only fixable by the signers moving the funds to a new wallet: the signer set and the code cannot
  change.'
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xdbe46a02322e636b92296954637e1d7db9d5ed26'
  code: bytecode
  code_url: https://etherscan.io/address/0xdbe46a02322e636b92296954637e1d7db9d5ed26#code
  proxy_of: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 90
  basis: held
activity: {}
impact: funds-loss
action: Move the funds to a wallet whose signers can be replaced by post-quantum ones, then stop using this one.
evidence_level: bytecode
checks:
- id: dispatcher
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 60003560e01c8063abe3219c1161004e578063abe3219c146101e1578063c6044c461461020c578063ca34837b14610235578063fc0f392d1461025e576100c9565b8063158ef93e14610113578063722769911461013e578063736c0d5b146101675780637df73e27146101a4576100c956
  says: the dispatcher lists nine functions and none replaces a signer or upgrades
  for:
  - action
  - evidence-2
  - justification
  - what
- id: recover
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b60018682858560405160008152602001604052604051610e519493929190611e83565b6020604051602081039080840390855afa
  says: signatures are recovered by a staticcall to the ecrecover precompile with all remaining gas
  for:
  - evidence-1
  - what
- id: two-sigs
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 7369676e6174757265206e6565642032
  says: the send paths take exactly two signatures
  for:
  - what
- id: both-signers
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b6109f182610349565b
  says: each recovered address is checked against the signer list
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
- id: caller-signer
  call: '0xdbe46a02322e636b92296954637e1d7db9d5ed26'
  data: '0xfc0f392d'
  reverts_with: Non-signer in onlySigner method
  says: signer-only functions refuse a caller that is not a signer
  for:
  - action
  - evidence-1
  - what
- id: send-call
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 60006040518083038185875af1
  says: after the checks the wallet makes the call with the given value
  for:
  - action
  - evidence-1
  - justification
  - what
- id: init-five
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 405180910390fd5b60058282
  says: setup requires exactly five signers
  for:
  - justification
  - what
- id: init-done
  storage: '0xdbe46a02322e636b92296954637e1d7db9d5ed26'
  slot: '0x1'
  is: '0x0000000000000000000000000000000000000000000000000000000000000100'
  says: the wallet is initialized and safe mode is off
  for:
  - evidence-2
  - justification
  - what
- id: init-again
  call: '0xdbe46a02322e636b92296954637e1d7db9d5ed26'
  data: '0xc6044c460000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000005'
  reverts_with: Contract already initialized
  says: the signer set cannot be set again
  for:
  - evidence-2
- id: no-1271-final
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 1626ba7e
  absent: true
  says: no ERC-1271 isValidSignature(bytes32,bytes) call
  for:
  - what
- id: no-1271-legacy
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 20c13b0b
  absent: true
  says: no legacy isValidSignature(bytes,bytes) call
  for:
  - what
- id: signer-1
  call: '0xdbe46a02322e636b92296954637e1d7db9d5ed26'
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
  call: '0xdbe46a02322e636b92296954637e1d7db9d5ed26'
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
  call: '0xdbe46a02322e636b92296954637e1d7db9d5ed26'
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
  call: '0xdbe46a02322e636b92296954637e1d7db9d5ed26'
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
  call: '0xdbe46a02322e636b92296954637e1d7db9d5ed26'
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
reviews:
- who: r-dbe46a02, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-12): Fixed-signer multisig stays forgeable through its signers''
    ECDSA keys. Only fixable by the signers moving the funds to a new wallet: the signer set and the code cannot
    change. Fix: Move the funds to a wallet whose signers can be replaced by post-quantum ones, then stop using
    this one. One refuter agrees on the current card with no objection (D-029: a second refuter only for removals);
    Claude read the card and the answer.'
related: []
---

## What happens

This wallet sends ETH or tokens when one signer calls it with ECDSA signatures from two other signers. Its five signers are fixed at setup and the code cannot change, so forging three signer keys empties it. A signer that moves to post-quantum keys stays forgeable: the wallet never asks its account.

## Evidence

- The [wallet code](https://etherscan.io/address/0x0d424072d658e6abd92c36f8fc16fd6479ae15a0#code) recovers two signatures, requires them and the caller to be three distinct signers, then makes the call.
- [This wallet](https://etherscan.io/address/0xdbe46a02322e636b92296954637e1d7db9d5ed26) is set up (setting it up again reverts) and has no function that replaces a signer or upgrades it.

## Reviewer notes

### Mechanism

Unverified; read from the disassembly of the clone target 0x0d424072 (heimdall output as a lead). Nine selectors: init 0xc6044c46 (requires exactly 5 non-zero signers, sets signers[a]=true, then initialized; reverts once initialized), 0xca34837b (ETH/call send, hash prefixed 'ETHER') and 0x72276991 (token send via transfer, prefix 'ERC20'), activateSafeMode 0xfc0f392d (any signer; then sends only to signers), getters isSigner 0x7df73e27/signers 0x736c0d5b, safeMode 0xabe3219c, initialized 0x158ef93e. Both send paths require msg.sender to be a signer (0x5a3/0x286 -> isSigner 0x349), then 0x817: exactly two signatures, each recovered by staticcall to precompile 1 with all gas (0xe2e-0xe62), checks expiry against timestamp, both recovered addresses are signers (0x9e8, 0xa30), differ from each other (0xa78) and from msg.sender (0xae7, 0xb56). No other path moves funds. Storage slot 1 = 0x100: initialized, safe mode off. Quantum-exposure rating: a CRQC holding three signer keys (one sends the transaction, two sign) takes the holdings; the code (non-upgradeable clone, no DELEGATECALL in target) and signer set cannot change, so the fix is the signers moving the funds to a new wallet (MEDIUM, a new deployment users move to).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path for signers with code: neither 0x1626ba7e nor 0x20c13b0b is in the code; the only staticcall is the recovery.
- Ruled out: unused implementation: this address is an initialized clone holding 0.05 ETH, not the implementation.
- Ruled out: a direct path without signatures: the dispatcher lists nine functions; only the two send functions move funds and both need two signatures.
- Ruled out: a fixed gas budget for the recovery (EIP-8151): the staticcall forwards all gas (GAS before STATICCALL); nothing here breaks under EIP-8151 with nobody migrating.
- Ruled out: safe mode as a closed path: safeMode() is false at the block, and safe mode only limits recipients to signers.
- Ruled out: Signers: the five addresses of setup transaction 0x0b57d085b7… (block 19,146,336), found by Claude in that block and each confirmed by isSigner at the block; all distinct, none has code.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
