---
id: ethosrewardsclaim-2d5d8d3b-rotate-signer-before-migrating
format: 2
title: 'EthosRewardsClaim: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2d5d8d3bc51f12de698e0f94b52adfd8c7e53403'
  name: EthosRewardsClaim
  code: verified
  code_url: https://etherscan.io/address/0x527e663e1da0480f8fd357b5cafd8e5c894bc312#code
  proxy_of: '0x527e663e1da0480f8fd357b5cafd8e5c894bc312'
  copies: 3
  family: 4da123dfb03407cfb3d120361797a733
  upgradeable: 'yes'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 106
impact: liveness
action: Before a signer's account moves to real code, use setTrustedAddress so that another key can sign in its
  place.
evidence_level: source
checks:
- id: recover
  source: '0x527e663e1da0480f8fd357b5cafd8e5c894bc312'
  file: src/AirdropAndRewards/EthosRewardsClaim.sol
  line: 313
  has: address signerAddress = ECDSA.recover(ethSignedMessageHash, _signature);
  says: verifySignatureAirdrop recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x527e663e1da0480f8fd357b5cafd8e5c894bc312'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x527e663e1da0480f8fd357b5cafd8e5c894bc312'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x527e663e1da0480f8fd357b5cafd8e5c894bc312'
  file: src/AirdropAndRewards/EthosRewardsClaim.sol
  line: 314
  has: return trustedAddresses[signerAddress];
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x527e663e1da0480f8fd357b5cafd8e5c894bc312'
  file: src/AirdropAndRewards/EthosRewardsClaim.sol
  line: 137
  has: function setTrustedAddress
  says: setTrustedAddress changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xd596406b49b44b2f57ace1b9467fb7c9357b78ec'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x623efd7602c715f4378bf569d59ef7f969dce0def100387790b25b2db80bbf99'
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

EthosRewardsClaim checks an ECDSA signature in verifySignatureAirdrop and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setTrustedAddress changes who may sign.

## Evidence

- [verifySignatureAirdrop](https://etherscan.io/address/0x527e663e1da0480f8fd357b5cafd8e5c894bc312#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setTrustedAddress](https://etherscan.io/address/0x527e663e1da0480f8fd357b5cafd8e5c894bc312#code) changes who may sign; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x623efd7602c715f4378bf569d59ef7f969dce0def100387790b25b2db80bbf99) on record recovered [0xd596…78ec](https://etherscan.io/address/0xd596406b49b44b2f57ace1b9467fb7c9357b78ec), an account without code.

## Reviewer notes

### Mechanism

verifySignatureAirdrop (src/AirdropAndRewards/EthosRewardsClaim.sol, line 304) recovers a signer on line 313 and tests it on line 314 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. setTrustedAddress (src/AirdropAndRewards/EthosRewardsClaim.sol, line 137) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-09-03, recovering 0xd596…78ec; 106 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
