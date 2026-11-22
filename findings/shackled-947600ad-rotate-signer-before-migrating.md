---
id: shackled-947600ad-rotate-signer-before-migrating
format: 2
title: 'Shackled: its signer is a contract, so no signature is accepted now'
status: confirmed
severity: INFORMATIONAL
justification: Nothing can break while the signer is a contract; a key set later can be replaced before it moves
  to real code.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x947600ad1ad2fadf88faf7d30193d363208fc76d'
  name: Shackled
  code: verified
  code_url: https://etherscan.io/address/0x947600ad1ad2fadf88faf7d30193d363208fc76d#code
  copies: 1
  admin: '0xa0385041eb8ec23ad04a76c8a50b85ca0c7ff770'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 23
impact: liveness
action: If a key is set as signer again, replace it with transferOwnership before its account moves to real code.
evidence_level: source
checks:
- id: recover
  source: '0x947600ad1ad2fadf88faf7d30193d363208fc76d'
  file: contracts/Shackled.sol
  line: 179
  has: address actualSigner = ECDSA.recover(
  says: checkSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x947600ad1ad2fadf88faf7d30193d363208fc76d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
- id: no-1271-legacy
  bytecode: '0x947600ad1ad2fadf88faf7d30193d363208fc76d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
- id: match
  source: '0x947600ad1ad2fadf88faf7d30193d363208fc76d'
  file: contracts/Shackled.sol
  line: 184
  has: return (owner == actualSigner);
  says: the recovered address must be its owner
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0x947600ad1ad2fadf88faf7d30193d363208fc76d'
  fn: transferOwnership(address)
  says: the code has transferOwnership
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x947600ad1ad2fadf88faf7d30193d363208fc76d'
  fn: owner()(address)
  is: '0xa0385041eb8ec23ad04a76c8a50b85ca0c7ff770'
  says: Its owner is 0xa0385041eb8ec23ad04a76c8a50b85ca0c7ff770 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xa0385041eb8ec23ad04a76c8a50b85ca0c7ff770'
  is: contract
  says: the signer's account is a contract
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

Shackled checks an ECDSA signature in checkSignature and accepts only its owner. That signer is a contract at the block, which no ECDSA signature can match, so none is accepted now. transferOwnership can set a key again; replace that key before its account takes real code.

## Evidence

- [checkSignature](https://etherscan.io/address/0x947600ad1ad2fadf88faf7d30193d363208fc76d#code) recovers the signature with ECDSA and accepts only its owner; the code never asks that account.
- [transferOwnership](https://etherscan.io/address/0x947600ad1ad2fadf88faf7d30193d363208fc76d#code) changes the signer; only the owner can call it.
- The signer at the block is [0xa038…f770](https://etherscan.io/address/0xa0385041eb8ec23ad04a76c8a50b85ca0c7ff770), a contract.

## Reviewer notes

### Mechanism

checkSignature (contracts/Shackled.sol, line 171) recovers a signer on line 179 and tests it on line 184 against its owner (owner() returns 0xa0385041eb8ec23ad04a76c8a50b85ca0c7ff770). Neither isValidSignature selector is in the code, so that account is never asked. transferOwnership is in the code. The signer is a contract at the block, and a recovery cannot return a contract's address. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-03-23, recovering 0x54f3…d4ae; 23 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
