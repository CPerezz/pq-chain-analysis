---
id: validator-93746538-rotate-signer-before-migrating
format: 2
title: 'Validator: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x93746538d4519c809827205bd1c2c7a0e15bd74b'
  name: Validator
  code: verified
  code_url: https://etherscan.io/address/0x93746538d4519c809827205bd1c2c7a0e15bd74b#code
  copies: 1
  upgradeable: 'no'
  admin: '0x4be5ef97b7cfd37f536324c7f18a2ffde5892074'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 114
impact: liveness
action: Replace the signer with setOracle before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x93746538d4519c809827205bd1c2c7a0e15bd74b'
  file: Validator.sol
  line: 194
  has: 'require(recoverSigner(prefixed(hash), signature) == oracle, "Validator: invalid signature");'
  says: createUnlock recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x93746538d4519c809827205bd1c2c7a0e15bd74b'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x93746538d4519c809827205bd1c2c7a0e15bd74b'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x93746538d4519c809827205bd1c2c7a0e15bd74b'
  file: Validator.sol
  line: 202
  has: function setOracle
  says: setOracle changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xd513b05905cdd1d5595b384a97ebea15d1e79f97'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xc57cc3ab3cd79b75026336a5ede496e6cef1b561de83a20833c7f6b6e38d070f'
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

Validator accepts a call to createUnlock only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setOracle changes the signer.

## Evidence

- [createUnlock](https://etherscan.io/address/0x93746538d4519c809827205bd1c2c7a0e15bd74b#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setOracle](https://etherscan.io/address/0x93746538d4519c809827205bd1c2c7a0e15bd74b#code) changes the signer; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0xc57cc3ab3cd79b75026336a5ede496e6cef1b561de83a20833c7f6b6e38d070f) on record recovered [0xd513…9f97](https://etherscan.io/address/0xd513b05905cdd1d5595b384a97ebea15d1e79f97), an account without code.

## Reviewer notes

### Mechanism

createUnlock (Validator.sol, line 177) recovers a signer on line 194 and tests it on line 194 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setOracle (Validator.sol, line 202) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-04, recovering 0xd513…9f97; 114 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
