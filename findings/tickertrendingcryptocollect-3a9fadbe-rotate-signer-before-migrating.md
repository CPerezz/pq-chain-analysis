---
id: tickertrendingcryptocollect-3a9fadbe-rotate-signer-before-migrating
format: 2
title: 'This contract: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3a9fadbe04a8b89d53a6b9cf8a70c5c08b2b1f13'
  name: TickertrendingCryptoCollect
  code: verified
  code_url: https://etherscan.io/address/0x457033fa7fdc63aa927a50e606ef759327092288#code
  proxy_of: '0x457033fa7fdc63aa927a50e606ef759327092288'
  copies: 2
  family: be1ee2dcbbfce9721866cc1e1b31e05f
  upgradeable: 'yes'
  admin: '0x47b4004725393839d46381c09b392b50afd9f139'
value:
  usd: 20
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with updateSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x457033fa7fdc63aa927a50e606ef759327092288'
  file: DEFI/TICKERTRENDING/cryptoCollect.sol
  line: 83
  has: require(ecrecover(payloadHash, v, r, s) == SIGNER, "Signature mismatch");
  says: verifyPayload recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x457033fa7fdc63aa927a50e606ef759327092288'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x457033fa7fdc63aa927a50e606ef759327092288'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x457033fa7fdc63aa927a50e606ef759327092288'
  file: DEFI/TICKERTRENDING/cryptoCollect.sol
  line: 73
  has: function updateSigner
  says: updateSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x3a9fadbe04a8b89d53a6b9cf8a70c5c08b2b1f13'
  fn: SIGNER()(address)
  is: '0x8839a01ab96280a35df563890c1b0a40cc0ee3a0'
  says: The signer it keeps in storage is 0x8839a01ab96280a35df563890c1b0a40cc0ee3a0 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x8839a01ab96280a35df563890c1b0a40cc0ee3a0'
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

This contract checks an ECDSA signature in verifyPayload and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSigner changes the signer.

## Evidence

- [verifyPayload](https://etherscan.io/address/0x457033fa7fdc63aa927a50e606ef759327092288#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateSigner](https://etherscan.io/address/0x457033fa7fdc63aa927a50e606ef759327092288#code) changes the signer; only the owner can call it.
- The signer at the block is [0x8839…e3a0](https://etherscan.io/address/0x8839a01ab96280a35df563890c1b0a40cc0ee3a0), an account without code.

## Reviewer notes

### Mechanism

verifyPayload (DEFI/TICKERTRENDING/cryptoCollect.sol, line 78) recovers a signer on line 83 and tests it on line 83 against the signer it keeps in storage (SIGNER() returns 0x8839a01ab96280a35df563890c1b0a40cc0ee3a0). Neither isValidSignature selector is in the code, so that account is never asked. updateSigner (DEFI/TICKERTRENDING/cryptoCollect.sol, line 73) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-11-26, recovering 0x8839…e3a0; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
