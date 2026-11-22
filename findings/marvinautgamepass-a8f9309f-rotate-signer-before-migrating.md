---
id: marvinautgamepass-a8f9309f-rotate-signer-before-migrating
format: 2
title: 'MarvinautGamePass: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa8f9309fb856139e2ad0c168cf875a665aa783a9'
  name: MarvinautGamePass
  code: verified
  code_url: https://etherscan.io/address/0xa8f9309fb856139e2ad0c168cf875a665aa783a9#code
  copies: 1
  upgradeable: 'no'
  admin: '0xe5eabe8582847909f9421cc50c94bbfc765c36b6'
value:
  usd: 180
  basis: held
activity:
  txs_90d: 3
impact: liveness
action: Replace the signer with setupContract before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xa8f9309fb856139e2ad0c168cf875a665aa783a9'
  file: contracts/MarvinautGamePass.sol
  line: 147
  has: require(_hashedMessage.toEthSignedMessageHash().recover(_signature) == signer, 'InvalidSigner');
  says: wlMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xa8f9309fb856139e2ad0c168cf875a665aa783a9'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xa8f9309fb856139e2ad0c168cf875a665aa783a9'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xa8f9309fb856139e2ad0c168cf875a665aa783a9'
  file: contracts/MarvinautGamePass.sol
  line: 41
  has: function setupContract
  says: setupContract changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xa8f9309fb856139e2ad0c168cf875a665aa783a9'
  fn: signer()(address)
  is: '0xa6a1eeb18cfd73a5e46661fadb4894e188abd1c5'
  says: The signer it keeps in storage is 0xa6a1eeb18cfd73a5e46661fadb4894e188abd1c5 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xa6a1eeb18cfd73a5e46661fadb4894e188abd1c5'
  is: delegation
  target: '0x0727ca41efc85f75cef26ee48f825893b4836786'
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

MarvinautGamePass accepts a call to wlMint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setupContract changes the signer.

## Evidence

- [wlMint](https://etherscan.io/address/0xa8f9309fb856139e2ad0c168cf875a665aa783a9#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setupContract](https://etherscan.io/address/0xa8f9309fb856139e2ad0c168cf875a665aa783a9#code) changes the signer; only the owner can call it.
- The signer at the block is [0xa6a1…d1c5](https://etherscan.io/address/0xa6a1eeb18cfd73a5e46661fadb4894e188abd1c5), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

wlMint (contracts/MarvinautGamePass.sol, line 145) recovers a signer on line 147 and tests it on line 147 against the signer it keeps in storage (signer() returns 0xa6a1eeb18cfd73a5e46661fadb4894e188abd1c5). Neither isValidSignature selector is in the code, so that account is never asked. setupContract (contracts/MarvinautGamePass.sol, line 41) writes it. The signer's account holds an EIP-7702 delegation to 0x0727ca41efc85f75cef26ee48f825893b4836786. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-05-01, recovering 0xa6a1…d1c5; 3 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
