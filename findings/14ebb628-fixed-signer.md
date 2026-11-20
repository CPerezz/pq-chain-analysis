---
id: 14ebb628-fixed-signer
title: "0x14ebb628: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x14ebb62887a69790a55ea9733d40026e5b56b734"
  family: "3d80697e3abbd27814762366d0ea66ba"
  copies: 4
  upgradeable: "no"
  rating: NONE
  txs_90d: 5
  last_active: 2026-11-10
  recoveries_14d: 1
fix:
  layer: none
  who_acts: "nobody"
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
  note: "Refuted: the expected signer is the account being swept, a 7702-delegated EOA, which EIP-8151 exempts. The study read 0xdeffdce7 as the signer, but it is the fee recipient. Residual doubt: the calldata is obfuscated, so the binding recovered==called account rests on the only trace in the window (no target address appears in plain calldata), not on a full bytecode trace."
---

## Summary

This is an EIP-7702 sweeper. The signature it recovers comes from the delegating account itself, not from a fixed party. The only constant in the code, 0xdeffdce7, is the 5% fee recipient. A signer that carries only a delegation indicator still recovers under EIP-8151. If the account ever takes real code, it stops being delegated to this contract.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: small sweep contracts (6); inferred: withdrawals signed by a fixed party. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Trace of tx 0xfb09a973 (type 4, block 26387920, sender 0x4a3e055f): the 0x01 call returns 0xbc376f8d, and 14ebb628 then CALLs 0xbc376f8d, which sweeps tokens with a transfer to 0xdeffdce7.
- 0xbc376f8d at block 26438999: code 0xef0100||14ebb628 (7702 delegation), nonce 15, an ordinary user EOA per its Etherscan page.
- Decompiled 98f2720d/da975ea3: fee = amount*0x1f4/0x2710, sent to 0xdeffdce7, and these run only when msg.sender==address(this). withdrawNative/withdrawERC20 require address(this)==14ebb628 and msg.sender==0x4a3e055f (operator).
- facts.json: n_ec=1; the family runs at 4 direct and 2 delegated addresses.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 5 transactions called it in the 90 days before that block; last on 2026-11-10.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

None for EIP-8151.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
