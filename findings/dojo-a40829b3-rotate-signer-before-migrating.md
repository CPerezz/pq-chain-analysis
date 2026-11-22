---
id: dojo-a40829b3-rotate-signer-before-migrating
format: 2
title: 'Dojo: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa40829b32748b8d6013e7a1a57e5e0d390407acd'
  name: Dojo
  code: verified
  code_url: https://etherscan.io/address/0xa40829b32748b8d6013e7a1a57e5e0d390407acd#code
  copies: 1
  upgradeable: 'no'
  admin: '0x6cc435f69fbac8ccddc8757e46a9d4376fdb16b5'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 15
impact: liveness
action: Replace the signer with setSigningAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xa40829b32748b8d6013e7a1a57e5e0d390407acd'
  file: contracts/Dojo.sol
  line: 304
  has: address signer = message.recover(signature);
  says: _validateSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xa40829b32748b8d6013e7a1a57e5e0d390407acd'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xa40829b32748b8d6013e7a1a57e5e0d390407acd'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xa40829b32748b8d6013e7a1a57e5e0d390407acd'
  file: contracts/Dojo.sol
  line: 305
  has: require(signer == _signingAddress, "Invalid signature");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xa40829b32748b8d6013e7a1a57e5e0d390407acd'
  file: contracts/Dojo.sol
  line: 189
  has: function setSigningAddress
  says: setSigningAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x11ebe7bd9d183e619f38b8f13f892b6c4000005b'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xd877ca27e8bb5c44009adbe48eb27d46dc532280ab747ad772d811452c400985'
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

Dojo checks an ECDSA signature in _validateSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigningAddress changes the signer.

## Evidence

- [_validateSignature](https://etherscan.io/address/0xa40829b32748b8d6013e7a1a57e5e0d390407acd#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigningAddress](https://etherscan.io/address/0xa40829b32748b8d6013e7a1a57e5e0d390407acd#code) changes the signer.
- Its latest signed [transaction](https://etherscan.io/tx/0xd877ca27e8bb5c44009adbe48eb27d46dc532280ab747ad772d811452c400985) on record recovered [0x11eb…005b](https://etherscan.io/address/0x11ebe7bd9d183e619f38b8f13f892b6c4000005b), an account without code.

## Reviewer notes

### Mechanism

_validateSignature (contracts/Dojo.sol, line 278) recovers a signer on line 304 and tests it on line 305 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSigningAddress (contracts/Dojo.sol, line 189) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0x11eb…005b; 15 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
