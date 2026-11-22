---
id: gratefuldead-a6dad779-rotate-signer-before-migrating
format: 2
title: 'GratefulDead: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa6dad7791994da79a7957bc3a9b3963d827f033e'
  name: GratefulDead
  code: verified
  code_url: https://etherscan.io/address/0xa6dad7791994da79a7957bc3a9b3963d827f033e#code
  copies: 2
  family: 56dd06ddeb2e0a75d70bba2249a0b064
  upgradeable: 'no'
  admin: '0x98b1b1f256b6512695973c0fa9fe512540fa4898'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 6
impact: liveness
action: Before a signer's account moves to real code, use freeMintAndExtra so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xa6dad7791994da79a7957bc3a9b3963d827f033e'
  file: contracts/GratefulDead.sol
  line: 129
  has: )).recover(signature), "signer address mismatch");
  says: freeMintAndExtra recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xa6dad7791994da79a7957bc3a9b3963d827f033e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xa6dad7791994da79a7957bc3a9b3963d827f033e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xa6dad7791994da79a7957bc3a9b3963d827f033e'
  file: contracts/GratefulDead.sol
  line: 130
  has: require(msg.sender == tx.origin);
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xa6dad7791994da79a7957bc3a9b3963d827f033e'
  file: contracts/GratefulDead.sol
  line: 123
  has: function freeMintAndExtra
  says: freeMintAndExtra changes who may sign
  for:
  - action
  - evidence-2
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

GratefulDead accepts a call to freeMintAndExtra only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. freeMintAndExtra changes who may sign.

## Evidence

- [freeMintAndExtra](https://etherscan.io/address/0xa6dad7791994da79a7957bc3a9b3963d827f033e#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [freeMintAndExtra](https://etherscan.io/address/0xa6dad7791994da79a7957bc3a9b3963d827f033e#code) changes who may sign.

## Reviewer notes

### Mechanism

freeMintAndExtra (contracts/GratefulDead.sol, line 123) recovers a signer on line 129 and tests it on line 130 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. freeMintAndExtra (contracts/GratefulDead.sol, line 123) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-08-09; 6 transactions called the address in the 90 days before the block. 6 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
