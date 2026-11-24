---
id: contract-9f199b93-fixed-owner-keys
format: 2
title: Multisig wallet whose five fixed ECDSA signer keys control its funds
status: candidate
severity: MEDIUM
justification: Forging three of five fixed signer keys moves the funds; only the signers moving them to a new wallet
  fixes it.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9f199b93ae33c330880bdb31422fca37c6d3fb14'
  code: bytecode
  code_url: https://etherscan.io/address/0x9f199b93ae33c330880bdb31422fca37c6d3fb14#code
  proxy_of: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 9990197
  basis: held
activity: {}
impact: funds-loss
action: Move the funds to a new wallet whose signers can use post-quantum keys; this wallet's signers cannot be
  replaced.
evidence_level: bytecode
checks:
- id: usdt
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0x9f199b93ae33c330880bdb31422fca37c6d3fb14'
  is: '10000018120000'
  says: the wallet holds 10,000,018.12 USDT
  for:
  - what
- id: dispatcher
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 60806040526004361061007f5760003560e01c8063abe3219c1161004e578063abe3219c146101e1578063c6044c461461020c578063ca34837b14610235578063fc0f392d1461025e576100c9565b8063158ef93e14610113578063722769911461013e578063736c0d5b146101675780637df73e27146101a4576100c9565b
  says: 'the dispatcher has eight functions: initialized, safeMode, init, activateSafeMode, signers, isSigner and
    two sends; no signer setter'
  for:
  - action
  - evidence-2
  - justification
  - what
- id: five
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b60058282905014
  says: init requires exactly five signers
  for:
  - what
- id: init-done
  call: '0x9f199b93ae33c330880bdb31422fca37c6d3fb14'
  data: '0xc6044c4600000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000'
  from: '0x06d731bfea4b948e39e212672ae2be0c0c422f7d'
  reverts_with: Contract already initialized
  says: init cannot run again, so the signer set cannot be replaced
  for:
  - action
  - evidence-2
  - justification
  - what
- id: nonsigner
  call: '0x9f199b93ae33c330880bdb31422fca37c6d3fb14'
  data: '0x722769910000000000000000000000001ab4973a48dc892cd9971ece8e01dcc7688f8f2300000000000000000000000000000000000000000000000000000000000d6d80000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec700000000000000000000000000000000000000000000000000000000698c564a00000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000419f55296fdcce9f926f5f6740943313047a98d389f2b2d4c35a84bdfbdb8324ad349b91864ce3befc681758f5499ad8569f9a7e7fa853ff1c8e0d76ab27fa022f1c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041eeb5666c5f15a5270e183ed24244f3af93e07f38b38b29f96939df8321378c5d0dfc2b28c278e080f9929fe65eedb80d9cd93b143c2c3f198b824b54675a2eb91c00000000000000000000000000000000000000000000000000000000000000'
  from: '0x000000000000000000000000000000000000dead'
  reverts_with: Non-signer in onlySigner method
  says: only a signer can send a transfer
  for:
  - action
  - what
- id: invalid-signer
  call: '0x9f199b93ae33c330880bdb31422fca37c6d3fb14'
  data: '0x722769910000000000000000000000001ab4973a48dc892cd9971ece8e01dcc7688f8f2300000000000000000000000000000000000000000000000000000000000d6d80000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000419f55296fdcce9f926f5f6740943313047a98d389f2b2d4c35a84bdfbdb8324ad349b91864ce3befc681758f5499ad8569f9a7e7fa853ff1c8e0d76ab27fa022f1c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041eeb5666c5f15a5270e183ed24244f3af93e07f38b38b29f96939df8321378c5d0dfc2b28c278e080f9929fe65eedb80d9cd93b143c2c3f198b824b54675a2eb91c00000000000000000000000000000000000000000000000000000000000000'
  from: '0x06d731bfea4b948e39e212672ae2be0c0c422f7d'
  reverts_with: Invalid signer
  says: a signature that does not recover to a stored signer is refused
  for:
  - justification
  - what
- id: ecrecover
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b60018682858560405160008152602001604052604051610e519493929190611e83565b6020604051602081039080840390855afa
  says: signatures are recovered with the ecrecover precompile (address 1), the code's only STATICCALL
  for:
  - justification
  - what
