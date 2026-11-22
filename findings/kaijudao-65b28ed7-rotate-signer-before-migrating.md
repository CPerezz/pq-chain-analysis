---
id: kaijudao-65b28ed7-rotate-signer-before-migrating
format: 2
title: 'KaijuDAO: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x65b28ed75c12d8ce29d892de9f8304a6d2e176a7'
  name: KaijuDAO
  code: verified
  code_url: https://etherscan.io/address/0x65b28ed75c12d8ce29d892de9f8304a6d2e176a7#code
  copies: 1
  upgradeable: 'no'
  admin: '0xc8a19e96530294523d4f6a9f08bb822420043b4c'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 93
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x65b28ed75c12d8ce29d892de9f8304a6d2e176a7'
  file: KaijuDAO.sol
  line: 302
  has: return recoverSigner(ethSignedMessageHash, signature) == signer;
  says: isWhitelisted recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x65b28ed75c12d8ce29d892de9f8304a6d2e176a7'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x65b28ed75c12d8ce29d892de9f8304a6d2e176a7'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x65b28ed75c12d8ce29d892de9f8304a6d2e176a7'
  file: KaijuDAO.sol
  line: 352
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xba6f51199725d4f1f6b1a9e5fefdc597edc89b8a'
  is: delegation
  target: '0xe6cae83bde06e4c305530e199d7217f42808555b'
  says: 'the address recovered in the latest signature check on record holds an EIP-7702 delegation: an ECDSA key
    still controls it'
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

KaijuDAO checks an ECDSA signature in isWhitelisted and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [isWhitelisted](https://etherscan.io/address/0x65b28ed75c12d8ce29d892de9f8304a6d2e176a7#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x65b28ed75c12d8ce29d892de9f8304a6d2e176a7#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0xba6f…9b8a](https://etherscan.io/address/0xba6f51199725d4f1f6b1a9e5fefdc597edc89b8a), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

isWhitelisted (KaijuDAO.sol, line 298) recovers a signer on line 302 and tests it on line 302 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSigner (KaijuDAO.sol, line 352) writes it. The signer's account holds an EIP-7702 delegation to 0xe6cae83bde06e4c305530e199d7217f42808555b. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-02-26, recovering 0xba6f…9b8a; 93 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
