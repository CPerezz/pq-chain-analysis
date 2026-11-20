---
id: theend-9d003ee2-fixed-signer
title: "TheEnd: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9d003ee2b66197b2664f82c4dfdbe4fb6cf8b0ac"
  family: "708abbae698b2e78abcfdf16d94aa374"
  name: "TheEnd"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner 0xAb8da4a15424E0A51B31317f3A69f76f1c4033c1"
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
  note: "Mint stops for good but owner's withdraw path is untouched and nothing is locked -> MEDIUM."
---

## Summary

TheEnd (ERC721A mint): claimMint/saleMint require a signature from the constant _signerAddress, no setter. If it gets code, minting via these two functions stops for good, but owner can still withdrawMoney() directly; nothing is escrowed per-buyer (mint is pay-and-receive in one call).

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Helmets2117: signed by SIGNER_ADDRESS, fixed in the code. Rule: same text up to names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- TheEnd.sol:47: _signerAddress constant, compared via ECDSA.recover in _isTrustedSigner (dossier source)
- TheEnd.sol:121-122: withdrawMoney() onlyOwner, no signature needed
- owner()==0xAb8da4a15424E0A51B31317f3A69f76f1c4033c1 at block 26438999 (cast call)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner deploys a successor mint contract with a fresh signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
