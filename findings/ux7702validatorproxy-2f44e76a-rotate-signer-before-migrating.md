---
id: ux7702validatorproxy-2f44e76a-rotate-signer-before-migrating
format: 2
title: 'UX7702ValidatorProxy: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2f44e76ac11be0578e6b5fdc6455af005ba41122'
  name: UX7702ValidatorProxy
  code: verified
  code_url: https://etherscan.io/address/0xc80dae4630dd3602653532028ecee235ed2f2705#code
  proxy_of: '0xc80dae4630dd3602653532028ecee235ed2f2705'
  copies: 3
  family: f8888708b29739aec367b4b54306f4e3
  upgradeable: 'yes'
  admin: '0x162c7edd32e7cbc04c33a6b9d8989b7ed72c865f'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 40
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xc80dae4630dd3602653532028ecee235ed2f2705'
  file: contracts/ux7702/ux7702ValidatorProxy.sol
  line: 64
  has: address addr = ECDSA.recover(hash, signatureData);
  says: _checkSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc80dae4630dd3602653532028ecee235ed2f2705'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc80dae4630dd3602653532028ecee235ed2f2705'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xc80dae4630dd3602653532028ecee235ed2f2705'
  file: contracts/ux7702/ux7702ValidatorProxy.sol
  line: 65
  has: require(signer == addr, "Invalid signer");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xc80dae4630dd3602653532028ecee235ed2f2705'
  file: contracts/ux7702/ux7702ValidatorProxy.sol
  line: 34
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x9460122656c9119b0f880f47ec6b9c231fd2d4cb'
  is: delegation
  target: '0xe05cca77f476de361178ba5086cd3c4b36ba81d8'
  says: 'the address recovered in the latest signature check on record holds an EIP-7702 delegation: an ECDSA key
    still controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x7ff6940a508777b3d6eb5dec5a98cd4302d165d7662dd40a53288a0b538fa1d2'
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

UX7702ValidatorProxy checks an ECDSA signature in _checkSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [_checkSignature](https://etherscan.io/address/0xc80dae4630dd3602653532028ecee235ed2f2705#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xc80dae4630dd3602653532028ecee235ed2f2705#code) changes the signer; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x7ff6940a508777b3d6eb5dec5a98cd4302d165d7662dd40a53288a0b538fa1d2) on record recovered [0x9460…d4cb](https://etherscan.io/address/0x9460122656c9119b0f880f47ec6b9c231fd2d4cb), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

_checkSignature (contracts/ux7702/ux7702ValidatorProxy.sol, line 56) recovers a signer on line 64 and tests it on line 65 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/ux7702/ux7702ValidatorProxy.sol, line 34) writes it. The signer's account holds an EIP-7702 delegation to 0xe05cca77f476de361178ba5086cd3c4b36ba81d8. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-20, recovering 0x9460…d4cb; 40 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
