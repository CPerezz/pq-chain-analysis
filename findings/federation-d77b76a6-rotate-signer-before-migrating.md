---
id: federation-d77b76a6-rotate-signer-before-migrating
format: 2
title: 'Federation: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd77b76a65a19715bdcb5ee223928af2919836a3e'
  name: Federation
  code: verified
  code_url: https://etherscan.io/address/0xd77b76a65a19715bdcb5ee223928af2919836a3e#code
  copies: 2
  family: 366cdfb1629a7b3d769af750e32870a7
  upgradeable: 'no'
  admin: '0x062c74f9d27b1178bb76186c1756128ccb3ccd2e'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 78
impact: liveness
action: Before a signer's account moves to real code, use addMember so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xd77b76a65a19715bdcb5ee223928af2919836a3e'
  file: Federation.sol
  line: 847
  has: address signer = ECDSA.recover(hash, signaturesInfos[i].signature);
  says: processSignedTransaction recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd77b76a65a19715bdcb5ee223928af2919836a3e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd77b76a65a19715bdcb5ee223928af2919836a3e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xd77b76a65a19715bdcb5ee223928af2919836a3e'
  file: Federation.sol
  line: 998
  has: function addMember
  says: addMember changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x8a2241ce21afa71515a73f82d09e690b85603f35'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x0f66e5afa697a954b8c671d21a48a7c941f933ff286bae5ced23de5e65206252'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

Federation accepts a call to processSignedTransaction only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addMember changes who may sign.

## Evidence

- [processSignedTransaction](https://etherscan.io/address/0xd77b76a65a19715bdcb5ee223928af2919836a3e#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [addMember](https://etherscan.io/address/0xd77b76a65a19715bdcb5ee223928af2919836a3e#code) changes who may sign; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x0f66e5afa697a954b8c671d21a48a7c941f933ff286bae5ced23de5e65206252) on record recovered [0x8a22…3f35](https://etherscan.io/address/0x8a2241ce21afa71515a73f82d09e690b85603f35), an account without code.

## Reviewer notes

### Mechanism

processSignedTransaction (Federation.sol, line 794) recovers a signer on line 847 and tests it on line 847 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. addMember (Federation.sol, line 998) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-04, recovering 0x8a22…3f35; 78 transactions called the address in the 90 days before the block. 4 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
