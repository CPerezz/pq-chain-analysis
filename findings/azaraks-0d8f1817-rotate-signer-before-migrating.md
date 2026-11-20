---
id: azaraks-0d8f1817-rotate-signer-before-migrating
title: "Azaraks: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0d8f1817c644101a915852841a3b5933b0b8dcc7"
  family: "bd5dfcd3d6ff2de8845a141217402424"
  name: "Azaraks"
  label: "The Last Azaraks: AZRKS Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 31399
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 45
  last_active: 2026-11-14
fix:
  layer: onchain-config
  who_acts: "owner 0xcC6e…6A5e"
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
  verdict: confirmed
  rating: LOW
  note: "The only missing fact was whether the controlling party is live: its owner 0xcc6eaa08a653c0d2b518cbe0c8270b9a5ad86a5e is a plain account (no code, nonce 92), read at the latest block (26,455,6xx; the node was down). Live by Anon's rule of 2026-11-20 (a key is presumed live unless shown lost), so it can rotate the signer or upgrade the code: LOW. Earlier doubt: setter exists; RPC (reth.dappnode) timed out on all nonce/codesize reads late in the run; liveness of the controlling party not verified (owner liveness). Missing read: cast nonce/codesize --block 26438999 0xcC6eaA08a653C0d2b518cBE0c8270b9A5AD86A5e (owner)."
---

## Summary

Azaraks NFT: mint signatures compared with signerAddress.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: NFT mint verifySignature: returns the signer, which the callers compare with signerAddress (by name), a stored address with a setter. Read from source.
- Azaraks.sol:1774 setSignerAddress onlyOwner; 1781 ecrecover
- owner() = 0xcC6eaA08a653C0d2b518cBE0c8270b9A5AD86A5e; signerAddress() = 0x0E059Ae6…42Ce

## Impact and exposure

- Value held at block 26,438,999: $31,399 (ETH and 49 priced tokens).
- Activity: 45 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

replace the checked key via the setter before the key account takes code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
