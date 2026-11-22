---
id: royaltyreceiver-3d4f91ff-rotate-signer-before-migrating
format: 2
title: 'RoyaltyReceiver: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3d4f91ff3cbea085640a6964f062b445c2174f3b'
  name: RoyaltyReceiver
  code: verified
  code_url: https://etherscan.io/address/0x8a11fa3e6732eb9df02bd9445a6986f1cfa06445#code
  proxy_of: '0x8a11fa3e6732eb9df02bd9445a6986f1cfa06445'
  copies: 2
  family: c322709cf3e265a74303397979fa5e49
  upgradeable: 'yes'
  admin: '0xeeac9eea71464f83a227b2defe754d0d52a2e732'
value:
  usd: 1222
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setTokenDetector before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x8a11fa3e6732eb9df02bd9445a6986f1cfa06445'
  file: contracts/RoyaltyReceiver.sol
  line: 374
  has: address signerAddress = keccak256(payload).toEthSignedMessageHash().recover(signature);
  says: validateSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x8a11fa3e6732eb9df02bd9445a6986f1cfa06445'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x8a11fa3e6732eb9df02bd9445a6986f1cfa06445'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x8a11fa3e6732eb9df02bd9445a6986f1cfa06445'
  file: contracts/RoyaltyReceiver.sol
  line: 376
  has: require(signerAddress == _tokenDetector, "Payload must be signed");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x8a11fa3e6732eb9df02bd9445a6986f1cfa06445'
  file: contracts/RoyaltyReceiver.sol
  line: 379
  has: function setTokenDetector
  says: setTokenDetector changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x1c490096f60cb1743dce3cb8b7ea50ffb1634a69'
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

RoyaltyReceiver checks an ECDSA signature in validateSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setTokenDetector changes the signer.

## Evidence

- [validateSignature](https://etherscan.io/address/0x8a11fa3e6732eb9df02bd9445a6986f1cfa06445#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setTokenDetector](https://etherscan.io/address/0x8a11fa3e6732eb9df02bd9445a6986f1cfa06445#code) changes the signer (through _setTokenDetector); only the owner can call it.
- The address recovered in its latest signature check on record is [0x1c49…4a69](https://etherscan.io/address/0x1c490096f60cb1743dce3cb8b7ea50ffb1634a69), an account without code.

## Reviewer notes

### Mechanism

validateSignature (contracts/RoyaltyReceiver.sol, line 373) recovers a signer on line 374 and tests it on line 376 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. _setTokenDetector (contracts/RoyaltyReceiver.sol, line 383) writes it, called by setTokenDetector. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-08-13, recovering 0x1c49…4a69; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
