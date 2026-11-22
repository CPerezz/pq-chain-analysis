---
id: nnsregistrarcontroller-8028a060-rotate-signer-before-migrating
format: 2
title: 'NNSRegistrarController: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8028a0606daae1f22455f52d62e5fa56568198c1'
  name: NNSRegistrarController
  code: verified
  code_url: https://etherscan.io/address/0xc89fe17c4e4ed0754712df6b66784042e74115ee#code
  proxy_of: '0xc89fe17c4e4ed0754712df6b66784042e74115ee'
  copies: 2
  family: 4fde5a56121f31f3e82bd0b446eb6981
  upgradeable: 'yes'
  admin: '0x31c00012ba64f62e44e8f4941e22105b65037baa'
value:
  usd: 316
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSignAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xc89fe17c4e4ed0754712df6b66784042e74115ee'
  file: NNSRegistrarController
  line: 768
  has: address recoveredAddress = ecrecover(digest, v, r, s);
  says: permitVoucher recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc89fe17c4e4ed0754712df6b66784042e74115ee'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc89fe17c4e4ed0754712df6b66784042e74115ee'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xc89fe17c4e4ed0754712df6b66784042e74115ee'
  file: NNSRegistrarController
  line: 769
  has: if (recoveredAddress != address(0) && recoveredAddress == signAddress)
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xc89fe17c4e4ed0754712df6b66784042e74115ee'
  file: NNSRegistrarController
  line: 335
  has: function setSignAddress
  says: setSignAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x8028a0606daae1f22455f52d62e5fa56568198c1'
  fn: signAddress()(address)
  is: '0x890d079ed0ff097494aa0a9c48792da53561d721'
  says: The signer it keeps in storage is 0x890d079ed0ff097494aa0a9c48792da53561d721 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x890d079ed0ff097494aa0a9c48792da53561d721'
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

NNSRegistrarController checks an ECDSA signature in permitVoucher and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignAddress changes the signer.

## Evidence

- [permitVoucher](https://etherscan.io/address/0xc89fe17c4e4ed0754712df6b66784042e74115ee#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignAddress](https://etherscan.io/address/0xc89fe17c4e4ed0754712df6b66784042e74115ee#code) changes the signer; only the owner can call it.
- The signer at the block is [0x890d…d721](https://etherscan.io/address/0x890d079ed0ff097494aa0a9c48792da53561d721), an account without code.

## Reviewer notes

### Mechanism

permitVoucher (NNSRegistrarController, line 759) recovers a signer on line 768 and tests it on line 769 against the signer it keeps in storage (signAddress() returns 0x890d079ed0ff097494aa0a9c48792da53561d721). Neither isValidSignature selector is in the code, so that account is never asked. setSignAddress (NNSRegistrarController, line 335) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-02-06; 0 transactions called the address in the 90 days before the block. 8 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
