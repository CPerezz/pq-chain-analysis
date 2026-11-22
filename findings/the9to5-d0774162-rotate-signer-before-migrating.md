---
id: the9to5-d0774162-rotate-signer-before-migrating
format: 2
title: 'The9to5: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd0774162f5dbe3d0fed3f355a2396a57d25a4fe5'
  name: The9to5
  code: verified
  code_url: https://etherscan.io/address/0xd0774162f5dbe3d0fed3f355a2396a57d25a4fe5#code
  copies: 1
  upgradeable: 'no'
  admin: '0x8b108ae4b969edd33a1496df98f251b726440ca8'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: Replace the signer with setFreeSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xd0774162f5dbe3d0fed3f355a2396a57d25a4fe5'
  file: src/The9to5.sol
  line: 154
  has: address recovered = ECDSA.recover(digest, sig);
  says: mintFree recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd0774162f5dbe3d0fed3f355a2396a57d25a4fe5'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd0774162f5dbe3d0fed3f355a2396a57d25a4fe5'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xd0774162f5dbe3d0fed3f355a2396a57d25a4fe5'
  file: src/The9to5.sol
  line: 155
  has: require(recovered == freeSigner, "bad sig");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xd0774162f5dbe3d0fed3f355a2396a57d25a4fe5'
  file: src/The9to5.sol
  line: 176
  has: function setFreeSigner
  says: setFreeSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xd0774162f5dbe3d0fed3f355a2396a57d25a4fe5'
  fn: freeSigner()(address)
  is: '0xa2e4a54f7e9bc65c77639987e0effa61dc6b9951'
  says: The signer it keeps in storage is 0xa2e4a54f7e9bc65c77639987e0effa61dc6b9951 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xa2e4a54f7e9bc65c77639987e0effa61dc6b9951'
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

The9to5 accepts a call to mintFree only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setFreeSigner changes the signer.

## Evidence

- [mintFree](https://etherscan.io/address/0xd0774162f5dbe3d0fed3f355a2396a57d25a4fe5#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setFreeSigner](https://etherscan.io/address/0xd0774162f5dbe3d0fed3f355a2396a57d25a4fe5#code) changes the signer; only the owner can call it.
- The signer at the block is [0xa2e4…9951](https://etherscan.io/address/0xa2e4a54f7e9bc65c77639987e0effa61dc6b9951), an account without code.

## Reviewer notes

### Mechanism

mintFree (src/The9to5.sol, line 136) recovers a signer on line 154 and tests it on line 155 against the signer it keeps in storage (freeSigner() returns 0xa2e4a54f7e9bc65c77639987e0effa61dc6b9951). Neither isValidSignature selector is in the code, so that account is never asked. setFreeSigner (src/The9to5.sol, line 176) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 5 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
