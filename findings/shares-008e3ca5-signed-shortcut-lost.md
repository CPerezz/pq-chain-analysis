---
id: shares-008e3ca5-signed-shortcut-lost
format: 2
title: vSWG holders whose accounts take real code lose permit and signed delegation
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
  address: '0x008e3ca51d31ebb9cb2d430dc0b91847c438c08c'
  name: Shares
  code: verified
  code_url: https://etherscan.io/address/0x8124cbb807a7b64123f3dec3ef64995d8b10d3eb#code
  proxy_of: '0x8124cbb807a7b64123f3dec3ef64995d8b10d3eb'
  copies: 65
  family: 1ef81bfa0ed2f0a40dbcd10666096b34
  upgradeable: 'yes'
  admin: '0xca48dc8b9ab4200466ab3255444e11291c6c51bd'
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
  bytecode: '0x8124cbb807a7b64123f3dec3ef64995d8b10d3eb'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - evidence-2
  - what
- id: no-1271-legacy
  bytecode: '0x8124cbb807a7b64123f3dec3ef64995d8b10d3eb'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - evidence-2
  - what
- id: permit-fn
  selector: '0x8124cbb807a7b64123f3dec3ef64995d8b10d3eb'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0x8124cbb807a7b64123f3dec3ef64995d8b10d3eb'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-3
  - justification
  - what
- id: permit-body
  source: '0x8124cbb807a7b64123f3dec3ef64995d8b10d3eb'
  file: '@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol'
  line: 56
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0x8124cbb807a7b64123f3dec3ef64995d8b10d3eb'
  file: '@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol'
  line: 71
  has: address signer = ECDSAUpgradeable.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0x8124cbb807a7b64123f3dec3ef64995d8b10d3eb'
  file: '@openzeppelin/contracts/token/ERC20/ERC20.sol'
  line: 136
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-3
- id: match
  source: '0x8124cbb807a7b64123f3dec3ef64995d8b10d3eb'
  file: '@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol'
  line: 72
  has: 'require(signer == owner, "ERC20Permit: invalid signature");'
  says: the recovered address must be the holder
  for:
  - evidence-1
  - justification
  - what
- id: bysig-fn
  selector: '0x8124cbb807a7b64123f3dec3ef64995d8b10d3eb'
  fn: delegateBySig(address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has delegateBySig
  for:
  - what
- id: delegate-fn
  selector: '0x8124cbb807a7b64123f3dec3ef64995d8b10d3eb'
  fn: delegate(address)
  says: the code has a direct delegate
  for:
  - action
  - evidence-3
  - justification
  - what
- id: bysig-body
  source: '0x8124cbb807a7b64123f3dec3ef64995d8b10d3eb'
  file: contracts/utils/BaalVotes.sol
  line: 74
  has: delegateBySig
  says: delegateBySig is defined here
  for:
  - evidence-2
  - what
- id: bysig-recover
  source: '0x8124cbb807a7b64123f3dec3ef64995d8b10d3eb'
  file: contracts/utils/BaalVotes.sol
  line: 83
  has: address signer = ECDSAUpgradeable.recover(
  says: delegateBySig recovers the signer with ECDSA
  for:
  - action
  - evidence-2
  - justification
  - what
- id: bysig-acts
  source: '0x8124cbb807a7b64123f3dec3ef64995d8b10d3eb'
  file: contracts/utils/BaalVotes.sol
  line: 103
  has: _delegate(signer, delegatee);
  says: the votes delegated are the recovered signer's
  for:
  - evidence-2
  - what
- id: delegate-body
  source: '0x8124cbb807a7b64123f3dec3ef64995d8b10d3eb'
  file: contracts/utils/BaalVotes.sol
  line: 63
  has: delegate
  says: delegate is a direct call of the holder
  for:
  - action
  - evidence-3
- id: supply
  call: '0x008e3ca51d31ebb9cb2d430dc0b91847c438c08c'
  fn: totalSupply()(uint256)
  is: 300000000000000000000
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0x008e3ca51d31ebb9cb2d430dc0b91847c438c08c'
  fn: symbol()(string)
  is: vSWG
  says: the token's symbol is vSWG
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

The vSWG token lets a holder approve a spender and delegate its votes with an ECDSA signature, or with direct approve and delegate calls. A holder whose account takes real code can no longer use permit and delegateBySig; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0x8124cbb807a7b64123f3dec3ef64995d8b10d3eb#code) recovers the signer with ECDSA and requires it to equal the holder; the code never asks the holder's account.
- [delegateBySig](https://etherscan.io/address/0x8124cbb807a7b64123f3dec3ef64995d8b10d3eb#code) recovers the signer with ECDSA and delegates that signer's votes; the code never asks the signer's account.
- [approve and delegate](https://etherscan.io/address/0x8124cbb807a7b64123f3dec3ef64995d8b10d3eb#code) act for the caller and take no signature.

## Reviewer notes

### Mechanism

permit (@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol, line 56) builds its digest and recovers the signer on line 71; the recovered address must equal the holder (line 72) before the allowance is set. approve (@openzeppelin/contracts/token/ERC20/ERC20.sol, line 136) sets the caller's own allowance. delegateBySig (contracts/utils/BaalVotes.sol, line 74) recovers the signer on line 83 and delegates that signer's votes on line 103. delegate (contracts/utils/BaalVotes.sol, line 63) delegates the caller's own votes. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 65 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit and delegateBySig has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and delegateBySig and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 300,000,000,000,000,000,000 base units.
- Ruled out: Written by the shortcut recipe (D-029): the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
