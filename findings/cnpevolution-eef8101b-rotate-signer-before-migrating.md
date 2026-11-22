---
id: cnpevolution-eef8101b-rotate-signer-before-migrating
format: 2
title: 'CnpEvolution: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xeef8101bc63cdacd1a3e6ad8f333f7eda87d532b'
  name: CnpEvolution
  code: verified
  code_url: https://etherscan.io/address/0xeef8101bc63cdacd1a3e6ad8f333f7eda87d532b#code
  copies: 1
  upgradeable: 'no'
  admin: '0x1bf41851e4bd044022dfa7e9c678809f5197a56f'
value:
  usd: 91
  basis: held
activity:
  txs_90d: 61
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xeef8101bc63cdacd1a3e6ad8f333f7eda87d532b'
  file: src/CnpEvolution.sol
  line: 62
  has: if (ECDSA.recover(digest, sig) != signer) revert BadSignature();
  says: switchImage recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xeef8101bc63cdacd1a3e6ad8f333f7eda87d532b'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xeef8101bc63cdacd1a3e6ad8f333f7eda87d532b'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xeef8101bc63cdacd1a3e6ad8f333f7eda87d532b'
  file: src/CnpEvolution.sol
  line: 73
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xeef8101bc63cdacd1a3e6ad8f333f7eda87d532b'
  fn: signer()(address)
  is: '0x73eeb099e367e19729d30864a1de01905497c0bb'
  says: The signer it keeps in storage is 0x73eeb099e367e19729d30864a1de01905497c0bb at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x73eeb099e367e19729d30864a1de01905497c0bb'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xfa256023ab483c13abd446b20c20bcaca93ae4bf6ee1f5a3ed179cc4dbe76a3a'
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

CnpEvolution accepts a call to switchImage only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [switchImage](https://etherscan.io/address/0xeef8101bc63cdacd1a3e6ad8f333f7eda87d532b#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xeef8101bc63cdacd1a3e6ad8f333f7eda87d532b#code) changes the signer; only the owner can call it.
- The signer at the block is [0x73ee…c0bb](https://etherscan.io/address/0x73eeb099e367e19729d30864a1de01905497c0bb), an account without code.

## Reviewer notes

### Mechanism

switchImage (src/CnpEvolution.sol, line 48) recovers a signer on line 62 and tests it on line 62 against the signer it keeps in storage (signer() returns 0x73eeb099e367e19729d30864a1de01905497c0bb). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (src/CnpEvolution.sol, line 73) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-15, recovering 0x73ee…c0bb; 61 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
