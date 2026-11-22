---
id: ubdvalidator-6532f9cc-rotate-signer-before-migrating
format: 2
title: 'UBDValidator: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6532f9cc71e41f7238ba2661948303fdc3e286cf'
  name: UBDValidator
  code: verified
  code_url: https://etherscan.io/address/0x6532f9cc71e41f7238ba2661948303fdc3e286cf#code
  copies: 1
  upgradeable: 'no'
  admin: '0xe206f8ac6067d8253c57d86ac96a789cd90ed4d4'
value:
  usd: 4
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x6532f9cc71e41f7238ba2661948303fdc3e286cf'
  file: src/UBDValidator.sol
  line: 36
  has: if (_recoverSigner(message, signature) != signer) { revert BadSignature(); }
  says: claimReward recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x6532f9cc71e41f7238ba2661948303fdc3e286cf'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x6532f9cc71e41f7238ba2661948303fdc3e286cf'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x6532f9cc71e41f7238ba2661948303fdc3e286cf'
  file: src/UBDValidator.sol
  line: 52
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x6532f9cc71e41f7238ba2661948303fdc3e286cf'
  fn: signer()(address)
  is: '0x5c6c2d9e324ff674def8e302c8557a525af92155'
  says: The signer it keeps in storage is 0x5c6c2d9e324ff674def8e302c8557a525af92155 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x5c6c2d9e324ff674def8e302c8557a525af92155'
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

UBDValidator accepts a call to claimReward only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [claimReward](https://etherscan.io/address/0x6532f9cc71e41f7238ba2661948303fdc3e286cf#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x6532f9cc71e41f7238ba2661948303fdc3e286cf#code) changes the signer; only the owner can call it.
- The signer at the block is [0x5c6c…2155](https://etherscan.io/address/0x5c6c2d9e324ff674def8e302c8557a525af92155), an account without code.

## Reviewer notes

### Mechanism

claimReward (src/UBDValidator.sol, line 31) recovers a signer on line 36 and tests it on line 36 against the signer it keeps in storage (signer() returns 0x5c6c2d9e324ff674def8e302c8557a525af92155). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (src/UBDValidator.sol, line 52) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-08-02, recovering 0x5c6c…2155; 0 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
