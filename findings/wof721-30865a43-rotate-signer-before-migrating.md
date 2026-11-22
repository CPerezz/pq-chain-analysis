---
id: wof721-30865a43-rotate-signer-before-migrating
format: 2
title: 'WOF721: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x30865a432efbe887b288d2a21165037db0c4d31a'
  name: WOF721
  code: verified
  code_url: https://etherscan.io/address/0x30865a432efbe887b288d2a21165037db0c4d31a#code
  copies: 2
  family: 265aab3d676bb2a113cfb762df0b99a2
  upgradeable: 'no'
  admin: '0x9f5e3592d3ee223ea97c5f1ce374c65e89869604'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x30865a432efbe887b288d2a21165037db0c4d31a'
  file: src/WOF721.sol
  line: 160
  has: address recovered = _hashTypedDataV4(hashVoucher(v)).recover(signature);
  says: _redeem recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x30865a432efbe887b288d2a21165037db0c4d31a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x30865a432efbe887b288d2a21165037db0c4d31a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x30865a432efbe887b288d2a21165037db0c4d31a'
  file: src/WOF721.sol
  line: 161
  has: if (recovered != s) revert BadSigner(recovered);
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x30865a432efbe887b288d2a21165037db0c4d31a'
  file: src/WOF721.sol
  line: 227
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x30865a432efbe887b288d2a21165037db0c4d31a'
  fn: signer()(address)
  is: '0x59b0b57a4b8cde1e02b799fab62fca7a14e5c5f8'
  says: The signer it keeps in storage is 0x59b0b57a4b8cde1e02b799fab62fca7a14e5c5f8 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x59b0b57a4b8cde1e02b799fab62fca7a14e5c5f8'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x18f1308a3502282119631adf98f9fc7a97227163b02df0f9dcbaf7f483dba5aa'
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

WOF721 checks an ECDSA signature in _redeem and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [_redeem](https://etherscan.io/address/0x30865a432efbe887b288d2a21165037db0c4d31a#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x30865a432efbe887b288d2a21165037db0c4d31a#code) changes the signer; only the owner can call it.
- The signer at the block is [0x59b0…c5f8](https://etherscan.io/address/0x59b0b57a4b8cde1e02b799fab62fca7a14e5c5f8), an account without code.

## Reviewer notes

### Mechanism

_redeem (src/WOF721.sol, line 151) recovers a signer on line 160 and tests it on line 161 against the signer it keeps in storage (signer() returns 0x59b0b57a4b8cde1e02b799fab62fca7a14e5c5f8). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (src/WOF721.sol, line 227) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-23, recovering 0x59b0…c5f8; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