- id: three-distinct
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 66697273745369676e65722073686f756c64206e6f7420626520657175616c20
  says: the code refuses a spend where the two signers or a signer and the caller are the same ('firstSigner should
    not be equal')
  for:
  - justification
  - what
- id: spend-tx
  tx: '0x0c2b545b53733a3233ad6f8abdc9b9ce5136c7d014c3e68a60c8dcb5de148c7d'
  to: '0x9f199b93ae33c330880bdb31422fca37c6d3fb14'
  ok: true
  says: a signer's token transfer with two signatures succeeded
  for:
  - evidence-1
  - what
- id: sender-signer
  call: '0x9f199b93ae33c330880bdb31422fca37c6d3fb14'
  fn: isSigner(address)(bool)
  args:
  - '0x06d731bfea4b948e39e212672ae2be0c0c422f7d'
  is: 'true'
  says: the sender of that transfer is a signer
  for:
  - evidence-1
- id: sender-eoa
  nonce: '0x06d731bfea4b948e39e212672ae2be0c0c422f7d'
  is: 4
  says: that signer is an account that has sent transactions, so its public key is on-chain
  for:
  - evidence-1
- id: no-1271
  selector: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the wallet never asks a signer through ERC-1271
  for:
  - justification
- id: signer-1
  call: '0x9f199b93ae33c330880bdb31422fca37c6d3fb14'
  fn: isSigner(address)(bool)
  args:
  - '0x3c3e56319d3de789284cc287581ba6881469a804'
  is: true
  says: 0x3c3e5631… is one of this wallet's five signers
  for:
  - what
- id: signer-1-key
  code: '0x3c3e56319d3de789284cc287581ba6881469a804'
  is: empty
  says: 'signer 0x3c3e5631… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-1-nonce
  nonce: '0x3c3e56319d3de789284cc287581ba6881469a804'
  is: 16
  says: signer 0x3c3e5631… has sent 16 transactions, so its public key is on-chain
  for:
  - notes
- id: signer-2
  call: '0x9f199b93ae33c330880bdb31422fca37c6d3fb14'
  fn: isSigner(address)(bool)
  args:
  - '0x06d731bfea4b948e39e212672ae2be0c0c422f7d'
  is: true
  says: 0x06d731bf… is one of this wallet's five signers
  for:
  - what
- id: signer-2-key
  code: '0x06d731bfea4b948e39e212672ae2be0c0c422f7d'
  is: empty
  says: 'signer 0x06d731bf… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-2-nonce
  nonce: '0x06d731bfea4b948e39e212672ae2be0c0c422f7d'
  is: 4
  says: signer 0x06d731bf… has sent 4 transactions, so its public key is on-chain
  for:
  - notes
- id: signer-3
  call: '0x9f199b93ae33c330880bdb31422fca37c6d3fb14'
  fn: isSigner(address)(bool)
  args:
  - '0x6f4de4bc02815bea28067539852f6b5601034650'
  is: true
  says: 0x6f4de4bc… is one of this wallet's five signers
  for:
  - what
- id: signer-3-key
  code: '0x6f4de4bc02815bea28067539852f6b5601034650'
  is: empty
  says: 'signer 0x6f4de4bc… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-3-nonce
  nonce: '0x6f4de4bc02815bea28067539852f6b5601034650'
  is: 0
  says: signer 0x6f4de4bc… has never sent a transaction
  for:
  - notes
- id: signer-4
  call: '0x9f199b93ae33c330880bdb31422fca37c6d3fb14'
  fn: isSigner(address)(bool)
  args:
  - '0x71c56394422d454813203da0fc70b6fabaed9273'
  is: true
  says: 0x71c56394… is one of this wallet's five signers
  for:
  - what
- id: signer-4-key
  code: '0x71c56394422d454813203da0fc70b6fabaed9273'
  is: empty
  says: 'signer 0x71c56394… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-4-nonce
  nonce: '0x71c56394422d454813203da0fc70b6fabaed9273'
  is: 0
  says: signer 0x71c56394… has never sent a transaction
  for:
  - notes
- id: signer-5
  call: '0x9f199b93ae33c330880bdb31422fca37c6d3fb14'
  fn: isSigner(address)(bool)
  args:
  - '0x78fa238fecd2c62f1f452f0df799fd6931bf16fd'
  is: true
  says: 0x78fa238f… is one of this wallet's five signers
  for:
  - what
- id: signer-5-key
  code: '0x78fa238fecd2c62f1f452f0df799fd6931bf16fd'
  is: empty
  says: 'signer 0x78fa238f… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-5-nonce
  nonce: '0x78fa238fecd2c62f1f452f0df799fd6931bf16fd'
  is: 0
  says: signer 0x78fa238f… has never sent a transaction
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
- who: r-9f199b93, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM candidate (PQ-12, bytecode): a custodian multisig clone of 0x0d424072
    holding 10,000,018 USDT, whose spend needs a signer as sender plus two other signers'' ECDSA signatures (three
    keys); its five signers were set once and cannot be replaced, so the only fix is the signers moving the funds.
    Signers read by Claude from the setup block (isSigner, code and nonce checks). The refuter agrees with no objection;
    Claude read the card and the answer.'
related: []
---

## What happens

This wallet holds about $10 million in USDT and pays out when one of its signers sends the transfer with ECDSA signatures of two other signers. Its five signers are set once at creation and nothing can replace them. A quantum attacker who recovers three signers' keys can move everything.

## Evidence

- A [transfer](https://etherscan.io/tx/0x0c2b545b53733a3233ad6f8abdc9b9ce5136c7d014c3e68a60c8dcb5de148c7d) on 2026-02-11 was sent by one signer and carried two more signers' ECDSA signatures.
- The [wallet](https://etherscan.io/address/0x9f199b93ae33c330880bdb31422fca37c6d3fb14#code) has no function to add, remove or replace a signer, and its setup refuses a second call.

## Reviewer notes

### Mechanism

The address is an EIP-1167 clone of 0x0d424072 (unverified, 7,934 bytes, no DELEGATECALL). Dispatcher (bytes 0x00-0x7f) has 8 selectors: initialized, signers(address), isSigner(address), safeMode, init(address[]), activateSafeMode, 0xca34837b (ETH send: to, value, data, expireTime, bytes[] signatures) and 0x72276991 (token send: to, value, token, expireTime, bytes[] signatures). init requires exactly 5 non-zero signers (PUSH1 05 EQ at 0x3ff, 'Invalid number of signers') and reverts once initialized. The send functions are onlySigner (msg.sender must be in the signers mapping, 'Non-signer in onlySigner method'), check expireTime against TIMESTAMP, require two 65-byte signatures ('signature need 2'), recover each with the ecrecover precompile (the only STATICCALL, at 0xe62, all gas) and require each recovered address to be a signer ('Invalid signer') and the three (caller, first, second) to be distinct. The hash prefix is the string ETHER for the ETH path (0xd0c); the exact token-path hash was not reproduced. No ERC-1271, no signer setter, no upgrade. Signer 0x06d731bf (EOA, nonce 4) sent tx 0x0c2b545b (0.88 USDT test transfer), with two signatures, which expose two more signers' public keys.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path: neither 0x1626ba7e nor 0x20c13b0b is in the implementation, and its only STATICCALL is the ecrecover precompile.
- Ruled out: key-state: the wallet is initialized; calling sendMultiSigToken from signer 0x06d731bf with a future expiry and the real signatures reverts 'Invalid signer', so signatures are checked against the stored signers. The other four signers could not be listed without the creation input; they are not the five signers of sibling wallet 0x59708733 (isSigner false for all five).
- Ruled out: unused implementation: this clone holds 10,000,018.12 USDT and 0.05 ETH and spent in tx 0x0c2b545b; it is in use itself. Other clones of 0x0d424072 (the old card counted 21) are separate rows.
- Ruled out: safe mode: safeMode() is false at the block.
- Ruled out: Signers: the five addresses of setup transaction 0x8f4fcb4631… (block 19,146,367), found by Claude in that block and each confirmed by isSigner at the block; all distinct, none has code.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
