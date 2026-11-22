---
id: billhavenescrowv9-c40c3573-rotate-signer-before-migrating
format: 2
title: 'BillHavenEscrowV9: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc40c3573c79a2d17812aeb25b25b41fbe30fd5d4'
  name: BillHavenEscrowV9
  code: verified
  code_url: https://etherscan.io/address/0x327f1d6bc63a9a196504b57a9d3c2b37f29faae4#code
  proxy_of: '0x327f1d6bc63a9a196504b57a9d3c2b37f29faae4'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 43
impact: liveness
action: Before a signer's account moves to real code, use addOracle so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x327f1d6bc63a9a196504b57a9d3c2b37f29faae4'
  file: contracts/libraries/SettlementLib.sol
  line: 332
  has: signer = ECDSA.recover(ethSignedHash, _signature);
  says: verifyOracle recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x327f1d6bc63a9a196504b57a9d3c2b37f29faae4'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x327f1d6bc63a9a196504b57a9d3c2b37f29faae4'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x327f1d6bc63a9a196504b57a9d3c2b37f29faae4'
  file: contracts/libraries/SettlementLib.sol
  line: 334
  has: if (_signature.length != 65) revert InvalidSignature();
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x327f1d6bc63a9a196504b57a9d3c2b37f29faae4'
  file: contracts/BillHavenEscrowV9.sol
  line: 932
  has: function addOracle
  says: addOracle changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x664b3d084629ae197712b5335d72024e94d4af6e'
  is: empty
  says: 'the address recovered in the latest signature check on record has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x4387c205eb7e54e394777a0a246a1af424a20904c6fc30227ca500851cc8c1e0'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
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

BillHavenEscrowV9 accepts a call to verifyOracle only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addOracle changes who may sign.

## Evidence

- [verifyOracle](https://etherscan.io/address/0x327f1d6bc63a9a196504b57a9d3c2b37f29faae4#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [addOracle](https://etherscan.io/address/0x327f1d6bc63a9a196504b57a9d3c2b37f29faae4#code) changes who may sign; only a role holder can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x4387c205eb7e54e394777a0a246a1af424a20904c6fc30227ca500851cc8c1e0) on record recovered [0x664b…af6e](https://etherscan.io/address/0x664b3d084629ae197712b5335d72024e94d4af6e), an account without code.

## Reviewer notes

### Mechanism

verifyOracle (contracts/libraries/SettlementLib.sol, line 298) recovers a signer on line 332 and tests it on line 334 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. addOracle (contracts/BillHavenEscrowV9.sol, line 932) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-05, recovering 0x664b…af6e; 43 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
