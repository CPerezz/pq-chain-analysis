---
id: contract-13b64d98-fixed-ecdsa-signers
format: 2
title: Multisig wallet with five fixed ECDSA signers that can never be replaced
status: candidate
severity: MEDIUM
justification: Signers are set once and the code cannot change, so the only fix is the signers moving the funds
  to a new wallet.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x13b64d98eeded1fd336a5ef33b0398a847d26f93'
  code: bytecode
  code_url: https://etherscan.io/address/0x13b64d98eeded1fd336a5ef33b0398a847d26f93#code
  proxy_of: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity: {}
impact: funds-loss
action: Move any funds to a wallet with post-quantum signers and stop using this one; its five signers cannot be
  replaced.
evidence_level: bytecode
checks:
- id: clone
  code: '0x13b64d98eeded1fd336a5ef33b0398a847d26f93'
  is: contract
  bytes: 45
  says: the address is a 45-byte EIP-1167 clone whose target, 0x0d424072, is fixed in its code
  for:
  - evidence-2
  - justification
- id: initialized
  call: '0x13b64d98eeded1fd336a5ef33b0398a847d26f93'
  fn: initialized()(bool)
  is: true
  says: this clone has been set up with its own signers
  for:
  - evidence-2
- id: init-once
  call: '0x13b64d98eeded1fd336a5ef33b0398a847d26f93'
  data: '0xc6044c460000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000005'
  reverts_with: Contract already initialized
  says: 'calling init again with five new signers reverts: the signer set cannot be set a second time'
  for:
  - action
  - evidence-2
  - justification
  - what
- id: init-five
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b6005828290501461044557
  says: init requires the signer list to have exactly five entries
  for:
  - evidence-2
  - justification
  - what
- id: dispatcher
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 60003560e01c8063abe3219c1161004e578063abe3219c146101e1578063c6044c461461020c578063ca34837b14610235578063fc0f392d1461025e576100c9565b8063158ef93e14610113578063722769911461013e578063736c0d5b146101675780637df73e27146101a4576100c956
  says: 'the dispatcher routes eight selectors only: init, the two sends, activateSafeMode and four getters; none
    adds, removes or replaces a signer'
  for:
  - action
  - evidence-2
  - justification
  - what
- id: only-signer
  call: '0x13b64d98eeded1fd336a5ef33b0398a847d26f93'
  from: '0x000000000000000000000000000000000000dEaD'
  data: '0xca34837b000000000000000000000000000000000000000000000000000000000000dead000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000002540be3ff00000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000411111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222200000000000000000000000000000000000000000000000000000000000000'
  reverts_with: Non-signer in onlySigner method
  says: 'a send from an address that is not a signer reverts: the sender must be a signer'
  for:
  - what
- id: ecrecover
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 60018682858560405160008152602001604052604051610e519493929190611e83565b6020604051602081039080840390855afa
  says: signatures are recovered by a STATICCALL to the ecrecover precompile (address 1) with all remaining gas
  for:
  - evidence-1
  - what
- id: send-verify
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b6105ac33610349565b6105eb57
  says: the ETH send first checks that msg.sender is in the signer map
  for:
  - what
- id: token-verify
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b61028f33610349565b6102ce57
  says: the token send first checks that msg.sender is in the signer map
  for:
  - what
- id: recovered-is-signer
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b6109f182610349565b610a30576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610a279061162c565b60405180910390fd5b610a3981610349565b610a78
  says: both recovered addresses are looked up in the signer map and the call reverts if either is not a signer
  for:
  - evidence-1
  - what
- id: distinct-1
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 66697273745369676e65722073686f756c64206e6f7420626520657175616c20
  says: the code carries the revert text 'firstSigner should not be equal' (to secondSigner, to msg.sender)
  for:
  - what
- id: distinct-2
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 7365636f6e645369676e65722073686f756c64206e6f7420626520657175616c
  says: the code carries the revert text 'secondSigner should not be equal' (to msg.sender)
  for:
  - what
