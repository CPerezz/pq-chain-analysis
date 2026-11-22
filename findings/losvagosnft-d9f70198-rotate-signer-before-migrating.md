---
id: losvagosnft-d9f70198-rotate-signer-before-migrating
format: 2
title: 'LosVagosNFT: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd9f701982b6c237a7a3f2eacc14b7843baac6caf'
  name: LosVagosNFT
  code: verified
  code_url: https://etherscan.io/address/0xd9f701982b6c237a7a3f2eacc14b7843baac6caf#code
  copies: 1
  upgradeable: 'no'
  admin: '0x6aa1fec683c5eed9f002d4d8f59adc00e50da817'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xd9f701982b6c237a7a3f2eacc14b7843baac6caf'
  file: contracts/LosVagosNFT.sol
  line: 455
  has: address _signer = _verify(voucher);
  says: redeem recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd9f701982b6c237a7a3f2eacc14b7843baac6caf'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd9f701982b6c237a7a3f2eacc14b7843baac6caf'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xd9f701982b6c237a7a3f2eacc14b7843baac6caf'
  file: contracts/LosVagosNFT.sol
  line: 456
  has: require(signer == _signer, "Signature invalid or unauthorized");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xd9f701982b6c237a7a3f2eacc14b7843baac6caf'
  file: contracts/LosVagosNFT.sol
  line: 144
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xd9f701982b6c237a7a3f2eacc14b7843baac6caf'
  fn: getSigner()(address)
  is: '0xfd4e223682559678b418988192664513109e364b'
  says: The signer it keeps in storage is 0xfd4e223682559678b418988192664513109e364b at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xfd4e223682559678b418988192664513109e364b'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
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

LosVagosNFT accepts a call to redeem only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [redeem](https://etherscan.io/address/0xd9f701982b6c237a7a3f2eacc14b7843baac6caf#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xd9f701982b6c237a7a3f2eacc14b7843baac6caf#code) changes the signer; only the owner can call it.
- The signer at the block is [0xfd4e…364b](https://etherscan.io/address/0xfd4e223682559678b418988192664513109e364b), an account without code.

## Reviewer notes

### Mechanism

redeem (contracts/LosVagosNFT.sol, line 454) recovers a signer on line 455 and tests it on line 456 against the signer it keeps in storage (getSigner() returns 0xfd4e223682559678b418988192664513109e364b). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/LosVagosNFT.sol, line 144) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-08-25, recovering 0xfd4e…364b; 5 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
