---
id: contract-f207b2f9-fixed-owner-keys
format: 2
title: Multisig wallet with fixed ECDSA signers that a quantum computer can forge
status: candidate
severity: MEDIUM
justification: The signers cannot be replaced and the code cannot change; the fix is the signers moving the funds
  to a new wallet.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf207b2f9f9417fc73cad069f7aa5ae1c6a5b428d'
  code: bytecode
  code_url: https://etherscan.io/address/0xf207b2f9f9417fc73cad069f7aa5ae1c6a5b428d#code
  proxy_of: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 144
  basis: held
activity: {}
impact: funds-loss
action: Move the funds to a wallet whose signers can be replaced with post-quantum keys.
evidence_level: bytecode
checks:
- id: clone
  code: '0xf207b2f9f9417fc73cad069f7aa5ae1c6a5b428d'
  is: contract
  bytes: 45
  says: the address is 45 bytes of code
  for:
  - action
  - evidence-2
  - justification
  - what
- id: clone-target
  bytecode: '0xf207b2f9f9417fc73cad069f7aa5ae1c6a5b428d'
  has: 730d424072d658e6abd92c36f8fc16fd6479ae15a05af4
  says: the clone delegates every call to the fixed address 0x0d424072
  for:
  - evidence-2
  - what
- id: init-done
  call: '0xf207b2f9f9417fc73cad069f7aa5ae1c6a5b428d'
  fn: initialized()(bool)
  is: true
  says: the wallet is initialized
  for:
  - evidence-2
  - justification
  - what
- id: init-locked
  call: '0xf207b2f9f9417fc73cad069f7aa5ae1c6a5b428d'
  data: '0xc6044c4600000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000005000000000000000000000000000000000000000000000000000000000000dead000000000000000000000000000000000000000000000000000000000000dea1000000000000000000000000000000000000000000000000000000000000dea2000000000000000000000000000000000000000000000000000000000000dea3000000000000000000000000000000000000000000000000000000000000dea4'
  reverts_with: Contract already initialized
  says: init refuses to set a new signer set
  for:
  - action
  - evidence-2
  - justification
  - what
- id: onlysigner
  call: '0xf207b2f9f9417fc73cad069f7aa5ae1c6a5b428d'
  data: '0xca34837b000000000000000000000000000000000000000000000000000000000000dead00000000000000000000000000000000000000000000000000000000000003e800000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000174876e7ff00000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000416a93861c652c0e3b78fda4e2b691274e873c6b87d028d8b71b20a3ab18274f0924f94bfa31f70a4bec0b7212d02aff17c3212303921d82a9e4a9ebd6db6733171b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000413e7848e4354902a57ea51ebdc58cbff57cb71e71f7ae530013552b543b8eab6c53425f52e6897953984584d4f7aed28df7f7359f57abe0121463d99df4fdd53b1c00000000000000000000000000000000000000000000000000000000000000'
  from: '0x000000000000000000000000000000000000dEaD'
  reverts_with: Non-signer in onlySigner method
  says: the send function refuses a caller that is not a signer
  for:
  - evidence-1
  - what
- id: ecrecover
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b60018682858560405160008152602001604052604051610e519493929190611e83565b6020604051602081039080840390855afa15
  says: the code calls precompile 0x01 (ecrecover) with STATICCALL forwarding all gas
  for:
  - evidence-1
  - what
- id: need2
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 7369676e6174757265206e6565642032
  says: the code carries the revert text 'signature need 2'
  for:
  - evidence-1
  - what
- id: distinct
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 7365636f6e645369676e65722073686f756c64206e6f7420626520657175616c
  says: the code requires the second signer to differ (from the caller)
  for:
  - what
- id: five
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 496e76616c6964206e756d626572206f66207369676e657273
  says: init carries the revert text 'Invalid number of signers' (it requires exactly five)
  for:
  - what
- id: signer-1
  call: '0xf207b2f9f9417fc73cad069f7aa5ae1c6a5b428d'
  fn: isSigner(address)(bool)
  args:
  - '0xda224f2ebc40c96340b26d0368844e8921d62c94'
  is: true
  says: 0xda224f2e… is one of this wallet's five signers
  for:
  - what
- id: signer-1-key
  code: '0xda224f2ebc40c96340b26d0368844e8921d62c94'
  is: empty
  says: 'signer 0xda224f2e… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-1-nonce
  nonce: '0xda224f2ebc40c96340b26d0368844e8921d62c94'
  is: 32
  says: signer 0xda224f2e… has sent 32 transactions, so its public key is on-chain
  for:
  - what
- id: signer-2
  call: '0xf207b2f9f9417fc73cad069f7aa5ae1c6a5b428d'
  fn: isSigner(address)(bool)
  args:
  - '0x520ba4843d56fa5b6692bcf44f3db50c319e0643'
  is: true
  says: 0x520ba484… is one of this wallet's five signers
  for:
  - what
- id: signer-2-key
  code: '0x520ba4843d56fa5b6692bcf44f3db50c319e0643'
  is: empty
  says: 'signer 0x520ba484… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-2-nonce
  nonce: '0x520ba4843d56fa5b6692bcf44f3db50c319e0643'
  is: 5
  says: signer 0x520ba484… has sent 5 transactions, so its public key is on-chain
  for:
  - what
