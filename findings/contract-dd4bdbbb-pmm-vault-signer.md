---
id: contract-dd4bdbbb-pmm-vault-signer
format: 2
title: PMM vault accepts operator ECDSA signatures a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: Forged operator signature releases vault inventory; MEDIUM as the owner can upgrade the proxied vault
  code.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xdd4bdbbb5e2e69165397f4af16ae520e549da1e4'
  code: decompiled
  code_url: code/0x9ccc309852968117da0c810a134e08d1e5c1a8c28b857d96e4db8fbed5d78825.sol
  proxy_of: '0x1bdb1d6bbe6d3bd03ec2897bcce530926493680f'
  copies: 1
  upgradeable: 'yes'
  admin: '0xbc6eeb953c3f9879da28a8a2b3158c06c7f349a7'
value:
  usd: 34
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Upgrade the vault via its ProxyAdmin to verify a post-quantum operator signature in isValidSignature.
evidence_level: bytecode
checks:
- id: sel-ivs
  selector: '0x1bdb1d6bbe6d3bd03ec2897bcce530926493680f'
  fn: isValidSignature(bytes32,bytes)
  says: The vault code exposes the ERC-1271 signature check.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-isop
  selector: '0x1bdb1d6bbe6d3bd03ec2897bcce530926493680f'
  fn: isOperator(address)
  says: The vault code keeps an operator set.
  for:
  - evidence-2
  - justification
  - what
- id: sel-ms
  selector: '0x1bdb1d6bbe6d3bd03ec2897bcce530926493680f'
  fn: multiSend(address[],address)
  says: The vault code can send its held tokens out.
  for:
  - evidence-3
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

This vault is an ERC-1271 maker for PMM orders and approves an order when isValidSignature accepts a 65-byte ECDSA signature from an operator. A quantum attacker who recovers an operator key can make the vault approve orders that hand over its inventory.

## Evidence

- [isValidSignature](https://etherscan.io/address/0x1bdb1d6bbe6d3bd03ec2897bcce530926493680f#code) is in the vault code and gates order approval on a signature.
- [isOperator](https://etherscan.io/address/0x1bdb1d6bbe6d3bd03ec2897bcce530926493680f#code) tracks the operator addresses whose signatures the vault accepts.
- [multiSend](https://etherscan.io/address/0x1bdb1d6bbe6d3bd03ec2897bcce530926493680f#code) lets the owner move the vault's tokens out.

## Reviewer notes

### Mechanism

Bytecode-only implementation behind a proxy. isValidSignature (selector 0x1626ba7e) decodes the signature bytes, requires length 65 ('only 65 sig'), applies the OpenZeppelin ECDSA s-value bound and recovery error codes, then looks up the recovered address in the operator mapping (slot 2, read by isOperator 0x6d70f7ae). It returns the ERC-1271 magic value 0x1626ba7e for an operator, else 0xffffffff. The OKX DexRouter settles PMM orders whose maker is the vault after this check and then moves the vault's tokens. Rotating operators keeps the ECDSA scheme; only new implementation code removes it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Operator key rotation alone does not remove the ECDSA dependency.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
