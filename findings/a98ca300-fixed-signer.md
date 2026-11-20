---
id: a98ca300-fixed-signer
title: "0xa98ca300: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa98ca300b4db75a701d49bdeb340fbdf4bd25d39"
  family: "6266bb0a279e631406c5f060a24e5f02"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Operator redeploys. Depositors withdraw with withdrawAll, and the rescuer pulls out any ETH."
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
  note: "MEDIUM (main reviewer's LOW/MEDIUM rule): the signed function dies for good; other parties' assets leave by separate paths (owner/depositor withdraw, rescue, timeout), not by the same act. The decompilation hides the ecrecover call (heimdall did not render it), so I rely on the study note that a fixed SIGNER is checked. Either candidate address is an EOA or 7702-delegated today, so the verdict is the same whichever one it is."
---

## Summary

The signer address is hard-coded in the bytecode and nothing can change it. Both candidate addresses are usable signers today: one is a plain EOA and the other is 7702-delegated. If the signer key's account gets real code, deposits, buys and price updates stop. Deposited NFTs can still be taken back through withdrawAll, and ETH through rescueETH, so nothing gets locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- The only setters are transferOwnership, renounceOwnership and updateRescuer, which write owner (slot 0) and rescuer (slot 1). No function writes a signer.
- Upgradeable: no. There is no proxy slot or upgrade function.
- Bytecode addresses: 0x00001340… has no code (EOA); 0x32da57… is 0xef0100 7702-delegated.
- withdrawAll (0x853828b6) clears storage_map_b[msg.sender] and calls 0x57f1887a….safeTransferFrom(this, msg.sender, id). No signature is checked.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract whose signer can be rotated or verified via ERC-1271. Users take their NFTs out with withdrawAll.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
