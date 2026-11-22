---
id: unifiedforwarderaccount-7529abff-rotate-signer-before-migrating
format: 2
title: 'UnifiedForwarderAccount: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7529abff0f8665a4e7fcd532d0f528090435d10e'
  name: UnifiedForwarderAccount
  code: verified
  code_url: https://etherscan.io/address/0x7529abff0f8665a4e7fcd532d0f528090435d10e#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1208
impact: liveness
action: Before a signer's account moves to real code, use setAuthorizedSigner so that another key can sign in its
  place.
evidence_level: source
checks:
- id: recover
  source: '0x7529abff0f8665a4e7fcd532d0f528090435d10e'
  file: contracts/UnifiedForwarderAccount.sol
  line: 100
  has: address recovered = ECDSA.recover(MessageHashUtils.toEthSignedMessageHash(userOpHash), op.signature);
  says: _validate recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x7529abff0f8665a4e7fcd532d0f528090435d10e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x7529abff0f8665a4e7fcd532d0f528090435d10e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x7529abff0f8665a4e7fcd532d0f528090435d10e'
  file: contracts/UnifiedForwarderAccount.sol
  line: 101
  has: require(recovered == signer, InvalidSignature(recovered, signer));
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x7529abff0f8665a4e7fcd532d0f528090435d10e'
  file: contracts/UnifiedForwarderAccount.sol
  line: 66
  has: function setAuthorizedSigner
  says: setAuthorizedSigner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x4f7f106b88688b0808ed3cc15aa88e3966856f44'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x6584361ef975ba92a6f234ac9afe1ecff5f5547632dc19f19c5e606afd2aada6'
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

UnifiedForwarderAccount checks an ECDSA signature in _validate and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAuthorizedSigner changes who may sign.

## Evidence

- [_validate](https://etherscan.io/address/0x7529abff0f8665a4e7fcd532d0f528090435d10e#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setAuthorizedSigner](https://etherscan.io/address/0x7529abff0f8665a4e7fcd532d0f528090435d10e#code) changes who may sign.
- Its latest signed [transaction](https://etherscan.io/tx/0x6584361ef975ba92a6f234ac9afe1ecff5f5547632dc19f19c5e606afd2aada6) on record recovered [0x4f7f…6f44](https://etherscan.io/address/0x4f7f106b88688b0808ed3cc15aa88e3966856f44), an account without code.

## Reviewer notes

### Mechanism

_validate (contracts/UnifiedForwarderAccount.sol, line 91) recovers a signer on line 100 and tests it on line 101 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. setAuthorizedSigner (contracts/UnifiedForwarderAccount.sol, line 66) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-18, recovering 0x4f7f…6f44; 1,208 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
