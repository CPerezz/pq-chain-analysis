---
id: f10b08d6-fixed-signer
title: "0xf10b08d6: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf10b08d6eff241e883762538324c938ae4376da6"
  family: "08ea68a306bb969e493b5f17c1d7da86"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: none
  who_acts: "No one needs to act. The 30-day HARD_OPEN opens trading on its own."
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
  rating: LOW
  note: "The study note says 'presale deposit/claim', but the code is a token whose launch-window gate expires at HARD_OPEN. That expiry is the alternative path that makes this LOW. Matching the signer to 0x71a9... is by elimination: the code does not name it, but it is the only EOA among the addresses in the bytecode."
---

## Summary

The gate signer is an immutable EOA that cannot be replaced, and there is no code check or ERC-1271 path. If the key's account got real code, signatures would stop recovering, but only until tradingOpen(). At HARD_OPEN (deploy time + 30 days) every gate is bypassed and holders can transfer freely, so nothing is locked for good.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable GATE_SIGNER;` is set in the constructor and never written again.
- `_authorize`: `if (recovered != GATE_SIGNER) revert BadSignature();`
- `_authorize` starts with `if (tradingOpen()) return;`
- `tradingOpen()`: `if (block.timestamp >= HARD_OPEN) return true;` with `HARD_OPEN = block.timestamp + _MAX_WINDOW` (30 days)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Nothing needs doing. The time-based HARD_OPEN fallback already removes the need for the signature after 30 days.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
