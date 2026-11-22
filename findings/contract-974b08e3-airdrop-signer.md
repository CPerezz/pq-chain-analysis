---
id: contract-974b08e3-airdrop-signer
format: 2
title: Block Street airdrop trusts one ECDSA signer a quantum attacker can forge
status: candidate
severity: MEDIUM
justification: One ECDSA signer authorises all claims; only the owner can fix it by ending the airdrop and redeploying,
  so MEDIUM.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x974b08e3ca65406451cb5867c032eb276fcf90b4'
  project: block-street
  code: decompiled
  code_url: code/0x4e04835ecbaee22ff9bbfc55691053ca3917d7c90755303053817a0ac506497e.sol
  copies: 1
  upgradeable: 'no'
  admin: '0x39830bb4a204278e7d2efd6ae6da50454add9999'
value:
  usd: 16
  basis: held
activity:
  txs_90d: 16
impact: funds-loss
action: End the airdrop, withdraw the remaining BSB, and redeploy claims as a Merkle distribution or with a post-quantum
  signer.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x974b08e3ca65406451cb5867c032eb276fcf90b4'
  has: 600160a01b0316602082602481845afa
  says: the runtime code calls the ecrecover precompile
  for:
  - evidence-1
  - justification
  - what
- id: s-claim
  selector: '0x974b08e3ca65406451cb5867c032eb276fcf90b4'
  fn: claim(uint256,uint256,bytes)
  says: the claim function taking amount, deadline and signature is in the code
  for:
  - evidence-1
  - justification
  - what
- id: s-signer
  selector: '0x974b08e3ca65406451cb5867c032eb276fcf90b4'
  fn: signer()
  says: the contract exposes a single stored signer address
  for:
  - evidence-2
  - justification
  - what
- id: s-setsigner
  selector: '0x974b08e3ca65406451cb5867c032eb276fcf90b4'
  fn: setSigner(address)
  says: the owner can swap the signer address
  for:
  - evidence-2
- id: s-end
  selector: '0x974b08e3ca65406451cb5867c032eb276fcf90b4'
  fn: endAirdrop()
  says: the owner can end the airdrop
  for:
  - action
  - evidence-3
  - justification
- id: s-withdraw
  selector: '0x974b08e3ca65406451cb5867c032eb276fcf90b4'
  fn: withdrawRemaining(address)
  says: the owner can withdraw the remaining tokens
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

The contract pays BSB to callers of claim who present an amount signed by its signer key, checked with ecrecover. A quantum attacker who recovers that key from a published claim signature can sign large claims to fresh addresses and drain the remaining BSB.

## Evidence

- [claim](https://etherscan.io/address/0x974b08e3ca65406451cb5867c032eb276fcf90b4#code) takes an amount, deadline and signature and calls the ecrecover precompile.
- [signer and setSigner](https://etherscan.io/address/0x974b08e3ca65406451cb5867c032eb276fcf90b4#code) hold and swap a single ECDSA signer address.
- [endAirdrop and withdrawRemaining](https://etherscan.io/address/0x974b08e3ca65406451cb5867c032eb276fcf90b4#code) let the owner stop claims and move the balance out.

## Reviewer notes

### Mechanism

From bytecode (unverified): claim(uint256 amount, uint256 deadline, bytes signature) (0x5eddd157) takes a reentrancy guard, reverts if the ended flag in slot 1 is set or hasClaimed[msg.sender], and requires block.timestamp < deadline <= block.timestamp+300 and amount > 0. It then hashes abi.encodePacked(msg.sender, amount, deadline, chainid, address(this)) under the Ethereum Signed Message prefix and runs OpenZeppelin ECDSA with an s-value bound. It STATICCALLs precompile 0x01 and requires the recovered address to equal the signer in slot 1, then transfers amount BSB to msg.sender. The amount is not bounded by any per-user allocation, so one forged signature can take the whole balance. setSigner (0x6c19e783, onlyOwner) only replaces one ECDSA address with another. endAirdrop (0x726b5bad) and withdrawRemaining(address) (0xfd0cdcdb), both onlyOwner, stop claims and transfer the BSB balance out.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not a proxy; the claim logic cannot be upgraded in place.
- Ruled out: Rotating the signer with setSigner leaves the same ECDSA exposure.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
