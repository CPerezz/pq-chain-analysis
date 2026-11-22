---
id: apepair-14cd6e43-signed-shortcut-lost
format: 2
title: APE-LP holders whose accounts take real code lose permit
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
  address: '0x14cd6e434e3d6129eac663eab625d38156761349'
  name: ApePair
  code: verified
  code_url: https://etherscan.io/address/0x14cd6e434e3d6129eac663eab625d38156761349#code
  copies: 15
  family: e62407882629ff969f3176e93ae08f77
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: Tell holders that permit stops once their account takes real code; a direct approve call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0x14cd6e434e3d6129eac663eab625d38156761349'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x14cd6e434e3d6129eac663eab625d38156761349'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: permit-fn
  selector: '0x14cd6e434e3d6129eac663eab625d38156761349'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0x14cd6e434e3d6129eac663eab625d38156761349'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-2
  - justification
  - what
- id: permit-body
  source: '0x14cd6e434e3d6129eac663eab625d38156761349'
  file: contracts/ApeERC20.sol
  line: 91
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0x14cd6e434e3d6129eac663eab625d38156761349'
  file: contracts/ApeERC20.sol
  line: 100
  has: address recoveredAddress = ecrecover(digest, v, r, s);
  says: permit recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0x14cd6e434e3d6129eac663eab625d38156761349'
  file: contracts/ApeERC20.sol
  line: 73
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-2
- id: match
  source: '0x14cd6e434e3d6129eac663eab625d38156761349'
  file: contracts/ApeERC20.sol
  line: 101
  has: 'require(recoveredAddress != address(0) && recoveredAddress == owner, ''ApeSwap: INVALID_SIGNATURE'');'
  says: the recovered address must be the holder
  for:
  - evidence-1
  - justification
  - what
- id: supply
  call: '0x14cd6e434e3d6129eac663eab625d38156761349'
  fn: totalSupply()(uint256)
  is: 5221781305263559
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0x14cd6e434e3d6129eac663eab625d38156761349'
  fn: symbol()(string)
  is: APE-LP
  says: the token's symbol is APE-LP
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

The APE-LP token lets a holder approve a spender with an ECDSA-signed permit or with a direct approve call. A holder whose account takes real code can no longer use permit; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0x14cd6e434e3d6129eac663eab625d38156761349#code) recovers the signer with ECDSA and requires it to equal the holder; the code never asks the holder's account.
- [approve](https://etherscan.io/address/0x14cd6e434e3d6129eac663eab625d38156761349#code) sets the caller's own allowance without a signature.

## Reviewer notes

### Mechanism

permit (contracts/ApeERC20.sol, line 91) builds its digest and recovers the signer on line 100; the recovered address must equal the holder (line 101) before the allowance is set. approve (contracts/ApeERC20.sol, line 73) sets the caller's own allowance. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 15 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 5,221,781,305,263,559 base units.
- Ruled out: Written by the shortcut recipe (D-029): the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
