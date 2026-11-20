---
id: c4ea4b0f-fixed-signer
title: "0xc4ea4b0f: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc4ea4b0fd176743635091ba63b3c46f9db49cabc"
  family: "2cb44e6f2b16ce8ef5def29c32cd89ec"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "No one needs to act. If the signer key's account gets code, verifySignature will return false (or revert, because ECDSA.recover fails), but only off-chain readers of that view would see a difference."
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
  note: "MEDIUM (main reviewer's LOW/MEDIUM rule): the signed function dies for good; other parties' assets leave by separate paths (owner/depositor withdraw, rescue, timeout), not by the same act. The study note does not match this source. This is an ERC1155 LDA, not a presale. The signature check is only an informational view, which is why the rating is LOW and the impact is none. The other two \"constants\" (0x1418..., 0x2932...) are not real addresses. They look like bytes from the code, such as the hash or string constants, read as addresses."
---

## Summary

The signer is a hardcoded constant and is an EOA today (code_bytes 0, not delegated), so the fixed-signer claim holds. The signature check is only a pure view (verifySignature) that checks one constant songHash. No mint, transfer or other function depends on it. EIP-8151 would only change what that view returns. No funds or rights can get stuck.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public constant signer = 0xD2aff66959ee0E6F92EE02D741071DDB5084Bebb` is a constant, and no function can change it
- The constants fact shows 0xd2aff6...bebb with code_bytes 0 and delegated false, so it is an EOA today
- verifySignature(bytes) is `public pure` and no other function in the source calls it
- mintLDAToOwner is onlyOwner and does not check a signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed. If anyone off-chain relies on verifySignature, they can check the signature themselves or with ERC-1271 instead.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
