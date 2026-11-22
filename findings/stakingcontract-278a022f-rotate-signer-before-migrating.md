---
id: stakingcontract-278a022f-rotate-signer-before-migrating
format: 2
title: 'StakingContract: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x278a022f6bfcd41dbad0fe0133cb5702c07f28d1'
  name: StakingContract
  code: verified
  code_url: https://etherscan.io/address/0x278a022f6bfcd41dbad0fe0133cb5702c07f28d1#code
  copies: 2
  family: 7cc4619e49ef475d4101ea96b79b22f3
  admin: '0xfcf62b37d43d3e4031924a6b513e3a6010ae57ca'
value:
  usd: 180
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSigAdd before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x278a022f6bfcd41dbad0fe0133cb5702c07f28d1'
  file: StakingContract.sol
  line: 803
  has: require(signatureAddress == _recoverSigner(sender, weight_, signature),
  says: increaseWeight recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x278a022f6bfcd41dbad0fe0133cb5702c07f28d1'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x278a022f6bfcd41dbad0fe0133cb5702c07f28d1'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x278a022f6bfcd41dbad0fe0133cb5702c07f28d1'
  file: StakingContract.sol
  line: 1124
  has: function setSigAdd
  says: setSigAdd changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x278a022f6bfcd41dbad0fe0133cb5702c07f28d1'
  fn: signatureAddress()(address)
  is: '0x3e974b6bb6b4580ef1d467640d077f8ed43f727f'
  says: The signer it keeps in storage is 0x3e974b6bb6b4580ef1d467640d077f8ed43f727f at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x3e974b6bb6b4580ef1d467640d077f8ed43f727f'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

StakingContract accepts a call to increaseWeight only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigAdd changes the signer.

## Evidence

- [increaseWeight](https://etherscan.io/address/0x278a022f6bfcd41dbad0fe0133cb5702c07f28d1#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigAdd](https://etherscan.io/address/0x278a022f6bfcd41dbad0fe0133cb5702c07f28d1#code) changes the signer; only the owner can call it.
- The signer at the block is [0x3e97…727f](https://etherscan.io/address/0x3e974b6bb6b4580ef1d467640d077f8ed43f727f), an account without code.

## Reviewer notes

### Mechanism

increaseWeight (StakingContract.sol, line 798) recovers a signer on line 803 and tests it on line 803 against the signer it keeps in storage (signatureAddress() returns 0x3e974b6bb6b4580ef1d467640d077f8ed43f727f). Neither isValidSignature selector is in the code, so that account is never asked. setSigAdd (StakingContract.sol, line 1124) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
