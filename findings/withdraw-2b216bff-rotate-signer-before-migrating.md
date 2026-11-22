---
id: withdraw-2b216bff-rotate-signer-before-migrating
format: 2
title: 'Withdraw: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2b216bff2d2be0a542af34314161a815a807be49'
  name: Withdraw
  code: verified
  code_url: https://etherscan.io/address/0x2b216bff2d2be0a542af34314161a815a807be49#code
  copies: 2
  family: 6ffe3cc5982f806f759aac69e2c8127e
  upgradeable: 'no'
  admin: '0x5840242988422abd8546c514b8e4d3ff1f7dfb7d'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 913
impact: liveness
action: Replace the signer with setSignAddr before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x2b216bff2d2be0a542af34314161a815a807be49'
  file: Withdraw.sol
  line: 147
  has: address singer = ecrecover(keccak256(abi.encodePacked(_wid, _wAmt, _tokenAddr, _deadline, _msgSender())),
    v, r
  says: claimreward recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x2b216bff2d2be0a542af34314161a815a807be49'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x2b216bff2d2be0a542af34314161a815a807be49'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x2b216bff2d2be0a542af34314161a815a807be49'
  file: Withdraw.sol
  line: 148
  has: require(singer == signAddr, "Signature Error.");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x2b216bff2d2be0a542af34314161a815a807be49'
  file: Withdraw.sol
  line: 138
  has: function setSignAddr
  says: setSignAddr changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x2b216bff2d2be0a542af34314161a815a807be49'
  fn: signAddr()(address)
  is: '0x56bf8b22f81ed39a750e8f320fb9af1a2ea6cf57'
  says: The signer it keeps in storage is 0x56bf8b22f81ed39a750e8f320fb9af1a2ea6cf57 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x56bf8b22f81ed39a750e8f320fb9af1a2ea6cf57'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x13bde4c98e98317a327d8dac5fa4f328e9256e1aa0ee1969249f1dbc766465d4'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
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

Withdraw accepts a call to claimreward only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignAddr changes the signer.

## Evidence

- [claimreward](https://etherscan.io/address/0x2b216bff2d2be0a542af34314161a815a807be49#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignAddr](https://etherscan.io/address/0x2b216bff2d2be0a542af34314161a815a807be49#code) changes the signer; only the owner can call it.
- The signer at the block is [0x56bf…cf57](https://etherscan.io/address/0x56bf8b22f81ed39a750e8f320fb9af1a2ea6cf57), an account without code.

## Reviewer notes

### Mechanism

claimreward (Withdraw.sol, line 142) recovers a signer on line 147 and tests it on line 148 against the signer it keeps in storage (signAddr() returns 0x56bf8b22f81ed39a750e8f320fb9af1a2ea6cf57). Neither isValidSignature selector is in the code, so that account is never asked. setSignAddr (Withdraw.sol, line 138) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-18, recovering 0x56bf…cf57; 913 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
