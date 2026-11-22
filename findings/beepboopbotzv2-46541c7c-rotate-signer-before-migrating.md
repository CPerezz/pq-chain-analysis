---
id: beepboopbotzv2-46541c7c-rotate-signer-before-migrating
format: 2
title: 'BeepBoopBotzV2: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x46541c7c9904112e5e62847bebb148051f71bafa'
  name: BeepBoopBotzV2
  code: verified
  code_url: https://etherscan.io/address/0x93d9456d08ae976a3b37ab96f414eb2f8746e21c#code
  proxy_of: '0x93d9456d08ae976a3b37ab96f414eb2f8746e21c'
  copies: 2
  family: eb37ee2d038cb7a57a53f1bab3776c1b
  upgradeable: 'yes'
  admin: '0x88517740b86f3ebf4c7a9ac5808b4986b289f9ad'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 15
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x93d9456d08ae976a3b37ab96f414eb2f8746e21c'
  file: src/BeepBoopBotzV2/BeepBoopBotzV2.sol
  line: 114
  has: address signer = data.toEthSignedMessageHash().recover(signature);
  says: evolve recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x93d9456d08ae976a3b37ab96f414eb2f8746e21c'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x93d9456d08ae976a3b37ab96f414eb2f8746e21c'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x93d9456d08ae976a3b37ab96f414eb2f8746e21c'
  file: src/BeepBoopBotzV2/BeepBoopBotzV2.sol
  line: 115
  has: require(_signer == signer, "Unauthorized");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x93d9456d08ae976a3b37ab96f414eb2f8746e21c'
  file: src/BeepBoopBotzV2/BeepBoopBotzV2.sol
  line: 222
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x9b3a24c4ef7aed90460fe007faa77b971d8a13a7'
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

BeepBoopBotzV2 accepts a call to evolve only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [evolve](https://etherscan.io/address/0x93d9456d08ae976a3b37ab96f414eb2f8746e21c#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x93d9456d08ae976a3b37ab96f414eb2f8746e21c#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0x9b3a…13a7](https://etherscan.io/address/0x9b3a24c4ef7aed90460fe007faa77b971d8a13a7), an account without code.

## Reviewer notes

### Mechanism

evolve (src/BeepBoopBotzV2/BeepBoopBotzV2.sol, line 105) recovers a signer on line 114 and tests it on line 115 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSigner (src/BeepBoopBotzV2/BeepBoopBotzV2.sol, line 222) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-05-26, recovering 0x9b3a…13a7; 15 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
