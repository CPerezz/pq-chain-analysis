---
id: yodlrouter-33a57dbf-fixed-signer
format: 2
title: 'YodlRouter: its signer cannot be replaced and must not take real code'
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
  address: '0x33a57dbf2a0141073795114a8abd9acc263c069d'
  name: YodlRouter
  code: verified
  code_url: https://etherscan.io/address/0x33a57dbf2a0141073795114a8abd9acc263c069d#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 1
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0x33a57dbf2a0141073795114a8abd9acc263c069d'
  file: src/AbstractYodlRouter.sol
  line: 253
  has: return ECDSA.recover(ethSignedMessageHash, priceFeed.signature) == RATE_VERIFIER;
  says: verifyRateSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x33a57dbf2a0141073795114a8abd9acc263c069d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x33a57dbf2a0141073795114a8abd9acc263c069d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: written
  source: '0x33a57dbf2a0141073795114a8abd9acc263c069d'
  file: src/AbstractYodlRouter.sol
  line: 18
  has: address public constant RATE_VERIFIER = 0xc71f6e1e4665d319610afA526BE529202cA13bB7;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x33a57dbf2a0141073795114a8abd9acc263c069d'
  fn: RATE_VERIFIER()(address)
  is: '0xc71f6e1e4665d319610afa526be529202ca13bb7'
  says: A signer fixed at deployment is 0xc71f6e1e4665d319610afa526be529202ca13bb7 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xc71f6e1e4665d319610afa526be529202ca13bb7'
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
  rating: MEDIUM
reviews: []
related: []
---

## What happens

YodlRouter checks an ECDSA signature in verifyRateSignature and accepts only a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [verifyRateSignature](https://etherscan.io/address/0x33a57dbf2a0141073795114a8abd9acc263c069d#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0x33a57dbf2a0141073795114a8abd9acc263c069d#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0xc71f…3bb7](https://etherscan.io/address/0xc71f6e1e4665d319610afa526be529202ca13bb7), an account without code.

## Reviewer notes

### Mechanism

verifyRateSignature (src/AbstractYodlRouter.sol, line 245) recovers a signer on line 253 and tests it on line 253 against a signer fixed at deployment (RATE_VERIFIER() returns 0xc71f6e1e4665d319610afa526be529202ca13bb7). Neither isValidSignature selector is in the code, so that account is never asked. RATE_VERIFIER is written on line 18 of src/AbstractYodlRouter.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
