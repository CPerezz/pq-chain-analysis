---
id: adminwithdrawmanager-5adabde1-rotate-signer-before-migrating
format: 2
title: 'AdminWithdrawManager: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5adabde1b6aedf8f768f782fff1b1cc396416f00'
  name: AdminWithdrawManager
  code: verified
  code_url: https://etherscan.io/address/0x5adabde1b6aedf8f768f782fff1b1cc396416f00#code
  copies: 2
  family: 3c296e91867cd5c9a7b0757169ad18f6
  upgradeable: 'no'
  admin: '0x4c45f70b1d9a7a6d1984daccad74d0e973b73f01'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 255
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x5adabde1b6aedf8f768f782fff1b1cc396416f00'
  file: contracts/periphery/counterfactual/AdminWithdrawManager.sol
  line: 102
  has: if (ECDSA.recover(_hashTypedDataV4(structHash), signature) != signer) revert InvalidSignature();
  says: signedWithdrawToUser recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x5adabde1b6aedf8f768f782fff1b1cc396416f00'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x5adabde1b6aedf8f768f782fff1b1cc396416f00'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x5adabde1b6aedf8f768f782fff1b1cc396416f00'
  file: contracts/periphery/counterfactual/AdminWithdrawManager.sol
  line: 118
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x5adabde1b6aedf8f768f782fff1b1cc396416f00'
  fn: signer()(address)
  is: '0xddb199ca909901299adcab370c3c8212cea80afe'
  says: The signer it keeps in storage is 0xddb199ca909901299adcab370c3c8212cea80afe at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xddb199ca909901299adcab370c3c8212cea80afe'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xe651f57be5e0e9bb4d540065084562b304609e75b60dbeba0b8e32209b928e57'
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

AdminWithdrawManager accepts a call to signedWithdrawToUser only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [signedWithdrawToUser](https://etherscan.io/address/0x5adabde1b6aedf8f768f782fff1b1cc396416f00#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x5adabde1b6aedf8f768f782fff1b1cc396416f00#code) changes the signer; only the owner can call it.
- The signer at the block is [0xddb1…0afe](https://etherscan.io/address/0xddb199ca909901299adcab370c3c8212cea80afe), an account without code.

## Reviewer notes

### Mechanism

signedWithdrawToUser (contracts/periphery/counterfactual/AdminWithdrawManager.sol, line 86) recovers a signer on line 102 and tests it on line 102 against the signer it keeps in storage (signer() returns 0xddb199ca909901299adcab370c3c8212cea80afe). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/periphery/counterfactual/AdminWithdrawManager.sol, line 118) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0xddb1…0afe; 255 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
