---
id: mintmanager-bce0c70a-rotate-signer-before-migrating
format: 2
title: 'MintManager: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbce0c70a10d374f0fcda6d37274915f6a8134286'
  name: MintManager
  code: verified
  code_url: https://etherscan.io/address/0xbce0c70a10d374f0fcda6d37274915f6a8134286#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 1805
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Before a signer's account moves to real code, use addSigner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xbce0c70a10d374f0fcda6d37274915f6a8134286'
  file: contracts/Common/BaseManager.sol
  line: 61
  has: (address recovered, ECDSA.RecoverError error) = ECDSA.tryRecover(_hashTypedDataV4(keccak256(encodeData)),
    sign
  says: checkSign recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xbce0c70a10d374f0fcda6d37274915f6a8134286'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xbce0c70a10d374f0fcda6d37274915f6a8134286'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xbce0c70a10d374f0fcda6d37274915f6a8134286'
  file: contracts/Common/BaseManager.sol
  line: 62
  has: return (signers[recovered] && error == ECDSA.RecoverError.NoError, recovered) ;
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xbce0c70a10d374f0fcda6d37274915f6a8134286'
  file: contracts/Common/BaseManager.sol
  line: 45
  has: function addSigner
  says: addSigner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x8efbc22e5d6bef7a54d802093d10f27a0fe69dbc'
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

MintManager checks an ECDSA signature in checkSign and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addSigner changes who may sign.

## Evidence

- [checkSign](https://etherscan.io/address/0xbce0c70a10d374f0fcda6d37274915f6a8134286#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [addSigner](https://etherscan.io/address/0xbce0c70a10d374f0fcda6d37274915f6a8134286#code) changes who may sign; only a role holder can call it.
- The address recovered in its latest signature check on record is [0x8efb…9dbc](https://etherscan.io/address/0x8efbc22e5d6bef7a54d802093d10f27a0fe69dbc), an account without code.

## Reviewer notes

### Mechanism

checkSign (contracts/Common/BaseManager.sol, line 59) recovers a signer on line 61 and tests it on line 62 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. addSigner (contracts/Common/BaseManager.sol, line 45) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-06-07, recovering 0x8efb…9dbc; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
