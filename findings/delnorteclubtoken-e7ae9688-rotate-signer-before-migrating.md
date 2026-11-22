---
id: delnorteclubtoken-e7ae9688-rotate-signer-before-migrating
format: 2
title: 'DelNorteClubToken: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe7ae968823c79ca4022096c0887971358d97acaa'
  name: DelNorteClubToken
  code: verified
  code_url: https://etherscan.io/address/0xe7ae968823c79ca4022096c0887971358d97acaa#code
  copies: 2
  family: 6d27f800df408509148c0143e950f34d
  upgradeable: 'no'
value:
  usd: 530
  basis: held
activity:
  txs_90d: 3
impact: liveness
action: Before a signer's account moves to real code, use addWhitelistedUser so that another key can sign in its
  place.
evidence_level: source
checks:
- id: recover
  source: '0xe7ae968823c79ca4022096c0887971358d97acaa'
  file: contracts/DelNorteClub.sol
  line: 268
  has: address recoveredSigner = recoverSigner(ethSignedMessageHash, registrarSignedMessage);
  says: whitelistUserWithRegKey recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xe7ae968823c79ca4022096c0887971358d97acaa'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe7ae968823c79ca4022096c0887971358d97acaa'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xe7ae968823c79ca4022096c0887971358d97acaa'
  file: contracts/DelNorteClub.sol
  line: 269
  has: require(recoveredSigner == registrarAddress,   "Sig not from registrar");
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xe7ae968823c79ca4022096c0887971358d97acaa'
  file: contracts/DelNorteClub.sol
  line: 161
  has: function addWhitelistedUser
  says: addWhitelistedUser changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

DelNorteClubToken accepts a call to whitelistUserWithRegKey only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addWhitelistedUser changes who may sign.

## Evidence

- [whitelistUserWithRegKey](https://etherscan.io/address/0xe7ae968823c79ca4022096c0887971358d97acaa#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [addWhitelistedUser](https://etherscan.io/address/0xe7ae968823c79ca4022096c0887971358d97acaa#code) changes who may sign.

## Reviewer notes

### Mechanism

whitelistUserWithRegKey (contracts/DelNorteClub.sol, line 254) recovers a signer on line 268 and tests it on line 269 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. addWhitelistedUser (contracts/DelNorteClub.sol, line 161) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-06-10; 3 transactions called the address in the 90 days before the block. 13 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
