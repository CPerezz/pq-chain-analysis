---
id: mmraiding-2598efb9-rotate-signer-before-migrating
format: 2
title: 'MMRaiding: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2598efb9653dc0e8b7bd9c9573d6d9ac729ac0ed'
  name: MMRaiding
  code: verified
  code_url: https://etherscan.io/address/0xb854c21a3dda2cc416ed290aa46223284a3bd43a#code
  proxy_of: '0xb854c21a3dda2cc416ed290aa46223284a3bd43a'
  copies: 2
  family: df4b63333291425843e66a2307361e1a
  upgradeable: 'yes'
  admin: '0x2bf1247440a649cc91f9a4ac1ada93663d8d749a'
value:
  usd: 25
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setAuthorizedSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xb854c21a3dda2cc416ed290aa46223284a3bd43a'
  file: src/MMRaiding.sol
  line: 139
  has: if (_recoverSigner(messageHash, signature) != authorizedSigner) revert InvalidSignature();
  says: claimRewards recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xb854c21a3dda2cc416ed290aa46223284a3bd43a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xb854c21a3dda2cc416ed290aa46223284a3bd43a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xb854c21a3dda2cc416ed290aa46223284a3bd43a'
  file: src/MMRaiding.sol
  line: 96
  has: function setAuthorizedSigner
  says: setAuthorizedSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x2598efb9653dc0e8b7bd9c9573d6d9ac729ac0ed'
  fn: authorizedSigner()(address)
  is: '0x4c02066f54a4266fa755d876bb8c6c3db8b6d05a'
  says: The signer it keeps in storage is 0x4c02066f54a4266fa755d876bb8c6c3db8b6d05a at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x4c02066f54a4266fa755d876bb8c6c3db8b6d05a'
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

MMRaiding accepts a call to claimRewards only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAuthorizedSigner changes the signer.

## Evidence

- [claimRewards](https://etherscan.io/address/0xb854c21a3dda2cc416ed290aa46223284a3bd43a#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setAuthorizedSigner](https://etherscan.io/address/0xb854c21a3dda2cc416ed290aa46223284a3bd43a#code) changes the signer; only the owner can call it.
- The signer at the block is [0x4c02…d05a](https://etherscan.io/address/0x4c02066f54a4266fa755d876bb8c6c3db8b6d05a), an account without code.

## Reviewer notes

### Mechanism

claimRewards (src/MMRaiding.sol, line 121) recovers a signer on line 139 and tests it on line 139 against the signer it keeps in storage (authorizedSigner() returns 0x4c02066f54a4266fa755d876bb8c6c3db8b6d05a). Neither isValidSignature selector is in the code, so that account is never asked. setAuthorizedSigner (src/MMRaiding.sol, line 96) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-03-19, recovering 0x4c02…d05a; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
