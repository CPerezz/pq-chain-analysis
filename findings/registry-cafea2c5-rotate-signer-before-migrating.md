---
id: registry-cafea2c5-rotate-signer-before-migrating
format: 2
title: 'Registry: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcafea2c575550512582090aa06d0a069e7236b9e'
  name: Registry
  code: verified
  code_url: https://etherscan.io/address/0xcafeac64cbe73e6e8973b52cdae8982de6fb500e#code
  proxy_of: '0xcafeac64cbe73e6e8973b52cdae8982de6fb500e'
  copies: 2
  family: 0972218b464c483401b1ff1c68664a14
  upgradeable: 'yes'
  admin: '0xcafea6063d4ec6b045d9676e58897c1f0882ca32'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 3163
impact: liveness
action: Before a signer's account moves to real code, use join so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xcafeac64cbe73e6e8973b52cdae8982de6fb500e'
  file: contracts/modules/governance/Registry.sol
  line: 132
  has: address signer = recoverSigner(message, signature);
  says: join recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xcafeac64cbe73e6e8973b52cdae8982de6fb500e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xcafeac64cbe73e6e8973b52cdae8982de6fb500e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xcafeac64cbe73e6e8973b52cdae8982de6fb500e'
  file: contracts/modules/governance/Registry.sol
  line: 133
  has: require(membersMeta.kycAuthAddress == signer, InvalidSignature());
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xcafeac64cbe73e6e8973b52cdae8982de6fb500e'
  file: contracts/modules/governance/Registry.sol
  line: 123
  has: function join
  says: join changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x176c27973e0229501d049de626d50918dda24656'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xe3ce7176ae739040e87ec68e4f6b522faf3c619bf9ac897823b39cf2404542a3'
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

Registry accepts a call to join only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. join changes who may sign.

## Evidence

- [join](https://etherscan.io/address/0xcafeac64cbe73e6e8973b52cdae8982de6fb500e#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [join](https://etherscan.io/address/0xcafeac64cbe73e6e8973b52cdae8982de6fb500e#code) changes who may sign.
- Its latest signed [transaction](https://etherscan.io/tx/0xe3ce7176ae739040e87ec68e4f6b522faf3c619bf9ac897823b39cf2404542a3) on record recovered [0x176c…4656](https://etherscan.io/address/0x176c27973e0229501d049de626d50918dda24656), an account without code.

## Reviewer notes

### Mechanism

join (contracts/modules/governance/Registry.sol, line 123) recovers a signer on line 132 and tests it on line 133 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. join (contracts/modules/governance/Registry.sol, line 123) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-13, recovering 0x176c…4656; 3,163 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