- id: no-1271
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 1626ba7e
  absent: true
  says: the code never asks a signer through ERC-1271 isValidSignature(bytes32,bytes)
  for:
  - evidence-1
- id: no-1271-legacy
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 20c13b0b
  absent: true
  says: the code never asks a signer through the legacy isValidSignature(bytes,bytes)
  for:
  - evidence-1
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x13b64d98eeded1fd336a5ef33b0398a847d26f93'
  is: 98880000000000
  says: the wallet holds 0.00009888 ETH
  for:
  - what
- id: signer-1
  call: '0x13b64d98eeded1fd336a5ef33b0398a847d26f93'
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
  - what
- id: signer-2
  call: '0x13b64d98eeded1fd336a5ef33b0398a847d26f93'
  fn: isSigner(address)(bool)
  args:
  - '0x17a012e287ce4dc193500b9fb59610f5d7e9f1b9'
  is: true
  says: 0x17a012e2… is one of this wallet's five signers
  for:
  - what
- id: signer-2-key
  code: '0x17a012e287ce4dc193500b9fb59610f5d7e9f1b9'
  is: empty
  says: 'signer 0x17a012e2… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-2-nonce
  nonce: '0x17a012e287ce4dc193500b9fb59610f5d7e9f1b9'
  is: 0
  says: signer 0x17a012e2… has never sent a transaction
  for:
  - what
- id: signer-3
  call: '0x13b64d98eeded1fd336a5ef33b0398a847d26f93'
  fn: isSigner(address)(bool)
  args:
  - '0x6f068f7bb8fb73a5224a2ee5be7aba059b0a4be8'
  is: true
  says: 0x6f068f7b… is one of this wallet's five signers
  for:
  - what
- id: signer-3-key
  code: '0x6f068f7bb8fb73a5224a2ee5be7aba059b0a4be8'
  is: empty
  says: 'signer 0x6f068f7b… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-3-nonce
  nonce: '0x6f068f7bb8fb73a5224a2ee5be7aba059b0a4be8'
  is: 0
  says: signer 0x6f068f7b… has never sent a transaction
  for:
  - what
- id: signer-4
  call: '0x13b64d98eeded1fd336a5ef33b0398a847d26f93'
  fn: isSigner(address)(bool)
  args:
  - '0xa8b77d1646d62de0e842a1906f23f60f4dd494e0'
  is: true
  says: 0xa8b77d16… is one of this wallet's five signers
  for:
  - what
- id: signer-4-key
  code: '0xa8b77d1646d62de0e842a1906f23f60f4dd494e0'
  is: empty
  says: 'signer 0xa8b77d16… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-4-nonce
  nonce: '0xa8b77d1646d62de0e842a1906f23f60f4dd494e0'
  is: 0
  says: signer 0xa8b77d16… has never sent a transaction
  for:
  - what
- id: signer-5
  call: '0x13b64d98eeded1fd336a5ef33b0398a847d26f93'
  fn: isSigner(address)(bool)
  args:
  - '0xfb1072a8989a8f57db8e718a4ac84221be7898ff'
  is: true
  says: 0xfb1072a8… is one of this wallet's five signers
  for:
  - what
- id: signer-5-key
  code: '0xfb1072a8989a8f57db8e718a4ac84221be7898ff'
  is: empty
  says: 'signer 0xfb1072a8… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-5-nonce
  nonce: '0xfb1072a8989a8f57db8e718a4ac84221be7898ff'
  is: 0
  says: signer 0xfb1072a8… has never sent a transaction
  for:
  - what
- id: sender-nonce-apr25
  nonce: '0x905a5ea20c841be32b2ba7d648b325ade5f655bb'
  at: 22317435
  is: 30
  says: right after this wallet's last known send (block 22,317,412, 2025-04-21) that signer had sent 30
  for:
  - what
- id: tx31-elsewhere
  tx: '0x61b42afd0919e706e0298620f24998f4f8b5074ffb63313e20ddc39682c86963'
  to: '0x688168e7585436bf03a9cb77f378484cb7eb5267'
  ok: true
  says: that signer's 31st transaction went to another wallet, not this one
  for:
  - what
