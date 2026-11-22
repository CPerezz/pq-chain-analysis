---
id: gametoken-4e1bb01e-rotate-signer-before-migrating
format: 2
title: 'GameToken: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4e1bb01ee7a835629d15cfc43d0c7feeede18353'
  name: GameToken
  code: verified
  code_url: https://etherscan.io/address/0x4e1bb01ee7a835629d15cfc43d0c7feeede18353#code
  copies: 3
  family: de0759900382af3d2f47fe0ecf4cc32a
  upgradeable: 'no'
  admin: '0x96c80ab80a920efd32485bc2fb9dfec601f357e6'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 138
impact: liveness
action: Replace the signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x4e1bb01ee7a835629d15cfc43d0c7feeede18353'
  file: contracts/GameToken.sol
  line: 45
  has: return _signerAddress == hash.recover(signature);
  says: matchAddresSigner recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x4e1bb01ee7a835629d15cfc43d0c7feeede18353'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x4e1bb01ee7a835629d15cfc43d0c7feeede18353'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x4e1bb01ee7a835629d15cfc43d0c7feeede18353'
  file: contracts/GameToken.sol
  line: 107
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xbda703092c8daee2e2bd651b9482d5a75d332ec1'
  is: empty
  says: the address recovered in the latest signature check on record has no code
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

GameToken checks an ECDSA signature in matchAddresSigner and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddress changes the signer.

## Evidence

- [matchAddresSigner](https://etherscan.io/address/0x4e1bb01ee7a835629d15cfc43d0c7feeede18353#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0x4e1bb01ee7a835629d15cfc43d0c7feeede18353#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0xbda7…2ec1](https://etherscan.io/address/0xbda703092c8daee2e2bd651b9482d5a75d332ec1), an account without code.

## Reviewer notes

### Mechanism

matchAddresSigner (contracts/GameToken.sol, line 44) recovers a signer on line 45 and tests it on line 45 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (contracts/GameToken.sol, line 107) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-03-28, recovering 0xbda7…2ec1; 138 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
