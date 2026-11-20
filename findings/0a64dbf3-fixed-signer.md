---
id: 0a64dbf3-fixed-signer
title: "0x0a64dbf3: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x0a64dbf3a80e69fe6e62b91470ba694cfa5b6cf4"
  family: "c3b027e1fc2c144be9934f8243cb7a77"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
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
  note: "Refuted: an uninitialized implementation, and its signer is settable by the owner anyway. The proxy 0x85bc164a (where any funds sit) was not read because the node timed out; its signer is settable by its owner, so it would be LOW/refuted unless the owner is dead."
---

## Summary

This is the uninitialized implementation of the SmartGoldOre EIP-1967 proxy 0x85bc164a. At the block its initializer flag, owner and signer are all zero, and it has 0 ETH and 0 txs. The signer is not fixed in any case: 0x3417d8d6 (onlyOwner) writes the USDT (0x98) and signer (0x97) slots.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a token claim contract behind a proxy (3 ETH with tokens): a signer with code ends claims. Not established beyond the decompiler: whether one of the unresolved functions sets the signer. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- State at block 26438999: slot 0 (initializer)=0, owner() (slot 0x33)=0, signer() (slot 0x97)=0, balance 0, txs_90d 0.
- Bytecode pc 0x0526-0x055a: call 0x0d0d (require slot0x33==CALLER, 'Ownable') then SSTORE slots 0x98 and 0x97. Dispatcher maps 0x3417d8d6 → 0x01d8 → 0x0526.
- Etherscan, deployer 0x24f4e592: 0a64dbf3 created at block 16605615, proxy 0x85bc164a created at 16605623 with implementation 0a64dbf3, and the deployer called 0x3417d8d6 on the proxy at 16605634.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None at this address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
