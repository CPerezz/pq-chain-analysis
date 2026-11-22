---
id: 04e42d93-fixed-signer
title: "0x04e42d93: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x04e42d93cff5deeb6a6485333af241bce566d317"
  family: "eedad1aa2d530711e10abd47366dc4e4"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 965
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner, or the project redeploying with a new signer. The owner can still call drain() and stopPresale()."
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
  note: "Unrelated to the signer issue: pause(), unPause() and setPrerevealURI() have no access control, so anyone can call them."
---

## Summary

The signer is a hardcoded constant with no setter and no ERC-1271 check, and it is an EOA today (code_bytes 0). If that key's account ever gets real code, signed presale and free mints stop, and so do deconstruct and reconstruct. No funds lock: the owner can still withdraw ETH with drain(), public mint opens after stopPresale(), and NFTs can still be transferred. A doll that was deconstructed but not yet reconstructed stays in that state, but it is still owned and transferable.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address constant ticket_signer = 0xD68a149D5646277cB271E283537b8A9C60D8A32f`; row facts give its code_bytes as 0 and delegated as false.
- presaleMint, deconstruct and reconstruct each `require (ticket_signer == signer, "wrong signer")` after a plain ecrecover.
- No function writes ticket_signer, and the contract has no upgrade path (upgradeable: no).
- `drain() public onlyOwner` sends address(this).balance to the owner.

## Impact and exposure

- Value held at block 26,438,999: $965 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a signer that can be changed, or add an ERC-1271 / code-aware check. In the meantime, the owner can call stopPresale() to open public minting and drain() to withdraw the ETH.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
