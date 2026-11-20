---
id: 1bc65fc3-fixed-signer
title: "0x1bc65fc3: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1bc65fc37add731cdc500de059342f5fabef45dd"
  family: "ecb8888c546b5c9199ea87fd5c726418"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator: deploy a new airdrop contract with a new signer and fund it again"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "I matched the signer to 0x27c3… by elimination: the token must be the contract (it is called for balanceOf/transfer), so the EOA must be the signer. If the signer fails, only the airdrop's claim stops. Unclaimed stock is burned by design, and users lose no deposits."
---

## Summary

The signer is the immutable signAddress, and the only EOA in the bytecode is 0x27c3…b0a7, so that is the signer. The contract has no ERC-1271 or code check. If the signer key's account gets code, claims stop. No user funds are held: the stock belongs to the operator, and endAirdrop is designed to burn whatever is unclaimed. So the claim function stops but nothing users own is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable signAddress;` is set in the constructor from _checker
- checkAirdrop: ECDSA.recover(mHash, s) then require(recoverSignAddress == signAddress, "SIGN ERROR")
- Address values in the bytecode: 0x12ee…ef42 is a contract (2832 bytes), so it is eth1 (claim calls balanceOf on it); 0x27c3…b0a7 is an EOA, so it is signAddress
- No function sets signAddress; Ownable only changes the owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a new signer key that is an EOA (or 7702-delegated) or with ERC-1271 support, and fund the new contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
