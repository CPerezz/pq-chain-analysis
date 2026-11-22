---
id: campaignbank-f26d144b-rotate-signer-before-migrating
format: 2
title: 'CampaignBank: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf26d144bd92260fb1c770b5b19b8caf2c5529e62'
  name: CampaignBank
  code: verified
  code_url: https://etherscan.io/address/0xf26d144bd92260fb1c770b5b19b8caf2c5529e62#code
  copies: 1
  upgradeable: 'no'
  admin: '0x169b80c523d432d243a21ce0c520678289f6f4ad'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 173
impact: liveness
action: Before a signer's account moves to real code, use registerTrustedSigner so that another key can sign in
  its place.
evidence_level: source
checks:
- id: recover
  source: '0xf26d144bd92260fb1c770b5b19b8caf2c5529e62'
  file: CampaignBank.sol
  line: 260
  has: trustedSigner[verify.recover(signature)],
  says: claimReward recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xf26d144bd92260fb1c770b5b19b8caf2c5529e62'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xf26d144bd92260fb1c770b5b19b8caf2c5529e62'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xf26d144bd92260fb1c770b5b19b8caf2c5529e62'
  file: CampaignBank.sol
  line: 187
  has: function registerTrustedSigner
  says: registerTrustedSigner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xc1070bf724c3e5b1a0d4da913ab9c28175e9075b'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x3bba09d564c4d2ddf9019285b193f3be6984bf8e4a1c567130caf8aec4c7229a'
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

CampaignBank accepts a call to claimReward only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. registerTrustedSigner changes who may sign.

## Evidence

- [claimReward](https://etherscan.io/address/0xf26d144bd92260fb1c770b5b19b8caf2c5529e62#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [registerTrustedSigner](https://etherscan.io/address/0xf26d144bd92260fb1c770b5b19b8caf2c5529e62#code) changes who may sign; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x3bba09d564c4d2ddf9019285b193f3be6984bf8e4a1c567130caf8aec4c7229a) on record recovered [0xc107…075b](https://etherscan.io/address/0xc1070bf724c3e5b1a0d4da913ab9c28175e9075b), an account without code.

## Reviewer notes

### Mechanism

claimReward (CampaignBank.sol, line 242) recovers a signer on line 260 and tests it on line 260 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. registerTrustedSigner (CampaignBank.sol, line 187) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-09-14, recovering 0xc107…075b; 173 transactions called the address in the 90 days before the block. 4 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
