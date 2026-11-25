---
id: contract-ed470553-owner-keys
format: 2
title: Multisig wallet clone trusts a fixed set of ECDSA signer keys
status: candidate
severity: MEDIUM
justification: Three forged signer keys move its funds; the signer set is fixed, so the fix is moving funds to a
  new wallet.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xed470553f61f23cd30ccf51ab066dc1598ed0c4f'
  code: bytecode
  code_url: https://etherscan.io/address/0xed470553f61f23cd30ccf51ab066dc1598ed0c4f#code
  proxy_of: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity: {}
impact: funds-loss
action: Move any funds to a wallet whose signers can change to post-quantum keys; this wallet's signer set cannot
  change.
evidence_level: bytecode
checks:
- id: recover
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 60018682858560405160008152602001604052604051610e519493929190611e83565b6020604051602081039080840390855afa15
  says: the signature helper STATICCALLs address 1, the ecrecover precompile, with all remaining gas
  for:
  - evidence-1
  - justification
  - what
- id: need2
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 7369676e6174757265206e6565642032
  says: the code carries the revert text 'signature need 2' of the two-signature check
  for:
  - evidence-1
  - justification
  - what
- id: distinct1
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 66697273745369676e65722073686f756c64206e6f7420626520657175616c20
  says: the code carries the revert texts 'firstSigner should not be equal to secondSigner / to msg.sender'
  for:
  - evidence-1
  - what
- id: distinct2
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 7365636f6e645369676e65722073686f756c64206e6f7420626520657175616c
  says: the code carries the revert text 'secondSigner should not be equal to msg.sender'
  for:
  - evidence-1
  - what
- id: send-nonsigner
  call: '0xed470553f61f23cd30ccf51ab066dc1598ed0c4f'
  data: '0xca34837b0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000002540be3ff00000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
  reverts_with: Non-signer in onlySigner method
  says: sendMultiSig refuses a caller that is not a signer
  for:
  - evidence-2
  - justification
  - what
- id: token-nonsigner
  call: '0xed470553f61f23cd30ccf51ab066dc1598ed0c4f'
  data: '0x7227699100000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000002540be3ff00000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
  reverts_with: Non-signer in onlySigner method
  says: sendMultiSigToken refuses a caller that is not a signer
  for:
  - evidence-2
  - what
- id: init-closed
  call: '0xed470553f61f23cd30ccf51ab066dc1598ed0c4f'
  data: '0xc6044c460000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001'
  reverts_with: Contract already initialized
  says: init(address[]), the only function that sets signers, refuses to run again
  for:
  - action
  - evidence-2
  - justification
  - what
- id: initialized
  call: '0xed470553f61f23cd30ccf51ab066dc1598ed0c4f'
  fn: initialized()(bool)
  args: []
  is: true
  says: the wallet has been set up
  for:
  - evidence-2
- id: safe-off
  call: '0xed470553f61f23cd30ccf51ab066dc1598ed0c4f'
  fn: safeMode()(bool)
  args: []
  is: false
  says: safe mode, which limits transfers to signer addresses, is off
  for:
  - what
- id: no-upgrade
  selector: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  fn: upgradeTo(address)
  absent: true
  says: the wallet code has no upgrade function
  for:
  - action
  - justification
  - what
- id: no-add
  selector: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  fn: addSigner(address)
  absent: true
  says: the wallet code has no addSigner function
  for:
  - action
  - what
- id: no-remove
  selector: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  fn: removeSigner(address)
  absent: true
  says: the wallet code has no removeSigner function
  for:
  - action
  - what
- id: no-1271
  selector: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the wallet code never asks a signer through ERC-1271
  for:
  - notes
- id: no-1271-legacy
  selector: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  fn: isValidSignature(bytes,bytes)
  absent: true
  says: nor through the legacy ERC-1271 selector
  for:
  - notes
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xed470553f61f23cd30ccf51ab066dc1598ed0c4f'
  is: 0
  says: the wallet holds no ETH
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
reviews:
- who: r-ed470553, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-12): Multisig wallet clone trusts a fixed set of ECDSA signer
    keys. Three forged signer keys move its funds; the signer set is fixed, so the fix is moving funds to a new
    wallet. Fix: Move any funds to a wallet whose signers can change to post-quantum keys; this wallet''s signer
    set cannot change. One refuter agrees on the current card with no objection (D-029: a second refuter only for
    removals); Claude read the card and the answer.'
related: []
---

## What happens

This multisig wallet sends ETH or tokens when one of its signers calls it with two other signers' ECDSA signatures. Whoever forges three signers' keys can move what it holds, and the signer set cannot be changed. It holds no ETH at the block.

## Evidence

- The wallet's [code](https://etherscan.io/address/0x0d424072d658e6abd92c36f8fc16fd6479ae15a0#code) recovers two signatures with the ecrecover precompile and rejects a repeated signer or the caller.
- This [wallet](https://etherscan.io/address/0xed470553f61f23cd30ccf51ab066dc1598ed0c4f) refuses transfers from a non-signer, and its one-time setup refuses to run again.

## Reviewer notes

### Mechanism

The address is a 45-byte EIP-1167 clone of 0x0d424072 (unverified, 7,934 bytes; read from my own disassembly, the heimdall output wrongly shows the send functions as plain reverts). Selectors resolve to init(address[]), sendMultiSig(address,uint256,bytes,uint256,bytes[2]), sendMultiSigToken(address,uint256,address,uint256,bytes[2]), activateSafeMode(), safeMode(), initialized(), signers(address), isSigner(address). Both send functions first require isSigner(msg.sender) (pc 0x5a3 / 0x286), then call the check at pc 0x817: the signature array must hold 2 entries; each 65-byte signature goes to the recover helper (pc 0xd49), which checks s and v and STATICCALLs address 1 with all remaining gas (pc 0xe62). Then: safe mode off or destination is a signer; block.timestamp < expireTime; both recovered addresses are signers; first != second; neither equals msg.sender. Then sendMultiSig CALLs to/value/data (pc 0x675) and sendMultiSigToken calls the token's transfer. The only SSTOREs (pc 0x570, 0x59e, 0x7a0) set the signer mapping and the initialized flag in init, and the safe-mode flag. init requires an uninitialized wallet, so the signer set is fixed after setup; no DELEGATECALL, no upgrade. There is no ERC-1271 or code-size branch: the only external calls are the send CALL, the token transfer and the precompile. Signers moving their own accounts to post-quantum keys does not help: the wallet never asks their accounts.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: unused implementation: this address is the clone itself, and initialized() is true at the block with safe mode off, so it is a set-up wallet, not bare implementation code.
- Ruled out: ERC-1271: neither isValidSignature(bytes32,bytes) nor isValidSignature(bytes,bytes) is in the code; the only calls are the transfer, the token transfer and the precompile.
- Ruled out: direct path without signatures: both transfer functions need two recovered signatures besides the calling signer; init is closed and activateSafeMode moves nothing.
- Ruled out: a fixed-gas recovery: the precompile call forwards all remaining gas (GAS right before STATICCALL), so the EIP-8151 price change does not break it by itself.
- Ruled out: separately, under EIP-8151 a signer whose account takes real code can no longer sign here, only call; that is a migration notice for the reviewer to weigh, not part of this card.

### Questions

- Who are the wallet's signers, and does any have real code at block 26,438,999? They are only in the setup call's input or the wallet's events, which I cannot read; the signers mapping cannot be listed.
- Is this wallet still in use (transactions in the 90 days to the block)? It holds 0 ETH and the dossier carries no activity figures.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
