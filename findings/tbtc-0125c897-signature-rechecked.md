---
id: tbtc-0125c897-signature-rechecked
title: "EcdsaDkgValidator: a signature checked again after others relied on it"
project: tbtc
status: confirmed
severity: LOW
patterns: [PQ-15]
impact: liveness
contracts:
- address: "0x0125c8977a02b2fa3970b1ed9af02f5bedd4ef27"
  family: "c7877dc4855722a5f03bf4c0c064af61"
  copies: 3
  name: "EcdsaDkgValidator"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1
  last_active: 2026-11-14
  recoveries_14d: 100
fix:
  layer: contract-upgrade
  who_acts: "Threshold governance changes the DKG check by upgrading WalletRegistry"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signature-rechecked"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW (Anon, 2026-11-20). An operator whose account already has code at submission is simply left out of the 51. One that takes code inside the challenge window makes an honest result fail: approval reverts and a challenge punishes the honest submitter (400 T, though today seize only emits an event) and restarts the DKG. Threshold's live governance can change the check by upgrading WalletRegistry, so a simple update fixes it."
---

## Summary

tBTC v2 EcdsaDkgValidator (verified source, no settable state, holds nothing). WalletRegistry 0x46d52e41c2f300bc82217ce22b920c34995204eb calls it to check a new wallet's DKG result: at least 51 of the 100 selected operators' ECDSA signatures. The result is not checked at submission; it can be challenged for 11,520 blocks (about 38 hours) and is checked again at approval.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Threshold/tBTC EcdsaDkgValidator.validateSignatures: every supporting signature of a DKG result must recover to the operator of the member at that index; a result that does not validate can be…. Read from source. Executed: a real transaction reverts with code at the signer. Executed by hand: see Evidence. Rated by hand: executed: nothing moves today (seize only emits an event) and clients can leave such signatures out.
- tBTC v2 WalletRegistry `0x46d52e41c2f300bc82217ce22b920c34995204eb`, validator `0x1a5f4f753bd071c907714aefb6e0bcee32401406` (`tryRecover`, false on mismatch). Executed on the last real DKG result: with one byte of code at operator `0xb71c49e11048bf3d2bc0bab81252334295dee012`, approval `0xdad127784152301e0be04a5d5bd40d676ab85f4a707331f0b82bd2323d9eab28` reverts and a challenge by an outsider succeeds with `DkgMaliciousResultSlashed(400 T, submitter)`. Today `seize` only emits an event.
- Source (Blockscout, verified): validateSignatures recovers each signature and compares it with the operator of the member at that index; 'Too few signatures' below groupThreshold = 51; EcdsaDkg.submitResult stores only the result hash; challengeResult re-runs validate and treats the submitter as malicious if it fails
- Last use: WalletRegistry staticcalled it in tx 0xdad127784152301e0be04a5d5bd40d676ab85f4a707331f0b82bd2323d9eab28 on 2026-11-14 (Blockscout internal transactions)
- Study replay of that result (engine, labelled): with code at operator 0xb71c49e11048bf3d2bc0bab81252334295dee012 the approval reverts and an outsider's challenge succeeds with DkgMaliciousResultSlashed(400 T, submitter); today Threshold's seize only emits an event
- WalletRegistry is an upgradeable proxy: ProxyAdmin 0x7affa05f726d293eb1193807a91617318292008e owned by 0x92f2d8b72a7f6a551be60b9aa4194248e9b4913d, governance 0x6aed6cc30d1b2770771052555d257da86ed47fe8; dkgParameters: resultChallengePeriodLength 11,520 blocks (latest block, node down)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-11-14.
- 100 signature recoveries in the study's two-week trace window.

## Remediation

New deployments that check once, or accept ERC-1271; until then parties settle before migrating a signing address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
