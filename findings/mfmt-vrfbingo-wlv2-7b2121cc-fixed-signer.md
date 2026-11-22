---
id: mfmt-vrfbingo-wlv2-7b2121cc-fixed-signer
format: 2
title: 'MFMT_VRFBingo_WLv2: its signer cannot be replaced and must not take real code'
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
  address: '0x7b2121cc78611b2ee746c8f7c4e7de7735df2357'
  name: MFMT_VRFBingo_WLv2
  code: verified
  code_url: https://etherscan.io/address/0x7b2121cc78611b2ee746c8f7c4e7de7735df2357#code
  copies: 1
  upgradeable: 'no'
  admin: '0xa6119dc1f2fc434130a8b3724f09dfd27accf599'
value:
  usd: 917
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0x7b2121cc78611b2ee746c8f7c4e7de7735df2357'
  file: gmf-mt.sol
  line: 335
  has: return signerAdmin == _payload.recover(_signature);
  says: matchSignerAdmin recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x7b2121cc78611b2ee746c8f7c4e7de7735df2357'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x7b2121cc78611b2ee746c8f7c4e7de7735df2357'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: written
  source: '0x7b2121cc78611b2ee746c8f7c4e7de7735df2357'
  file: gmf-mt.sol
  line: 23
  has: address signerAdmin = 0x88EbCC12aa77674E0795F2AC0E4e3e418391E65c;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x88ebcc12aa77674e0795f2ac0e4e3e418391e65c'
  is: empty
  says: 'the address recovered in the latest signature check on record has no code: an ECDSA key controls it'
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

MFMT_VRFBingo_WLv2 checks an ECDSA signature in matchSignerAdmin and accepts only a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [matchSignerAdmin](https://etherscan.io/address/0x7b2121cc78611b2ee746c8f7c4e7de7735df2357#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0x7b2121cc78611b2ee746c8f7c4e7de7735df2357#code); the verified source has no function that writes it afterwards.
- The address recovered in its latest signature check on record is [0x88eb…e65c](https://etherscan.io/address/0x88ebcc12aa77674e0795f2ac0e4e3e418391e65c), an account without code.

## Reviewer notes

### Mechanism

matchSignerAdmin (gmf-mt.sol, line 334) recovers a signer on line 335 and tests it on line 335 against a signer fixed at deployment. Neither isValidSignature selector is in the code, so that account is never asked. signerAdmin is written on line 23 of gmf-mt.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2021-12-11, recovering 0x88eb…e65c; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
