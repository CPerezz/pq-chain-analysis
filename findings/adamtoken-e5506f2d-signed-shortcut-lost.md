---
id: adamtoken-e5506f2d-signed-shortcut-lost
format: 2
title: ADAM holders whose accounts take real code lose signed vote delegation
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
  address: '0xe5506f2d0e7677d889b525d23aa19a522da34643'
  name: AdamToken
  code: verified
  code_url: https://etherscan.io/address/0xe5506f2d0e7677d889b525d23aa19a522da34643#code
  copies: 2
  family: 14e803753dae8cba72d8c3b39c10c207
  upgradeable: 'no'
  admin: '0xdc1d5b5b1aeee8a90cdcae38aa09c7582eca8007'
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: Tell holders that delegateBySig stops once their account takes real code; a direct delegate call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0xe5506f2d0e7677d889b525d23aa19a522da34643'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe5506f2d0e7677d889b525d23aa19a522da34643'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: bysig-fn
  selector: '0xe5506f2d0e7677d889b525d23aa19a522da34643'
  fn: delegateBySig(address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has delegateBySig
  for:
  - what
- id: delegate-fn
  selector: '0xe5506f2d0e7677d889b525d23aa19a522da34643'
  fn: delegate(address)
  says: the code has a direct delegate
  for:
  - action
  - evidence-2
  - justification
  - what
- id: bysig-body
  source: '0xe5506f2d0e7677d889b525d23aa19a522da34643'
  file: AdamToken.sol
  line: 910
  has: delegateBySig
  says: delegateBySig is defined here
  for:
  - evidence-1
  - what
- id: bysig-recover
  source: '0xe5506f2d0e7677d889b525d23aa19a522da34643'
  file: AdamToken.sol
  line: 925
  has: address signatory = ecrecover(digest, v, r, s);
  says: delegateBySig recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: bysig-acts
  source: '0xe5506f2d0e7677d889b525d23aa19a522da34643'
  file: AdamToken.sol
  line: 929
  has: return _delegate(signatory, delegatee);
  says: the votes delegated are the recovered signer's
  for:
  - evidence-1
  - what
- id: delegate-body
  source: '0xe5506f2d0e7677d889b525d23aa19a522da34643'
  file: AdamToken.sol
  line: 897
  has: delegate
  says: delegate is a direct call of the holder
  for:
  - action
  - evidence-2
- id: supply
  call: '0xe5506f2d0e7677d889b525d23aa19a522da34643'
  fn: totalSupply()(uint256)
  is: 8030837589761904761904669
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0xe5506f2d0e7677d889b525d23aa19a522da34643'
  fn: symbol()(string)
  is: ADAM
  says: the token's symbol is ADAM
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

The ADAM token lets a holder delegate its votes with an ECDSA-signed message or with a direct delegate call. A holder whose account takes real code can no longer use delegateBySig; an EIP-7702 delegation keeps working.

## Evidence

- [delegateBySig](https://etherscan.io/address/0xe5506f2d0e7677d889b525d23aa19a522da34643#code) recovers the signer with ECDSA and delegates that signer's votes; the code never asks the signer's account.
- [delegate](https://etherscan.io/address/0xe5506f2d0e7677d889b525d23aa19a522da34643#code) delegates the caller's own votes without a signature.

## Reviewer notes

### Mechanism

delegateBySig (AdamToken.sol, line 910) recovers the signer on line 925 and delegates that signer's votes on line 929. delegate (AdamToken.sol, line 897) delegates the caller's own votes. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of delegateBySig has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except delegateBySig and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 8,030,837,589,761,904,761,904,669 base units.
- Ruled out: Written by the shortcut recipe: the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
