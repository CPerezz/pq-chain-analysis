---
id: xceptionrewards-7e93cc80-rotate-signer-before-migrating
format: 2
title: 'XCeptionRewards: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7e93cc803c7e3defe6718caae238848479db0d35'
  name: XCeptionRewards
  code: verified
  code_url: https://etherscan.io/address/0x7e93cc803c7e3defe6718caae238848479db0d35#code
  copies: 2
  family: 8e70fb22c64e8ffc4d3df7a745b3f962
  upgradeable: 'no'
  admin: '0x5e1e2c21bf2be4f2b958d540c222fbf53d140bbf'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with updateSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x7e93cc803c7e3defe6718caae238848479db0d35'
  file: contracts/XCeptionRewards.sol
  line: 75
  has: ECDSA.recover(messageHash, signature) == _signer,
  says: claim recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x7e93cc803c7e3defe6718caae238848479db0d35'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x7e93cc803c7e3defe6718caae238848479db0d35'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x7e93cc803c7e3defe6718caae238848479db0d35'
  file: contracts/XCeptionRewards.sol
  line: 145
  has: function updateSigner
  says: updateSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x7e93cc803c7e3defe6718caae238848479db0d35'
  fn: getSigner()(address)
  is: '0xca31e01dc996b8360f7a7441b1cae3799b2a08f7'
  says: The signer it keeps in storage is 0xca31e01dc996b8360f7a7441b1cae3799b2a08f7 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xca31e01dc996b8360f7a7441b1cae3799b2a08f7'
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

XCeptionRewards accepts a call to claim only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSigner changes the signer.

## Evidence

- [claim](https://etherscan.io/address/0x7e93cc803c7e3defe6718caae238848479db0d35#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateSigner](https://etherscan.io/address/0x7e93cc803c7e3defe6718caae238848479db0d35#code) changes the signer; only the owner can call it.
- The signer at the block is [0xca31…08f7](https://etherscan.io/address/0xca31e01dc996b8360f7a7441b1cae3799b2a08f7), an account without code.

## Reviewer notes

### Mechanism

claim (contracts/XCeptionRewards.sol, line 55) recovers a signer on line 75 and tests it on line 75 against the signer it keeps in storage (getSigner() returns 0xca31e01dc996b8360f7a7441b1cae3799b2a08f7). Neither isValidSignature selector is in the code, so that account is never asked. updateSigner (contracts/XCeptionRewards.sol, line 145) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-02-23, recovering 0xca31…08f7; 0 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
