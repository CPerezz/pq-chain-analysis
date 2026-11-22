---
id: hyperion-ad3a38d3-rotate-signer-before-migrating
format: 2
title: 'Hyperion: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xad3a38d34a1a907a6a61fc2fe9d26bf2e3109216'
  name: Hyperion
  code: verified
  code_url: https://etherscan.io/address/0xad3a38d34a1a907a6a61fc2fe9d26bf2e3109216#code
  copies: 1
  upgradeable: 'no'
  admin: '0x44dc5ec08715a70ad4b7fa97ddba41130867074f'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 19
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xad3a38d34a1a907a6a61fc2fe9d26bf2e3109216'
  file: contracts/Hyperion.sol
  line: 75
  has: if(hash.toEthSignedMessageHash().recover(signature)!=signer) revert NotWhitelisted();
  says: group1Mint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xad3a38d34a1a907a6a61fc2fe9d26bf2e3109216'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xad3a38d34a1a907a6a61fc2fe9d26bf2e3109216'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xad3a38d34a1a907a6a61fc2fe9d26bf2e3109216'
  file: contracts/Hyperion.sol
  line: 123
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x44dc5ec08715a70ad4b7fa97ddba41130867074f'
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

Hyperion accepts a call to group1Mint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [group1Mint](https://etherscan.io/address/0xad3a38d34a1a907a6a61fc2fe9d26bf2e3109216#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xad3a38d34a1a907a6a61fc2fe9d26bf2e3109216#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0x44dc…074f](https://etherscan.io/address/0x44dc5ec08715a70ad4b7fa97ddba41130867074f), an account without code.

## Reviewer notes

### Mechanism

group1Mint (contracts/Hyperion.sol, line 71) recovers a signer on line 75 and tests it on line 75 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/Hyperion.sol, line 123) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-01-28, recovering 0x44dc…074f; 19 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
