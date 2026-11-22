---
id: fixedtoken-21413c11-signed-shortcut-lost
format: 2
title: GENE holders whose accounts take real code lose permit
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
  address: '0x21413c119b0c11c5d96ae1bd328917bc5c8ed67e'
  name: FixedToken
  code: verified
  code_url: https://etherscan.io/address/0xaa1a02671440be41545d83bddff2bf2488628c10#code
  proxy_of: '0xaa1a02671440be41545d83bddff2bf2488628c10'
  copies: 4
  family: 5d58ac53112780ca5eab384acbab18f4
  upgradeable: 'no'
value:
  usd: 6477
  basis: held
activity: {}
impact: liveness
action: Tell holders that permit stops once their account takes real code; a direct approve call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0xaa1a02671440be41545d83bddff2bf2488628c10'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xaa1a02671440be41545d83bddff2bf2488628c10'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: permit-fn
  selector: '0xaa1a02671440be41545d83bddff2bf2488628c10'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0xaa1a02671440be41545d83bddff2bf2488628c10'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-2
  - justification
  - what
- id: permit-body
  source: '0xaa1a02671440be41545d83bddff2bf2488628c10'
  file: contracts/Tokens/ERC20.sol
  line: 159
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0xaa1a02671440be41545d83bddff2bf2488628c10'
  file: contracts/Tokens/ERC20.sol
  line: 178
  has: address recoveredAddress = ecrecover(digest, v, r, s);
  says: permit recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0xaa1a02671440be41545d83bddff2bf2488628c10'
  file: contracts/Tokens/ERC20.sol
  line: 144
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-2
- id: match
  source: '0xaa1a02671440be41545d83bddff2bf2488628c10'
  file: contracts/Tokens/ERC20.sol
  line: 179
  has: 'require(recoveredAddress == owner_, "ERC20: Invalid Signature");'
  says: the recovered address must be the holder
  for:
  - evidence-1
  - justification
  - what
- id: supply
  call: '0x21413c119b0c11c5d96ae1bd328917bc5c8ed67e'
  fn: totalSupply()(uint256)
  is: 1000000000000000000000000000
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0x21413c119b0c11c5d96ae1bd328917bc5c8ed67e'
  fn: symbol()(string)
  is: GENE
  says: the token's symbol is GENE
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

The GENE token lets a holder approve a spender with an ECDSA-signed permit or with a direct approve call. A holder whose account takes real code can no longer use permit; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0xaa1a02671440be41545d83bddff2bf2488628c10#code) recovers the signer with ECDSA and requires it to equal the holder; the code never asks the holder's account.
- [approve](https://etherscan.io/address/0xaa1a02671440be41545d83bddff2bf2488628c10#code) sets the caller's own allowance without a signature.

## Reviewer notes

### Mechanism

permit (contracts/Tokens/ERC20.sol, line 159) builds its digest and recovers the signer on line 178; the recovered address must equal the holder (line 179) before the allowance is set. approve (contracts/Tokens/ERC20.sol, line 144) sets the caller's own allowance. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 4 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 1,000,000,000,000,000,000,000,000,000 base units.
- Ruled out: Written by the shortcut recipe (D-029): the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
