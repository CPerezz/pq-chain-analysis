---
id: mutationcontroller-e1cefd31-rotate-signer-before-migrating
format: 2
title: 'MutationController: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe1cefd316b6a297f15324427ab647bb309c25767'
  name: MutationController
  code: verified
  code_url: https://etherscan.io/address/0xe1cefd316b6a297f15324427ab647bb309c25767#code
  copies: 1
  upgradeable: 'no'
  admin: '0x71e2fb3f1636c8d1996004febedc85e878b1dc44'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 9
impact: liveness
action: Replace the signer with updateAuthorizedSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xe1cefd316b6a297f15324427ab647bb309c25767'
  file: contracts/MutationController.sol
  line: 457
  has: address recoveredSigner = ECDSA.recover(ethSignedMessageHash, _signature);
  says: verifySignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xe1cefd316b6a297f15324427ab647bb309c25767'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe1cefd316b6a297f15324427ab647bb309c25767'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xe1cefd316b6a297f15324427ab647bb309c25767'
  file: contracts/MutationController.sol
  line: 459
  has: recoveredSigner == authorizedSigner,
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xe1cefd316b6a297f15324427ab647bb309c25767'
  file: contracts/MutationController.sol
  line: 190
  has: function updateAuthorizedSigner
  says: updateAuthorizedSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xe1cefd316b6a297f15324427ab647bb309c25767'
  fn: authorizedSigner()(address)
  is: '0x023c51db075f4703ee306ddb65852904ba9568c1'
  says: The signer it keeps in storage is 0x023c51db075f4703ee306ddb65852904ba9568c1 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x023c51db075f4703ee306ddb65852904ba9568c1'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x60b5db6cd109dad60af7ec50cbf361afa6fd30517124d8c853dd055783acf5da'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
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

MutationController checks an ECDSA signature in verifySignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateAuthorizedSigner changes the signer.

## Evidence

- [verifySignature](https://etherscan.io/address/0xe1cefd316b6a297f15324427ab647bb309c25767#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateAuthorizedSigner](https://etherscan.io/address/0xe1cefd316b6a297f15324427ab647bb309c25767#code) changes the signer; only the owner can call it.
- The signer at the block is [0x023c…68c1](https://etherscan.io/address/0x023c51db075f4703ee306ddb65852904ba9568c1), an account without code.

## Reviewer notes

### Mechanism

verifySignature (contracts/MutationController.sol, line 438) recovers a signer on line 457 and tests it on line 459 against the signer it keeps in storage (authorizedSigner() returns 0x023c51db075f4703ee306ddb65852904ba9568c1). Neither isValidSignature selector is in the code, so that account is never asked. updateAuthorizedSigner (contracts/MutationController.sol, line 190) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-14, recovering 0x023c…68c1; 9 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