- id: signer-3
  call: '0xf207b2f9f9417fc73cad069f7aa5ae1c6a5b428d'
  fn: isSigner(address)(bool)
  args:
  - '0x3b85353aed81135474ae3d280fa8dddfa5d0069f'
  is: true
  says: 0x3b85353a… is one of this wallet's five signers
  for:
  - what
- id: signer-3-key
  code: '0x3b85353aed81135474ae3d280fa8dddfa5d0069f'
  is: empty
  says: 'signer 0x3b85353a… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-3-nonce
  nonce: '0x3b85353aed81135474ae3d280fa8dddfa5d0069f'
  is: 0
  says: signer 0x3b85353a… has never sent a transaction
  for:
  - notes
- id: signer-4
  call: '0xf207b2f9f9417fc73cad069f7aa5ae1c6a5b428d'
  fn: isSigner(address)(bool)
  args:
  - '0xad032fc20b9aa93ba92d2513197a7014cc9a118e'
  is: true
  says: 0xad032fc2… is one of this wallet's five signers
  for:
  - what
- id: signer-4-key
  code: '0xad032fc20b9aa93ba92d2513197a7014cc9a118e'
  is: empty
  says: 'signer 0xad032fc2… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-4-nonce
  nonce: '0xad032fc20b9aa93ba92d2513197a7014cc9a118e'
  is: 0
  says: signer 0xad032fc2… has never sent a transaction
  for:
  - notes
- id: signer-5
  call: '0xf207b2f9f9417fc73cad069f7aa5ae1c6a5b428d'
  fn: isSigner(address)(bool)
  args:
  - '0xecec161d6794312cc39ddac8fbdb9610a043b6e6'
  is: true
  says: 0xecec161d… is one of this wallet's five signers
  for:
  - what
- id: signer-5-key
  code: '0xecec161d6794312cc39ddac8fbdb9610a043b6e6'
  is: empty
  says: 'signer 0xecec161d… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-5-nonce
  nonce: '0xecec161d6794312cc39ddac8fbdb9610a043b6e6'
  is: 0
  says: signer 0xecec161d… has never sent a transaction
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

This multisig wallet sends its ETH when one of its five signers calls it with ECDSA signatures from two other signers. Its five signers are set once and cannot be set again, and its code cannot be upgraded. Whoever forges three signer keys can take its funds; at least two signers' keys are on-chain.

## Evidence

- [The wallet code](https://etherscan.io/address/0x0d424072d658e6abd92c36f8fc16fd6479ae15a0#code) refuses callers that are not signers and recovers two further signatures with ECDSA.
- [This wallet](https://etherscan.io/address/0xf207b2f9f9417fc73cad069f7aa5ae1c6a5b428d#code) is a fixed clone of that code; it is already initialized and refuses a new set of signers.

## Reviewer notes

### Mechanism

The address is a 45-byte EIP-1167 clone of 0x0d424072 (unverified, 7,934 bytes, no DELEGATECALL, no upgrade path). Function 0xca34837b(address to,uint256 value,bytes data,uint256 expireTime,bytes[2] signatures) requires msg.sender to be in the signers map ('Non-signer in onlySigner method'), checks expiry, builds a hash, recovers both signatures with STATICCALL to precompile 0x01 forwarding all gas, requires each recovered address to be a signer ('Invalid signer'), distinct from each other and from msg.sender, then CALLs `to` with the value. 0x72276991 is the token variant (ERC20 transfer selector a9059cbb). The runtime has exactly three SSTOREs: two in init(address[]) (0xc6044c46: signers map entries, then the initialized flag; it requires exactly 5 non-zero signers and reverts once initialized) and one in activateSafeMode (0xfc0f392d), which only sets the safe-mode flag. So the signer set is fixed after init. I ran the code locally (anvil, setCode of this clone and of 0x0d424072, init with five test keys): a signer plus two co-signers' signatures over the recovered hash sent 1000 wei; a non-signer co-signature reverted 'Invalid signer'; a co-signature by the caller reverted 'secondSigner should not be equal to msg.sender'.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for signers with code: the only STATICCALL in the code is the one to precompile 0x01, and there is no EXTCODESIZE opcode.
- Ruled out: a way to replace signers: only init writes the signers map, and init reverts on this wallet ('Contract already initialized'); activateSafeMode writes only the safe-mode flag.
- Ruled out: unused implementation: this address is the clone itself, initialized, holding 0.08 ETH at the block, safe mode off; the implementation 0x0d424072 is a different address.
- Ruled out: a fixed gas amount for the recovery: the STATICCALL forwards GAS, so no EIP-8151 gas issue here.
- Ruled out: EIP-8151 side note: a signer whose account takes real code would no longer count as a co-signer, and with a fixed set the wallet could fall below three usable signers; that is a separate migration notice, not folded in here.
- Ruled out: the old card counted 21 clones of this code together; this card describes this address only.
- Ruled out: Signers: the five addresses of setup transaction 0x0442e0089d… (block 19,146,305), found by Claude in that block and each confirmed by isSigner at the block; all distinct, none has code.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
