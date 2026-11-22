---
id: payabletraitsdrop-0d387002-rotate-signer-before-migrating
format: 2
title: 'PayableTraitsDrop: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0d387002fda9a0a07dfc35c7326dac8b379bcfec'
  name: PayableTraitsDrop
  code: verified
  code_url: https://etherscan.io/address/0x0d387002fda9a0a07dfc35c7326dac8b379bcfec#code
  copies: 1
  admin: '0x139c8919ce2b7fb8a04f929d83b8c54c116c692b'
value:
  usd: 292
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x0d387002fda9a0a07dfc35c7326dac8b379bcfec'
  file: contracts/PayableTraitsDrop.sol
  line: 52
  has: address recoveredWallet = ECDSA.recover(messageHash, _signature);
  says: mint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x0d387002fda9a0a07dfc35c7326dac8b379bcfec'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x0d387002fda9a0a07dfc35c7326dac8b379bcfec'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x0d387002fda9a0a07dfc35c7326dac8b379bcfec'
  file: contracts/PayableTraitsDrop.sol
  line: 54
  has: require(recoveredWallet == signerAddress, "Invalid signature for the caller");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x0d387002fda9a0a07dfc35c7326dac8b379bcfec'
  file: contracts/PayableTraitsDrop.sol
  line: 33
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x0d387002fda9a0a07dfc35c7326dac8b379bcfec'
  fn: signerAddress()(address)
  is: '0xcca01763bc9be95f0dc07851c6bf61273d47b5a1'
  says: The signer it keeps in storage is 0xcca01763bc9be95f0dc07851c6bf61273d47b5a1 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xcca01763bc9be95f0dc07851c6bf61273d47b5a1'
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

PayableTraitsDrop accepts a call to mint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddress changes the signer.

## Evidence

- [mint](https://etherscan.io/address/0x0d387002fda9a0a07dfc35c7326dac8b379bcfec#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0x0d387002fda9a0a07dfc35c7326dac8b379bcfec#code) changes the signer; only the owner can call it.
- The signer at the block is [0xcca0…b5a1](https://etherscan.io/address/0xcca01763bc9be95f0dc07851c6bf61273d47b5a1), an account without code.

## Reviewer notes

### Mechanism

mint (contracts/PayableTraitsDrop.sol, line 42) recovers a signer on line 52 and tests it on line 54 against the signer it keeps in storage (signerAddress() returns 0xcca01763bc9be95f0dc07851c6bf61273d47b5a1). Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (contracts/PayableTraitsDrop.sol, line 33) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-03-25, recovering 0xcca0…b5a1; 0 transactions called the address in the 90 days before the block. 4 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
