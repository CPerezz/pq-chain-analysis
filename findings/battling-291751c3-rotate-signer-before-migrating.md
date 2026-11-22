---
id: battling-291751c3-rotate-signer-before-migrating
format: 2
title: 'Battling: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x291751c3e4894523f8d2a93ee338626861b77061'
  name: Battling
  code: verified
  code_url: https://etherscan.io/address/0x291751c3e4894523f8d2a93ee338626861b77061#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 40
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x291751c3e4894523f8d2a93ee338626861b77061'
  file: contracts/BattlingRefOnChain.sol
  line: 58
  has: require(decodeSignature(msg.sender, _amount, _message, _battle_id, _deadline, _erc20_token, _player_referral_a
  says: _isCallerVerified recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x291751c3e4894523f8d2a93ee338626861b77061'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x291751c3e4894523f8d2a93ee338626861b77061'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x291751c3e4894523f8d2a93ee338626861b77061'
  file: contracts/BattlingRefOnChain.sol
  line: 268
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x291751c3e4894523f8d2a93ee338626861b77061'
  fn: SIGNER()(address)
  is: '0xd0e3c02035a5bd4c76c43bc56b35ccc58dd6df2f'
  says: The signer it keeps in storage is 0xd0e3c02035a5bd4c76c43bc56b35ccc58dd6df2f at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xd0e3c02035a5bd4c76c43bc56b35ccc58dd6df2f'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
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

Battling checks an ECDSA signature in _isCallerVerified and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddress changes the signer.

## Evidence

- [_isCallerVerified](https://etherscan.io/address/0x291751c3e4894523f8d2a93ee338626861b77061#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0x291751c3e4894523f8d2a93ee338626861b77061#code) changes the signer.
- The signer at the block is [0xd0e3…df2f](https://etherscan.io/address/0xd0e3c02035a5bd4c76c43bc56b35ccc58dd6df2f), an account without code.

## Reviewer notes

### Mechanism

_isCallerVerified (contracts/BattlingRefOnChain.sol, line 55) recovers a signer on line 58 and tests it on line 58 against the signer it keeps in storage (SIGNER() returns 0xd0e3c02035a5bd4c76c43bc56b35ccc58dd6df2f). Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (contracts/BattlingRefOnChain.sol, line 268) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-04-27, recovering 0xd0e3…df2f; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
