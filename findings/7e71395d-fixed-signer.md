---
id: 7e71395d-fixed-signer
title: "0x7e71395d (tagged deployed by Demonix: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7e71395d2e29ce1e5284bfba80656dee62bfaaa3"
  family: "2f2ff128a0a34b48662a79b6160902bc"
  label: "deployed by Demonix: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The project owner would need to deploy a new contract or give allowlisted users another way to mint."
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
  note: "The study note's 'presale deposit/claim' description does not match the code: this is an NFT whitelist mint. The second constant 0x1858d8db... (EOA) is not shown as the signer in the decompiled code."
---

## Summary

The signer for whitelistMint is a hardcoded constant. It is an EOA today and nothing can replace it. If that key's account gets code, only allowlist minting of new NFTs stops. Existing NFTs and the ETH held are unaffected: holders can still transfer and the owner can still withdraw. Note: the study note calls this a presale with signed deposit and claim, but the code is an NFT mint.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- whitelistMint (0x37bc4c0b) runs ECDSA recovery and then require(recovered == 0x42945b71838b41cd8c1a2de01f7f4f68012c1329, "account is not whitelisted")
- The signer constant 0x42945b71... has code_bytes 0 (EOA, not delegated)
- Only setters found: transferOwnership and renounceOwnership, which write the owner slot; no function writes a signer
- There is no extcodesize check or isValidSignature call on the signer

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the signer key as a plain EOA (no code other than 7702 delegation). If allowlist minting must continue after the key gets code, deploy a new contract with a replaceable signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
