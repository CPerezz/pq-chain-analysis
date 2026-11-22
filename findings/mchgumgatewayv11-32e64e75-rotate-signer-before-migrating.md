---
id: mchgumgatewayv11-32e64e75-rotate-signer-before-migrating
format: 2
title: 'MCHGUMGatewayV11: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x32e64e75091d13c64f11db67ea94ac16951629b9'
  name: MCHGUMGatewayV11
  code: verified
  code_url: https://etherscan.io/address/0x32e64e75091d13c64f11db67ea94ac16951629b9#code
  copies: 1
  upgradeable: 'no'
  admin: '0xe7af11370c3bab51230d8307454350bdf6d68f4a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setValidater before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x32e64e75091d13c64f11db67ea94ac16951629b9'
  file: MCHGUMGatewayV11.sol
  line: 600
  has: address signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(_message), _signature);
  says: validateSig recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x32e64e75091d13c64f11db67ea94ac16951629b9'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x32e64e75091d13c64f11db67ea94ac16951629b9'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x32e64e75091d13c64f11db67ea94ac16951629b9'
  file: MCHGUMGatewayV11.sol
  line: 601
  has: return (signer == validater);
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x32e64e75091d13c64f11db67ea94ac16951629b9'
  file: MCHGUMGatewayV11.sol
  line: 415
  has: function setValidater
  says: setValidater changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x32e64e75091d13c64f11db67ea94ac16951629b9'
  fn: validater()(address)
  is: '0x35c5fd312ef06b88ae7d2f9928dbebf486d0784d'
  says: The signer it keeps in storage is 0x35c5fd312ef06b88ae7d2f9928dbebf486d0784d at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x35c5fd312ef06b88ae7d2f9928dbebf486d0784d'
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

MCHGUMGatewayV11 checks an ECDSA signature in validateSig and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setValidater changes the signer.

## Evidence

- [validateSig](https://etherscan.io/address/0x32e64e75091d13c64f11db67ea94ac16951629b9#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setValidater](https://etherscan.io/address/0x32e64e75091d13c64f11db67ea94ac16951629b9#code) changes the signer.
- The signer at the block is [0x35c5…784d](https://etherscan.io/address/0x35c5fd312ef06b88ae7d2f9928dbebf486d0784d), an account without code.

## Reviewer notes

### Mechanism

validateSig (MCHGUMGatewayV11.sol, line 598) recovers a signer on line 600 and tests it on line 601 against the signer it keeps in storage (validater() returns 0x35c5fd312ef06b88ae7d2f9928dbebf486d0784d). Neither isValidSignature selector is in the code, so that account is never asked. setValidater (MCHGUMGatewayV11.sol, line 415) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-03-05, recovering 0x35c5…784d; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
