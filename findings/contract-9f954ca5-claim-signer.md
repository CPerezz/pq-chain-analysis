---
id: contract-9f954ca5-claim-signer
format: 2
title: MUTY claim distributor trusts one ECDSA signer a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: Signer key is ECDSA and updateSigner only rotates it; the owner must deploy a new distributor to
  fix.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9f954ca511ea6c453fc743d0d9b8fbf17e7d86c0'
  project: mumutycoon
  code: decompiled
  code_url: code/0x0b1764dec52702263d71be7d68a46b2729525baa5b09aa53d491193d54c29995.sol
  copies: 1
  upgradeable: 'no'
  admin: '0x7d7e03d8f6c3870752249cbea0f787690e29d462'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace the distributor with one verifying post-quantum signatures or a Merkle root before refilling.
evidence_level: bytecode
checks:
- id: sel-claim
  selector: '0x9f954ca511ea6c453fc743d0d9b8fbf17e7d86c0'
  fn: claim(string,uint256,uint256,uint256,bytes)
  says: The claim function taking a signature is in the code.
  for:
  - evidence-1
  - what
- id: sel-signer
  selector: '0x9f954ca511ea6c453fc743d0d9b8fbf17e7d86c0'
  fn: signer()
  says: A single signer address getter is in the code.
  for:
  - evidence-2
  - justification
  - what
- id: sel-updatesigner
  selector: '0x9f954ca511ea6c453fc743d0d9b8fbf17e7d86c0'
  fn: updateSigner(address)
  says: The owner can replace the signer address, not the scheme.
  for:
  - action
  - evidence-2
  - justification
- id: sel-eip712
  selector: '0x9f954ca511ea6c453fc743d0d9b8fbf17e7d86c0'
  fn: eip712Domain()
  says: The contract exposes an EIP-712 signing domain.
  for:
  - evidence-1
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
reviews: []
related: []
---

## What happens

The contract pays out MUTY to callers of claim with an EIP-712 message signed by one backend signer key. A quantum attacker who recovers that signer's ECDSA key can sign claims and draw out whatever MUTY the distributor holds.

## Evidence

- [claim](https://etherscan.io/address/0x9f954ca511ea6c453fc743d0d9b8fbf17e7d86c0#code) takes a signature over an EIP-712 claim; eip712Domain is exposed.
- [signer and updateSigner](https://etherscan.io/address/0x9f954ca511ea6c453fc743d0d9b8fbf17e7d86c0#code) hold and rotate a single signer address.

## Reviewer notes

### Mechanism

Bytecode only. claim(string,uint256,uint256,uint256,bytes) (0x6b3a4851) and sibling 0xbc1133de recover the signer of an EIP-712 digest (domain via eip712Domain/getDomainSeparator) and compare with signer() (0x238ac933, decompiled as store_e >> 8). Per-user nonces (getUserNonce) and SIGNATURE_VALIDITY_PERIOD = 3600 bound replay, and MAX_CLAIM_AMOUNT caps a single claim, but a forged signature from the recovered key passes all of these. Payouts transfer MUTY (0xecdbe205...) held by the contract, which the owner refills via depositTokens. updateSigner(address) (0xa7ecd37e) only swaps the ECDSA address; no upgrade selectors exist.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No proxy or upgrade path; scheme change needs a new deployment.
- Ruled out: Distributor currently holds no MUTY and no ETH.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
