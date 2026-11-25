---
id: contract-0edd5b0d-fixed-signer-keys
format: 2
title: A multisig wallet's five ECDSA signer keys cannot be replaced
status: candidate
severity: MEDIUM
justification: Three forged signer keys can take the funds; the fix is the signers moving them to a new wallet.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0edd5b0de0fe748be331186bf0aa878f47f601db'
  code: bytecode
  code_url: https://etherscan.io/address/0x0edd5b0de0fe748be331186bf0aa878f47f601db#code
  proxy_of: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 978
  basis: held
activity: {}
impact: funds-loss
action: Move the funds to a wallet whose signers can be post-quantum; this wallet's signer set cannot be changed.
evidence_level: bytecode
checks:
- id: clone
  bytecode: '0x0edd5b0de0fe748be331186bf0aa878f47f601db'
  has: 363d3d373d3d3d363d730d424072d658e6abd92c36f8fc16fd6479ae15a05af43d82803e903d91602b57fd5bf3
  says: the wallet's whole code is an EIP-1167 minimal proxy that delegates every call to 0x0d424072…15a0, an address
    fixed in the code
  for:
  - action
  - evidence-1
  - evidence-3
  - justification
  - what
- id: clone-size
  code: '0x0edd5b0de0fe748be331186bf0aa878f47f601db'
  is: contract
  bytes: 45
  says: the wallet's code is 45 bytes, the minimal proxy and nothing else
  for:
  - action
  - evidence-3
  - justification
  - what
- id: initialized
  call: '0x0edd5b0de0fe748be331186bf0aa878f47f601db'
  fn: initialized()(bool)
  is: true
  says: the wallet has been initialized, so its signers are set
  for:
  - evidence-3
  - what
- id: init-closed
  call: '0x0edd5b0de0fe748be331186bf0aa878f47f601db'
  fn: init(address[])
  args:
  - - '0x0000000000000000000000000000000000000001'
    - '0x0000000000000000000000000000000000000002'
    - '0x0000000000000000000000000000000000000003'
    - '0x0000000000000000000000000000000000000004'
    - '0x0000000000000000000000000000000000000005'
  reverts_with: Contract already initialized
  says: init, the one function that writes signers, refuses to run again on this wallet
  for:
  - action
  - evidence-2
  - justification
  - what
- id: safemode-off
  call: '0x0edd5b0de0fe748be331186bf0aa878f47f601db'
  fn: safeMode()(bool)
  is: false
  says: safe mode is off, so a send can go to any address
  for:
  - action
  - evidence-3
  - justification
  - what
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x0edd5b0de0fe748be331186bf0aa878f47f601db'
  is: 542000000000000000
  says: the wallet holds 0.542 ETH
  for:
  - evidence-3
  - what
- id: non-signer
  call: '0x0edd5b0de0fe748be331186bf0aa878f47f601db'
  data: '0xca34837b000000000000000000000000000000000000000000000000000000000000dead000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000174876e7ff00000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000411111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111100000000000000000000000000000000000000000000000000000000000000'
  from: '0x000000000000000000000000000000000000dead'
  reverts_with: Non-signer in onlySigner method
  says: the ETH send (selector 0xca34837b) refuses a caller that is not a signer
  for:
  - what
- id: dispatch
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 60003560e01c8063abe3219c1161004e578063abe3219c146101e1578063c6044c461461020c578063ca34837b14610235578063fc0f392d1461025e576100c9565b8063158ef93e14610113578063722769911461013e578063736c0d5b146101675780637df73e27146101a4576100c956
  says: 'the dispatcher knows eight selectors only: two sends, init, activateSafeMode and four reads; none replaces
    a signer'
  for:
  - action
  - evidence-2
  - justification
  - what
- id: five
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b6005828290501461044557
  says: init requires exactly five signers
  for:
  - what
- id: caller-eth
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b6105ac33610349565b6105eb
  says: the ETH send first looks the caller up in the signer mapping
  for:
  - justification
  - what
- id: caller-token
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b61028f33610349565b6102ce
  says: the token send first looks the caller up in the signer mapping
  for:
  - justification
  - what
- id: two-sigs
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b6000806002801461085d
  says: the signature check takes exactly two signatures
  for:
  - evidence-1
  - justification
  - what
- id: ecrecover
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b60018682858560405160008152602001604052604051610e519493929190611e83565b6020604051602081039080840390855afa
  says: each signature goes to the precompile at address 1 (ECDSA recovery) with all remaining gas
  for:
  - evidence-1
  - justification
  - what
- id: first-signer
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b6109f182610349565b610a30
  says: the first recovered address is looked up in the signer mapping
  for:
  - evidence-1
  - justification
  - what
- id: second-signer
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b610a3981610349565b610a78
  says: the second recovered address is looked up in the signer mapping
  for:
  - evidence-1
  - justification
  - what
- id: distinct
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b8073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff161415610a
  says: the two recovered addresses must differ
  for:
  - justification
  - what
