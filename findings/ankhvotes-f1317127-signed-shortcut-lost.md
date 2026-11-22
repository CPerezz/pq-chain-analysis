---
id: ankhvotes-f1317127-signed-shortcut-lost
format: 2
title: vANKH holders whose accounts take real code lose permit and signed delegation
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
  address: '0xf13171276348966db138a7230af2db4aef4e5ddc'
  name: AnkhVotes
  code: verified
  code_url: https://etherscan.io/address/0xf13171276348966db138a7230af2db4aef4e5ddc#code
  copies: 1
  upgradeable: 'no'
  admin: '0xda6c4071355fb54aa1c4a051a7e0db56d706b1a9'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Tell holders that permit and delegateBySig stop once their account takes real code; a direct approve and
  delegate call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0xf13171276348966db138a7230af2db4aef4e5ddc'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - evidence-2
  - what
- id: no-1271-legacy
  bytecode: '0xf13171276348966db138a7230af2db4aef4e5ddc'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - evidence-2
  - what
- id: permit-fn
  selector: '0xf13171276348966db138a7230af2db4aef4e5ddc'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0xf13171276348966db138a7230af2db4aef4e5ddc'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-3
  - justification
  - what
- id: permit-body
  source: '0xf13171276348966db138a7230af2db4aef4e5ddc'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol
  line: 42
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0xf13171276348966db138a7230af2db4aef4e5ddc'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol
  line: 59
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0xf13171276348966db138a7230af2db4aef4e5ddc'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
  line: 120
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-3
- id: match
  source: '0xf13171276348966db138a7230af2db4aef4e5ddc'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol
  line: 60
  has: if (signer != owner) {
  says: the recovered address must be the holder
  for:
  - evidence-1
  - justification
  - what
- id: bysig-fn
  selector: '0xf13171276348966db138a7230af2db4aef4e5ddc'
  fn: delegateBySig(address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has delegateBySig
  for:
  - what
- id: delegate-fn
  selector: '0xf13171276348966db138a7230af2db4aef4e5ddc'
  fn: delegate(address)
  says: the code has a direct delegate
  for:
  - action
  - evidence-3
  - justification
  - what
- id: bysig-body
  source: '0xf13171276348966db138a7230af2db4aef4e5ddc'
  file: lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol
  line: 143
  has: delegateBySig
  says: delegateBySig is defined here
  for:
  - evidence-2
  - what
- id: bysig-recover
  source: '0xf13171276348966db138a7230af2db4aef4e5ddc'
  file: lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol
  line: 154
  has: address signer = ECDSA.recover(
  says: delegateBySig recovers the signer with ECDSA
  for:
  - action
  - evidence-2
  - justification
  - what
- id: bysig-acts
  source: '0xf13171276348966db138a7230af2db4aef4e5ddc'
  file: lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol
  line: 161
  has: _delegate(signer, delegatee);
  says: the votes delegated are the recovered signer's
  for:
  - evidence-2
  - what
- id: delegate-body
  source: '0xf13171276348966db138a7230af2db4aef4e5ddc'
  file: lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol
  line: 135
  has: delegate
  says: delegate is a direct call of the holder
  for:
  - action
  - evidence-3
- id: supply
  call: '0xf13171276348966db138a7230af2db4aef4e5ddc'
  fn: totalSupply()(uint256)
  is: 1000000000000000000000
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0xf13171276348966db138a7230af2db4aef4e5ddc'
  fn: symbol()(string)
  is: vANKH
  says: the token's symbol is vANKH
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

The vANKH token lets a holder approve a spender and delegate its votes with an ECDSA signature, or with direct approve and delegate calls. A holder whose account takes real code can no longer use permit and delegateBySig; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0xf13171276348966db138a7230af2db4aef4e5ddc#code) recovers the signer with ECDSA and requires it to equal the holder; the code never asks the holder's account.
- [delegateBySig](https://etherscan.io/address/0xf13171276348966db138a7230af2db4aef4e5ddc#code) recovers the signer with ECDSA and delegates that signer's votes; the code never asks the signer's account.
- [approve and delegate](https://etherscan.io/address/0xf13171276348966db138a7230af2db4aef4e5ddc#code) act for the caller and take no signature.

## Reviewer notes

### Mechanism

permit (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol, line 42) builds its digest and recovers the signer on line 59; the recovered address must equal the holder (line 60) before the allowance is set. approve (lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol, line 120) sets the caller's own allowance. delegateBySig (lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol, line 143) recovers the signer on line 154 and delegates that signer's votes on line 161. delegate (lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol, line 135) delegates the caller's own votes. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit and delegateBySig has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and delegateBySig and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 1,000,000,000,000,000,000,000 base units.
- Ruled out: Written by the shortcut recipe (D-029): the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
