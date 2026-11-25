---
id: contract-70213959-owner-keys
format: 2
title: Custody wallet with five fixed ECDSA signers can be drained by forged keys
status: candidate
severity: MEDIUM
justification: Forging three of five fixed signer keys takes everything; the fix needs the signers to move the funds.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x70213959a644baa94840bbfb4129550bceceb3c2'
  code: bytecode
  code_url: https://etherscan.io/address/0x70213959a644baa94840bbfb4129550bceceb3c2#code
  proxy_of: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 82827864
  basis: held
activity: {}
impact: funds-loss
action: Move the funds to a wallet whose signers verify post-quantum signatures; this wallet cannot change its signers.
evidence_level: bytecode
checks:
- id: clone
  bytecode: '0x70213959a644baa94840bbfb4129550bceceb3c2'
  has: 363d3d373d3d3d363d730d424072d658e6abd92c36f8fc16fd6479ae15a05af43d82803e903d91602b57fd5bf3
  says: the wallet is a minimal clone that runs the code at 0x0d424072 for every call; the target is fixed in its
    code
  for:
  - action
  - evidence-2
  - what
- id: dispatcher
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 8063abe3219c1161004e578063abe3219c146101e1578063c6044c461461020c578063ca34837b14610235578063fc0f392d1461025e576100c9565b8063158ef93e14610113578063722769911461013e578063736c0d5b146101675780637df73e27146101a4576100c956
  says: the code routes nine selectors only (two spends, init, signer reads, safe mode); anything else goes to the
    deposit fallback
  for:
  - action
  - evidence-1
  - justification
  - what
- id: spend-entry
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b6105ac33610349565b6105eb57
  says: the ETH spend 0xca34837b first looks up the caller in the signer mapping and reverts if it is not a signer
  for:
  - action
  - evidence-1
  - justification
  - what
- id: token-entry
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b61028f33610349565b6102ce57
  says: the token spend 0x72276991 makes the same caller check
  for:
  - notes
- id: onlysigner
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 4e6f6e2d7369676e657220696e206f6e6c795369676e6572206d6574686f64
  says: the revert reason of that caller check
  for:
  - evidence-1
  - what
- id: two-sigs
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 7369676e6174757265206e6565642032
  says: the spend takes two signatures
  for:
  - what
- id: distinct
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 66697273745369676e65722073686f756c64206e6f7420626520657175616c20
  says: the two recovered signers must differ from each other and from the caller
  for:
  - evidence-1
  - justification
  - what
- id: ecrecover
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b60018682858560405160008152602001604052604051610e519493929190611e83565b6020604051602081039080840390855afa
  says: each signature goes to the ecrecover precompile (address 1) with all remaining gas
  for:
  - evidence-1
  - justification
  - what
- id: ether-prefix
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 7f4554484552
  says: the signed hash of an ETH spend starts with the text ETHER
  for:
  - notes
- id: init-once
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 436f6e747261637420616c726561647920696e697469616c697a6564
  says: init can run once
  for:
  - action
  - evidence-1
  - justification
  - what
- id: five
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 496e76616c6964206e756d626572206f66207369676e657273
  says: init takes exactly five signers
  for:
  - evidence-2
  - what
- id: safe-mode-text
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 45787465726e616c207472616e7366657220696e2073616665206d6f6465
  says: safe mode only limits where a spend can send to
  for:
  - notes
- id: initialized
  call: '0x70213959a644baa94840bbfb4129550bceceb3c2'
  fn: initialized()(bool)
  is: true
  says: this wallet has been initialized, so its signer set is final
  for:
  - evidence-2
  - what
- id: safe-mode
  call: '0x70213959a644baa94840bbfb4129550bceceb3c2'
  fn: safeMode()(bool)
  is: false
  says: safe mode is off
  for:
  - notes
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x70213959a644baa94840bbfb4129550bceceb3c2'
  is: '45899202011101000000000'
  says: the wallet holds 45,899.2 ETH
  for:
  - evidence-2
  - what
- id: signer-1
  call: '0x70213959a644baa94840bbfb4129550bceceb3c2'
  fn: isSigner(address)(bool)
  args:
  - '0x7f6a0886e9c06635802c823b1e01fa5ace23012f'
  is: true
  says: 0x7f6a0886e9c06635802c823b1e01fa5ace23012f is a signer of this wallet
  for:
  - evidence-2
  - what
- id: signer-2
  call: '0x70213959a644baa94840bbfb4129550bceceb3c2'
  fn: isSigner(address)(bool)
  args:
  - '0x6761ee52d24b4519f2ad3c7b80d6d5b57b825b74'
  is: true
  says: 0x6761ee52d24b4519f2ad3c7b80d6d5b57b825b74 is a signer of this wallet
  for:
  - evidence-2
  - what
- id: signer-3
  call: '0x70213959a644baa94840bbfb4129550bceceb3c2'
  fn: isSigner(address)(bool)
  args:
  - '0x1458e52d23b531df0e5a2b0d8db43d85018069f9'
  is: true
  says: 0x1458e52d23b531df0e5a2b0d8db43d85018069f9 is a signer of this wallet
  for:
  - evidence-2
  - what
- id: signer-4
  call: '0x70213959a644baa94840bbfb4129550bceceb3c2'
  fn: isSigner(address)(bool)
  args:
  - '0xd59a643bbb558cdbfdc1f9747aa171218bdc3357'
  is: true
  says: 0xd59a643bbb558cdbfdc1f9747aa171218bdc3357 is a signer of this wallet
  for:
  - evidence-2
  - what
