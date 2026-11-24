---
id: contract-9c9c8f4f-owner-keys
format: 2
title: Wallet's five fixed ECDSA signer keys cannot be replaced
status: candidate
severity: MEDIUM
justification: Three forged signer keys spend its funds; the signers are fixed, so the fix is moving to a new wallet.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  code: bytecode
  code_url: https://etherscan.io/address/0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46#code
  proxy_of: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity: {}
impact: funds-loss
action: Move to a wallet that can take post-quantum signers before funding this one again; its five signers cannot
  be replaced.
evidence_level: bytecode
checks:
- id: clone
  bytecode: '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  has: 363d3d373d3d3d363d730d424072d658e6abd92c36f8fc16fd6479ae15a05af43d82803e903d91602b57fd5bf3
  says: the address is a minimal clone that runs the code at 0x0d424072 with its own storage
  for:
  - action
  - evidence-1
  - justification
  - what
- id: dispatcher
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 60003560e01c8063abe3219c1161004e578063abe3219c146101e1578063c6044c461461020c578063ca34837b14610235578063fc0f392d1461025e576100c9565b8063158ef93e14610113578063722769911461013e578063736c0d5b146101675780637df73e27146101a4576100c956
  says: 'the whole function table: eight selectors, none that changes a signer; any other selector reaches a fallback
    that only logs deposits'
  for:
  - action
  - justification
  - what
- id: recover
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 60018682858560405160008152602001604052604051610e519493929190611e83565b6020604051602081039080840390855afa
  says: each signature is recovered by a static call to precompile 1 (ecrecover) with all gas; the signer's own
    code is never asked
  for:
  - evidence-1
  - justification
  - what
- id: tokpath
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: '6103148682848661081756'
  says: the token spend 0x72276991 jumps into the shared signature checker at 0x0817
  for:
  - evidence-1
  - what
- id: ethpath
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: '6106368984868861081756'
  says: the ETH/call spend 0xca34837b jumps into the same signature checker at 0x0817
  for:
  - evidence-1
  - what
- id: bothsigners
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 6109f182610349565b610a3057
  says: the checker looks the first recovered address up in the signer mapping and reverts unless it is set
  for:
  - what
- id: secondsigner
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 610a3981610349565b610a7857
  says: the checker does the same for the second recovered address
  for:
  - what
- id: distinct
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 8073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff161415610ae757
  says: the checker reverts when the two recovered addresses are equal
  for:
  - what
- id: initialized
  call: '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  data: '0x158ef93e'
  is: '0x0000000000000000000000000000000000000000000000000000000000000001'
  says: initialized() is true on this clone
  for:
  - action
  - justification
  - what
- id: initclosed
  call: '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  fn: init(address[])()
  args:
  - - '0x0000000000000000000000000000000000000001'
    - '0x0000000000000000000000000000000000000002'
    - '0x0000000000000000000000000000000000000003'
    - '0x0000000000000000000000000000000000000004'
    - '0x0000000000000000000000000000000000000005'
  reverts_with: Contract already initialized
  says: init, the only function that writes signers, cannot run again
  for:
  - action
  - justification
  - what
- id: safemodeoff
  call: '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  data: '0xabe3219c'
  is: '0x0000000000000000000000000000000000000000000000000000000000000000'
  says: safe mode (payouts to signers only) is off
  for:
  - notes
- id: signer1
  call: '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  fn: isSigner(address)(bool)
  args:
  - '0x3c3e56319d3de789284cc287581ba6881469a804'
  is: true
  says: 0x3c3e56319d3de789284cc287581ba6881469a804 is one of the five signers set at creation
  for:
  - what
- id: plainkey1
  code: '0x3c3e56319d3de789284cc287581ba6881469a804'
  is: empty
  says: 'signer 0x3c3e56319d3de789284cc287581ba6881469a804 has no code: it is a plain ECDSA key'
  for:
  - justification
  - what
- id: signer2
  call: '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  fn: isSigner(address)(bool)
  args:
  - '0x78fa238fecd2c62f1f452f0df799fd6931bf16fd'
  is: true
  says: 0x78fa238fecd2c62f1f452f0df799fd6931bf16fd is one of the five signers set at creation
  for:
  - what
- id: plainkey2
  code: '0x78fa238fecd2c62f1f452f0df799fd6931bf16fd'
  is: empty
  says: 'signer 0x78fa238fecd2c62f1f452f0df799fd6931bf16fd has no code: it is a plain ECDSA key'
  for:
  - justification
  - what
- id: signer3
  call: '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  fn: isSigner(address)(bool)
  args:
  - '0x06d731bfea4b948e39e212672ae2be0c0c422f7d'
  is: true
  says: 0x06d731bfea4b948e39e212672ae2be0c0c422f7d is one of the five signers set at creation
  for:
  - what
