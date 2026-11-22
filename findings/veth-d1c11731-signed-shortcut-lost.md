---
id: veth-d1c11731-signed-shortcut-lost
format: 2
title: vaETH holders whose accounts take real code lose permit
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
  address: '0xd1c117319b3595fbc39b471ab1fd485629eb05f2'
  name: VETH
  code: verified
  code_url: https://etherscan.io/address/0xf296b1113cc49ae4c6890e7b5dd3bed780407487#code
  proxy_of: '0xf296b1113cc49ae4c6890e7b5dd3bed780407487'
  copies: 4
  family: 95720c214632fbe4da1a3f4fd3c9895e
  upgradeable: 'yes'
  admin: '0xe647951b8e67247643abd45b5acb80096f561624'
value:
  usd: 19911
  basis: held
activity: {}
impact: liveness
action: Tell holders that permit stops once their account takes real code; a direct approve call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0xf296b1113cc49ae4c6890e7b5dd3bed780407487'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xf296b1113cc49ae4c6890e7b5dd3bed780407487'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: permit-fn
  selector: '0xf296b1113cc49ae4c6890e7b5dd3bed780407487'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0xf296b1113cc49ae4c6890e7b5dd3bed780407487'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-2
  - justification
  - what
- id: permit-body
  source: '0xf296b1113cc49ae4c6890e7b5dd3bed780407487'
  file: contracts/pool/PoolERC20Permit.sol
  line: 41
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0xf296b1113cc49ae4c6890e7b5dd3bed780407487'
  file: contracts/pool/PoolERC20Permit.sol
  line: 56
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0xf296b1113cc49ae4c6890e7b5dd3bed780407487'
  file: contracts/pool/PoolERC20.sol
  line: 101
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-2
- id: match
  source: '0xf296b1113cc49ae4c6890e7b5dd3bed780407487'
  file: contracts/pool/PoolERC20Permit.sol
  line: 57
  has: 'require(signer == owner, "ERC20Permit: invalid signature");'
  says: the recovered address must be the holder
  for:
  - evidence-1
  - justification
  - what
- id: supply
  call: '0xd1c117319b3595fbc39b471ab1fd485629eb05f2'
  fn: totalSupply()(uint256)
  is: 902960397856963122500
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0xd1c117319b3595fbc39b471ab1fd485629eb05f2'
  fn: symbol()(string)
  is: vaETH
  says: the token's symbol is vaETH
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

The vaETH token lets a holder approve a spender with an ECDSA-signed permit or with a direct approve call. A holder whose account takes real code can no longer use permit; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0xf296b1113cc49ae4c6890e7b5dd3bed780407487#code) recovers the signer with ECDSA and requires it to equal the holder; the code never asks the holder's account.
- [approve](https://etherscan.io/address/0xf296b1113cc49ae4c6890e7b5dd3bed780407487#code) sets the caller's own allowance without a signature.

## Reviewer notes

### Mechanism

permit (contracts/pool/PoolERC20Permit.sol, line 41) builds its digest and recovers the signer on line 56; the recovered address must equal the holder (line 57) before the allowance is set. approve (contracts/pool/PoolERC20.sol, line 101) sets the caller's own allowance. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 4 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 902,960,397,856,963,122,500 base units.
- Ruled out: Written by the shortcut recipe (D-029): the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
