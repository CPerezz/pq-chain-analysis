---
id: leftoverexchanger-e9f1420b-signer-upgrade-only
title: "LeftoverExchanger: signer replaceable only by an upgrade"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe9f1420bf4ff6a1db45baf974c84d81bea781b58"
  family: "10aaa29e460cafdb7d9a01c516f3f076"
  name: "LeftoverExchanger"
  label: "deployed by 1inch: Deployer 5"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "1inch resolver operator"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "MEDIUM: no update path, but only the operator's own resolver balance is at stake and the owner's direct-call exits still move it. Only the ERC-1271 signed function dies. This is the template itself."
---

## Summary

1inch resolver/LeftoverExchanger-style contract: isValidSignature accepts only ecrecover == 0x2d2d58933e62ed68794d3c337a4d3bc24809ceb2, hard-coded in bytecode (immutable/constant), with no setter and no upgrade path. If that key's account takes real code, the ERC-1271 signed path dies, but the same key can still sweep the funds by calling the contract directly.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: 1inch LeftoverExchanger ERC-1271: the signer must be _OWNER, fixed in the code. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- verified source LeftoverExchanger.sol: isValidSignature returns the magic value iff ECDSA.recover(hash,sig) == _OWNER (immutable)
- 0x2d2d58933e62ed68794d3c337a4d3bc24809ceb2 at block 26438999: no code (EOA), nonce 4469
- Way out: the owner-gated exits (batchTransfer(bytes), rescueEther(), transfer(address,address,uint256)) require msg.sender == the same address (OnlyOwner 0x5fc483c5)
- EIP-1967 implementation slot empty; bytecode has no upgrade selector; value held: None USD, txs_90d 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Before migrating the owner key to code, sweep the funds out through the owner-gated direct calls and redeploy a resolver that checks ERC-1271 or takes a settable signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
