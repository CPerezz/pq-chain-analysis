---
id: bankauthorizedusdtdistributor-dde308eb-rotate-signer-before-migrating
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
  address: '0xdde308eba8b8403b1d125ef0c7db1249f9d7dbf4'
  name: BankAuthorizedUSDTDistributor
  code: verified
  code_url: https://etherscan.io/address/0xdde308eba8b8403b1d125ef0c7db1249f9d7dbf4#code
  copies: 5
  family: e873b53307f7ba02ffac1de12ef606e3
  upgradeable: 'no'
  admin: '0xabcbc58504193f3b2fb2f6fda621252ea8c82167'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setBankWallet before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xdde308eba8b8403b1d125ef0c7db1249f9d7dbf4'
  file: contracts/BankAuthorizedUSDTDistributor.sol
  line: 136
  has: address signer = ECDSA.recover(digest, bankSig);
  says: startDistributionWithPermit recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xdde308eba8b8403b1d125ef0c7db1249f9d7dbf4'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xdde308eba8b8403b1d125ef0c7db1249f9d7dbf4'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xdde308eba8b8403b1d125ef0c7db1249f9d7dbf4'
  file: contracts/BankAuthorizedUSDTDistributor.sol
  line: 137
  has: require(signer == bankWallet, "invalid bank sig");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xdde308eba8b8403b1d125ef0c7db1249f9d7dbf4'
  file: contracts/BankAuthorizedUSDTDistributor.sol
  line: 83
  has: function setBankWallet
  says: setBankWallet changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xdde308eba8b8403b1d125ef0c7db1249f9d7dbf4'
  fn: bankWallet()(address)
  is: '0xab80712ebf19c2f906866c0b984df4c3b6e74284'
  says: The signer it keeps in storage is 0xab80712ebf19c2f906866c0b984df4c3b6e74284 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xab80712ebf19c2f906866c0b984df4c3b6e74284'
  is: delegation
  target: '0x63c0c19a282a1b52b07dd5a65b58948a07dae32b'
  says: 'the signer''s account holds an EIP-7702 delegation: an ECDSA key still controls it'
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

This contract accepts a call to startDistributionWithPermit only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setBankWallet changes the signer.

## Evidence

- [startDistributionWithPermit](https://etherscan.io/address/0xdde308eba8b8403b1d125ef0c7db1249f9d7dbf4#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setBankWallet](https://etherscan.io/address/0xdde308eba8b8403b1d125ef0c7db1249f9d7dbf4#code) changes the signer; only the owner can call it.
- The signer at the block is [0xab80…4284](https://etherscan.io/address/0xab80712ebf19c2f906866c0b984df4c3b6e74284), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

startDistributionWithPermit (contracts/BankAuthorizedUSDTDistributor.sol, line 117) recovers a signer on line 136 and tests it on line 137 against the signer it keeps in storage (bankWallet() returns 0xab80712ebf19c2f906866c0b984df4c3b6e74284). Neither isValidSignature selector is in the code, so that account is never asked. setBankWallet (contracts/BankAuthorizedUSDTDistributor.sol, line 83) writes it. The signer's account holds an EIP-7702 delegation to 0x63c0c19a282a1b52b07dd5a65b58948a07dae32b. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 5 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
