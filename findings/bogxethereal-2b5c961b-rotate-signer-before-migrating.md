---
id: bogxethereal-2b5c961b-rotate-signer-before-migrating
format: 2
title: 'BogxEthereal: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2b5c961bc0cd1945d4e173c1a6df38b9c1702b5d'
  name: BogxEthereal
  code: verified
  code_url: https://etherscan.io/address/0xfb45fcaf4f8a22019a43a6e1417e2c947aadca69#code
  proxy_of: '0xfb45fcaf4f8a22019a43a6e1417e2c947aadca69'
  copies: 2
  family: 556acd3c7f9b64762978995940ed061d
  upgradeable: 'yes'
  admin: '0x1ad707f6618b1b9445aa9b86bb72191cb0f17066'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: Replace the signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xfb45fcaf4f8a22019a43a6e1417e2c947aadca69'
  file: contracts/BogxEthereal.sol
  line: 181
  has: return ECDSAUpgradeable.recover(ethSignedMessageHash, signature) == signerAddress;
  says: checkSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xfb45fcaf4f8a22019a43a6e1417e2c947aadca69'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xfb45fcaf4f8a22019a43a6e1417e2c947aadca69'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xfb45fcaf4f8a22019a43a6e1417e2c947aadca69'
  file: contracts/BogxEthereal.sol
  line: 113
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x2b5c961bc0cd1945d4e173c1a6df38b9c1702b5d'
  fn: signerAddress()(address)
  is: '0x6e427e36d518ca8923104357dd871f3aa6baee24'
  says: The signer it keeps in storage is 0x6e427e36d518ca8923104357dd871f3aa6baee24 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x6e427e36d518ca8923104357dd871f3aa6baee24'
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

BogxEthereal checks an ECDSA signature in checkSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddress changes the signer.

## Evidence

- [checkSignature](https://etherscan.io/address/0xfb45fcaf4f8a22019a43a6e1417e2c947aadca69#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0xfb45fcaf4f8a22019a43a6e1417e2c947aadca69#code) changes the signer; only the owner can call it.
- The signer at the block is [0x6e42…ee24](https://etherscan.io/address/0x6e427e36d518ca8923104357dd871f3aa6baee24), an account without code.

## Reviewer notes

### Mechanism

checkSignature (contracts/BogxEthereal.sol, line 159) recovers a signer on line 181 and tests it on line 181 against the signer it keeps in storage (signerAddress() returns 0x6e427e36d518ca8923104357dd871f3aa6baee24). Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (contracts/BogxEthereal.sol, line 113) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-10-19, recovering 0x6e42…ee24; 5 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
