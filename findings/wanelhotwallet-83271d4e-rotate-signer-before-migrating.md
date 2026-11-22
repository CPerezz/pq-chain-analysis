---
id: wanelhotwallet-83271d4e-rotate-signer-before-migrating
format: 2
title: 'WanelHotWallet: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x83271d4e26aafbe8457e6165e162ad9d569f42da'
  name: WanelHotWallet
  code: verified
  code_url: https://etherscan.io/address/0x83271d4e26aafbe8457e6165e162ad9d569f42da#code
  copies: 2
  family: 90f9aa005a2ab82389746d745542a5ba
  upgradeable: 'no'
  admin: '0xbe240469a95721978679f968654fb648d01b0ef8'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 7
impact: liveness
action: Before a signer's account moves to real code, use setObserver so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x83271d4e26aafbe8457e6165e162ad9d569f42da'
  file: 261117_WanelHotWallet/WanelHotWallet.sol
  line: 153
  has: address recoveredObserver = _recover(digest, signatures[i]);
  says: _countValidObservers recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x83271d4e26aafbe8457e6165e162ad9d569f42da'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x83271d4e26aafbe8457e6165e162ad9d569f42da'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x83271d4e26aafbe8457e6165e162ad9d569f42da'
  file: 261117_WanelHotWallet/WanelHotWallet.sol
  line: 67
  has: function setObserver
  says: setObserver changes who may sign
  for:
  - action
  - evidence-2
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

WanelHotWallet checks an ECDSA signature in _countValidObservers and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setObserver changes who may sign.

## Evidence

- [_countValidObservers](https://etherscan.io/address/0x83271d4e26aafbe8457e6165e162ad9d569f42da#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setObserver](https://etherscan.io/address/0x83271d4e26aafbe8457e6165e162ad9d569f42da#code) changes who may sign; only the owner can call it.

## Reviewer notes

### Mechanism

_countValidObservers (261117_WanelHotWallet/WanelHotWallet.sol, line 149) recovers a signer on line 153 and tests it on line 153 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. setObserver (261117_WanelHotWallet/WanelHotWallet.sol, line 67) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 7 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
