---
id: thortoken-a5f2211b-signed-shortcut-lost
format: 2
title: THOR holders whose accounts take real code lose permit and signed delegation
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
  address: '0xa5f2211b9b8170f694421f2046281775e8468044'
  name: ThorToken
  code: verified
  code_url: https://etherscan.io/address/0xa5f2211b9b8170f694421f2046281775e8468044#code
  copies: 1
  upgradeable: 'no'
  admin: '0x8f692d7abc6cdf567571276f76112ec9a01de309'
value:
  usd: 19
  basis: held
activity:
  txs_90d: 4794
impact: liveness
action: Tell holders that permit and delegateBySig stop once their account takes real code; a direct approve and
  delegate call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0xa5f2211b9b8170f694421f2046281775e8468044'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - evidence-2
  - what
- id: no-1271-legacy
  bytecode: '0xa5f2211b9b8170f694421f2046281775e8468044'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - evidence-2
  - what
- id: permit-fn
  selector: '0xa5f2211b9b8170f694421f2046281775e8468044'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0xa5f2211b9b8170f694421f2046281775e8468044'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-3
  - justification
  - what
- id: permit-body
  source: '0xa5f2211b9b8170f694421f2046281775e8468044'
  file: contracts/ERC20Permit.sol
  line: 33
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0xa5f2211b9b8170f694421f2046281775e8468044'
  file: contracts/ERC20Permit.sol
  line: 48
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0xa5f2211b9b8170f694421f2046281775e8468044'
  file: '@openzeppelin/contracts/token/ERC20/ERC20.sol'
  line: 131
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-3
- id: match
  source: '0xa5f2211b9b8170f694421f2046281775e8468044'
  file: contracts/ERC20Permit.sol
  line: 49
  has: 'require(signer == owner, "ERC20Permit: invalid signature");'
  says: the recovered address must be the holder
  for:
  - evidence-1
  - justification
  - what
- id: bysig-fn
  selector: '0xa5f2211b9b8170f694421f2046281775e8468044'
  fn: delegateBySig(address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has delegateBySig
  for:
  - what
- id: delegate-fn
  selector: '0xa5f2211b9b8170f694421f2046281775e8468044'
  fn: delegate(address)
  says: the code has a direct delegate
  for:
  - action
  - evidence-3
  - justification
  - what
- id: bysig-body
  source: '0xa5f2211b9b8170f694421f2046281775e8468044'
  file: contracts/ThorToken.sol
  line: 136
  has: delegateBySig
  says: delegateBySig is defined here
  for:
  - evidence-2
  - what
- id: bysig-recover
  source: '0xa5f2211b9b8170f694421f2046281775e8468044'
  file: contracts/ThorToken.sol
  line: 145
  has: address signer = ECDSA.recover(
  says: delegateBySig recovers the signer with ECDSA
  for:
  - action
  - evidence-2
  - justification
  - what
- id: bysig-acts
  source: '0xa5f2211b9b8170f694421f2046281775e8468044'
  file: contracts/ThorToken.sol
  line: 152
  has: return _delegate(signer, delegatee);
  says: the votes delegated are the recovered signer's
  for:
  - evidence-2
  - what
- id: delegate-body
  source: '0xa5f2211b9b8170f694421f2046281775e8468044'
  file: contracts/ThorToken.sol
  line: 129
  has: delegate
  says: delegate is a direct call of the holder
  for:
  - action
  - evidence-3
- id: supply
  call: '0xa5f2211b9b8170f694421f2046281775e8468044'
  fn: totalSupply()(uint256)
  is: 500000000000000000000000000
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0xa5f2211b9b8170f694421f2046281775e8468044'
  fn: symbol()(string)
  is: THOR
  says: the token's symbol is THOR
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

The THOR token lets a holder approve a spender and delegate its votes with an ECDSA signature, or with direct approve and delegate calls. A holder whose account takes real code can no longer use permit and delegateBySig; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0xa5f2211b9b8170f694421f2046281775e8468044#code) recovers the signer with ECDSA and requires it to equal the holder; the code never asks the holder's account.
- [delegateBySig](https://etherscan.io/address/0xa5f2211b9b8170f694421f2046281775e8468044#code) recovers the signer with ECDSA and delegates that signer's votes; the code never asks the signer's account.
- [approve and delegate](https://etherscan.io/address/0xa5f2211b9b8170f694421f2046281775e8468044#code) act for the caller and take no signature.

## Reviewer notes

### Mechanism

permit (contracts/ERC20Permit.sol, line 33) builds its digest and recovers the signer on line 48; the recovered address must equal the holder (line 49) before the allowance is set. approve (@openzeppelin/contracts/token/ERC20/ERC20.sol, line 131) sets the caller's own allowance. delegateBySig (contracts/ThorToken.sol, line 136) recovers the signer on line 145 and delegates that signer's votes on line 152. delegate (contracts/ThorToken.sol, line 129) delegates the caller's own votes. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit and delegateBySig has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and delegateBySig and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 500,000,000,000,000,000,000,000,000 base units.
- Ruled out: Written by the shortcut recipe: the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
