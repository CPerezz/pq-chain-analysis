---
id: word-0cc5d6c7-rotate-signer-before-migrating
format: 2
title: 'Word: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0cc5d6c786202ba7d938aba1d458c4b84ac77ba3'
  name: Word
  code: verified
  code_url: https://etherscan.io/address/0x0cc5d6c786202ba7d938aba1d458c4b84ac77ba3#code
  copies: 1
  admin: '0xeb77cc666c89285734dffd2962e78a3dfaf36316'
value:
  usd: 325
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSignAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x0cc5d6c786202ba7d938aba1d458c4b84ac77ba3'
  file: contracts/Word.sol
  line: 148
  has: require(hash.recover(sig) == signAddress, "sign error");
  says: whitelistMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x0cc5d6c786202ba7d938aba1d458c4b84ac77ba3'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x0cc5d6c786202ba7d938aba1d458c4b84ac77ba3'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x0cc5d6c786202ba7d938aba1d458c4b84ac77ba3'
  file: contracts/Word.sol
  line: 66
  has: function setSignAddress
  says: setSignAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x0cc5d6c786202ba7d938aba1d458c4b84ac77ba3'
  fn: signAddress()(address)
  is: '0xc849db869527a973b9a1e9303adc282c2f80eb71'
  says: The signer it keeps in storage is 0xc849db869527a973b9a1e9303adc282c2f80eb71 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xc849db869527a973b9a1e9303adc282c2f80eb71'
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

Word accepts a call to whitelistMint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignAddress changes the signer.

## Evidence

- [whitelistMint](https://etherscan.io/address/0x0cc5d6c786202ba7d938aba1d458c4b84ac77ba3#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignAddress](https://etherscan.io/address/0x0cc5d6c786202ba7d938aba1d458c4b84ac77ba3#code) changes the signer; only the owner can call it.
- The signer at the block is [0xc849…eb71](https://etherscan.io/address/0xc849db869527a973b9a1e9303adc282c2f80eb71), an account without code.

## Reviewer notes

### Mechanism

whitelistMint (contracts/Word.sol, line 141) recovers a signer on line 148 and tests it on line 148 against the signer it keeps in storage (signAddress() returns 0xc849db869527a973b9a1e9303adc282c2f80eb71). Neither isValidSignature selector is in the code, so that account is never asked. setSignAddress (contracts/Word.sol, line 66) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-09-17, recovering 0xc849…eb71; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
