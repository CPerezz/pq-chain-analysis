---
id: onesig-be634b03-rotate-signer-before-migrating
format: 2
title: 'OneSig: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbe634b030feaab661300667eaf82510a3a025413'
  name: OneSig
  code: verified
  code_url: https://etherscan.io/address/0xbe634b030feaab661300667eaf82510a3a025413#code
  copies: 23
  family: 3b53e50841ae962320e65ef130b9d02a
  upgradeable: 'no'
value:
  usd: 663
  basis: held
activity:
  txs_90d: 178
impact: liveness
action: Before a signer's account moves to real code, use setSigner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xbe634b030feaab661300667eaf82510a3a025413'
  file: contracts/MultiSig.sol
  line: 180
  has: address currentSigner = ECDSA.recover(_digest, signature);
  says: verifyNSignatures recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xbe634b030feaab661300667eaf82510a3a025413'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xbe634b030feaab661300667eaf82510a3a025413'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xbe634b030feaab661300667eaf82510a3a025413'
  file: contracts/MultiSig.sol
  line: 185
  has: if (!isSigner(currentSigner)) revert SignerNotFound(currentSigner);
  says: the recovered address must be an address in the signer set it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xbe634b030feaab661300667eaf82510a3a025413'
  file: contracts/MultiSig.sol
  line: 112
  has: function setSigner
  says: setSigner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x00bd5c12508a346e4355c8ee085ae2bcb742e814'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x5e8100a4c7d4a9075d170d56ae0568a417dad169b693300805997ce44ed8398a'
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

OneSig checks an ECDSA signature in verifyNSignatures and accepts only an address in the signer set it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes who may sign.

## Evidence

- [verifyNSignatures](https://etherscan.io/address/0xbe634b030feaab661300667eaf82510a3a025413#code) recovers the signature with ECDSA and accepts only an address in the signer set it keeps; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xbe634b030feaab661300667eaf82510a3a025413#code) changes who may sign (through _addSigner).
- Its latest signed [transaction](https://etherscan.io/tx/0x5e8100a4c7d4a9075d170d56ae0568a417dad169b693300805997ce44ed8398a) on record recovered [0x00bd…e814](https://etherscan.io/address/0x00bd5c12508a346e4355c8ee085ae2bcb742e814), an account without code.

## Reviewer notes

### Mechanism

verifyNSignatures (contracts/MultiSig.sol, line 167) recovers a signer on line 180 and tests it on line 185 against an address in the signer set it keeps. Neither isValidSignature selector is in the code, so that account is never asked. _addSigner (contracts/MultiSig.sol, line 126) writes it, called by setSigner. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 23 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0x00bd…e814; 178 transactions called the address in the 90 days before the block. 8 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
