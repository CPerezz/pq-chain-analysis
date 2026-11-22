---
id: strangeattractors-1ca15ccd-rotate-signer-before-migrating
format: 2
title: 'StrangeAttractors: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1ca15ccdd91b55cd617a48dc9eefb98cae224757'
  name: StrangeAttractors
  code: verified
  code_url: https://etherscan.io/address/0x1ca15ccdd91b55cd617a48dc9eefb98cae224757#code
  copies: 1
  admin: '0x24fce07dd6f1c48403d088d71c57d6ef4e65ce41'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 13
impact: liveness
action: Replace the signer with setSlotSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x1ca15ccdd91b55cd617a48dc9eefb98cae224757'
  file: contracts/utils/SignedSlotRestrictable.sol
  line: 80
  has: (message.toEthSignedMessageHash().recover(signature) == _signer));
  says: isValidSlot recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x1ca15ccdd91b55cd617a48dc9eefb98cae224757'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x1ca15ccdd91b55cd617a48dc9eefb98cae224757'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x1ca15ccdd91b55cd617a48dc9eefb98cae224757'
  file: contracts/StrangeAttractors.sol
  line: 165
  has: function setSlotSigner
  says: setSlotSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x8c647f0aba9e801417e3ac4af26d5502328f86cb'
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

StrangeAttractors checks an ECDSA signature in isValidSlot and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSlotSigner changes the signer.

## Evidence

- [isValidSlot](https://etherscan.io/address/0x1ca15ccdd91b55cd617a48dc9eefb98cae224757#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSlotSigner](https://etherscan.io/address/0x1ca15ccdd91b55cd617a48dc9eefb98cae224757#code) changes the signer (through _setSlotSigner); only the owner can call it.
- The address recovered in its latest signature check on record is [0x8c64…86cb](https://etherscan.io/address/0x8c647f0aba9e801417e3ac4af26d5502328f86cb), an account without code.

## Reviewer notes

### Mechanism

isValidSlot (contracts/utils/SignedSlotRestrictable.sol, line 73) recovers a signer on line 80 and tests it on line 80 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. _setSlotSigner (contracts/utils/SignedSlotRestrictable.sol, line 54) writes it, called by setSlotSigner. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-06-30, recovering 0x8c64…86cb; 13 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
