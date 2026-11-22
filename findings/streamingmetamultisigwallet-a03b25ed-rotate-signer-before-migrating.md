---
id: streamingmetamultisigwallet-a03b25ed-rotate-signer-before-migrating
format: 2
title: 'This contract: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa03b25eda6a2c33053bb7c38b56c9baf9b6a0758'
  name: StreamingMetaMultiSigWallet
  code: verified
  code_url: https://etherscan.io/address/0xa03b25eda6a2c33053bb7c38b56c9baf9b6a0758#code
  copies: 4
  family: 82f7ad9fb4b330de556e84f85586e88f
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Before a signer's account moves to real code, use addSigner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xa03b25eda6a2c33053bb7c38b56c9baf9b6a0758'
  file: StreamingMetaMultiSigWallet.sol
  line: 183
  has: address recovered = recover(_hash,signatures[i]);
  says: executeTransaction recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xa03b25eda6a2c33053bb7c38b56c9baf9b6a0758'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xa03b25eda6a2c33053bb7c38b56c9baf9b6a0758'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xa03b25eda6a2c33053bb7c38b56c9baf9b6a0758'
  file: StreamingMetaMultiSigWallet.sol
  line: 147
  has: function addSigner
  says: addSigner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x34aa3f359a9d614239015126635ce7732c18fdf3'
  is: delegation
  target: '0x612373d7003d694220f7800eeaf8e3924c0951d3'
  says: 'the address recovered in the latest signature check on record holds an EIP-7702 delegation: an ECDSA key
    still controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
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

This contract accepts a call to executeTransaction only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addSigner changes who may sign.

## Evidence

- [executeTransaction](https://etherscan.io/address/0xa03b25eda6a2c33053bb7c38b56c9baf9b6a0758#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [addSigner](https://etherscan.io/address/0xa03b25eda6a2c33053bb7c38b56c9baf9b6a0758#code) changes who may sign.
- The address recovered in its latest signature check on record is [0x34aa…fdf3](https://etherscan.io/address/0x34aa3f359a9d614239015126635ce7732c18fdf3), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

executeTransaction (StreamingMetaMultiSigWallet.sol, line 173) recovers a signer on line 183 and tests it on line 183 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. addSigner (StreamingMetaMultiSigWallet.sol, line 147) writes it. The signer's account holds an EIP-7702 delegation to 0x612373d7003d694220f7800eeaf8e3924c0951d3. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 4 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2021-03-03, recovering 0x34aa…fdf3; 0 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