- id: plainkey3
  code: '0x06d731bfea4b948e39e212672ae2be0c0c422f7d'
  is: empty
  says: 'signer 0x06d731bfea4b948e39e212672ae2be0c0c422f7d has no code: it is a plain ECDSA key'
  for:
  - justification
  - what
- id: signer4
  call: '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  fn: isSigner(address)(bool)
  args:
  - '0x71c56394422d454813203da0fc70b6fabaed9273'
  is: true
  says: 0x71c56394422d454813203da0fc70b6fabaed9273 is one of the five signers set at creation
  for:
  - what
- id: plainkey4
  code: '0x71c56394422d454813203da0fc70b6fabaed9273'
  is: empty
  says: 'signer 0x71c56394422d454813203da0fc70b6fabaed9273 has no code: it is a plain ECDSA key'
  for:
  - justification
  - what
- id: signer5
  call: '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  fn: isSigner(address)(bool)
  args:
  - '0x6f4de4bc02815bea28067539852f6b5601034650'
  is: true
  says: 0x6f4de4bc02815bea28067539852f6b5601034650 is one of the five signers set at creation
  for:
  - what
- id: plainkey5
  code: '0x6f4de4bc02815bea28067539852f6b5601034650'
  is: empty
  says: 'signer 0x6f4de4bc02815bea28067539852f6b5601034650 has no code: it is a plain ECDSA key'
  for:
  - justification
  - what
- id: nonsigner
  call: '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  data: '0x722769910000000000000000000000001ab4973a48dc892cd9971ece8e01dcc7688f8f2300000000000000000000000000000000000000000000000000002d79883d2000000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000000000000000000000000000000000008b9f07ed00000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000004179591453d35c150085d2f6c84aa0d626201fe98c23f1b6f401340cee77e0ab0d5949f1ae6dfe387a7adc892b888ebe386cce02bdc86f476872c42c73b106e5af1b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041d5bf260a540d43e03e9780201c4149f20c7bd11a4716d96c06f1e3665f92fd7e46fba0ff291b2edab32d1d1d0d1b271a67d8ad14039adebae55ad9b758a917761c00000000000000000000000000000000000000000000000000000000000000'
  from: '0x000000000000000000000000000000000000dead'
  reverts_with: Non-signer in onlySigner method
  says: a spend from a non-signer is refused even with two valid signatures (calldata of the 2025-03-20 transfer,
    valid to 2044)
  for:
  - evidence-1
  - evidence-2
  - justification
  - what
- id: firstnotsender
  call: '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  data: '0x722769910000000000000000000000001ab4973a48dc892cd9971ece8e01dcc7688f8f2300000000000000000000000000000000000000000000000000002d79883d2000000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000000000000000000000000000000000008b9f07ed00000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000004179591453d35c150085d2f6c84aa0d626201fe98c23f1b6f401340cee77e0ab0d5949f1ae6dfe387a7adc892b888ebe386cce02bdc86f476872c42c73b106e5af1b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041d5bf260a540d43e03e9780201c4149f20c7bd11a4716d96c06f1e3665f92fd7e46fba0ff291b2edab32d1d1d0d1b271a67d8ad14039adebae55ad9b758a917761c00000000000000000000000000000000000000000000000000000000000000'
  from: '0x06d731bfea4b948e39e212672ae2be0c0c422f7d'
  reverts_with: firstSigner should not be equal to msg.sender
  says: 'the same calldata sent by the signer of its first signature (0x06d731bf) is refused: the sender cannot
    be one of the two'
  for:
  - evidence-1
  - justification
  - what
- id: secondnotsender
  call: '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  data: '0x722769910000000000000000000000001ab4973a48dc892cd9971ece8e01dcc7688f8f2300000000000000000000000000000000000000000000000000002d79883d2000000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000000000000000000000000000000000008b9f07ed00000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000004179591453d35c150085d2f6c84aa0d626201fe98c23f1b6f401340cee77e0ab0d5949f1ae6dfe387a7adc892b888ebe386cce02bdc86f476872c42c73b106e5af1b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041d5bf260a540d43e03e9780201c4149f20c7bd11a4716d96c06f1e3665f92fd7e46fba0ff291b2edab32d1d1d0d1b271a67d8ad14039adebae55ad9b758a917761c00000000000000000000000000000000000000000000000000000000000000'
  from: '0x78fa238fecd2c62f1f452f0df799fd6931bf16fd'
  reverts_with: secondSigner should not be equal to msg.sender
  says: the same calldata sent by the signer of its second signature (0x78fa238f, nonce 0) is refused; that key's
    signature is on-chain
  for:
  - evidence-1
  - evidence-3
  - justification
  - what
