---
id: crosschain-0bbc02ef-rotate-signer-before-migrating
format: 2
title: 'Crosschain: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0bbc02ef7ce79a820b7edda8d5d409ae7615e636'
  name: Crosschain
  code: verified
  code_url: https://etherscan.io/address/0xde9305c7489d9f05aa96931b3e9c7ac19aae246c#code
  proxy_of: '0xde9305c7489d9f05aa96931b3e9c7ac19aae246c'
  copies: 2
  family: abfe20671d9285cedc699d29f3870aba
  upgradeable: 'yes'
  admin: '0x2a9da57ee6e79bb17b90d122f49785917d24dfd9'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 71
impact: liveness
action: Before a signer's account moves to real code, use addNodeAddr so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xde9305c7489d9f05aa96931b3e9c7ac19aae246c'
  file: Crosschain.sol
  line: 471
  has: address _nodeAddr = ecrecover(hash, _sig.v, _sig.r, _sig.s);
  says: verifySign recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xde9305c7489d9f05aa96931b3e9c7ac19aae246c'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xde9305c7489d9f05aa96931b3e9c7ac19aae246c'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xde9305c7489d9f05aa96931b3e9c7ac19aae246c'
  file: Crosschain.sol
  line: 472
  has: require(_nodeAddr !=address(0),"Illegal signature");
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xde9305c7489d9f05aa96931b3e9c7ac19aae246c'
  file: Crosschain.sol
  line: 305
  has: function addNodeAddr
  says: addNodeAddr changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x470259a440f4f2b3bc63aa90b7a68528717b9a36'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x8a8a51356f0b29a9c4823ba9b2b792468815944cfdfb2a987e05914fe6274e34'
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

Crosschain checks an ECDSA signature in verifySign and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addNodeAddr changes who may sign.

## Evidence

- [verifySign](https://etherscan.io/address/0xde9305c7489d9f05aa96931b3e9c7ac19aae246c#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [addNodeAddr](https://etherscan.io/address/0xde9305c7489d9f05aa96931b3e9c7ac19aae246c#code) changes who may sign; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x8a8a51356f0b29a9c4823ba9b2b792468815944cfdfb2a987e05914fe6274e34) on record recovered [0x4702…9a36](https://etherscan.io/address/0x470259a440f4f2b3bc63aa90b7a68528717b9a36), an account without code.

## Reviewer notes

### Mechanism

verifySign (Crosschain.sol, line 466) recovers a signer on line 471 and tests it on line 472 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. addNodeAddr (Crosschain.sol, line 305) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-14, recovering 0x4702…9a36; 71 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
