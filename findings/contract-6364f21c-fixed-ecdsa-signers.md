---
id: contract-6364f21c-fixed-ecdsa-signers
format: 2
title: Multisig trusts fixed ECDSA signer keys to move its funds
status: candidate
severity: MEDIUM
justification: Three forged signer keys can empty it; the signers cannot be replaced, so the fix is moving the funds
  out.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6364f21c14aa790973386aa86af278ccf1f819f2'
  code: bytecode
  code_url: https://etherscan.io/address/0x6364f21c14aa790973386aa86af278ccf1f819f2#code
  proxy_of: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 36
  basis: held
activity: {}
impact: funds-loss
action: Move the funds to a new wallet whose signers can use post-quantum keys; this wallet's signers cannot be
  replaced.
evidence_level: bytecode
checks:
- id: clone
  code: '0x6364f21c14aa790973386aa86af278ccf1f819f2'
  is: contract
  bytes: 45
  says: the address is a 45-byte clone that runs the wallet code at 0x0d424072
  for:
  - evidence-2
- id: clone-target
  bytecode: '0x6364f21c14aa790973386aa86af278ccf1f819f2'
  has: 363d3d373d3d3d363d730d424072d658e6abd92c36f8fc16fd6479ae15a05af4
  says: the clone delegates every call to the wallet code at 0x0d424072, fixed in its code
  for:
  - notes
- id: recover
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 60018682858560405160008152602001604052604051610e519493929190611e83565b6020604051602081039080840390855afa
  says: the wallet code calls the ecrecover precompile (address 1) with all remaining gas
  for:
  - evidence-1
  - justification
  - what
- id: ecdsa-lib
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 45434453413a20696e76616c6964207369676e6174757265202773272076616c
  says: 'the code carries the ECDSA library''s revert text, ''ECDSA: invalid signature ''s'' value'''
  for:
  - notes
- id: need2
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 7369676e6174757265206e6565642032
  says: 'the code carries the revert text ''signature need 2'': a transfer takes exactly two signatures'
  for:
  - evidence-1
  - justification
  - what
- id: distinct
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 7365636f6e645369676e65722073686f756c64206e6f7420626520657175616c
  says: the code checks that the second recovered signer differs from the first and from the sender (revert text
    'secondSigner should not be equal')
  for:
  - evidence-1
  - what
- id: invalid-signer
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 496e76616c6964207369676e6572
  says: the code reverts with 'Invalid signer' when an address is not in the signer list
  for:
  - evidence-1
  - what
- id: send-eth
  call: '0x6364f21c14aa790973386aa86af278ccf1f819f2'
  data: '0xca34837b0000000000000000000000001111111111111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000002540be3ff00000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
  from: '0x1111111111111111111111111111111111111111'
  reverts_with: Non-signer in onlySigner method
  says: the transfer function with a call (selector 0xca34837b) refuses a sender that is not a signer
  for:
  - evidence-2
  - justification
  - what
- id: send-token
  call: '0x6364f21c14aa790973386aa86af278ccf1f819f2'
  data: '0x7227699100000000000000000000000011111111111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111111111111111111111111111100000000000000000000000000000000000000000000000000000002540be3ff00000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
  from: '0x1111111111111111111111111111111111111111'
  reverts_with: Non-signer in onlySigner method
  says: the token transfer function (selector 0x72276991) refuses a sender that is not a signer
  for:
  - evidence-2
  - what
- id: five
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: '60058282905014610445'
  says: init compares the number of signers given with 5 (PUSH1 5, EQ) and reverts otherwise
  for:
  - action
  - what
- id: five-text
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 496e76616c6964206e756d626572206f66207369676e657273
  says: the code carries the revert text 'Invalid number of signers'
  for:
  - what
- id: initialized
  call: '0x6364f21c14aa790973386aa86af278ccf1f819f2'
  fn: initialized()(bool)
  is: true
  says: this wallet was initialized
  for:
  - what
- id: init-closed
  call: '0x6364f21c14aa790973386aa86af278ccf1f819f2'
  fn: init(address[])
  args:
  - - '0x1111111111111111111111111111111111111111'
    - '0x1111111111111111111111111111111111111111'
    - '0x1111111111111111111111111111111111111111'
    - '0x1111111111111111111111111111111111111111'
    - '0x1111111111111111111111111111111111111111'
  from: '0x1111111111111111111111111111111111111111'
  reverts_with: Contract already initialized
  says: init cannot be run again, so the signer list cannot be set anew
  for:
  - action
  - evidence-2
  - justification
  - what
- id: dispatcher
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 60003560e01c8063abe3219c1161004e578063abe3219c146101e1578063c6044c461461020c578063ca34837b14610235578063fc0f392d1461025e576100c9565b8063158ef93e14610113578063722769911461013e578063736c0d5b146101675780637df73e27146101a4576100c956
  says: the dispatcher lists eight functions (safeMode, init, two transfers, activateSafeMode, initialized, signers,
    isSigner)
  for:
  - action
  - justification
  - what
- id: no-1271
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector (0x1626ba7e)
  for:
  - what
- id: no-1271-legacy
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector (0x20c13b0b)
  for:
  - what
- id: safe-mode-off
  call: '0x6364f21c14aa790973386aa86af278ccf1f819f2'
  fn: safeMode()(bool)
  is: false
  says: 'safe mode is off: transfers to any address are open'
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

This wallet moves its ETH and tokens when one of its signers sends the transaction and two other signers sign it with ECDSA. Its list of five signer addresses is set once, at initialisation, and no function replaces it. Whoever derives three signers' private keys can empty it.

## Evidence

- [The wallet code](https://etherscan.io/address/0x0d424072d658e6abd92c36f8fc16fd6479ae15a0#code) recovers two ECDSA signatures; both must be listed signers, distinct from each other and the sender.
- [This wallet](https://etherscan.io/address/0x6364f21c14aa790973386aa86af278ccf1f819f2#code) refuses transfers sent by a non-signer and refuses a second initialisation.

## Reviewer notes

### Mechanism

Same runtime code as 0x8028270e06fca18e212306a7c93bfee52b440fc5, whose card an author wrote and a refuter checked: the path through the code and what was ruled out are in that card's notes. Here its 17 checks were run again at this address.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Anything about this address beyond those checks: no author or refuter looked at it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
