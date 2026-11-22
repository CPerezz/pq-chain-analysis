---
id: gamerdelegator-36f697f7-signed-shortcut-lost
format: 2
title: GAMER holders whose accounts take real code lose signed vote delegation
status: confirmed
severity: INFORMATIONAL
justification: A holder loses only the signed way, and only by moving its account to real code; the direct call
  still works.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x36f697f791a0c91d6f1bb166767d5d2d701b1d82'
  name: GAMERDelegator
  code: verified
  code_url: https://etherscan.io/address/0x36f697f791a0c91d6f1bb166767d5d2d701b1d82#code
  copies: 2
  family: bd6171f77e3b62d652af02618ada9961
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: Tell holders that delegateBySig stops once their account takes real code; a direct delegate call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0x36f697f791a0c91d6f1bb166767d5d2d701b1d82'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x36f697f791a0c91d6f1bb166767d5d2d701b1d82'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: bysig-fn
  selector: '0x36f697f791a0c91d6f1bb166767d5d2d701b1d82'
  fn: delegateBySig(address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has delegateBySig
  for:
  - what
- id: delegate-fn
  selector: '0x36f697f791a0c91d6f1bb166767d5d2d701b1d82'
  fn: delegate(address)
  says: the code has a direct delegate
  for:
  - action
  - evidence-2
  - justification
  - what
- id: bysig-body
  source: '0x36f697f791a0c91d6f1bb166767d5d2d701b1d82'
  file: Users/qijunlin/MyWorkSpace/SolidityWorkSpace/gamer_truffle/contracts/token/GAMERGovernance.sol
  line: 44
  has: delegateBySig
  says: delegateBySig is defined here
  for:
  - evidence-1
  - what
- id: bysig-recover
  source: '0x36f697f791a0c91d6f1bb166767d5d2d701b1d82'
  file: Users/qijunlin/MyWorkSpace/SolidityWorkSpace/gamer_truffle/contracts/token/GAMERGovernance.sol
  line: 80
  has: address signatory = ecrecover(digest, v, r, s);
  says: delegateBySig recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: bysig-acts
  source: '0x36f697f791a0c91d6f1bb166767d5d2d701b1d82'
  file: Users/qijunlin/MyWorkSpace/SolidityWorkSpace/gamer_truffle/contracts/token/GAMERGovernance.sol
  line: 84
  has: return _delegate(signatory, delegatee);
  says: the votes delegated are the recovered signer's
  for:
  - evidence-1
  - what
- id: delegate-body
  source: '0x36f697f791a0c91d6f1bb166767d5d2d701b1d82'
  file: Users/qijunlin/MyWorkSpace/SolidityWorkSpace/gamer_truffle/contracts/token/GAMERGovernance.sol
  line: 31
  has: delegate
  says: delegate is a direct call of the holder
  for:
  - action
  - evidence-2
- id: supply
  call: '0x36f697f791a0c91d6f1bb166767d5d2d701b1d82'
  fn: totalSupply()(uint256)
  is: 3643395732791428102753013
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0x36f697f791a0c91d6f1bb166767d5d2d701b1d82'
  fn: symbol()(string)
  is: GAMER
  says: the token's symbol is GAMER
  for:
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

The GAMER token lets a holder delegate its votes with an ECDSA-signed message or with a direct delegate call. A holder whose account takes real code can no longer use delegateBySig; an EIP-7702 delegation keeps working.

## Evidence

- [delegateBySig](https://etherscan.io/address/0x36f697f791a0c91d6f1bb166767d5d2d701b1d82#code) recovers the signer with ECDSA and delegates that signer's votes; the code never asks the signer's account.
- [delegate](https://etherscan.io/address/0x36f697f791a0c91d6f1bb166767d5d2d701b1d82#code) delegates the caller's own votes without a signature.

## Reviewer notes

### Mechanism

delegateBySig (Users/qijunlin/MyWorkSpace/SolidityWorkSpace/gamer_truffle/contracts/token/GAMERGovernance.sol, line 44) recovers the signer on line 80 and delegates that signer's votes on line 84. delegate (Users/qijunlin/MyWorkSpace/SolidityWorkSpace/gamer_truffle/contracts/token/GAMERGovernance.sol, line 31) delegates the caller's own votes. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of delegateBySig has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except delegateBySig and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 3,643,395,732,791,428,102,753,013 base units.
- Ruled out: Written by the shortcut recipe (D-029): the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
