---
id: crosschainhtlc-c6d27843-rotate-signer-before-migrating
format: 2
title: 'CrossChainHTLC: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc6d27843426f31ef378d0c2101384519811933cf'
  name: CrossChainHTLC
  code: verified
  code_url: https://etherscan.io/address/0xcfa0b12c439a6059b1288223636adf78076b992e#code
  proxy_of: '0xcfa0b12c439a6059b1288223636adf78076b992e'
  copies: 2
  family: 7ef4cef6e26b17dc77d94389dc136d7f
  upgradeable: 'yes'
value:
  usd: 6
  basis: held
activity:
  txs_90d: 187
impact: liveness
action: Replace the signer with setMaintainer before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xcfa0b12c439a6059b1288223636adf78076b992e'
  file: contracts/CrossChainHTLC.sol
  line: 492
  has: address signer = ECDSA.recover(_hashTypedDataV4(structHash), maintainerSig);
  says: _validateHtlcLockSource recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xcfa0b12c439a6059b1288223636adf78076b992e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xcfa0b12c439a6059b1288223636adf78076b992e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xcfa0b12c439a6059b1288223636adf78076b992e'
  file: contracts/CrossChainHTLC.sol
  line: 493
  has: if (signer != maintainer) revert InvalidSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xcfa0b12c439a6059b1288223636adf78076b992e'
  file: contracts/CrossChainHTLC.sol
  line: 126
  has: function setMaintainer
  says: setMaintainer changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xc6d27843426f31ef378d0c2101384519811933cf'
  fn: maintainer()(address)
  is: '0x6228ab40e809d3077667630b622a4a44a2dd8919'
  says: The signer it keeps in storage is 0x6228ab40e809d3077667630b622a4a44a2dd8919 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x6228ab40e809d3077667630b622a4a44a2dd8919'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x7c08287f9bc7f1be4eeb57ebeb67d30254095b9237a609eb8945ff1135303793'
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

CrossChainHTLC checks an ECDSA signature in _validateHtlcLockSource and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setMaintainer changes the signer.

## Evidence

- [_validateHtlcLockSource](https://etherscan.io/address/0xcfa0b12c439a6059b1288223636adf78076b992e#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setMaintainer](https://etherscan.io/address/0xcfa0b12c439a6059b1288223636adf78076b992e#code) changes the signer; only a role holder can call it.
- The signer at the block is [0x6228…8919](https://etherscan.io/address/0x6228ab40e809d3077667630b622a4a44a2dd8919), an account without code.

## Reviewer notes

### Mechanism

_validateHtlcLockSource (contracts/CrossChainHTLC.sol, line 470) recovers a signer on line 492 and tests it on line 493 against the signer it keeps in storage (maintainer() returns 0x6228ab40e809d3077667630b622a4a44a2dd8919). Neither isValidSignature selector is in the code, so that account is never asked. setMaintainer (contracts/CrossChainHTLC.sol, line 126) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-14, recovering 0x6228…8919; 187 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
