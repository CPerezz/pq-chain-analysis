---
id: redpacket-00000089-rotate-signer-before-migrating
format: 2
title: 'RedPacket: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x00000089f4f34e66c7e6bd8da93976d1b5dccd8a'
  name: RedPacket
  code: verified
  code_url: https://etherscan.io/address/0x00000089f4f34e66c7e6bd8da93976d1b5dccd8a#code
  copies: 1
  upgradeable: 'no'
  admin: '0x780d5819fe00baa1f2fa4ac47e2dcee67c42e184'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x00000089f4f34e66c7e6bd8da93976d1b5dccd8a'
  file: src/RedPacket.sol
  line: 256
  has: address recovered = ECDSA.recover(digest, signature);
  says: _verifyClaimSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x00000089f4f34e66c7e6bd8da93976d1b5dccd8a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x00000089f4f34e66c7e6bd8da93976d1b5dccd8a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x00000089f4f34e66c7e6bd8da93976d1b5dccd8a'
  file: src/RedPacket.sol
  line: 257
  has: if (recovered != signer) revert InvalidSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x00000089f4f34e66c7e6bd8da93976d1b5dccd8a'
  file: src/RedPacket.sol
  line: 95
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x00000089f4f34e66c7e6bd8da93976d1b5dccd8a'
  fn: signer()(address)
  is: '0xc1bf2f1c02d38bda1781851bcc2ebd73f58fbbef'
  says: The signer it keeps in storage is 0xc1bf2f1c02d38bda1781851bcc2ebd73f58fbbef at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xc1bf2f1c02d38bda1781851bcc2ebd73f58fbbef'
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

RedPacket checks an ECDSA signature in _verifyClaimSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [_verifyClaimSignature](https://etherscan.io/address/0x00000089f4f34e66c7e6bd8da93976d1b5dccd8a#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x00000089f4f34e66c7e6bd8da93976d1b5dccd8a#code) changes the signer; only the owner can call it.
- The signer at the block is [0xc1bf…bbef](https://etherscan.io/address/0xc1bf2f1c02d38bda1781851bcc2ebd73f58fbbef), an account without code.

## Reviewer notes

### Mechanism

_verifyClaimSignature (src/RedPacket.sol, line 245) recovers a signer on line 256 and tests it on line 257 against the signer it keeps in storage (signer() returns 0xc1bf2f1c02d38bda1781851bcc2ebd73f58fbbef). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (src/RedPacket.sol, line 95) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