- id: not-caller-1
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b3373ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffff
  says: the first recovered address must not be the caller
  for:
  - justification
  - what
- id: not-caller-2
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b3373ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffff
  says: the second recovered address must not be the caller
  for:
  - justification
  - what
- id: eth-call
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 5b60006040518083038185875af1
  says: after the check the ETH send calls the destination with the value and data
  for:
  - action
  - what
- id: token-transfer
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: a9059cbb
  says: after the check the token send calls transfer(address,uint256) on the token
  for:
  - action
  - what
- id: no-1271
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 1626ba7e
  says: the ERC-1271 selector isValidSignature(bytes32,bytes) is nowhere in the code
  absent: true
  for:
  - evidence-1
  - what
- id: no-legacy-1271
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 20c13b0b
  says: the legacy isValidSignature(bytes,bytes) selector is nowhere in the code
  absent: true
  for:
  - evidence-1
  - what
- id: no-upgrade
  selector: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  fn: upgradeTo(address)
  absent: true
  says: the code behind the wallet has no upgradeTo function
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-1
  call: '0x0edd5b0de0fe748be331186bf0aa878f47f601db'
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
  - notes
- id: signer-2
  call: '0x0edd5b0de0fe748be331186bf0aa878f47f601db'
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
  - notes
- id: signer-3
  call: '0x0edd5b0de0fe748be331186bf0aa878f47f601db'
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
  call: '0x0edd5b0de0fe748be331186bf0aa878f47f601db'
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
  call: '0x0edd5b0de0fe748be331186bf0aa878f47f601db'
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
reviews:
- who: r-0edd5b0d, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-12): A multisig wallet''s five ECDSA signer keys cannot be
    replaced. Three forged signer keys can take the funds; the fix is the signers moving them to a new wallet. Fix:
    Move the funds to a wallet whose signers can be post-quantum; this wallet''s signer set cannot be changed. One
    refuter agrees on the current card with no objection (D-029: a second refuter only for removals); Claude read
    the card and the answer.'
related: []
---

## What happens

This wallet sends ETH or tokens when one of its five signers calls it with ECDSA signatures of two other signers. A quantum attacker who recovers three signer keys can take what it holds. No function replaces a signer, and the code cannot be upgraded.

## Evidence

- The [code this wallet runs](https://etherscan.io/address/0x0d424072d658e6abd92c36f8fc16fd6479ae15a0#code) recovers two signatures with ECDSA and looks each address up among its signers; it never asks a signer contract.
- That [code](https://etherscan.io/address/0x0d424072d658e6abd92c36f8fc16fd6479ae15a0#code) has eight functions: two sends, init, safe mode, four reads. None replaces a signer; init refuses to run again.
- The [wallet](https://etherscan.io/address/0x0edd5b0de0fe748be331186bf0aa878f47f601db) is a fixed minimal proxy; it is initialized, its safe mode is off, and it holds 0.542 ETH.

## Reviewer notes

### Mechanism

The address is an EIP-1167 clone of 0x0d424072 (unverified, solc 0.8.10; judged from a disassembly, the decompiler shows only part). Eight selectors. init(address[]) runs once, needs exactly 5 non-zero addresses, sets signers[a] (slot 0 mapping) and the initialized flag (slot 1, byte 1). ETH send 0xca34837b(to, value, data, expireTime, bytes[2] sigs) and token send 0x72276991(to, value, token, expireTime, bytes[2] sigs): caller must be a signer; hash = keccak(packed 'ETHER' or 'ERC20', to, value, data or token, expireTime); each 65-byte signature goes to ecrecover (low-s enforced, all gas); both recovered addresses must be signers, differ from each other and from the caller; expireTime >= now; in safe mode `to` must be a signer. Then to.call{value}(data) or token.transfer(to, value). activateSafeMode (any signer) sets slot 1 byte 0; nothing clears it. Any other calldata falls to a fallback that logs a deposit and stops.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: erc1271: neither isValidSignature selector is in the code; a signer contract can only be the caller, the two other approvals are always ECDSA.
- Ruled out: unused-implementation: this row is the clone; initialized() is true here and it holds 0.542 ETH.
- Ruled out: key-state: init requires five non-zero signers and initialized() is true; which addresses they are is in the init calldata only (see Questions).
- Ruled out: setter and direct-path: none of the eight selectors changes a signer or sends without two signatures; init reverts with 'Contract already initialized'.
- Ruled out: path-closed: safeMode() is false; in safe mode sends still go to signer addresses, which a forger of signer keys controls.
- Ruled out: wrong-code and children: the 45 bytes are the minimal proxy to 0x0d424072; that code has no DELEGATECALL opcode, and its only CREATE byte is in the metadata tail.
- Ruled out: The dossier lists no replay or trace for this address, so nothing executed is cited.
- Ruled out: Signers: the five addresses of setup transaction 0x3aa889c968… (block 19,146,318), found by Claude in that block and each confirmed by isSigner at the block; all distinct, none has code.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
