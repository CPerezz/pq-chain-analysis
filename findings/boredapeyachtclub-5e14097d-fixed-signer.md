---
id: boredapeyachtclub-5e14097d-fixed-signer
format: 2
title: 'BoredApeYachtClub: its signer cannot be replaced and must not take real code'
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if a signer's account takes real code; the signer is fixed, so a new contract is then
  needed.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5e14097daeb9b91c4354e2280dfba01c68e3e103'
  name: BoredApeYachtClub
  code: verified
  code_url: https://etherscan.io/address/0x5e14097daeb9b91c4354e2280dfba01c68e3e103#code
  copies: 3
  family: 892b3517784eface1587a7dcc4cab094
  upgradeable: 'no'
  admin: '0xdda12e4411ce9a57ed73b78bf1cf7fbec94cf773'
value:
  usd: 69
  basis: held
activity:
  txs_90d: 8
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0x5e14097daeb9b91c4354e2280dfba01c68e3e103'
  file: contracts/MasterchefMasatoshiJuniorX.sol
  line: 143
  has: return signerAddress == messageHash.toEthSignedMessageHash().recover(signature);
  says: verifyAddressSigner recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x5e14097daeb9b91c4354e2280dfba01c68e3e103'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x5e14097daeb9b91c4354e2280dfba01c68e3e103'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: written
  source: '0x5e14097daeb9b91c4354e2280dfba01c68e3e103'
  file: contracts/MasterchefMasatoshiJuniorX.sol
  line: 67
  has: signerAddress = _signerAddress;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
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

BoredApeYachtClub checks an ECDSA signature in verifyAddressSigner and accepts only a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [verifyAddressSigner](https://etherscan.io/address/0x5e14097daeb9b91c4354e2280dfba01c68e3e103#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0x5e14097daeb9b91c4354e2280dfba01c68e3e103#code); the verified source has no function that writes it afterwards.

## Reviewer notes

### Mechanism

verifyAddressSigner (contracts/MasterchefMasatoshiJuniorX.sol, line 142) recovers a signer on line 143 and tests it on line 143 against a signer fixed at deployment. Neither isValidSignature selector is in the code, so that account is never asked. signerAddress is written on line 67 of contracts/MasterchefMasatoshiJuniorX.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 8 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
