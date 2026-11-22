---
id: metaleons-bf9aeedf-rotate-signer-before-migrating
format: 2
title: 'MetaLeons: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbf9aeedf8fb9e1eeec6f38f240d70ddaa12e0221'
  name: MetaLeons
  code: verified
  code_url: https://etherscan.io/address/0xbf9aeedf8fb9e1eeec6f38f240d70ddaa12e0221#code
  copies: 2
  family: 26f8c2fa12358bdb3edca2140d191953
  upgradeable: 'no'
  admin: '0x055a94245653115c3dbca435f8ca95dc8dce347c'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSignatureWallet before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xbf9aeedf8fb9e1eeec6f38f240d70ddaa12e0221'
  file: contracts/Metaleon.sol
  line: 343
  has: require(_verifySignature(_signature, 0) == signatureWallet, "Not whitelisted");
  says: presaleMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xbf9aeedf8fb9e1eeec6f38f240d70ddaa12e0221'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xbf9aeedf8fb9e1eeec6f38f240d70ddaa12e0221'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xbf9aeedf8fb9e1eeec6f38f240d70ddaa12e0221'
  file: contracts/Metaleon.sol
  line: 214
  has: function setSignatureWallet
  says: setSignatureWallet changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xbf9aeedf8fb9e1eeec6f38f240d70ddaa12e0221'
  fn: signatureWallet()(address)
  is: '0xcb83a0e4635f4483f2eea00345496e11f633c0b1'
  says: The signer it keeps in storage is 0xcb83a0e4635f4483f2eea00345496e11f633c0b1 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xcb83a0e4635f4483f2eea00345496e11f633c0b1'
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

MetaLeons accepts a call to presaleMint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignatureWallet changes the signer.

## Evidence

- [presaleMint](https://etherscan.io/address/0xbf9aeedf8fb9e1eeec6f38f240d70ddaa12e0221#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignatureWallet](https://etherscan.io/address/0xbf9aeedf8fb9e1eeec6f38f240d70ddaa12e0221#code) changes the signer; only the owner can call it.
- The signer at the block is [0xcb83…c0b1](https://etherscan.io/address/0xcb83a0e4635f4483f2eea00345496e11f633c0b1), an account without code.

## Reviewer notes

### Mechanism

presaleMint (contracts/Metaleon.sol, line 336) recovers a signer on line 343 and tests it on line 343 against the signer it keeps in storage (signatureWallet() returns 0xcb83a0e4635f4483f2eea00345496e11f633c0b1). Neither isValidSignature selector is in the code, so that account is never asked. setSignatureWallet (contracts/Metaleon.sol, line 214) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
