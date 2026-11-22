---
id: summerpenguin-c36d1b72-rotate-signer-before-migrating
format: 2
title: 'SummerPenguin: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc36d1b722af420917d6ce43a3fdef999b3e32781'
  name: SummerPenguin
  code: verified
  code_url: https://etherscan.io/address/0xc36d1b722af420917d6ce43a3fdef999b3e32781#code
  copies: 1
  upgradeable: 'no'
  admin: '0x904d9e94d6a0e8553c923815d30de5e3cf23762f'
value:
  usd: 1227
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Replace the signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xc36d1b722af420917d6ce43a3fdef999b3e32781'
  file: SummerPenguin.sol
  line: 40
  has: return signerAddress == ECDSA.recover(message, signature);
  says: verifySignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc36d1b722af420917d6ce43a3fdef999b3e32781'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc36d1b722af420917d6ce43a3fdef999b3e32781'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xc36d1b722af420917d6ce43a3fdef999b3e32781'
  file: SummerPenguin.sol
  line: 76
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xc36d1b722af420917d6ce43a3fdef999b3e32781'
  fn: signerAddress()(address)
  is: '0x9cce5f784ecb28428cc35aa23da34ef3fe6ad2e5'
  says: The signer it keeps in storage is 0x9cce5f784ecb28428cc35aa23da34ef3fe6ad2e5 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x9cce5f784ecb28428cc35aa23da34ef3fe6ad2e5'
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

SummerPenguin checks an ECDSA signature in verifySignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddress changes the signer.

## Evidence

- [verifySignature](https://etherscan.io/address/0xc36d1b722af420917d6ce43a3fdef999b3e32781#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0xc36d1b722af420917d6ce43a3fdef999b3e32781#code) changes the signer; only the owner can call it.
- The signer at the block is [0x9cce…d2e5](https://etherscan.io/address/0x9cce5f784ecb28428cc35aa23da34ef3fe6ad2e5), an account without code.

## Reviewer notes

### Mechanism

verifySignature (SummerPenguin.sol, line 25) recovers a signer on line 40 and tests it on line 40 against the signer it keeps in storage (signerAddress() returns 0x9cce5f784ecb28428cc35aa23da34ef3fe6ad2e5). Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (SummerPenguin.sol, line 76) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-09-12, recovering 0x9cce…d2e5; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
