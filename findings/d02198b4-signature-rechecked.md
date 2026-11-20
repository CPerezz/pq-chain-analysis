---
id: d02198b4-signature-rechecked
title: "0xd02198b4: a signature checked again after others relied on it"
status: not-affected
severity: NONE
patterns: [PQ-15]
impact: none
contracts:
- address: "0xd02198b4db929d5c7d1aed4824eea6219a84c8ed"
  family: "db25486453f239342dbeb1bfeab69caa"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "none"
evidence:
  level: bytecode
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
  verdict: refuted
  rating: NONE
  note: "Refuted: there is one ecrecover call site, reached only from the authorization step of the user-initiated send. Settlement paths (sendAcked from the gateway, takeOut and transfer from the manager) are gated by msg.sender, not by a signature checked again. The row's 'presign/MPC Vault' description comes from template ec3bbcc8 and does not match this bytecode."
---

## Summary

Claim fails. The manager signature is checked only once, inside the user's own call to 0x77e676d0, with a nonce and an expiry. No later step (sendAcked, takeOut, transfer) checks it again or depends on it, so nobody who relied on an earlier signature can be harmed. The fixed-manager problem is filed under eip-8151-fixed-signer (MEDIUM).

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: per-trade Vault (18 clones): settlement pays out only with a presign of coreAddrs[1] and an MPC signature of coreAddrs[0], both fixed in the vault; after the timeout anyone can…. Same code idiom as template ec3bbcc8, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode at block 26438999: the only ecrecover (STATICCALL to 0x01 at pc 0x4969) is reached from the auth check at 0x2a21, which is called only from selector 0x77e676d0 (an unnamed user entry of shape (address,bytes/string,uint64) whose strings include 'Invalid sender address', 'Invalid contract address', 'Authorization verification failed'). It hashes address(this), the sender, the nonce (map slot 4, must be stored+1, 'Invalid auth code') and an expiry block ('Authorization expired'), then compares the recovered signer with the managers list in slot 2 ('Signer is not a manager'). An empty signature fails, so a call without a manager signature reverts.
- The managers list (slot 2: length 1, element 0xa69334468887c12150d99e66b312994802e99530, an EOA with no code) is written only by initialize (pc 0x2090). The initialize call reverts with 'contract initialized'. setGateway, called from the manager (debug_traceCall prestate diff), writes only a gateway mapping entry (two hashed slots) and never touches slot 2. No proxy and no upgrade function.
- setGateway, setFeeRate, takeOut and transfer(address to,uint256 amount,address token) check that msg.sender is a manager ('This function need manager' when called from another address). Called from the manager, transfer moves the vault's whole wAUTOX balance (cast call --trace). takeOut, called from the manager, reaches the 'Result is not timeout or fail' state check. sendAcked is gated by gateway or result checks, not by a signature.
- Holdings at block 26438999: 0 ETH, 1,000.000001 wAUTOX (0x907b8586…, 9 decimals) and 998 wAUTOX (0x2e8f94b9…). Every token inflow came from 0x8e555e80… or from the manager. The contract emitted only 6 logs, the last at block 0x17f4f22 (about 25.1M), and had 0 txs in the last 90 days.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for this entry. See the eip-8151-fixed-signer row.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
