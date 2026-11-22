---
id: pairtoken-ffff3870-signed-shortcut-lost
format: 2
title: PAIR holders whose accounts take real code lose permit
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
  address: '0xffff3870d0c50c50fa785e59fd81d83a82c2b8ed'
  name: PairToken
  code: verified
  code_url: https://etherscan.io/address/0xffff3870d0c50c50fa785e59fd81d83a82c2b8ed#code
  copies: 2
  family: c53d47f2b848c3160a5516089eaa2a05
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
  bytecode: '0xffff3870d0c50c50fa785e59fd81d83a82c2b8ed'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xffff3870d0c50c50fa785e59fd81d83a82c2b8ed'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: permit-fn
  selector: '0xffff3870d0c50c50fa785e59fd81d83a82c2b8ed'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0xffff3870d0c50c50fa785e59fd81d83a82c2b8ed'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-2
  - justification
  - what
- id: permit-body
  source: '0xffff3870d0c50c50fa785e59fd81d83a82c2b8ed'
  file: lib/solady/src/tokens/ERC20.sol
  line: 389
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0xffff3870d0c50c50fa785e59fd81d83a82c2b8ed'
  file: lib/solady/src/tokens/ERC20.sol
  line: 448
  has: let t := staticcall(gas(), 1, 0x00, 0x80, 0x20, 0x20)
  says: permit calls the ecrecover precompile with all the gas
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0xffff3870d0c50c50fa785e59fd81d83a82c2b8ed'
  file: lib/solady/src/tokens/ERC20.sol
  line: 186
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-2
- id: match
  source: '0xffff3870d0c50c50fa785e59fd81d83a82c2b8ed'
  file: lib/solady/src/tokens/ERC20.sol
  line: 454
  has: if iszero(eq(mload(returndatasize()), owner)) {
  says: the recovered address must be the holder
  for:
  - evidence-1
  - justification
  - what
- id: supply
  call: '0xffff3870d0c50c50fa785e59fd81d83a82c2b8ed'
  fn: totalSupply()(uint256)
  is: 993042721103613100854317
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0xffff3870d0c50c50fa785e59fd81d83a82c2b8ed'
  fn: symbol()(string)
  is: PAIR
  says: the token's symbol is PAIR
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

The PAIR token lets a holder approve a spender with an ECDSA-signed permit or with a direct approve call. A holder whose account takes real code can no longer use permit; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0xffff3870d0c50c50fa785e59fd81d83a82c2b8ed#code) calls the ecrecover precompile in assembly and reverts unless the result is the holder; the code never asks the holder's account.
- [approve](https://etherscan.io/address/0xffff3870d0c50c50fa785e59fd81d83a82c2b8ed#code) sets the caller's own allowance without a signature.

## Reviewer notes

### Mechanism

permit (lib/solady/src/tokens/ERC20.sol, line 389) builds its digest and recovers the signer on line 448; the recovered address must equal the holder (line 454) before the allowance is set. approve (lib/solady/src/tokens/ERC20.sol, line 186) sets the caller's own allowance. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 993,042,721,103,613,100,854,317 base units.
- Ruled out: Written by the shortcut recipe (D-029): the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
