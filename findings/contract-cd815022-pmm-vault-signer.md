---
id: contract-cd815022-pmm-vault-signer
format: 2
title: PMM vault accepts operator ECDSA signatures a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: A forged operator key makes the vault approve any order; the 2-of-5 owner Safe can fix it by upgrading
  the code.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcd81502214d405f40ff14884f2b3962a2f822d67'
  code: decompiled
  code_url: code/0xc9ed0d58d5e8c632733188114bf6cd56305450539723b020e4a062f845840d16.sol
  proxy_of: '0x2e9f95c5327e3c6c30d6601b4bb1b527defea577'
  copies: 1
  upgradeable: 'yes'
  admin: '0x0a19711f1b1696bf1fb93478bb3e5f454a3ab07b'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Upgrade the vault to verify a post-quantum operator signature in isValidSignature.
evidence_level: bytecode
checks:
- id: sel-isvalid
  selector: '0x2e9f95c5327e3c6c30d6601b4bb1b527defea577'
  fn: isValidSignature(bytes32,bytes)
  says: The vault exposes the ERC-1271 signature check.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-setop
  selector: '0x2e9f95c5327e3c6c30d6601b4bb1b527defea577'
  fn: setOperator(address,bool)
  says: The owner can set operator signer addresses.
  for:
  - evidence-2
  - justification
  - what
- id: sel-isop
  selector: '0x2e9f95c5327e3c6c30d6601b4bb1b527defea577'
  fn: isOperator(address)
  says: The vault keeps an operator set it consults.
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

This vault acts as an ERC-1271 maker for PMM orders and answers isValidSignature with ECDSA signatures from operators the owner sets. A quantum attacker who recovers an operator key can sign orders the vault approves and take whatever inventory it holds.

## Evidence

- [isValidSignature](https://etherscan.io/address/0x2e9f95c5327e3c6c30d6601b4bb1b527defea577#code) is in the vault code, so the vault validates maker signatures on-chain.
- [setOperator](https://etherscan.io/address/0x2e9f95c5327e3c6c30d6601b4bb1b527defea577#code) and isOperator manage the signer set the vault trusts.

## Reviewer notes

### Mechanism

Unverified implementation 0x2e9f95c5 behind an EIP-1967 proxy. Takers fill PMM orders through OKX DexRouter (dagSwapByOrderId), which calls vault.isValidSignature(hash, signature). Decompiled selector 0x1626ba7e requires a signature of at least 65 bytes ('at least 65 sig'), recovers a signer with ECDSA and returns the magic value 0x1626ba7e when isOperator(signer) is true (storage mapping at slot 2, set by setOperator). With a recovered operator key, an attacker signs arbitrary orders and the router moves the vault's tokens. Rotating operators keeps ECDSA; only new code removes it. The listed vault currently holds nothing; sibling vaults of the same design and owner hold inventory.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Listed vault balance is currently zero; exposure sits in sibling vaults.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
