---
id: campaigndonationsplitter-1f415d14-rotate-signer-before-migrating
format: 2
title: 'CampaignDonationSplitter: replace the signer before it takes real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1f415d1426724507a722aa5d66409d23c4de6425'
  name: CampaignDonationSplitter
  code: verified
  code_url: https://etherscan.io/address/0x1f415d1426724507a722aa5d66409d23c4de6425#code
  copies: 1
  upgradeable: 'no'
  admin: '0x744d905773049a11ddfba3258953a15909525bf3'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Replace the signer with setRegistrar before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x1f415d1426724507a722aa5d66409d23c4de6425'
  file: src/CampaignDonationSplitter.sol
  line: 299
  has: (address signer, ECDSA.RecoverError err, ) = ECDSA.tryRecover(digest, a.signature);
  says: _resolveBeneficiary recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x1f415d1426724507a722aa5d66409d23c4de6425'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x1f415d1426724507a722aa5d66409d23c4de6425'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x1f415d1426724507a722aa5d66409d23c4de6425'
  file: src/CampaignDonationSplitter.sol
  line: 300
  has: if (err != ECDSA.RecoverError.NoError || signer != r) revert BadRegistrarSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x1f415d1426724507a722aa5d66409d23c4de6425'
  file: src/CampaignDonationSplitter.sol
  line: 122
  has: function setRegistrar
  says: setRegistrar changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x1f415d1426724507a722aa5d66409d23c4de6425'
  fn: registrar()(address)
  is: '0x04c5a58cb4d1c6f86bf3811dc9874a2261a1e687'
  says: The signer it keeps in storage is 0x04c5a58cb4d1c6f86bf3811dc9874a2261a1e687 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x04c5a58cb4d1c6f86bf3811dc9874a2261a1e687'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x770f61be9ae964d9ab5fc4f93e0ada098768680c20c2e1a43f782f0b191e69e1'
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

CampaignDonationSplitter checks an ECDSA signature in _resolveBeneficiary and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setRegistrar changes the signer.

## Evidence

- [_resolveBeneficiary](https://etherscan.io/address/0x1f415d1426724507a722aa5d66409d23c4de6425#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setRegistrar](https://etherscan.io/address/0x1f415d1426724507a722aa5d66409d23c4de6425#code) changes the signer; only the owner can call it.
- The signer at the block is [0x04c5…e687](https://etherscan.io/address/0x04c5a58cb4d1c6f86bf3811dc9874a2261a1e687), an account without code.

## Reviewer notes

### Mechanism

_resolveBeneficiary (src/CampaignDonationSplitter.sol, line 289) recovers a signer on line 299 and tests it on line 300 against the signer it keeps in storage (registrar() returns 0x04c5a58cb4d1c6f86bf3811dc9874a2261a1e687). Neither isValidSignature selector is in the code, so that account is never asked. setRegistrar (src/CampaignDonationSplitter.sol, line 122) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-11, recovering 0x04c5…e687; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
