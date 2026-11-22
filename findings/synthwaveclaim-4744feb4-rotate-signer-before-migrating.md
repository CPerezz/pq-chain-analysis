---
id: synthwaveclaim-4744feb4-rotate-signer-before-migrating
format: 2
title: 'SynthwaveClaim: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4744feb48a74cd8c3e7f6ba9ba97cd377416ba78'
  name: SynthwaveClaim
  code: verified
  code_url: https://etherscan.io/address/0x4744feb48a74cd8c3e7f6ba9ba97cd377416ba78#code
  copies: 1
  upgradeable: 'no'
  admin: '0x323211cd8c4dc8d678035cdd3cdab0b9b9927936'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 40
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x4744feb48a74cd8c3e7f6ba9ba97cd377416ba78'
  file: src/SynthwaveClaim.sol
  line: 94
  has: (address recovered, ECDSA.RecoverError err,) = ECDSA.tryRecover(claimDigest(c), signature);
  says: _claim recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x4744feb48a74cd8c3e7f6ba9ba97cd377416ba78'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x4744feb48a74cd8c3e7f6ba9ba97cd377416ba78'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x4744feb48a74cd8c3e7f6ba9ba97cd377416ba78'
  file: src/SynthwaveClaim.sol
  line: 95
  has: if (err != ECDSA.RecoverError.NoError || recovered != signer) revert InvalidSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x4744feb48a74cd8c3e7f6ba9ba97cd377416ba78'
  file: src/SynthwaveClaim.sol
  line: 127
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x4744feb48a74cd8c3e7f6ba9ba97cd377416ba78'
  fn: signer()(address)
  is: '0x2876c313eb2e475455e1a730661ddef6dcc9479f'
  says: The signer it keeps in storage is 0x2876c313eb2e475455e1a730661ddef6dcc9479f at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x2876c313eb2e475455e1a730661ddef6dcc9479f'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xa545fc736cc6f22e0b321d6007e13aa7350e2725c62894a53126f6105e72fb99'
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

SynthwaveClaim checks an ECDSA signature in _claim and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [_claim](https://etherscan.io/address/0x4744feb48a74cd8c3e7f6ba9ba97cd377416ba78#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x4744feb48a74cd8c3e7f6ba9ba97cd377416ba78#code) changes the signer; only the owner can call it.
- The signer at the block is [0x2876…479f](https://etherscan.io/address/0x2876c313eb2e475455e1a730661ddef6dcc9479f), an account without code.

## Reviewer notes

### Mechanism

_claim (src/SynthwaveClaim.sol, line 89) recovers a signer on line 94 and tests it on line 95 against the signer it keeps in storage (signer() returns 0x2876c313eb2e475455e1a730661ddef6dcc9479f). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (src/SynthwaveClaim.sol, line 127) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0x2876…479f; 40 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
