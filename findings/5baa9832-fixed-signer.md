---
id: 5baa9832-fixed-signer
title: "0x5baa9832: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5baa9832a16dff1b02e7d557649638e46934196b"
  family: "1b4ffa515a9d2fac4aa42eb8a066a279"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner (0x060918a75a405c2981fa504b1bdbc611c6036fb1) withdraws the tokens and redeploys the contract, or distributes the tokens to beneficiaries another way."
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
  note: "I could not check whether the signer is an EOA today. Its immutable value is not in the row facts (constants list is empty), so neither the address nor its code size is available. The confirmation assumes it is an EOA; if it already has non-delegation code, the verdict would be refuted. The study_note calls this a presale with signed deposits, but in the source deposit() is owner-only and only claim() needs a signature."
---

## Summary

The signer is immutable and nothing can replace it. OpenZeppelin's ECDSA.recover has no ERC-1271 fallback and the contract never checks for code. If the signer's account gets real code, claims stop working. The owner can still pull the operator-funded tokens out with withdraw(), so nothing is locked and only the claim function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address private immutable __signer;` is assigned only in the constructor
- In claim(): `if (_recover(walletAllocation, signature) != __signer) revert InvalidSignature();`
- _recover uses ECDSA.recover only (no SignatureChecker or isValidSignature)
- withdraw(uint256 amount) onlyOwner calls `token.safeTransfer(msg.sender, amount)`, so the owner can rescue the tokens

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new Claim contract with a signer that is an EOA (or 7702-delegated), or with a signer that can be changed and ERC-1271 support. Then have the owner withdraw the remaining tokens from this contract and move them to the new one.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
