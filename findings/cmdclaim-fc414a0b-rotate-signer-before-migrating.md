---
id: cmdclaim-fc414a0b-rotate-signer-before-migrating
format: 2
title: 'CMDClaim: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xfc414a0b34f951d7a2670677ba842103920b3601'
  name: CMDClaim
  code: verified
  code_url: https://etherscan.io/address/0xfc414a0b34f951d7a2670677ba842103920b3601#code
  copies: 1
  upgradeable: 'no'
  admin: '0xba4cdf5cf24a810284a167d82658b0935b897351'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 9
impact: liveness
action: Replace the signer with rotateSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xfc414a0b34f951d7a2670677ba842103920b3601'
  file: src/CMDClaim.sol
  line: 252
  has: address recovered = ECDSA.recover(digest, signature);
  says: _verifySignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xfc414a0b34f951d7a2670677ba842103920b3601'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xfc414a0b34f951d7a2670677ba842103920b3601'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xfc414a0b34f951d7a2670677ba842103920b3601'
  file: src/CMDClaim.sol
  line: 253
  has: if (recovered != signer) revert InvalidSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xfc414a0b34f951d7a2670677ba842103920b3601'
  file: src/CMDClaim.sol
  line: 217
  has: function rotateSigner
  says: rotateSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xfc414a0b34f951d7a2670677ba842103920b3601'
  fn: signer()(address)
  is: '0xe5a527c026370fc826142f848078e0bf0eb8f876'
  says: The signer it keeps in storage is 0xe5a527c026370fc826142f848078e0bf0eb8f876 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xe5a527c026370fc826142f848078e0bf0eb8f876'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x3b7b598190c3a13137dc6b9bd49457ddd0cb223e47a6c8f9b71dae960b28e3cb'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
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

CMDClaim checks an ECDSA signature in _verifySignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. rotateSigner changes the signer.

## Evidence

- [_verifySignature](https://etherscan.io/address/0xfc414a0b34f951d7a2670677ba842103920b3601#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [rotateSigner](https://etherscan.io/address/0xfc414a0b34f951d7a2670677ba842103920b3601#code) changes the signer; only the owner can call it.
- The signer at the block is [0xe5a5…f876](https://etherscan.io/address/0xe5a527c026370fc826142f848078e0bf0eb8f876), an account without code.

## Reviewer notes

### Mechanism

_verifySignature (src/CMDClaim.sol, line 249) recovers a signer on line 252 and tests it on line 253 against the signer it keeps in storage (signer() returns 0xe5a527c026370fc826142f848078e0bf0eb8f876). Neither isValidSignature selector is in the code, so that account is never asked. rotateSigner (src/CMDClaim.sol, line 217) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-23, recovering 0xe5a5…f876; 9 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
