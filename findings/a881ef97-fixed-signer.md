---
id: a881ef97-fixed-signer
title: "0xa881ef97: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xa881ef97e6a899d544142fead7b353ad00ec908d"
  family: "6a61a75e11da3212963d4bd3c1cf5519"
  copies: 2
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "n/a"
evidence:
  level: bytecode
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
  note: "The batch's generic 'Presale deposit/claim needs SIGNER' note does not describe this contract at all; it is a different template (referral payment splitter) that never gates money behind a fixed ecrecover comparison."
---

## Summary

This is a referral/subscription payment splitter (teamWithdraw/refWithdraw), not a Presale. The only ecrecover in the bytecode recovers a dynamic signer used purely as a storage key for self-registering a referral record; it is never compared to a fixed constant. The two USDT-moving functions (refWithdraw, teamWithdraw) are gated only by plain msg.sender checks (recipient == msg.sender, team wallet == msg.sender), with no signature involved.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Full OpenZeppelin ECDSA.recover present (error strings "ECDSA: invalid signature" etc.) feeding into a subroutine at 0x211a that SLOADs a mapping keyed by the recovered address and writes a referral/subscription counter — no EQ against any fixed address.
- refWithdraw() and teamWithdraw(uint256) (the only functions that move USDT) check msg.sender directly (require(msg.sender==recipient), require(msg.sender==store_a/teamWallet)); heimdall's full decompile confirms no recover()/signature check in either.
- The three selectors heimdall omitted (0x1c1cb323, 0x70439385, 0xc4b6ebdf) are just the auto-generated public getters for currencyAddress/teamAmount/ref — trivial, no signature logic.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none needed

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
