---
id: guardv3-4ca75992-fixed-signer
format: 2
title: 'GuardV3: its signer cannot be replaced and must not take real code'
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
  address: '0x4ca75992d2750bec270731a72dfdede6b9e71cc7'
  name: GuardV3
  code: verified
  code_url: https://etherscan.io/address/0x4ca75992d2750bec270731a72dfdede6b9e71cc7#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 49
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0x4ca75992d2750bec270731a72dfdede6b9e71cc7'
  file: GuardV3.sol
  line: 719
  has: currentGuard = ECDSA.recover(dataHash, signatures[i]);
  says: checkNSignatures recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x4ca75992d2750bec270731a72dfdede6b9e71cc7'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x4ca75992d2750bec270731a72dfdede6b9e71cc7'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: written
  source: '0x4ca75992d2750bec270731a72dfdede6b9e71cc7'
  file: GuardV3.sol
  line: 470
  has: address internal constant SENTINEL_GUARDS = address(0x1);
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x3b9e571adecb0c277486036d6097e9c2cccfa9d9'
  is: empty
  says: 'the address recovered in the latest signature check on record has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xe8f918397789e39b0715498ea543e42732d60d5eeb439b4ad4e93346ef0b6648'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
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

GuardV3 checks an ECDSA signature in checkNSignatures and accepts only a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x4ca75992d2750bec270731a72dfdede6b9e71cc7#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0x4ca75992d2750bec270731a72dfdede6b9e71cc7#code); the verified source has no function that writes it afterwards.
- Its latest signed [transaction](https://etherscan.io/tx/0xe8f918397789e39b0715498ea543e42732d60d5eeb439b4ad4e93346ef0b6648) on record recovered [0x3b9e…a9d9](https://etherscan.io/address/0x3b9e571adecb0c277486036d6097e9c2cccfa9d9), an account without code.

## Reviewer notes

### Mechanism

checkNSignatures (GuardV3.sol, line 708) recovers a signer on line 719 and tests it on line 719 against a signer fixed at deployment. Neither isValidSignature selector is in the code, so that account is never asked. SENTINEL_GUARDS is written on line 470 of GuardV3.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0x3b9e…a9d9; 49 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