- id: thirdpasses
  call: '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  data: '0x722769910000000000000000000000001ab4973a48dc892cd9971ece8e01dcc7688f8f2300000000000000000000000000000000000000000000000000002d79883d2000000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000000000000000000000000000000000008b9f07ed00000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000004179591453d35c150085d2f6c84aa0d626201fe98c23f1b6f401340cee77e0ab0d5949f1ae6dfe387a7adc892b888ebe386cce02bdc86f476872c42c73b106e5af1b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041d5bf260a540d43e03e9780201c4149f20c7bd11a4716d96c06f1e3665f92fd7e46fba0ff291b2edab32d1d1d0d1b271a67d8ad14039adebae55ad9b758a917761c00000000000000000000000000000000000000000000000000000000000000'
  from: '0x3c3e56319d3de789284cc287581ba6881469a804'
  reverts_with: 'TransferHelper::safeTransfer: transfer failed'
  says: 'sent by a third signer it passes every signature check and fails only at the USDT transfer: the wallet
    holds no USDT'
  for:
  - evidence-1
  - justification
  - what
- id: wasok
  call: '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  data: '0x722769910000000000000000000000001ab4973a48dc892cd9971ece8e01dcc7688f8f2300000000000000000000000000000000000000000000000000002d79883d2000000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000000000000000000000000000000000008b9f07ed00000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000004179591453d35c150085d2f6c84aa0d626201fe98c23f1b6f401340cee77e0ab0d5949f1ae6dfe387a7adc892b888ebe386cce02bdc86f476872c42c73b106e5af1b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041d5bf260a540d43e03e9780201c4149f20c7bd11a4716d96c06f1e3665f92fd7e46fba0ff291b2edab32d1d1d0d1b271a67d8ad14039adebae55ad9b758a917761c00000000000000000000000000000000000000000000000000000000000000'
  from: '0x3c3e56319d3de789284cc287581ba6881469a804'
  at: 22086586
  is: 0x
  says: one block before it was mined, that spend succeeds from its real sender, a third signer
  for:
  - notes
- id: badsig
  call: '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  data: '0x722769910000000000000000000000001ab4973a48dc892cd9971ece8e01dcc7688f8f2300000000000000000000000000000000000000000000000000002d79883d2001000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000000000000000000000000000000000008b9f07ed00000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000004179591453d35c150085d2f6c84aa0d626201fe98c23f1b6f401340cee77e0ab0d5949f1ae6dfe387a7adc892b888ebe386cce02bdc86f476872c42c73b106e5af1b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041d5bf260a540d43e03e9780201c4149f20c7bd11a4716d96c06f1e3665f92fd7e46fba0ff291b2edab32d1d1d0d1b271a67d8ad14039adebae55ad9b758a917761c00000000000000000000000000000000000000000000000000000000000000'
  from: '0x3c3e56319d3de789284cc287581ba6881469a804'
  reverts_with: Invalid signer
  says: 'with the amount changed by one unit it is refused: recovered addresses must be signers, and the signatures
    bind the amount'
  for:
  - evidence-1
  - justification
  - what
- id: sig6f4d
  call: '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  data: '0x72276991000000000000000000000000ed9ab5bc05a0152b9dc2f7902e8369af7bc18771000000000000000000000000000000000000000000000000000009184eee86c0000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000000000000000000000000000000000006ae5e23b00000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000004100706cdbff35c9732d8f3d323b1c325773c9b1ec81da607b4c2f73c3060ffbd83bcf35c71e97a5f8a4c6e80a2d3e283493a028c7246ec14836624299cec692ae1c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000417bfb205546d8b4b811e5fb59d4e1a5aa80777597d74834cd0b57a1be42ef6a64445c90ac6b43af977dea39f7e37e236486c99481f3555de1f1bc9259ca8a58dc1c00000000000000000000000000000000000000000000000000000000000000'
  from: '0x6f4de4bc02815bea28067539852f6b5601034650'
  at: 26311639
  reverts_with: secondSigner should not be equal to msg.sender
  says: 'the second signature of the 2026-10-31 transfer recovers to signer 0x6f4de4bc (nonce 0): its signature
    is on-chain'
  for:
  - evidence-3
- id: sent3c3e
  nonce: '0x3c3e56319d3de789284cc287581ba6881469a804'
  min: 1
  says: signer 0x3c3e5631 has sent transactions, so its public key is on-chain
  for:
  - evidence-3
- id: sent06d7
  nonce: '0x06d731bfea4b948e39e212672ae2be0c0c422f7d'
  min: 1
  says: signer 0x06d731bf has sent transactions, so its public key is on-chain
  for:
  - evidence-3