- id: signer-5
  call: '0x70213959a644baa94840bbfb4129550bceceb3c2'
  fn: isSigner(address)(bool)
  args:
  - '0xe4af0df01622386bf1d3589ba325c66293850632'
  is: true
  says: 0xe4af0df01622386bf1d3589ba325c66293850632 is a signer of this wallet
  for:
  - evidence-2
  - what
- id: eoa-1
  code: '0x7f6a0886e9c06635802c823b1e01fa5ace23012f'
  is: empty
  says: signer 0x7f6a0886e9c06635802c823b1e01fa5ace23012f has no code
  for:
  - evidence-3
- id: eoa-2
  code: '0x6761ee52d24b4519f2ad3c7b80d6d5b57b825b74'
  is: empty
  says: signer 0x6761ee52d24b4519f2ad3c7b80d6d5b57b825b74 has no code
  for:
  - evidence-3
- id: eoa-3
  code: '0x1458e52d23b531df0e5a2b0d8db43d85018069f9'
  is: empty
  says: signer 0x1458e52d23b531df0e5a2b0d8db43d85018069f9 has no code
  for:
  - evidence-3
- id: eoa-4
  code: '0xd59a643bbb558cdbfdc1f9747aa171218bdc3357'
  is: empty
  says: signer 0xd59a643bbb558cdbfdc1f9747aa171218bdc3357 has no code
  for:
  - evidence-3
- id: eoa-5
  code: '0xe4af0df01622386bf1d3589ba325c66293850632'
  is: empty
  says: signer 0xe4af0df01622386bf1d3589ba325c66293850632 has no code
  for:
  - evidence-3
- id: nonce-1
  nonce: '0x7f6a0886e9c06635802c823b1e01fa5ace23012f'
  is: 311
  says: signer 0x7f6a0886 has sent 311 transactions, so its public key is on-chain
  for:
  - evidence-3
  - what
- id: nonce-2
  nonce: '0x6761ee52d24b4519f2ad3c7b80d6d5b57b825b74'
  is: 63
  says: signer 0x6761ee52 has sent 63 transactions, so its public key is on-chain
  for:
  - evidence-3
  - what
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
- who: r-70213959, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection (the card was edited after this answer)
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-12): Custody wallet with five fixed ECDSA signers can be drained
    by forged keys. Forging three of five fixed signer keys takes everything; the fix needs the signers to move
    the funds. Settled before with two agreeing refuters; Claude afterwards only removed a reviewer note that did
    not belong in the registry. Settled again by Claude (D-029). Claude read the card and the answers.'
related: []
---

## What happens

This wallet holds 45,899 ETH and pays out when one of its five ECDSA signers sends the transfer with signatures of two others. A quantum attacker who derives three signer keys can take it all; the signer set cannot be changed, so the funds must move.

## Evidence

- [Wallet code](https://etherscan.io/address/0x0d424072d658e6abd92c36f8fc16fd6479ae15a0#code): the sender must be a signer and two other signers' signatures go to ecrecover; nothing changes the signers.
- [This wallet](https://etherscan.io/address/0x70213959a644baa94840bbfb4129550bceceb3c2) is a fixed clone of that code, set up once with five signers, and holds 45,899 ETH.
- All five signers are plain accounts; [0x7f6a0886](https://etherscan.io/address/0x7f6a0886e9c06635802c823b1e01fa5ace23012f) and 0x6761ee52 have sent transactions, so their public keys are on-chain.

## Reviewer notes

### Mechanism

The address is an EIP-1167 clone of unverified 0x0d424072 (no DELEGATECALL, no upgrade selector). Read from the disassembly; the decompile drops the spend body. ETH spend 0xca34837b(address to,uint256 value,bytes data,uint256 expireTime,bytes[2] sigs) at pc 0x05a3: require signers[msg.sender]; hash = keccak256(abi.encodePacked('ETHER',to,value,data,expireTime)); verify (pc 0x0817) recovers sigs[0] and sigs[1] through the ecrecover precompile with all gas (pc 0x0e2e-0x0e62), requires both to be signers, distinct, and different from msg.sender, requires !safeMode || signers[to] and expireTime >= now; then CALL(to,value,data) with all gas. Token spend 0x72276991 does the same with an ERC20 prefix and a safeTransfer. Signers are written only in init 0xc6044c46 (once, exactly five, non-zero); the other SSTOREs set initialized and safeMode (set-only). So three distinct signers act per spend: one sends, two sign. Checked locally: recovering the two signatures of tx 0x14a78281 (sibling clone 0x59708733, sender 0x7f6a0886) with that hash gives 0x6761ee52 and 0x1458e52d, so the hash reading is right and a third key (nonce 0) is public through calldata.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: erc1271: no isValidSignature selector and no other path; the dispatcher routes nine selectors only, and each signer is matched on the ecrecover result.
- Ruled out: unused-implementation: this address is the clone itself, initialized, with its own five signers and 45,899 ETH; the implementation 0x0d424072 is not the subject.
- Ruled out: key-state: all five isSigner reads are true; all five signers have no code.
- Ruled out: setter / reopened: no add, remove or replace function for signers; init reverts once initialized; no upgrade path in clone or implementation.
- Ruled out: path-closed: safeMode is off; even when on it only limits destinations to signer addresses, which a key forger controls.
- Ruled out: wrong-code: selectors and revert texts read from the implementation's runtime code at the block; the old card's two-signature threshold misses the required signer sender, so three keys are needed, not two.
- Ruled out: value-whose: 45,899.2 ETH is this address's own balance (Multicall3 read), not a family total; whose money it is cannot be shown, so whose is left empty.
- Ruled out: Separate from this card: under EIP-8151 a signer whose account takes real code stops counting (replay eip8151_signer_code of tx 0x14a78281 on sibling clone 0x59708733 reverts); that is a migration notice for another row, not cited here.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
