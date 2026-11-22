---
id: megashapeshifterz-d6d80461-rotate-signer-before-migrating
format: 2
title: 'MegaShapeShifterz: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd6d80461b1875a8679fe789db689156f42b7f86b'
  name: MegaShapeShifterz
  code: verified
  code_url: https://etherscan.io/address/0xd6d80461b1875a8679fe789db689156f42b7f86b#code
  copies: 1
  upgradeable: 'no'
  admin: '0x6fbdda1f644a2031fdd59475f3a7c3a5d3346301'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 118
impact: liveness
action: Replace the signer with unpdateSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xd6d80461b1875a8679fe789db689156f42b7f86b'
  file: contracts/NFTs/MegaShapeshifters.sol
  line: 187
  has: address receivedAddress = ECDSA.recover(message, signature);
  says: _validateMutateSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd6d80461b1875a8679fe789db689156f42b7f86b'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd6d80461b1875a8679fe789db689156f42b7f86b'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xd6d80461b1875a8679fe789db689156f42b7f86b'
  file: contracts/NFTs/MegaShapeshifters.sol
  line: 188
  has: return (receivedAddress != address(0) && receivedAddress == signer);
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xd6d80461b1875a8679fe789db689156f42b7f86b'
  file: contracts/NFTs/MegaShapeshifters.sol
  line: 261
  has: function unpdateSigner
  says: unpdateSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xd6d80461b1875a8679fe789db689156f42b7f86b'
  fn: signer()(address)
  is: '0x7744b770891cafe6d1d5fdb797fc0a4fd49cf366'
  says: The signer it keeps in storage is 0x7744b770891cafe6d1d5fdb797fc0a4fd49cf366 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x7744b770891cafe6d1d5fdb797fc0a4fd49cf366'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

MegaShapeShifterz checks an ECDSA signature in _validateMutateSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. unpdateSigner changes the signer.

## Evidence

- [_validateMutateSignature](https://etherscan.io/address/0xd6d80461b1875a8679fe789db689156f42b7f86b#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [unpdateSigner](https://etherscan.io/address/0xd6d80461b1875a8679fe789db689156f42b7f86b#code) changes the signer; only the owner can call it.
- The signer at the block is [0x7744…f366](https://etherscan.io/address/0x7744b770891cafe6d1d5fdb797fc0a4fd49cf366), an account without code.

## Reviewer notes

### Mechanism

_validateMutateSignature (contracts/NFTs/MegaShapeshifters.sol, line 179) recovers a signer on line 187 and tests it on line 188 against the signer it keeps in storage (signer() returns 0x7744b770891cafe6d1d5fdb797fc0a4fd49cf366). Neither isValidSignature selector is in the code, so that account is never asked. unpdateSigner (contracts/NFTs/MegaShapeshifters.sol, line 261) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-06-09, recovering 0x7744…f366; 118 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
