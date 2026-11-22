---
id: invoice-52174932-rotate-signer-before-migrating
format: 2
title: 'Invoice: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5217493257fcbf209580342e6929e20d2ac914f1'
  name: Invoice
  code: verified
  code_url: https://etherscan.io/address/0x5217493257fcbf209580342e6929e20d2ac914f1#code
  copies: 1
  upgradeable: 'no'
  admin: '0x891ad309b9bab30cee3ef001ac73178812b6de08'
value:
  usd: 27302
  basis: held
activity:
  txs_90d: 6243
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x5217493257fcbf209580342e6929e20d2ac914f1'
  file: Invoice.sol
  line: 50
  has: isValid = isValid && (ecrecover(payloadHash, v, r, s) == quoteSigner);
  says: isValidPayment recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x5217493257fcbf209580342e6929e20d2ac914f1'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x5217493257fcbf209580342e6929e20d2ac914f1'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x5217493257fcbf209580342e6929e20d2ac914f1'
  file: Invoice.sol
  line: 115
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x5217493257fcbf209580342e6929e20d2ac914f1'
  fn: quoteSigner()(address)
  is: '0xa97ceb180ca61d124b6a4aadc5530bc53198922f'
  says: The signer it keeps in storage is 0xa97ceb180ca61d124b6a4aadc5530bc53198922f at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xa97ceb180ca61d124b6a4aadc5530bc53198922f'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x6958f0e4bbc9874e83d575a936a09c65238beb2cddce0f35ec87febf0d2404e7'
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

Invoice checks an ECDSA signature in isValidPayment and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [isValidPayment](https://etherscan.io/address/0x5217493257fcbf209580342e6929e20d2ac914f1#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x5217493257fcbf209580342e6929e20d2ac914f1#code) changes the signer.
- The signer at the block is [0xa97c…922f](https://etherscan.io/address/0xa97ceb180ca61d124b6a4aadc5530bc53198922f), an account without code.

## Reviewer notes

### Mechanism

isValidPayment (Invoice.sol, line 33) recovers a signer on line 50 and tests it on line 50 against the signer it keeps in storage (quoteSigner() returns 0xa97ceb180ca61d124b6a4aadc5530bc53198922f). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (Invoice.sol, line 115) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-18, recovering 0xa97c…922f; 6,243 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
