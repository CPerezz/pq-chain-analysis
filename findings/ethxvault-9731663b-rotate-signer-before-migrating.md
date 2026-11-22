---
id: ethxvault-9731663b-rotate-signer-before-migrating
format: 2
title: 'EthXVault: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9731663b54c9c29acdc4c5f981b9049de39eedf1'
  name: EthXVault
  code: verified
  code_url: https://etherscan.io/address/0x9731663b54c9c29acdc4c5f981b9049de39eedf1#code
  copies: 1
  upgradeable: 'no'
  admin: '0xd325ae8a67fcfbbd79f797cde2b192f74a403530'
value:
  usd: 4
  basis: held
activity:
  txs_90d: 65
impact: liveness
action: Replace the signer with setVerifier before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x9731663b54c9c29acdc4c5f981b9049de39eedf1'
  file: EthXpay.sol
  line: 86
  has: address recovered=digest.toEthSignedMessageHash().recover(signature);
  says: claim recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x9731663b54c9c29acdc4c5f981b9049de39eedf1'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x9731663b54c9c29acdc4c5f981b9049de39eedf1'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x9731663b54c9c29acdc4c5f981b9049de39eedf1'
  file: EthXpay.sol
  line: 87
  has: require(recovered==verifier,"bad proof");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x9731663b54c9c29acdc4c5f981b9049de39eedf1'
  file: EthXpay.sol
  line: 62
  has: function setVerifier
  says: setVerifier changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x9731663b54c9c29acdc4c5f981b9049de39eedf1'
  fn: verifier()(address)
  is: '0x4e013bdfccd98726684a1c43df6fc4bc30d61bdb'
  says: The signer it keeps in storage is 0x4e013bdfccd98726684a1c43df6fc4bc30d61bdb at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x4e013bdfccd98726684a1c43df6fc4bc30d61bdb'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xccfe7a6cd14e0e075b5fc2cf404a04fc84ce07e48c244ebfce958bde2bf8e509'
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

EthXVault accepts a call to claim only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setVerifier changes the signer.

## Evidence

- [claim](https://etherscan.io/address/0x9731663b54c9c29acdc4c5f981b9049de39eedf1#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setVerifier](https://etherscan.io/address/0x9731663b54c9c29acdc4c5f981b9049de39eedf1#code) changes the signer; only the owner can call it.
- The signer at the block is [0x4e01…1bdb](https://etherscan.io/address/0x4e013bdfccd98726684a1c43df6fc4bc30d61bdb), an account without code.

## Reviewer notes

### Mechanism

claim (EthXpay.sol, line 82) recovers a signer on line 86 and tests it on line 87 against the signer it keeps in storage (verifier() returns 0x4e013bdfccd98726684a1c43df6fc4bc30d61bdb). Neither isValidSignature selector is in the code, so that account is never asked. setVerifier (EthXpay.sol, line 62) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-05, recovering 0x4e01…1bdb; 65 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
