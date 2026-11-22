---
id: azuro-9e6be44c-signed-shortcut-lost
format: 2
title: AZUR holders whose accounts take real code lose permit and signed delegation
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
  address: '0x9e6be44cc1236eef7e1f197418592d363bedcd5a'
  name: Azuro
  code: verified
  code_url: https://etherscan.io/address/0x9e6be44cc1236eef7e1f197418592d363bedcd5a#code
  copies: 2
  family: 04fe5441b74a59769cb0afba9ce70809
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: Tell holders that permit and delegateBySig stop once their account takes real code; a direct approve and
  delegate call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0x9e6be44cc1236eef7e1f197418592d363bedcd5a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - evidence-2
  - what
- id: no-1271-legacy
  bytecode: '0x9e6be44cc1236eef7e1f197418592d363bedcd5a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - evidence-2
  - what
- id: permit-fn
  selector: '0x9e6be44cc1236eef7e1f197418592d363bedcd5a'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0x9e6be44cc1236eef7e1f197418592d363bedcd5a'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-3
  - justification
  - what
- id: permit-body
  source: '0x9e6be44cc1236eef7e1f197418592d363bedcd5a'
  file: '@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol'
  line: 44
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0x9e6be44cc1236eef7e1f197418592d363bedcd5a'
  file: '@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol'
  line: 61
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0x9e6be44cc1236eef7e1f197418592d363bedcd5a'
  file: '@openzeppelin/contracts/token/ERC20/ERC20.sol'
  line: 132
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-3
- id: match
  source: '0x9e6be44cc1236eef7e1f197418592d363bedcd5a'
  file: '@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol'
  line: 62
  has: if (signer != owner) {
  says: the recovered address must be the holder
  for:
  - evidence-1
  - justification
  - what
- id: bysig-fn
  selector: '0x9e6be44cc1236eef7e1f197418592d363bedcd5a'
  fn: delegateBySig(address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has delegateBySig
  for:
  - what
- id: delegate-fn
  selector: '0x9e6be44cc1236eef7e1f197418592d363bedcd5a'
  fn: delegate(address)
  says: the code has a direct delegate
  for:
  - action
  - evidence-3
  - justification
  - what
- id: bysig-body
  source: '0x9e6be44cc1236eef7e1f197418592d363bedcd5a'
  file: '@openzeppelin/contracts/governance/utils/Votes.sol'
  line: 142
  has: delegateBySig
  says: delegateBySig is defined here
  for:
  - evidence-2
  - what
- id: bysig-recover
  source: '0x9e6be44cc1236eef7e1f197418592d363bedcd5a'
  file: '@openzeppelin/contracts/governance/utils/Votes.sol'
  line: 153
  has: address signer = ECDSA.recover(
  says: delegateBySig recovers the signer with ECDSA
  for:
  - action
  - evidence-2
  - justification
  - what
- id: bysig-acts
  source: '0x9e6be44cc1236eef7e1f197418592d363bedcd5a'
  file: '@openzeppelin/contracts/governance/utils/Votes.sol'
  line: 160
  has: _delegate(signer, delegatee);
  says: the votes delegated are the recovered signer's
  for:
  - evidence-2
  - what
- id: delegate-body
  source: '0x9e6be44cc1236eef7e1f197418592d363bedcd5a'
  file: '@openzeppelin/contracts/governance/utils/Votes.sol'
  line: 134
  has: delegate
  says: delegate is a direct call of the holder
  for:
  - action
  - evidence-3
- id: supply
  call: '0x9e6be44cc1236eef7e1f197418592d363bedcd5a'
  fn: totalSupply()(uint256)
  is: 1000000000000000000000000000
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0x9e6be44cc1236eef7e1f197418592d363bedcd5a'
  fn: symbol()(string)
  is: AZUR
  says: the token's symbol is AZUR
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

The AZUR token lets a holder approve a spender and delegate its votes with an ECDSA signature, or with direct approve and delegate calls. A holder whose account takes real code can no longer use permit and delegateBySig; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0x9e6be44cc1236eef7e1f197418592d363bedcd5a#code) recovers the signer with ECDSA and requires it to equal the holder; the code never asks the holder's account.
- [delegateBySig](https://etherscan.io/address/0x9e6be44cc1236eef7e1f197418592d363bedcd5a#code) recovers the signer with ECDSA and delegates that signer's votes; the code never asks the signer's account.
- [approve and delegate](https://etherscan.io/address/0x9e6be44cc1236eef7e1f197418592d363bedcd5a#code) act for the caller and take no signature.

## Reviewer notes

### Mechanism

permit (@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol, line 44) builds its digest and recovers the signer on line 61; the recovered address must equal the holder (line 62) before the allowance is set. approve (@openzeppelin/contracts/token/ERC20/ERC20.sol, line 132) sets the caller's own allowance. delegateBySig (@openzeppelin/contracts/governance/utils/Votes.sol, line 142) recovers the signer on line 153 and delegates that signer's votes on line 160. delegate (@openzeppelin/contracts/governance/utils/Votes.sol, line 134) delegates the caller's own votes. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit and delegateBySig has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and delegateBySig and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 1,000,000,000,000,000,000,000,000,000 base units.
- Ruled out: Written by the shortcut recipe (D-029): the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
