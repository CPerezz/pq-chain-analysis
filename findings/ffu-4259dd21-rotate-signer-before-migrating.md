---
id: ffu-4259dd21-rotate-signer-before-migrating
format: 2
title: 'FFU: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4259dd21b7b45e5ac66443391a6e489c9d1665b4'
  name: FFU
  code: verified
  code_url: https://etherscan.io/address/0x4259dd21b7b45e5ac66443391a6e489c9d1665b4#code
  copies: 1
  upgradeable: 'no'
  admin: '0xb767864f566f97bbb4cd83a0c90b5d9050b27d19'
value:
  usd: 244
  basis: held
activity:
  txs_90d: 30
impact: liveness
action: Replace the signer with configure before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x4259dd21b7b45e5ac66443391a6e489c9d1665b4'
  file: contracts/FFU.sol
  line: 75
  has: 'require(signature.length > 0 && recoverSignerAddress(_msgSender(), signature) == authorizedSigner, "tx sender '
  says: presale recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x4259dd21b7b45e5ac66443391a6e489c9d1665b4'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x4259dd21b7b45e5ac66443391a6e489c9d1665b4'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x4259dd21b7b45e5ac66443391a6e489c9d1665b4'
  file: contracts/FFU.sol
  line: 39
  has: function configure
  says: configure changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x4259dd21b7b45e5ac66443391a6e489c9d1665b4'
  fn: authorizedSigner()(address)
  is: '0x722fb9a301c89c84e4d7fa70d5b1825e6225edc6'
  says: The signer it keeps in storage is 0x722fb9a301c89c84e4d7fa70d5b1825e6225edc6 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x722fb9a301c89c84e4d7fa70d5b1825e6225edc6'
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

FFU accepts a call to presale only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. configure changes the signer.

## Evidence

- [presale](https://etherscan.io/address/0x4259dd21b7b45e5ac66443391a6e489c9d1665b4#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [configure](https://etherscan.io/address/0x4259dd21b7b45e5ac66443391a6e489c9d1665b4#code) changes the signer; only the owner can call it.
- The signer at the block is [0x722f…edc6](https://etherscan.io/address/0x722fb9a301c89c84e4d7fa70d5b1825e6225edc6), an account without code.

## Reviewer notes

### Mechanism

presale (contracts/FFU.sol, line 73) recovers a signer on line 75 and tests it on line 75 against the signer it keeps in storage (authorizedSigner() returns 0x722fb9a301c89c84e4d7fa70d5b1825e6225edc6). Neither isValidSignature selector is in the code, so that account is never asked. configure (contracts/FFU.sol, line 39) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-10-09, recovering 0x722f…edc6; 30 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
