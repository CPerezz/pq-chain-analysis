---
id: vbeth-2dc70fb7-signed-shortcut-lost
format: 2
title: vbETH holders whose accounts take real code lose permit
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
  address: '0x2dc70fb75b88d2eb4715bc06e1595e6d97c34dff'
  name: VbETH
  code: verified
  code_url: https://etherscan.io/address/0x81c16f89222c32806daf01f5129937dfe19d525e#code
  proxy_of: '0x81c16f89222c32806daf01f5129937dfe19d525e'
  copies: 2
  family: 0e88978470a069f2787c1a8cbf3b2ad8
  upgradeable: 'yes'
  admin: '0x14be6579a41342ca6b402ec85e7be538e6ade951'
value:
  usd: 1167797
  basis: held
activity: {}
impact: liveness
action: Tell holders that permit stops once their account takes real code; a direct approve call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0x81c16f89222c32806daf01f5129937dfe19d525e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x81c16f89222c32806daf01f5129937dfe19d525e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: permit-fn
  selector: '0x81c16f89222c32806daf01f5129937dfe19d525e'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0x81c16f89222c32806daf01f5129937dfe19d525e'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-2
  - justification
  - what
- id: permit-body
  source: '0x81c16f89222c32806daf01f5129937dfe19d525e'
  file: dependencies/@openzeppelin-contracts-upgradeable-5.1.0/token/ERC20/extensions/ERC20PermitUpgradeable.sol
  line: 49
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0x81c16f89222c32806daf01f5129937dfe19d525e'
  file: dependencies/@openzeppelin-contracts-upgradeable-5.1.0/token/ERC20/extensions/ERC20PermitUpgradeable.sol
  line: 66
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0x81c16f89222c32806daf01f5129937dfe19d525e'
  file: dependencies/@openzeppelin-contracts-upgradeable-5.1.0/token/ERC20/ERC20Upgradeable.sol
  line: 150
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-2
- id: match
  source: '0x81c16f89222c32806daf01f5129937dfe19d525e'
  file: dependencies/@openzeppelin-contracts-upgradeable-5.1.0/token/ERC20/extensions/ERC20PermitUpgradeable.sol
  line: 67
  has: if (signer != owner) {
  says: the recovered address must be the holder
  for:
  - evidence-1
  - justification
  - what
- id: supply
  call: '0x2dc70fb75b88d2eb4715bc06e1595e6d97c34dff'
  fn: totalSupply()(uint256)
  is: 2746009025666189850848
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0x2dc70fb75b88d2eb4715bc06e1595e6d97c34dff'
  fn: symbol()(string)
  is: vbETH
  says: the token's symbol is vbETH
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

The vbETH token lets a holder approve a spender with an ECDSA-signed permit or with a direct approve call. A holder whose account takes real code can no longer use permit; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0x81c16f89222c32806daf01f5129937dfe19d525e#code) recovers the signer with ECDSA and requires it to equal the holder; the code never asks the holder's account.
- [approve](https://etherscan.io/address/0x81c16f89222c32806daf01f5129937dfe19d525e#code) sets the caller's own allowance without a signature.

## Reviewer notes

### Mechanism

permit (dependencies/@openzeppelin-contracts-upgradeable-5.1.0/token/ERC20/extensions/ERC20PermitUpgradeable.sol, line 49) builds its digest and recovers the signer on line 66; the recovered address must equal the holder (line 67) before the allowance is set. approve (dependencies/@openzeppelin-contracts-upgradeable-5.1.0/token/ERC20/ERC20Upgradeable.sol, line 150) sets the caller's own allowance. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 2,746,009,025,666,189,850,848 base units.
- Ruled out: Written by the shortcut recipe (D-029): the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
