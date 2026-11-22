---
id: momentx-genesis-tablet-701d32f0-rotate-signer-before-migrating
format: 2
title: 'MomentX_Genesis_Tablet: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x701d32f0bbb18db243410e82d438ff5d917bd799'
  name: MomentX_Genesis_Tablet
  code: verified
  code_url: https://etherscan.io/address/0x701d32f0bbb18db243410e82d438ff5d917bd799#code
  copies: 1
  upgradeable: 'no'
  admin: '0x8f30b1b4d0cab00ceedd080591b0029c48038e25'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 6
impact: liveness
action: Replace the signer with setWhiteListAdmin before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x701d32f0bbb18db243410e82d438ff5d917bd799'
  file: mx_genesis_tablet.sol
  line: 182
  has: address recovered_address = keccak256(abi.encodePacked(address(this),_add)).toEthSignedMessageHash().recover(s
  says: isValidAccessMessage recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x701d32f0bbb18db243410e82d438ff5d917bd799'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x701d32f0bbb18db243410e82d438ff5d917bd799'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x701d32f0bbb18db243410e82d438ff5d917bd799'
  file: mx_genesis_tablet.sol
  line: 184
  has: return  (_whitelist_admin == recovered_address);
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x701d32f0bbb18db243410e82d438ff5d917bd799'
  file: mx_genesis_tablet.sol
  line: 75
  has: function setWhiteListAdmin
  says: setWhiteListAdmin changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xee44ac234b5de7d369a398db6f5c5a4856f0524e'
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

MomentX_Genesis_Tablet checks an ECDSA signature in isValidAccessMessage and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setWhiteListAdmin changes the signer.

## Evidence

- [isValidAccessMessage](https://etherscan.io/address/0x701d32f0bbb18db243410e82d438ff5d917bd799#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setWhiteListAdmin](https://etherscan.io/address/0x701d32f0bbb18db243410e82d438ff5d917bd799#code) changes the signer; only a role holder can call it.
- The address recovered in its latest signature check on record is [0xee44…524e](https://etherscan.io/address/0xee44ac234b5de7d369a398db6f5c5a4856f0524e), an account without code.

## Reviewer notes

### Mechanism

isValidAccessMessage (mx_genesis_tablet.sol, line 180) recovers a signer on line 182 and tests it on line 184 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setWhiteListAdmin (mx_genesis_tablet.sol, line 75) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2021-12-06, recovering 0xee44…524e; 6 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
