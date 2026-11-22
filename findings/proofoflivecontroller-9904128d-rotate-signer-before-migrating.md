---
id: proofoflivecontroller-9904128d-rotate-signer-before-migrating
format: 2
title: 'ProofOfLiveController: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9904128d42d8a484a6ec0a82495b29e1880fa649'
  name: ProofOfLiveController
  code: verified
  code_url: https://etherscan.io/address/0x9904128d42d8a484a6ec0a82495b29e1880fa649#code
  copies: 1
  upgradeable: 'no'
  admin: '0xb113a7b59e7cd692e2cd5cc50ed14ea0b7a230e4'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 3
impact: liveness
action: Replace the signer with setMintSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x9904128d42d8a484a6ec0a82495b29e1880fa649'
  file: project/contracts/ProofOfLiveController.sol
  line: 103
  has: address signer = ecrecover(messageHash, v, r, s);
  says: mintWithSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x9904128d42d8a484a6ec0a82495b29e1880fa649'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x9904128d42d8a484a6ec0a82495b29e1880fa649'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x9904128d42d8a484a6ec0a82495b29e1880fa649'
  file: project/contracts/ProofOfLiveController.sol
  line: 104
  has: require(signer == mintSigner && signer != address(0), "Invalid signature");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x9904128d42d8a484a6ec0a82495b29e1880fa649'
  file: project/contracts/ProofOfLiveController.sol
  line: 55
  has: function setMintSigner
  says: setMintSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x9904128d42d8a484a6ec0a82495b29e1880fa649'
  fn: mintSigner()(address)
  is: '0x164ddfbbe74569b69729d3177857ed2a9622f50e'
  says: The signer it keeps in storage is 0x164ddfbbe74569b69729d3177857ed2a9622f50e at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x164ddfbbe74569b69729d3177857ed2a9622f50e'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xcd00d9109485750244fa95c0cf6911341ad72be7e39f7b6f2d036f96fd9ab231'
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

ProofOfLiveController accepts a call to mintWithSignature only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setMintSigner changes the signer.

## Evidence

- [mintWithSignature](https://etherscan.io/address/0x9904128d42d8a484a6ec0a82495b29e1880fa649#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setMintSigner](https://etherscan.io/address/0x9904128d42d8a484a6ec0a82495b29e1880fa649#code) changes the signer; only the owner can call it.
- The signer at the block is [0x164d…f50e](https://etherscan.io/address/0x164ddfbbe74569b69729d3177857ed2a9622f50e), an account without code.

## Reviewer notes

### Mechanism

mintWithSignature (project/contracts/ProofOfLiveController.sol, line 91) recovers a signer on line 103 and tests it on line 104 against the signer it keeps in storage (mintSigner() returns 0x164ddfbbe74569b69729d3177857ed2a9622f50e). Neither isValidSignature selector is in the code, so that account is never asked. setMintSigner (project/contracts/ProofOfLiveController.sol, line 55) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-01, recovering 0x164d…f50e; 3 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
