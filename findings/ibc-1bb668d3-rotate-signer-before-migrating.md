---
id: ibc-1bb668d3-rotate-signer-before-migrating
format: 2
title: 'Ibc: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1bb668d33d367702adbe81346d57d5e5083fa346'
  name: Ibc
  code: verified
  code_url: https://etherscan.io/address/0x1bb668d33d367702adbe81346d57d5e5083fa346#code
  copies: 2
  family: 1745c7c0932c68650f985d50f9cd052c
  upgradeable: 'no'
  admin: '0x95d490789d043d32fd33aa058afe1c8772c61e48'
value:
  usd: 196
  basis: held
activity:
  txs_90d: 2716
impact: liveness
action: Before a signer's account moves to real code, use addOracle so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x1bb668d33d367702adbe81346d57d5e5083fa346'
  file: contracts/bridge/Ibc.sol
  line: 284
  has: address recoveredSigner = ECDSA.recover(MessageHashUtils.toEthSignedMessageHash(messageHash), signatures[i]);
  says: checkSignatures recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x1bb668d33d367702adbe81346d57d5e5083fa346'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x1bb668d33d367702adbe81346d57d5e5083fa346'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x1bb668d33d367702adbe81346d57d5e5083fa346'
  file: contracts/bridge/Ibc.sol
  line: 109
  has: function addOracle
  says: addOracle changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xf1f7ca2438534890782e2b52feec217b5e1f58f1'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xb7a811f07e9ba3907dbdece213d66d35bcec50caf8d7c2330af4b3ca98883f9b'
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

Ibc checks an ECDSA signature in checkSignatures and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addOracle changes who may sign.

## Evidence

- [checkSignatures](https://etherscan.io/address/0x1bb668d33d367702adbe81346d57d5e5083fa346#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [addOracle](https://etherscan.io/address/0x1bb668d33d367702adbe81346d57d5e5083fa346#code) changes who may sign; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0xb7a811f07e9ba3907dbdece213d66d35bcec50caf8d7c2330af4b3ca98883f9b) on record recovered [0xf1f7…58f1](https://etherscan.io/address/0xf1f7ca2438534890782e2b52feec217b5e1f58f1), an account without code.

## Reviewer notes

### Mechanism

checkSignatures (contracts/bridge/Ibc.sol, line 271) recovers a signer on line 284 and tests it on line 284 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. addOracle (contracts/bridge/Ibc.sol, line 109) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-16, recovering 0xf1f7…58f1; 2,716 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
