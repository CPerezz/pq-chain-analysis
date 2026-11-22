---
id: validator-f787128e-rotate-signer-before-migrating
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
  address: '0xf787128e3eb8161174944117b9fe1204a22097fb'
  name: Validator
  code: verified
  code_url: https://etherscan.io/address/0xf787128e3eb8161174944117b9fe1204a22097fb#code
  copies: 1
  upgradeable: 'no'
  admin: '0x782bd59d45cf49edd64e6c9ba3a0bc32f9d2b1d3'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 230
impact: liveness
action: Replace the signer with setOracle before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xf787128e3eb8161174944117b9fe1204a22097fb'
  file: project:/contracts/Validator.sol
  line: 88
  has: 'require(recoverSigner(prefixed(hash), signature) == oracle, "Validator: invalid signature");'
  says: createUnlock recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xf787128e3eb8161174944117b9fe1204a22097fb'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xf787128e3eb8161174944117b9fe1204a22097fb'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xf787128e3eb8161174944117b9fe1204a22097fb'
  file: project:/contracts/Validator.sol
  line: 96
  has: function setOracle
  says: setOracle changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xccb4bdffafe90a90e1a06a3307b59394d5ddaefb'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x7db78603b0dac549011a51a429f03c6f018b25d0af07a82f048590030bd3be5a'
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

- [createUnlock](https://etherscan.io/address/0xf787128e3eb8161174944117b9fe1204a22097fb#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setOracle](https://etherscan.io/address/0xf787128e3eb8161174944117b9fe1204a22097fb#code) changes the signer; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x7db78603b0dac549011a51a429f03c6f018b25d0af07a82f048590030bd3be5a) on record recovered [0xccb4…aefb](https://etherscan.io/address/0xccb4bdffafe90a90e1a06a3307b59394d5ddaefb), an account without code.

## Reviewer notes

### Mechanism

createUnlock (project:/contracts/Validator.sol, line 71) recovers a signer on line 88 and tests it on line 88 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setOracle (project:/contracts/Validator.sol, line 96) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0xccb4…aefb; 230 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
