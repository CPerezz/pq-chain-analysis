---
id: attribute-88109eed-rotate-signer-before-migrating
format: 2
title: 'Attribute: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x88109eed892a6fa8270b1c6d77604b2bdf53e541'
  name: Attribute
  code: verified
  code_url: https://etherscan.io/address/0x239054f7efce1e29e0cac3ab1609f0c8e71f368c#code
  proxy_of: '0x239054f7efce1e29e0cac3ab1609f0c8e71f368c'
  copies: 1
  upgradeable: 'yes'
  admin: '0xfe93d561a66c7f71862219bbd640bddb9f7eb1be'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1263
impact: liveness
action: Replace the signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x239054f7efce1e29e0cac3ab1609f0c8e71f368c'
  file: src/lib/AttributeFixedSaleLib.sol
  line: 355
  has: if (_recoverSigner(ethSignedMessageHash, signature) != signerAddress) revert InvalidFixedSaleSignature();
  says: _verifyFixedSaleSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x239054f7efce1e29e0cac3ab1609f0c8e71f368c'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x239054f7efce1e29e0cac3ab1609f0c8e71f368c'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x239054f7efce1e29e0cac3ab1609f0c8e71f368c'
  file: src/Attribute.sol
  line: 671
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x88109eed892a6fa8270b1c6d77604b2bdf53e541'
  fn: signerAddress()(address)
  is: '0x1d19b2f358cf27eb0b7adb9d924db47addfd7197'
  says: The signer it keeps in storage is 0x1d19b2f358cf27eb0b7adb9d924db47addfd7197 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x1d19b2f358cf27eb0b7adb9d924db47addfd7197'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

Attribute checks an ECDSA signature in _verifyFixedSaleSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddress changes the signer.

## Evidence

- [_verifyFixedSaleSignature](https://etherscan.io/address/0x239054f7efce1e29e0cac3ab1609f0c8e71f368c#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0x239054f7efce1e29e0cac3ab1609f0c8e71f368c#code) changes the signer; only the owner can call it.
- The signer at the block is [0x1d19…7197](https://etherscan.io/address/0x1d19b2f358cf27eb0b7adb9d924db47addfd7197), an account without code.

## Reviewer notes

### Mechanism

_verifyFixedSaleSignature (src/lib/AttributeFixedSaleLib.sol, line 331) recovers a signer on line 355 and tests it on line 355 against the signer it keeps in storage (signerAddress() returns 0x1d19b2f358cf27eb0b7adb9d924db47addfd7197). Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (src/Attribute.sol, line 671) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-03-18, recovering 0x1d19…7197; 1,263 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
