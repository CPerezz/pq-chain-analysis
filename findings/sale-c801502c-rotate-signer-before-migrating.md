---
id: sale-c801502c-rotate-signer-before-migrating
format: 2
title: 'Sale: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc801502c574eec48b11b3ec93fdf73752d7f63cb'
  name: Sale
  code: verified
  code_url: https://etherscan.io/address/0xc801502c574eec48b11b3ec93fdf73752d7f63cb#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 2774
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setVerifier before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xc801502c574eec48b11b3ec93fdf73752d7f63cb'
  file: contracts/main/Sale.sol
  line: 272
  has: address recoveredSigner = hash.recover(v, r, s);
  says: withdrawDepositorsReferralDeposit recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc801502c574eec48b11b3ec93fdf73752d7f63cb'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc801502c574eec48b11b3ec93fdf73752d7f63cb'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xc801502c574eec48b11b3ec93fdf73752d7f63cb'
  file: contracts/main/Sale.sol
  line: 274
  has: require(recoveredSigner == _verifier, InvalidVerifier());
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xc801502c574eec48b11b3ec93fdf73752d7f63cb'
  file: contracts/main/Sale.sol
  line: 182
  has: function setVerifier
  says: setVerifier changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x31b63463497565dd57b64009bba45e0e75af968b'
  is: empty
  says: the address recovered in the latest signature check on record has no code
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

Sale accepts a call to withdrawDepositorsReferralDeposit only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setVerifier changes the signer.

## Evidence

- [withdrawDepositorsReferralDeposit](https://etherscan.io/address/0xc801502c574eec48b11b3ec93fdf73752d7f63cb#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setVerifier](https://etherscan.io/address/0xc801502c574eec48b11b3ec93fdf73752d7f63cb#code) changes the signer; only a role holder can call it.
- The address recovered in its latest signature check on record is [0x31b6…968b](https://etherscan.io/address/0x31b63463497565dd57b64009bba45e0e75af968b), an account without code.

## Reviewer notes

### Mechanism

withdrawDepositorsReferralDeposit (contracts/main/Sale.sol, line 266) recovers a signer on line 272 and tests it on line 274 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setVerifier (contracts/main/Sale.sol, line 182) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-12-31, recovering 0x31b6…968b; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
