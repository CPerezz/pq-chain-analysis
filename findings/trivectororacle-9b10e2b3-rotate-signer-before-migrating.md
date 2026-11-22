---
id: trivectororacle-9b10e2b3-rotate-signer-before-migrating
format: 2
title: 'TriVectorOracle: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9b10e2b35c094cdc9df89275cb3bbee7744c1ea7'
  name: TriVectorOracle
  code: verified
  code_url: https://etherscan.io/address/0x9b10e2b35c094cdc9df89275cb3bbee7744c1ea7#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 21
impact: liveness
action: Before a signer's account moves to real code, use addSigner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x9b10e2b35c094cdc9df89275cb3bbee7744c1ea7'
  file: src/oracle/TriVectorOracle.sol
  line: 466
  has: ECDSA.tryRecover(_digest(asset, quote.priceE18, quote.timestamp), quote.signature);
  says: _readCex recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x9b10e2b35c094cdc9df89275cb3bbee7744c1ea7'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x9b10e2b35c094cdc9df89275cb3bbee7744c1ea7'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x9b10e2b35c094cdc9df89275cb3bbee7744c1ea7'
  file: src/oracle/TriVectorOracle.sol
  line: 467
  has: if (err != ECDSA.RecoverError.NoError || !isSigner[signer]) return (false, 0);
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x9b10e2b35c094cdc9df89275cb3bbee7744c1ea7'
  file: src/oracle/TriVectorOracle.sol
  line: 313
  has: function addSigner
  says: addSigner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x8f8e605d97a242e9ce9afa49c971d8386a66e53e'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x70eb0884a76c480da5c72cafaf6a47a91fe20b4843442e9fc38d2aa805ce4f3e'
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

TriVectorOracle checks an ECDSA signature in _readCex and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addSigner changes who may sign.

## Evidence

- [_readCex](https://etherscan.io/address/0x9b10e2b35c094cdc9df89275cb3bbee7744c1ea7#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [addSigner](https://etherscan.io/address/0x9b10e2b35c094cdc9df89275cb3bbee7744c1ea7#code) changes who may sign; only a role holder can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x70eb0884a76c480da5c72cafaf6a47a91fe20b4843442e9fc38d2aa805ce4f3e) on record recovered [0x8f8e…e53e](https://etherscan.io/address/0x8f8e605d97a242e9ce9afa49c971d8386a66e53e), an account without code.

## Reviewer notes

### Mechanism

_readCex (src/oracle/TriVectorOracle.sol, line 448) recovers a signer on line 466 and tests it on line 467 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. addSigner (src/oracle/TriVectorOracle.sol, line 313) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-05, recovering 0x8f8e…e53e; 21 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
