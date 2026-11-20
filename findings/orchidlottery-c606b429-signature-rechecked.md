---
id: orchidlottery-c606b429-signature-rechecked
title: "OrchidLottery: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xc606b429f93dd85594f36b07141f995cd5f60014"
  family: "d8e299316c6189e883fd45c7fec6187f"
  copies: 2
  name: "OrchidLottery"
  upgradeable: "no"
  rating: CRITICAL
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Orchid (redeploy); recipients cash tickets before the funder's signing key takes code"
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
  rating: CRITICAL
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: "The recipient relied on the signed tickets and loses them, while the funder's timeout exit protects only the funder; no update path. Same as the 026 precedent 0x6db8381b."
---

## Summary

Orchid lottery: grab() recovers the ticket signer with ecrecover; the signer is the funder's per-pot key, and the recipient redeems tickets it earned earlier. If that key takes code, the recipient's tickets stop recovering, while the funder can still warn() and then pull() the pot back after 1 day.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Orchid lottery grab: a ticket the funder signed earlier is redeemed later by the recipient from the funder's balance; the recipient relies on the signature. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Sourcify verified source (scratch review_agents/036/src) lottery.sol: grab() does signer = ecrecover(...) and require(signer != 0), and pays from pots[funder][signer]; there is no ERC-1271 or code check
- warn() sets unlock_ = now + 1 day; after that pull()/yank() send the escrow back to the funder, with no recipient path
- there is no proxy slot, upgrade function or setter; the token is 0xff9978B7b309021D39a76f52Be377F2B95D72394 (what() at 26438999)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Recipients redeem all held tickets before the funder's signer key takes code; otherwise a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
