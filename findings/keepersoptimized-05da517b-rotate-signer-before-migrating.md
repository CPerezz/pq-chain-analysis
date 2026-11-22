---
id: keepersoptimized-05da517b-rotate-signer-before-migrating
format: 2
title: 'KeepersOptimized: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x05da517b1bf9999b7762eaefa8372341a1a47559'
  name: KeepersOptimized
  code: verified
  code_url: https://etherscan.io/address/0x05da517b1bf9999b7762eaefa8372341a1a47559#code
  copies: 1
  upgradeable: 'no'
  admin: '0xf250d5584d682ba2f555197bd26b58e83d7ca4c6'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 311
impact: liveness
action: Replace the signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x05da517b1bf9999b7762eaefa8372341a1a47559'
  file: src/contracts/nft/KeepersOptimized.sol
  line: 212
  has: if (signerAddress != ecrecover(messageDigest, v, r, s)) revert SignatureMismatch();
  says: mintPublic recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x05da517b1bf9999b7762eaefa8372341a1a47559'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x05da517b1bf9999b7762eaefa8372341a1a47559'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x05da517b1bf9999b7762eaefa8372341a1a47559'
  file: src/contracts/nft/KeepersOptimized.sol
  line: 133
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x05da517b1bf9999b7762eaefa8372341a1a47559'
  fn: signerAddress()(address)
  is: '0x76813a60f3c54bcd4b73b04abce2d943e0c5c7af'
  says: The signer it keeps in storage is 0x76813a60f3c54bcd4b73b04abce2d943e0c5c7af at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x76813a60f3c54bcd4b73b04abce2d943e0c5c7af'
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

KeepersOptimized accepts a call to mintPublic only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddress changes the signer.

## Evidence

- [mintPublic](https://etherscan.io/address/0x05da517b1bf9999b7762eaefa8372341a1a47559#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0x05da517b1bf9999b7762eaefa8372341a1a47559#code) changes the signer; only the owner can call it.
- The signer at the block is [0x7681…c7af](https://etherscan.io/address/0x76813a60f3c54bcd4b73b04abce2d943e0c5c7af), an account without code.

## Reviewer notes

### Mechanism

mintPublic (src/contracts/nft/KeepersOptimized.sol, line 200) recovers a signer on line 212 and tests it on line 212 against the signer it keeps in storage (signerAddress() returns 0x76813a60f3c54bcd4b73b04abce2d943e0c5c7af). Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (src/contracts/nft/KeepersOptimized.sol, line 133) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-11-14, recovering 0x7681…c7af; 311 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
