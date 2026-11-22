---
id: collectioncore-dfc29398-rotate-signer-before-migrating
format: 2
title: 'CollectionCore: no signer is set; replace a later one before it takes real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing can break while no signer is set; one set later can be replaced before its account moves
  to real code.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xdfc29398419b0719c2478b382bb642a7936e326f'
  name: CollectionCore
  code: verified
  code_url: https://etherscan.io/address/0xdfc29398419b0719c2478b382bb642a7936e326f#code
  copies: 1
  upgradeable: 'no'
  admin: '0x91e6a1209d6abd0757649aea024a17d2a2143982'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: If a signer is set again, replace it with setSignerAddress before its account moves to real code.
evidence_level: source
checks:
- id: recover
  source: '0xdfc29398419b0719c2478b382bb642a7936e326f'
  file: CollectionCore.sol
  line: 1892
  has: address addressWhoSigned = encodedRequest.recover(request.signature);
  says: mintTokens recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xdfc29398419b0719c2478b382bb642a7936e326f'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xdfc29398419b0719c2478b382bb642a7936e326f'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xdfc29398419b0719c2478b382bb642a7936e326f'
  file: CollectionCore.sol
  line: 1893
  has: require(addressWhoSigned == signerAddress, "sig error");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xdfc29398419b0719c2478b382bb642a7936e326f'
  file: CollectionCore.sol
  line: 1840
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xdfc29398419b0719c2478b382bb642a7936e326f'
  fn: signerAddress()(address)
  is: '0x0000000000000000000000000000000000000000'
  says: no signer is set at the block
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

CollectionCore accepts a call to mintTokens only with an ECDSA signature of the signer it keeps in storage. No signer is set at the block; setSignerAddress sets one. A signer set later is refused once its account takes real code; an EIP-7702 delegation keeps working.

## Evidence

- [mintTokens](https://etherscan.io/address/0xdfc29398419b0719c2478b382bb642a7936e326f#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0xdfc29398419b0719c2478b382bb642a7936e326f#code) sets the signer.
- No signer is set at the block: [signerAddress()](https://etherscan.io/address/0xdfc29398419b0719c2478b382bb642a7936e326f#readContract) returns the zero address.

## Reviewer notes

### Mechanism

mintTokens (CollectionCore.sol, line 1882) recovers a signer on line 1892 and tests it on line 1893 against the signer it keeps in storage (signerAddress() returns 0x0000000000000000000000000000000000000000). Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (CollectionCore.sol, line 1840) writes it. No signer is set at the block. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 5 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
