---
id: revertrewardcontract-cd68eff7-rotate-signer-before-migrating
format: 2
title: 'RevertRewardContract: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcd68eff7da225cbc9215c9c0002fb9c2f287d094'
  name: RevertRewardContract
  code: verified
  code_url: https://etherscan.io/address/0xcd68eff7da225cbc9215c9c0002fb9c2f287d094#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 4
impact: liveness
action: Replace the signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xcd68eff7da225cbc9215c9c0002fb9c2f287d094'
  file: contracts/RevertRewardContract.sol
  line: 213
  has: address ownerAddress = ECDSA.recover(hash, signature);
  says: checkSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xcd68eff7da225cbc9215c9c0002fb9c2f287d094'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xcd68eff7da225cbc9215c9c0002fb9c2f287d094'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xcd68eff7da225cbc9215c9c0002fb9c2f287d094'
  file: contracts/RevertRewardContract.sol
  line: 214
  has: if (ownerAddress == signerAddress) {
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xcd68eff7da225cbc9215c9c0002fb9c2f287d094'
  file: contracts/RevertRewardContract.sol
  line: 241
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xcd68eff7da225cbc9215c9c0002fb9c2f287d094'
  fn: signerAddress()(address)
  is: '0xa94d13af35ec13aa945d30c57bf7d3da8268dfa6'
  says: The signer it keeps in storage is 0xa94d13af35ec13aa945d30c57bf7d3da8268dfa6 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xa94d13af35ec13aa945d30c57bf7d3da8268dfa6'
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

RevertRewardContract checks an ECDSA signature in checkSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddress changes the signer.

## Evidence

- [checkSignature](https://etherscan.io/address/0xcd68eff7da225cbc9215c9c0002fb9c2f287d094#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0xcd68eff7da225cbc9215c9c0002fb9c2f287d094#code) changes the signer.
- The signer at the block is [0xa94d…dfa6](https://etherscan.io/address/0xa94d13af35ec13aa945d30c57bf7d3da8268dfa6), an account without code.

## Reviewer notes

### Mechanism

checkSignature (contracts/RevertRewardContract.sol, line 199) recovers a signer on line 213 and tests it on line 214 against the signer it keeps in storage (signerAddress() returns 0xa94d13af35ec13aa945d30c57bf7d3da8268dfa6). Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (contracts/RevertRewardContract.sol, line 241) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-10-11, recovering 0xbfa2…6c42; 4 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
