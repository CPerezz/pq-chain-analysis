---
id: pool1-fd613522-fixed-signer
title: "Pool1: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xfd61352232157815cf7b71045557192bf0ce1884"
  family: "c95db7561743c59ea1457175fb532a40"
  name: "Pool1"
  label: "Nexus Mutual: Pool"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  verdict: refuted
  rating: NONE
  note: "The signer is read from a settable getter, not hard-coded -> refuted."
---

## Summary

Nexus Mutual Pool1/Quotation: isValidSignature checks ecrecover against qd.getAuthQuoteEngine() -- a GETTER, not a hard-coded constant. QuotationData.changeAuthQuoteEngine(address) is an onlyInternal setter, so the key is settable by Nexus Mutual's governance/internal contracts.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: an oracle proof: the signature must match a public key from the proof chain / returns the recovered address, or whether it equals an address its caller passes in. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Quotation.sol:220-223: isValidSignature compares ecrecover(...) to qd.getAuthQuoteEngine() (dossier source)
- QuotationData.sol:192,256: function changeAuthQuoteEngine(address _add) external onlyInternal; function getAuthQuoteEngine() external view returns(address)
- this is exactly the rubric's refuted criterion: 'the key is settable'

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

n/a

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
