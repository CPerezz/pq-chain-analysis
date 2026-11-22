---
id: cryptogames-33333313-fixed-signer
format: 2
title: 'CryptoGames: its signer cannot be replaced and must not take real code'
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
  address: '0x3333331365f21e192fd43e599dbb44eff532a667'
  name: CryptoGames
  code: verified
  code_url: https://etherscan.io/address/0x3333331365f21e192fd43e599dbb44eff532a667#code
  copies: 3
  family: 4a28a8cc81e8dc2989423a1aaacb61f9
  upgradeable: 'no'
  admin: '0x333333e25f2176e2e165aeb1b933ce10cf315b47'
value:
  usd: 8
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0x3333331365f21e192fd43e599dbb44eff532a667'
  file: CryptoGames.sol
  line: 195
  has: require (ecrecover(seed, _v, _r, _s) == CROUPIER_BOB);
  says: confirm recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x3333331365f21e192fd43e599dbb44eff532a667'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x3333331365f21e192fd43e599dbb44eff532a667'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: written
  source: '0x3333331365f21e192fd43e599dbb44eff532a667'
  file: CryptoGames.sol
  line: 42
  has: address public  CROUPIER_BOB = 0xB0B3336c83A4c86FBd4f804BB8D410B23F181b05;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x3333331365f21e192fd43e599dbb44eff532a667'
  fn: CROUPIER_BOB()(address)
  is: '0xb0b3336c83a4c86fbd4f804bb8d410b23f181b05'
  says: A signer fixed at deployment is 0xb0b3336c83a4c86fbd4f804bb8d410b23f181b05 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xb0b3336c83a4c86fbd4f804bb8d410b23f181b05'
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
  rating: HIGH
reviews: []
related: []
---

## What happens

CryptoGames accepts a call to confirm only with an ECDSA signature of a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [confirm](https://etherscan.io/address/0x3333331365f21e192fd43e599dbb44eff532a667#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0x3333331365f21e192fd43e599dbb44eff532a667#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0xb0b3…1b05](https://etherscan.io/address/0xb0b3336c83a4c86fbd4f804bb8d410b23f181b05), an account without code.

## Reviewer notes

### Mechanism

confirm (CryptoGames.sol, line 193) recovers a signer on line 195 and tests it on line 195 against a signer fixed at deployment (CROUPIER_BOB() returns 0xb0b3336c83a4c86fbd4f804bb8d410b23f181b05). Neither isValidSignature selector is in the code, so that account is never asked. CROUPIER_BOB is written on line 42 of CryptoGames.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2020-09-18, recovering 0xb0b3…1b05; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