- id: txout
  tx: '0x5b0f74aba88d2f588d401ec9eec11983ba89a6a6ff7b8815898af9e2dced2181'
  to: '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  ok: true
  says: the transfer of 2026-10-31 (block 26,311,640) called this wallet and succeeded
  for:
  - evidence-2
  - evidence-3
  - what
- id: tx2025
  tx: '0xcaa9c0b5464a5bb5de28a6bce95a0f6575837c540aee06a543badfdc369c6363'
  to: '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  ok: true
  says: the transfer of 2025-03-20 (block 22,086,587) called this wallet and succeeded
  for:
  - evidence-3
- id: usdtbefore
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  at: 26311639
  is: 10000008120000
  says: the wallet held 10,000,008.12 USDT one block before the 2026-10-31 transfer
  for:
  - evidence-2
  - what
- id: usdtafter
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  at: 26311640
  is: 0
  says: the wallet held no USDT after that transfer
  for:
  - evidence-2
  - what
- id: usdtzero
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  is: 0
  says: the wallet holds no USDT
  for:
  - action
  - what
- id: ethzero
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x9c9c8f4f33679ce7f2c46cbf8ab4feb4cf45fe46'
  is: 0
  says: the wallet holds no ETH
  for:
  - action
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
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: CRITICAL
reviews:
- who: r-9c9c8f4f, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-12): Wallet''s five fixed ECDSA signer keys cannot be replaced.
    Three forged signer keys spend its funds; the signers are fixed, so the fix is moving to a new wallet. Fix:
    Move to a wallet that can take post-quantum signers before funding this one again; its five signers cannot be
    replaced. One refuter agrees on the current card with no objection (D-029: a second refuter only for removals);
    Claude read the card and the answer.'
related: []
---

## What happens

This wallet pays out when one of its five signers sends a transfer carrying ECDSA signatures of two other signers. The five signers are fixed. A quantum attacker who forges three of those keys can spend what it holds. It holds no ETH or USDT, after it sent out about 10 million USDT on 2026-10-31.

## Evidence

- The [wallet code](https://etherscan.io/address/0x0d424072d658e6abd92c36f8fc16fd6479ae15a0#code) recovers two ECDSA signatures and refuses a sender that is not a third signer.
- A signer sent the [transfer of 2026-10-31](https://etherscan.io/tx/0x5b0f74aba88d2f588d401ec9eec11983ba89a6a6ff7b8815898af9e2dced2181) that moved out the wallet's USDT.
- Four of the five signers have sent a transaction or signed a [transfer](https://etherscan.io/tx/0xcaa9c0b5464a5bb5de28a6bce95a0f6575837c540aee06a543badfdc369c6363), which reveals their public keys.

## Reviewer notes

### Mechanism

Read from the bytecode of 0x0d424072 by disassembly (the decompiler shows both spend functions as bare reverts). 0x72276991(to, amount, token, expireTime, bytes[2] sigs) and 0xca34837b(to, value, data, expireTime, bytes[2] sigs) require the caller to be in the signer mapping (slot 0), hash keccak256('ERC20' | to | amount | token | expireTime) or keccak256('ETHER' | to | value | data | expireTime), and enter the checker at 0x0817: two 65-byte signatures, each recovered through precompile 1; safe mode off or `to` a signer; expireTime >= block time; both recovered addresses in the mapping; first != second; neither equal to the caller. Then a token transfer or a call with value. A spend so needs three of the five keys. init(address[]) takes five non-zero addresses once. activateSafeMode (any signer) sets a flag nothing clears. No ERC-1271, no delegate-call, no signer setter. The hash holds neither the wallet's address nor a nonce.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 or a second path: the only static call is to precompile 1; both spend functions run the checker; the other functions are views, init (closed) and activateSafeMode.
- Ruled out: Unused or unset: the clone is initialized, isSigner is true for the five addresses of its creation transaction 0xbcf0af3d3fddb20abdccc8acd644c2b2c681bc848067b954c256607fafcad12a, and it spent on 2026-10-31. The old card's five keys (0x7f6a0886…) are not signers here (isSigner false).
- Ruled out: The old card's 2-of-5: wrong. The sender must be a third signer, so three keys are needed.
- Ruled out: Retired: it holds 0 ETH, 0 USDT and 0.0001 TUSD, but its signers are plain keys that spent 19 days before the block and nothing closes it. The card says it is empty.
- Ruled out: Whose money, which operator: not shown; whose and project left empty. The 2026-10-31 payout went to 0xed9ab5bc05a0152b9dc2f7902e8369af7bc18771.
- Ruled out: Fifth signer 0x71c56394 (nonce 0): signed none of the five spends an explorer lists for this wallet (blocks 20,411,325 to 26,311,640); its signatures on other wallets were not looked for.
- Ruled out: The EIP-8151 notice (a signer that takes real code stops counting; signers cannot be replaced) is a separate root issue, not folded in.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
