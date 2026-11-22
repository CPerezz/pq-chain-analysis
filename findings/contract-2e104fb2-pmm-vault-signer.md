---
id: contract-2e104fb2-pmm-vault-signer
format: 2
title: Market-maker vault trusts operator ECDSA keys a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: A forged operator key lets the vault approve any order; MEDIUM because the owner Safe can upgrade
  the vault code.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2e104fb25676c7c3e3a5a648865cca1db15dcc71'
  code: decompiled
  code_url: code/0x88bbffccccd4d989033df93971d0670168b913a81cd6169ebaf14594b5f14ea1.sol
  proxy_of: '0xbf95581001997a4ad56b741575cdf94820b2e113'
  copies: 1
  upgradeable: 'yes'
  admin: '0x88e0ab3351446461f16813899fc40cce2d85aceb'
value:
  usd: 663870
  basis: held
activity:
  txs_90d: 18980
impact: funds-loss
action: Upgrade the vault through its ProxyAdmin to code that verifies a post-quantum operator signature in isValidSignature.
evidence_level: bytecode
checks:
- id: sel-isvalid
  selector: '0xbf95581001997a4ad56b741575cdf94820b2e113'
  fn: isValidSignature(bytes32,bytes)
  says: The vault exposes the ERC-1271 signature check.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-setop
  selector: '0xbf95581001997a4ad56b741575cdf94820b2e113'
  fn: setOperator(address,bool)
  says: The vault lets its owner set operator addresses.
  for:
  - evidence-2
  - justification
  - what
- id: sel-isop
  selector: '0xbf95581001997a4ad56b741575cdf94820b2e113'
  fn: isOperator(address)
  says: The vault keeps a per-address operator flag.
  for:
  - evidence-2
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review08 (bytecode, proxy slots, Safe reads, deployer siblings, token flows)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This vault acts as an ERC-1271 maker for PMM orders and approves an order signature when it comes from an address marked as operator. A quantum attacker who recovers an operator's ECDSA key can sign any order and take the vault's inventory.

## Evidence

- [isValidSignature](https://etherscan.io/address/0xbf95581001997a4ad56b741575cdf94820b2e113#code) is in the vault code, so the vault answers ERC-1271 signature checks.
- [setOperator](https://etherscan.io/address/0xbf95581001997a4ad56b741575cdf94820b2e113#code) and isOperator manage the operator addresses whose signatures the vault trusts.

## Reviewer notes

### Mechanism

A taker swaps through the OKX DexRouter, which settles a PMM order whose maker is this vault and checks the maker signature by calling isValidSignature(bytes32,bytes) (selector 0x1626ba7e). Decompiled code requires a signature of at least 65 bytes ('at least 65 sig'), recovers a signer with ECDSA and returns the magic value 0x1626ba7e when the recovered address is set in the operator mapping (isOperator, written by setOperator(address,bool)), else 0xffffffff. The router then moves the vault's tokens. Rotating operators keeps the ECDSA scheme; only new implementation code behind the proxy removes it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Bytecode only; signature recovery logic read from decompiled code, not verified source.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
