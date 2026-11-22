---
id: pixelpups-c86f5685-fixed-signer
format: 2
title: 'PixelPups: its signer cannot be replaced and must not take real code'
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if a signer's account takes real code; the signer is fixed, so a new contract is then
  needed.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc86f568522832eb7f031d77634aca6bc6cd82f68'
  name: PixelPups
  code: verified
  code_url: https://etherscan.io/address/0xc86f568522832eb7f031d77634aca6bc6cd82f68#code
  copies: 1
  upgradeable: 'no'
  admin: '0x6851b1d68ca161e791114a4594004c758f29cbfe'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0xc86f568522832eb7f031d77634aca6bc6cd82f68'
  file: contracts/PixelPups.sol
  line: 58
  has: address signer = ECDSA.recover(hash, _signatureV,  _signatureR,  _signatureS);
  says: mintWhitelist recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc86f568522832eb7f031d77634aca6bc6cd82f68'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc86f568522832eb7f031d77634aca6bc6cd82f68'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xc86f568522832eb7f031d77634aca6bc6cd82f68'
  file: contracts/PixelPups.sol
  line: 60
  has: require(signer == _signerAddress, "Invalid signature");
  says: the recovered address must be a signer fixed at deployment
  for:
  - evidence-1
  - justification
  - what
- id: written
  source: '0xc86f568522832eb7f031d77634aca6bc6cd82f68'
  file: contracts/PixelPups.sol
  line: 31
  has: address public _signerAddress = 0xF6bA99F2E6ce96B74d4df667C01c5ed2EF249be2;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xc86f568522832eb7f031d77634aca6bc6cd82f68'
  fn: _signerAddress()(address)
  is: '0xf6ba99f2e6ce96b74d4df667c01c5ed2ef249be2'
  says: A signer fixed at deployment is 0xf6ba99f2e6ce96b74d4df667c01c5ed2ef249be2 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xf6ba99f2e6ce96b74d4df667c01c5ed2ef249be2'
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

PixelPups accepts a call to mintWhitelist only with an ECDSA signature of a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [mintWhitelist](https://etherscan.io/address/0xc86f568522832eb7f031d77634aca6bc6cd82f68#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0xc86f568522832eb7f031d77634aca6bc6cd82f68#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0xf6ba…9be2](https://etherscan.io/address/0xf6ba99f2e6ce96b74d4df667c01c5ed2ef249be2), an account without code.

## Reviewer notes

### Mechanism

mintWhitelist (contracts/PixelPups.sol, line 52) recovers a signer on line 58 and tests it on line 60 against a signer fixed at deployment (_signerAddress() returns 0xf6ba99f2e6ce96b74d4df667c01c5ed2ef249be2). Neither isValidSignature selector is in the code, so that account is never asked. _signerAddress is written on line 31 of contracts/PixelPups.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-01-08, recovering 0xf6ba…9be2; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
