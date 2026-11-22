---
id: contract-8377d393-pmm-vault-signer
format: 2
title: Market-maker vault signs any order for a quantum-forged operator key
status: candidate
severity: MEDIUM
justification: Operator ECDSA keys release vault inventory; the 2-of-5 owner Safe can fix it by moving funds to
  new vault code.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8377d393cca7ee75b4e91c612a967e89442d460d'
  code: decompiled
  code_url: code/0xa8e68a7f3071f558cd361468c59fda71e402d48220b2a3338b462070e5491cb1.sol
  copies: 1
  upgradeable: 'no'
  admin: '0x91fd09982efff951df4ff80e7e78fee1981ac51d'
value:
  usd: 315195
  basis: held
activity:
  txs_90d: 4101
impact: funds-loss
action: Move the inventory out of this non-upgradeable vault into one that verifies a post-quantum operator signature.
evidence_level: bytecode
checks:
- id: code
  code: '0x8377d393cca7ee75b4e91c612a967e89442d460d'
  is: contract
  bytes: 11390
  says: The address holds contract code.
  for:
  - what
- id: sel-isvalidsig
  selector: '0x8377d393cca7ee75b4e91c612a967e89442d460d'
  fn: isValidSignature(bytes32,bytes)
  says: The vault exposes the ERC-1271 signature check.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-setoperator
  selector: '0x8377d393cca7ee75b4e91c612a967e89442d460d'
  fn: setOperator(address,bool)
  says: The owner sets operator addresses.
  for:
  - evidence-2
  - justification
  - what
- id: sel-isoperator
  selector: '0x8377d393cca7ee75b4e91c612a967e89442d460d'
  fn: isOperator(address)
  says: The vault keeps an operator list.
  for:
  - evidence-2
  - what
- id: sel-multisend
  selector: '0x8377d393cca7ee75b4e91c612a967e89442d460d'
  fn: multiSend(address[],address)
  says: The vault has a function that sends its tokens out.
  for:
  - action
  - evidence-3
  - justification
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

This vault holds a market maker's inventory and acts as the signing maker for PMM orders through isValidSignature. It accepts signatures from operators set by the owner, so a quantum attacker who recovers an operator key can approve orders that move its tokens.

## Evidence

- [isValidSignature](https://etherscan.io/address/0x8377d393cca7ee75b4e91c612a967e89442d460d#code) is in the vault's bytecode, so the vault acts as an ERC-1271 order signer.
- [setOperator and isOperator](https://etherscan.io/address/0x8377d393cca7ee75b4e91c612a967e89442d460d#code) manage the operator keys whose signatures the vault accepts.
- [multiSend](https://etherscan.io/address/0x8377d393cca7ee75b4e91c612a967e89442d460d#code) lets the owner move tokens out of the vault.

## Reviewer notes

### Mechanism

A taker swaps through OKX DexRouter, which settles a PMM order whose maker is this vault and calls isValidSignature(bytes32,bytes) (selector 0x1626ba7e) on it. The decompiled body checks the signature length ('sig len less than 66', 'wrong length') and returns the magic value 0x1626ba7e after an operator lookup in the operator mapping (storage slot 2, the same mapping isOperator reads), otherwise 'err sig'. The operator mapping is set with setOperator(address,bool) (event OperatorSet). Recovery uses ECDSA, so a recovered operator private key yields signatures the vault accepts, and the router then transfers the vault's tokens to the taker. The contract is not a proxy; rotating operators keeps the ECDSA scheme, so removing it needs new vault code and moving funds with the owner-only multiSend.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable: no proxy; the fix is a new deployment.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
