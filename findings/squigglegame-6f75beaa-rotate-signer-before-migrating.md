---
id: squigglegame-6f75beaa-rotate-signer-before-migrating
format: 2
title: 'SquiggleGame: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6f75beaa3d3d8a15e08a9f499464c696fc4d4cde'
  name: SquiggleGame
  code: verified
  code_url: https://etherscan.io/address/0x6f75beaa3d3d8a15e08a9f499464c696fc4d4cde#code
  copies: 1
  upgradeable: 'no'
  admin: '0xfa96217c8910a260f377ed9b0dd7044692e0b7f8'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 20
impact: liveness
action: Replace the signer with setScoreValidatorAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x6f75beaa3d3d8a15e08a9f499464c696fc4d4cde'
  file: SquiggleGame.sol
  line: 225
  has: address resolvedAddr = ECDSA.recover(msgHash, _sig);
  says: lockScore recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x6f75beaa3d3d8a15e08a9f499464c696fc4d4cde'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x6f75beaa3d3d8a15e08a9f499464c696fc4d4cde'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x6f75beaa3d3d8a15e08a9f499464c696fc4d4cde'
  file: SquiggleGame.sol
  line: 226
  has: require(resolvedAddr == scoreValidatorAddr, "Resolved address not the same as the validator address");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x6f75beaa3d3d8a15e08a9f499464c696fc4d4cde'
  file: SquiggleGame.sol
  line: 88
  has: function setScoreValidatorAddress
  says: setScoreValidatorAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x6f75beaa3d3d8a15e08a9f499464c696fc4d4cde'
  fn: scoreValidatorAddr()(address)
  is: '0x4faaee1b7f2d85599f65e37ab042174612f8f759'
  says: The signer it keeps in storage is 0x4faaee1b7f2d85599f65e37ab042174612f8f759 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x4faaee1b7f2d85599f65e37ab042174612f8f759'
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

SquiggleGame accepts a call to lockScore only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setScoreValidatorAddress changes the signer.

## Evidence

- [lockScore](https://etherscan.io/address/0x6f75beaa3d3d8a15e08a9f499464c696fc4d4cde#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setScoreValidatorAddress](https://etherscan.io/address/0x6f75beaa3d3d8a15e08a9f499464c696fc4d4cde#code) changes the signer; only the owner can call it.
- The signer at the block is [0x4faa…f759](https://etherscan.io/address/0x4faaee1b7f2d85599f65e37ab042174612f8f759), an account without code.

## Reviewer notes

### Mechanism

lockScore (SquiggleGame.sol, line 218) recovers a signer on line 225 and tests it on line 226 against the signer it keeps in storage (scoreValidatorAddr() returns 0x4faaee1b7f2d85599f65e37ab042174612f8f759). Neither isValidSignature selector is in the code, so that account is never asked. setScoreValidatorAddress (SquiggleGame.sol, line 88) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-08-11, recovering 0x4faa…f759; 20 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
