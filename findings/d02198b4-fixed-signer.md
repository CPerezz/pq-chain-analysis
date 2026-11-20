---
id: d02198b4-fixed-signer
title: "0xd02198b4: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd02198b4db929d5c7d1aed4824eea6219a84c8ed"
  family: "db25486453f239342dbeb1bfeab69caa"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator (manager 0xa6933446…) redeploys with a rotatable or ERC-1271-aware manager set; until then the manager key must not get real code"
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
  verdict: confirmed
  rating: MEDIUM
  note: "No update path: the managers come only from initialize, which is closed, and there is no proxy or upgrade. Only the signed user-send function dies. The tokens held (about 2,000 wAUTOX, funded by the operator and the manager) still leave through the manager's msg.sender-gated transfer and takeOut, so it is MEDIUM (function dies, nothing locked), not HIGH. The row's note (a per-trade Vault with coreAddrs and MPC signatures, 18 clones) is misattributed from template ec3bbcc8: this contract is a different manager/gateway design and was read on its own."
---

## Summary

Claim holds. The cross-chain gateway accepts user sends (0x77e676d0) only with a signature from its managers list, and that list was set once in initialize and can never be replaced. If the manager key gets real code, new signed sends die for good, but every exit (transfer, takeOut) is gated by msg.sender, so nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

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

Keep the manager 0xa6933446… a plain EOA, or one with only a 7702 delegation, until the gateway is replaced. Redeploy with a manager setter or ERC-1271 support. Before migrating, the manager can sweep the tokens with transfer().

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