- id: tx32-elsewhere
  tx: '0xe7d0c232522fb75f24dcab140986489ddee153da376c163f16f633d7a7eea4cc'
  to: '0x688168e7585436bf03a9cb77f378484cb7eb5267'
  ok: true
  says: its 32nd and last transaction also went to the other wallet
  for:
  - what
- id: last-send
  tx: '0x4fb318004832ebea18a298fbd24b22c48686e5aa2b13a97ca8f441adefc2def7'
  to: '0x13b64d98eeded1fd336a5ef33b0398a847d26f93'
  ok: true
  says: 'a send by this wallet on 2025-04-21: signer 0x905a5ea2 sent it, co-signed by 0xfb1072a8 and 0xa8b77d16'
  for:
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
reviews: []
related: []
---

## What happens

This wallet sends ETH or tokens when one signer sends the transaction and two others sign it with ECDSA. Its five signers are fixed at setup. A quantum attacker with three signer keys can send out all it holds, under 0.0001 ETH. It has sent nothing since April 2025; a signer could still use it.

## Evidence

- The [wallet code](https://etherscan.io/address/0x0d424072d658e6abd92c36f8fc16fd6479ae15a0#code) recovers two ECDSA signatures, rejects any not from a signer and never asks a signer's account.
- [This wallet](https://etherscan.io/address/0x13b64d98eeded1fd336a5ef33b0398a847d26f93) was set up once with five signers; setting it up again reverts, and no function changes a signer.

## Reviewer notes

### Mechanism

The address is a 45-byte EIP-1167 clone of unverified 0x0d424072 (no DELEGATECALL, no upgrade selector). The dispatcher routes eight selectors only: c6044c46 init(address[]), ca34837b (ETH/call send: to, value, data, expireTime, bytes[] signatures), 72276991 (token send), fc0f392d activateSafeMode, plus initialized, safeMode, signers(address), isSigner(address). Both sends start with onlySigner (CALLER in the signer map at slot 0, revert 'Non-signer in onlySigner method'), hash their arguments with an 'ETHER' or 'ERC20' prefix, and call the routine at 0x817. It takes signatures[0] and signatures[1], recovers each through STATICCALL to precompile 0x01 with all remaining gas (low-s enforced), checks the expiry, requires each recovered address to be in the signer map (revert 'Invalid signer'), and requires the two to differ from each other and from msg.sender. The ETH path CALLs the target with all gas; the token path does a safeTransfer. Safe mode (any signer can switch it on) only limits recipients to signers. init requires exactly five non-zero signers and sets initialized; it reverts once initialized. The runtime has three SSTOREs only: the signer map, the initialized flag, and the safe-mode flag. Nothing adds, removes or replaces a signer after setup, and nothing asks a signer contract through ERC-1271. Spending needs three distinct signers: the sender plus two ECDSA signatures.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path: neither selector 0x1626ba7e nor 0x20c13b0b appears; recovered addresses go straight to the signer map.
- Ruled out: implementation-only: this clone was initialized itself (initialized() is true; init reverts 'Contract already initialized').
- Ruled out: an upgrade or signer setter: the clone's target is fixed in its 45 bytes; the implementation has no DELEGATECALL and only three SSTOREs.
- Ruled out: the old card's five signers (0x7f6a0886, 0x6761ee52, 0x1458e52d, 0xd59a643b, 0xe4af0df0): isSigner is false for all five here.
- Ruled out: a direct path without signatures: both sends need the sender plus two more signer signatures; activateSafeMode only restricts recipients.
- Ruled out: EIP-8151 effect (a separate notice, not this rating): a signer with real code stops counting as a signature signer but can still be the sender.
- Ruled out: Signers: the five addresses of setup transaction 0x24b4ab429c… (block 21,136,136), found by Claude in that block and each confirmed by isSigner at the block; all distinct, none has code.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
