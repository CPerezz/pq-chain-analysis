---
id: culturecodes-b5c08608-rotate-signer-before-migrating
format: 2
title: 'CultureCodes: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb5c0860815f9142bd5e8e55aae21cdae0169182d'
  name: CultureCodes
  code: verified
  code_url: https://etherscan.io/address/0xb5c0860815f9142bd5e8e55aae21cdae0169182d#code
  copies: 1
  upgradeable: 'no'
  admin: '0xbb048e05e69eef8781eb0ddd4b81579c7fbc6be2'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 15
impact: liveness
action: Replace the signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xb5c0860815f9142bd5e8e55aae21cdae0169182d'
  file: CultureCodes.sol
  line: 330
  has: require(recover(hash, signature)==_signerAddress, "INVALID SIGNATURE");
  says: HolderMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xb5c0860815f9142bd5e8e55aae21cdae0169182d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xb5c0860815f9142bd5e8e55aae21cdae0169182d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xb5c0860815f9142bd5e8e55aae21cdae0169182d'
  file: CultureCodes.sol
  line: 578
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xfeff9016efbb5fccadb87444285bfed17e1a071a'
  is: empty
  says: the address recovered in the latest signature check on record has no code
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

CultureCodes accepts a call to HolderMint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddress changes the signer.

## Evidence

- [HolderMint](https://etherscan.io/address/0xb5c0860815f9142bd5e8e55aae21cdae0169182d#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0xb5c0860815f9142bd5e8e55aae21cdae0169182d#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0xfeff…071a](https://etherscan.io/address/0xfeff9016efbb5fccadb87444285bfed17e1a071a), an account without code.

## Reviewer notes

### Mechanism

HolderMint (CultureCodes.sol, line 316) recovers a signer on line 330 and tests it on line 330 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (CultureCodes.sol, line 578) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-01-19, recovering 0xfeff…071a; 15 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
