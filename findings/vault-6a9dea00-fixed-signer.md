---
id: vault-6a9dea00-fixed-signer
format: 2
title: 'Vault: its signer cannot be replaced and must not take real code'
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
  address: '0x6a9dea00465e875ce9fcea70a67432a1d274973e'
  name: Vault
  code: verified
  code_url: https://etherscan.io/address/0x6a9dea00465e875ce9fcea70a67432a1d274973e#code
  copies: 2
  family: e0d779e6726e8712208da0f18041c02c
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0x6a9dea00465e875ce9fcea70a67432a1d274973e'
  file: contracts/Vault.sol
  line: 75
  has: require(data.toEthSignedMessageHash().recover(_signature) == serverSigner, "Invalid signature. Signature
    sourc
  says: changeRecipientAddress recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x6a9dea00465e875ce9fcea70a67432a1d274973e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x6a9dea00465e875ce9fcea70a67432a1d274973e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: written
  source: '0x6a9dea00465e875ce9fcea70a67432a1d274973e'
  file: contracts/Vault.sol
  line: 57
  has: serverSigner = _serverSigner;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xd06470c8358bc33d4fad5e2657170880b2ad0938'
  is: empty
  says: 'the address recovered in the latest signature check on record has no code: an ECDSA key controls it'
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
  rating: HIGH
reviews: []
related: []
---

## What happens

Vault accepts a call to changeRecipientAddress only with an ECDSA signature of a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [changeRecipientAddress](https://etherscan.io/address/0x6a9dea00465e875ce9fcea70a67432a1d274973e#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0x6a9dea00465e875ce9fcea70a67432a1d274973e#code); the verified source has no function that writes it afterwards.
- The address recovered in its latest signature check on record is [0xd064…0938](https://etherscan.io/address/0xd06470c8358bc33d4fad5e2657170880b2ad0938), an account without code.

## Reviewer notes

### Mechanism

changeRecipientAddress (contracts/Vault.sol, line 69) recovers a signer on line 75 and tests it on line 75 against a signer fixed at deployment. Neither isValidSignature selector is in the code, so that account is never asked. serverSigner is written on line 57 of contracts/Vault.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-10-16, recovering 0xd064…0938; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
