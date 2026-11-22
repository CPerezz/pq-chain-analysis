---
id: matr1x2061-9a27d13a-rotate-signer-before-migrating
format: 2
title: 'Matr1x2061: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9a27d13a4896baa03843a0728dff6007d665f8ee'
  name: Matr1x2061
  code: verified
  code_url: https://etherscan.io/address/0xee8e0e67d48238048cbe5ffa8559d0b0799cf68c#code
  proxy_of: '0xee8e0e67d48238048cbe5ffa8559d0b0799cf68c'
  copies: 2
  family: 148f39f31971054d33534532d38cfe1c
  upgradeable: 'yes'
  admin: '0x7418e7b5b8292e96acb849f9ae9e14441aeb9d4c'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 67
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xee8e0e67d48238048cbe5ffa8559d0b0799cf68c'
  file: Matr1x2061.sol
  line: 3702
  has: address signerOwner = signatureWallet(_msgSender(),1,_salt,"matr1xlist",_signature);
  says: mlMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xee8e0e67d48238048cbe5ffa8559d0b0799cf68c'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xee8e0e67d48238048cbe5ffa8559d0b0799cf68c'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xee8e0e67d48238048cbe5ffa8559d0b0799cf68c'
  file: Matr1x2061.sol
  line: 3705
  has: require(signerOwner == verifySigner, "Not authorized to mint");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xee8e0e67d48238048cbe5ffa8559d0b0799cf68c'
  file: Matr1x2061.sol
  line: 3797
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x9a27d13a4896baa03843a0728dff6007d665f8ee'
  fn: verifySigner()(address)
  is: '0xdff1113d60988df55cf6b181ade251a4496d3495'
  says: The signer it keeps in storage is 0xdff1113d60988df55cf6b181ade251a4496d3495 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xdff1113d60988df55cf6b181ade251a4496d3495'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
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

Matr1x2061 accepts a call to mlMint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [mlMint](https://etherscan.io/address/0xee8e0e67d48238048cbe5ffa8559d0b0799cf68c#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xee8e0e67d48238048cbe5ffa8559d0b0799cf68c#code) changes the signer; only a role holder can call it.
- The signer at the block is [0xdff1…3495](https://etherscan.io/address/0xdff1113d60988df55cf6b181ade251a4496d3495), an account without code.

## Reviewer notes

### Mechanism

mlMint (Matr1x2061.sol, line 3689) recovers a signer on line 3702 and tests it on line 3705 against the signer it keeps in storage (verifySigner() returns 0xdff1113d60988df55cf6b181ade251a4496d3495). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (Matr1x2061.sol, line 3797) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-03-02, recovering 0xdff1…3495; 67 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
