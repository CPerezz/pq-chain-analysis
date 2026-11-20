---
id: delegationcontract-c4f27042-rotate-signer-before-migrating
title: "DelegationContract: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xc4f2704273598d51a0ec76a31c12553ec8f5a891"
  family: "49d1545a2ab7899eec64a3e1b8627455"
  copies: 19
  name: "DelegationContract"
  label: "MatrixedLink: Lido EDF Oracle"
  upgradeable: "no"
  rating: NONE
  txs_90d: 2808
  last_active: 2026-11-17
  recoveries_14d: 100
fix:
  layer: none
  who_acts: "none (owner Safe can renominate)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Code is checked first and ERC-1271 is accepted, so a signer with code is handled. The executed revert likely came from injected code without isValidSignature [INFERENCE]. Even otherwise LOW, since the owner can renominate."
---

## Summary

DelegationContract.isValidSignature checks the delegate's signature with OpenZeppelin SignatureChecker.isValidSignatureNow, and the owner nominates or revokes that delegate.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: DelegationContract ERC-1271: SignatureChecker on the current delegate, which is nominated and revoked by calls. Read from source. Executed: a real transaction reverts with code at the signer.
- DelegationContract.sol:143 SignatureChecker.isValidSignatureNow(delegate, …); the vendored SignatureChecker.sol:33-37 uses ECDSA when signer.code.length == 0 and ERC-1271 otherwise
- nominateDelegate and revokeDelegate are onlyOwner (OWNER immutable, msg.sender check line 200)
- owner = Safe 0x60D7…066C, 2-of-3 (probed at block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 19 addresses).
- Activity: 2,808 transactions called it in the 90 days before that block; last on 2026-11-17.
- 100 signature recoveries in the study's two-week trace window.

## Remediation

Nothing needed: a delegate with code is checked through its ERC-1271. If it lacks ERC-1271, the owner Safe nominates a new delegate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
