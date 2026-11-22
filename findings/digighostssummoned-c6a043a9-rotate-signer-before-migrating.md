---
id: digighostssummoned-c6a043a9-rotate-signer-before-migrating
format: 2
title: 'DigiGhostsSummoned: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc6a043a97986eabc761db0616513546043ee489a'
  name: DigiGhostsSummoned
  code: verified
  code_url: https://etherscan.io/address/0xc6a043a97986eabc761db0616513546043ee489a#code
  copies: 1
  upgradeable: 'no'
  admin: '0xafafc4a8ff33a0fef37f261a9a466363cf58aafd'
value:
  usd: 202
  basis: held
activity:
  txs_90d: 214
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xc6a043a97986eabc761db0616513546043ee489a'
  file: contracts/DigiGhostsSummoned.sol
  line: 84
  has: if (ECDSA.recover(digest, sig) != signer) revert BadSignature();
  says: mint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc6a043a97986eabc761db0616513546043ee489a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc6a043a97986eabc761db0616513546043ee489a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xc6a043a97986eabc761db0616513546043ee489a'
  file: contracts/DigiGhostsSummoned.sol
  line: 127
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xc6a043a97986eabc761db0616513546043ee489a'
  fn: signer()(address)
  is: '0x7a6f8fb5f941e89a16c004c129c0426285998ab8'
  says: The signer it keeps in storage is 0x7a6f8fb5f941e89a16c004c129c0426285998ab8 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x7a6f8fb5f941e89a16c004c129c0426285998ab8'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x5146aa21b9b89a65990854b3fb9b2e099a198a54ee170ac8c40372ac115996a4'
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

DigiGhostsSummoned accepts a call to mint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [mint](https://etherscan.io/address/0xc6a043a97986eabc761db0616513546043ee489a#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xc6a043a97986eabc761db0616513546043ee489a#code) changes the signer; only the owner can call it.
- The signer at the block is [0x7a6f…8ab8](https://etherscan.io/address/0x7a6f8fb5f941e89a16c004c129c0426285998ab8), an account without code.

## Reviewer notes

### Mechanism

mint (contracts/DigiGhostsSummoned.sol, line 77) recovers a signer on line 84 and tests it on line 84 against the signer it keeps in storage (signer() returns 0x7a6f8fb5f941e89a16c004c129c0426285998ab8). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/DigiGhostsSummoned.sol, line 127) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-14, recovering 0x7a6f…8ab8; 214 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
