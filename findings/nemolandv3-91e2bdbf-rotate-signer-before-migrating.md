---
id: nemolandv3-91e2bdbf-rotate-signer-before-migrating
format: 2
title: 'NemoLandV3: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x91e2bdbfbd03be4db28944e4a45e3eeb636f781c'
  name: NemoLandV3
  code: verified
  code_url: https://etherscan.io/address/0xf8ba58db9c7265038ced10731ff9c525fcd7a071#code
  proxy_of: '0xf8ba58db9c7265038ced10731ff9c525fcd7a071'
  copies: 2
  family: 81916a6882a5d1a7802e8befc2dfbd8d
  upgradeable: 'yes'
  admin: '0x52f931f3dc09c317d6b6550d06daeba1639920e6'
value:
  usd: 106
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with changeSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xf8ba58db9c7265038ced10731ff9c525fcd7a071'
  file: contracts/Land/NemoLandV3.sol
  line: 535
  has: bool isValid = msgHash.toEthSignedMessageHash().recover(_signature) ==
  says: isValidRequest recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xf8ba58db9c7265038ced10731ff9c525fcd7a071'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xf8ba58db9c7265038ced10731ff9c525fcd7a071'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xf8ba58db9c7265038ced10731ff9c525fcd7a071'
  file: contracts/Land/NemoLandV3.sol
  line: 150
  has: function changeSigner
  says: changeSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x35db783ec42609842c62fe1667dbe15628ae8a6f'
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

NemoLandV3 checks an ECDSA signature in isValidRequest and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. changeSigner changes the signer.

## Evidence

- [isValidRequest](https://etherscan.io/address/0xf8ba58db9c7265038ced10731ff9c525fcd7a071#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [changeSigner](https://etherscan.io/address/0xf8ba58db9c7265038ced10731ff9c525fcd7a071#code) changes the signer; only a role holder can call it.
- The address recovered in its latest signature check on record is [0x35db…8a6f](https://etherscan.io/address/0x35db783ec42609842c62fe1667dbe15628ae8a6f), an account without code.

## Reviewer notes

### Mechanism

isValidRequest (contracts/Land/NemoLandV3.sol, line 524) recovers a signer on line 535 and tests it on line 535 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. changeSigner (contracts/Land/NemoLandV3.sol, line 150) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-06-19, recovering 0x35db…8a6f; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
