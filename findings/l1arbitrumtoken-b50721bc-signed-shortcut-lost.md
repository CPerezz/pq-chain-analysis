---
id: l1arbitrumtoken-b50721bc-signed-shortcut-lost
format: 2
title: ARB holders whose accounts take real code lose permit
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
  address: '0xb50721bcf8d664c30412cfbc6cf7a15145234ad1'
  name: L1ArbitrumToken
  code: verified
  code_url: https://etherscan.io/address/0xad0c361ef902a7d9851ca7dcc85535da2d3c6fc7#code
  proxy_of: '0xad0c361ef902a7d9851ca7dcc85535da2d3c6fc7'
  copies: 2
  family: 0b070f2c25f2ca7c26c2e937e20baf6c
  upgradeable: 'yes'
  admin: '0x5613af0474eb9c528a34701a5b1662e3c8fa0678'
value:
  usd: 5292
  basis: held
activity: {}
impact: liveness
action: Tell holders that permit stops once their account takes real code; a direct approve call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0xad0c361ef902a7d9851ca7dcc85535da2d3c6fc7'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xad0c361ef902a7d9851ca7dcc85535da2d3c6fc7'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: permit-fn
  selector: '0xad0c361ef902a7d9851ca7dcc85535da2d3c6fc7'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0xad0c361ef902a7d9851ca7dcc85535da2d3c6fc7'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-2
  - justification
  - what
- id: permit-body
  source: '0xad0c361ef902a7d9851ca7dcc85535da2d3c6fc7'
  file: node_modules/@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol
  line: 56
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0xad0c361ef902a7d9851ca7dcc85535da2d3c6fc7'
  file: node_modules/@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol
  line: 71
  has: address signer = ECDSAUpgradeable.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0xad0c361ef902a7d9851ca7dcc85535da2d3c6fc7'
  file: node_modules/@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol
  line: 141
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-2
- id: match
  source: '0xad0c361ef902a7d9851ca7dcc85535da2d3c6fc7'
  file: node_modules/@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol
  line: 72
  has: 'require(signer == owner, "ERC20Permit: invalid signature");'
  says: the recovered address must be the holder
  for:
  - evidence-1
  - justification
  - what
- id: supply
  call: '0xb50721bcf8d664c30412cfbc6cf7a15145234ad1'
  fn: totalSupply()(uint256)
  is: 261515488374442462228933928
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0xb50721bcf8d664c30412cfbc6cf7a15145234ad1'
  fn: symbol()(string)
  is: ARB
  says: the token's symbol is ARB
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

The ARB token lets a holder approve a spender with an ECDSA-signed permit or with a direct approve call. A holder whose account takes real code can no longer use permit; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0xad0c361ef902a7d9851ca7dcc85535da2d3c6fc7#code) recovers the signer with ECDSA and requires it to equal the holder; the code never asks the holder's account.
- [approve](https://etherscan.io/address/0xad0c361ef902a7d9851ca7dcc85535da2d3c6fc7#code) sets the caller's own allowance without a signature.

## Reviewer notes

### Mechanism

permit (node_modules/@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol, line 56) builds its digest and recovers the signer on line 71; the recovered address must equal the holder (line 72) before the allowance is set. approve (node_modules/@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol, line 141) sets the caller's own allowance. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 261,515,488,374,442,462,228,933,928 base units.
- Ruled out: Written by the shortcut recipe: the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
