---
id: dhvessel-5ddb2ca0-rotate-signer-before-migrating
format: 2
title: 'DHVessel: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5ddb2ca013ebe1c0f2f9ab8ad3d3d4bccdb66b35'
  name: DHVessel
  code: verified
  code_url: https://etherscan.io/address/0x5ddb2ca013ebe1c0f2f9ab8ad3d3d4bccdb66b35#code
  copies: 1
  upgradeable: 'no'
  admin: '0xd2e2e23b9f82e1351cb38987da181c22d0492aab'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 20
impact: liveness
action: Replace the signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x5ddb2ca013ebe1c0f2f9ab8ad3d3d4bccdb66b35'
  file: contracts/DHVessel.sol
  line: 50
  has: 'require(_signerAddress == recoverAddress(msg.sender, tokenType, dhTokenId, ticketId, signature), "user cannot '
  says: evolve recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x5ddb2ca013ebe1c0f2f9ab8ad3d3d4bccdb66b35'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x5ddb2ca013ebe1c0f2f9ab8ad3d3d4bccdb66b35'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x5ddb2ca013ebe1c0f2f9ab8ad3d3d4bccdb66b35'
  file: contracts/DHVessel.sol
  line: 81
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xa2bcd5cc70e1e568dd31c475fcb19e8c367b2202'
  is: delegation
  target: '0x0727ca41efc85f75cef26ee48f825893b4836786'
  says: 'the address recovered in the latest signature check on record holds an EIP-7702 delegation: an ECDSA key
    still controls it'
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

DHVessel accepts a call to evolve only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddress changes the signer.

## Evidence

- [evolve](https://etherscan.io/address/0x5ddb2ca013ebe1c0f2f9ab8ad3d3d4bccdb66b35#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0x5ddb2ca013ebe1c0f2f9ab8ad3d3d4bccdb66b35#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0xa2bc…2202](https://etherscan.io/address/0xa2bcd5cc70e1e568dd31c475fcb19e8c367b2202), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

evolve (contracts/DHVessel.sol, line 47) recovers a signer on line 50 and tests it on line 50 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (contracts/DHVessel.sol, line 81) writes it. The signer's account holds an EIP-7702 delegation to 0x0727ca41efc85f75cef26ee48f825893b4836786. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-11-04, recovering 0xa2bc…2202; 20 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
