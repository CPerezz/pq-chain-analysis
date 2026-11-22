---
id: etherc20metavault-33a88052-signed-shortcut-lost
format: 2
title: ERC-20 holders whose accounts take real code lose permit
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
  address: '0x33a880521d31abed1b919c197af21619d1a871e7'
  name: EthErc20MetaVault
  code: verified
  code_url: https://etherscan.io/address/0x3f2c0a621369fc54f6deec6c9534e980fd2e98d5#code
  proxy_of: '0x3f2c0a621369fc54f6deec6c9534e980fd2e98d5'
  copies: 8
  family: 2c7550b968f20b25c5f89638cea61906
  upgradeable: 'yes'
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: Tell holders that permit stops once their account takes real code; a direct approve call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0x3f2c0a621369fc54f6deec6c9534e980fd2e98d5'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x3f2c0a621369fc54f6deec6c9534e980fd2e98d5'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: permit-fn
  selector: '0x3f2c0a621369fc54f6deec6c9534e980fd2e98d5'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0x3f2c0a621369fc54f6deec6c9534e980fd2e98d5'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-2
  - justification
  - what
- id: permit-body
  source: '0x3f2c0a621369fc54f6deec6c9534e980fd2e98d5'
  file: contracts/base/ERC20Upgradeable.sol
  line: 81
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0x3f2c0a621369fc54f6deec6c9534e980fd2e98d5'
  file: contracts/base/ERC20Upgradeable.sol
  line: 91
  has: address recoveredAddress = ecrecover(
  says: permit recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0x3f2c0a621369fc54f6deec6c9534e980fd2e98d5'
  file: contracts/base/ERC20Upgradeable.sol
  line: 54
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-2
- id: match
  source: '0x3f2c0a621369fc54f6deec6c9534e980fd2e98d5'
  file: contracts/base/ERC20Upgradeable.sol
  line: 104
  has: if (recoveredAddress == address(0) || recoveredAddress != owner) {
  says: the recovered address must be the holder
  for:
  - evidence-1
  - justification
  - what
- id: supply
  call: '0x33a880521d31abed1b919c197af21619d1a871e7'
  fn: totalSupply()(uint256)
  is: 1000000000
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0x33a880521d31abed1b919c197af21619d1a871e7'
  fn: symbol()(string)
  is: ERC-20
  says: the token's symbol is ERC-20
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

The ERC-20 token lets a holder approve a spender with an ECDSA-signed permit or with a direct approve call. A holder whose account takes real code can no longer use permit; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0x3f2c0a621369fc54f6deec6c9534e980fd2e98d5#code) recovers the signer with ECDSA and requires it to equal the holder; the code never asks the holder's account.
- [approve](https://etherscan.io/address/0x3f2c0a621369fc54f6deec6c9534e980fd2e98d5#code) sets the caller's own allowance without a signature.

## Reviewer notes

### Mechanism

permit (contracts/base/ERC20Upgradeable.sol, line 81) builds its digest and recovers the signer on line 91; the recovered address must equal the holder (line 104) before the allowance is set. approve (contracts/base/ERC20Upgradeable.sol, line 54) sets the caller's own allowance. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 8 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 1,000,000,000 base units.
- Ruled out: Written by the shortcut recipe: the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
