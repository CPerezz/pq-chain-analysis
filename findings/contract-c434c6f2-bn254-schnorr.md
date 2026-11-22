---
id: contract-c434c6f2-bn254-schnorr
format: 2
title: PrivateDEX deposits rest on BN254 proofs a quantum attacker could forge
status: candidate
severity: HIGH
justification: Discrete-log proofs on BN254 guard deposits in code the owner cannot change; only a new deployment
  fixes it.
category: quantum-exposure
pattern: PQ-11
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc434c6f25ed88f5365465bd6ff9bf04d1d944500'
  project: houdini-swap
  code: decompiled
  code_url: code/0x2b4cbbd2b55836c723ccbf74afa1c7226a290990d47cca4ca85e1fed1743ac5e.sol
  copies: 1
  admin: '0x8a462a861e34939157c61d478e959dc18152fc2e'
value:
  usd: 4
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Redeploy with a post-quantum ownership proof (hash commitments with a STARK) and have depositors withdraw
  from this contract.
evidence_level: bytecode
checks:
- id: code
  code: '0xc434c6f25ed88f5365465bd6ff9bf04d1d944500'
  is: contract
  bytes: 16408
  says: the address holds 16408 bytes of contract code
  for:
  - action
  - justification
  - what
- id: sel-getvalue
  selector: '0xc434c6f25ed88f5365465bd6ff9bf04d1d944500'
  fn: getValue(uint256,address)
  says: per-deposit token balance getter is present
  for:
  - evidence-1
  - what
- id: sel-proofused
  selector: '0xc434c6f25ed88f5365465bd6ff9bf04d1d944500'
  fn: proofUsed(bytes32)
  says: contract records used proofs
  for:
  - evidence-2
  - what
- id: sel-nullifier
  selector: '0xc434c6f25ed88f5365465bd6ff9bf04d1d944500'
  fn: nullifierUsed(uint256)
  says: contract records used nullifiers
  for:
  - evidence-2
  - what
- id: sel-whitelist
  selector: '0xc434c6f25ed88f5365465bd6ff9bf04d1d944500'
  fn: AddContractToWhitelist(address)
  says: owner function manages the contract whitelist
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
reviews: []
related: []
---

## What happens

This PrivateDEX holds token deposits keyed to BN254 curve points and tracks spent proofs and nullifiers. A quantum attacker who solves a deposit's discrete log can forge its ownership proof and withdraw it.

## Evidence

- [Deposit balances](https://etherscan.io/address/0xc434c6f25ed88f5365465bd6ff9bf04d1d944500#code) are looked up per deposit id and token via getValue.
- [Proof and nullifier records](https://etherscan.io/address/0xc434c6f25ed88f5365465bd6ff9bf04d1d944500#code) (proofUsed, nullifierUsed) gate spending of deposits.
- [Owner functions](https://etherscan.io/address/0xc434c6f25ed88f5365465bd6ff9bf04d1d944500#code) manage the contract whitelist, such as AddContractToWhitelist.

## Reviewer notes

### Mechanism

Unverified bytecode matching the verified PrivateDEX except for the linked CryptoCore library address. In PrivateDEX, WithdrawERC20 looks up the deposit by D.A.X, hashes the operation with sha256 and calls CryptoCore.VerifyProof, which checks R + e·D.B == z·D.A on BN254 G1 with ecMul/ecAdd. This is a Schnorr proof of knowledge of x with D.B = x·D.A. Private-mode paths use VerifyProofPrivate, an OR-composition with a nullifier. Recovering x by a quantum discrete-log attack lets anyone forge the proof and send the tokens to any address. Owner functions only touch the whitelist, and there is no proxy, so the check cannot be replaced.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not a SNARK/trusted-setup issue: the pairing helper is unused on these paths
- Ruled out: No upgrade path: owner only edits the whitelist

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
