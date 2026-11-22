---
id: localethereumescrows-09678741-rotate-signer-before-migrating
format: 2
title: 'LocalEthereumEscrows: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x09678741bd50c3e74301f38fbd0136307099ae5d'
  name: LocalEthereumEscrows
  code: verified
  code_url: https://etherscan.io/address/0x09678741bd50c3e74301f38fbd0136307099ae5d#code
  copies: 2
  family: afcdcf8075a5ec2aba20a474929c3d82
  upgradeable: 'no'
  admin: '0x73d599aee68c8c30e07b4c07588d628c64c7afca'
value:
  usd: 8761
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with LocalEthereumEscrows before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x09678741bd50c3e74301f38fbd0136307099ae5d'
  file: LocalEthereumEscrows.sol
  line: 111
  has: require(ecrecover(keccak256(_tradeHash, _paymentWindowInSeconds, _expiry), _v, _r, _s) == relayer);
  says: createEscrow recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x09678741bd50c3e74301f38fbd0136307099ae5d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x09678741bd50c3e74301f38fbd0136307099ae5d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x09678741bd50c3e74301f38fbd0136307099ae5d'
  file: LocalEthereumEscrows.sol
  line: 67
  has: function LocalEthereumEscrows
  says: LocalEthereumEscrows changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x09678741bd50c3e74301f38fbd0136307099ae5d'
  fn: relayer()(address)
  is: '0xf008e2c7a7f16ac706c2e0ebd3f015d442016420'
  says: The signer it keeps in storage is 0xf008e2c7a7f16ac706c2e0ebd3f015d442016420 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xf008e2c7a7f16ac706c2e0ebd3f015d442016420'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
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

LocalEthereumEscrows accepts a call to createEscrow only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. LocalEthereumEscrows changes the signer.

## Evidence

- [createEscrow](https://etherscan.io/address/0x09678741bd50c3e74301f38fbd0136307099ae5d#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [LocalEthereumEscrows](https://etherscan.io/address/0x09678741bd50c3e74301f38fbd0136307099ae5d#code) changes the signer.
- The signer at the block is [0xf008…6420](https://etherscan.io/address/0xf008e2c7a7f16ac706c2e0ebd3f015d442016420), an account without code.

## Reviewer notes

### Mechanism

createEscrow (LocalEthereumEscrows.sol, line 92) recovers a signer on line 111 and tests it on line 111 against the signer it keeps in storage (relayer() returns 0xf008e2c7a7f16ac706c2e0ebd3f015d442016420). Neither isValidSignature selector is in the code, so that account is never asked. LocalEthereumEscrows (LocalEthereumEscrows.sol, line 67) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2020-06-01; 0 transactions called the address in the 90 days before the block. 64711 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
