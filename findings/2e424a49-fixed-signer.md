---
id: 2e424a49-fixed-signer
title: "0x2e424a49 (tagged DappRadar: Airdrop Claim): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2e424a4953940ae99f153a50d0139e7cd108c071"
  family: "9958a655edf54cb0bd5f6f027fd82c4f"
  label: "DappRadar: Airdrop Claim"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Operator: deploy a new airdrop contract with a new signer and point the reserve allowance to it"
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
  rating: MEDIUM
  note: "I mapped the immutables by code size, not by reading constructor arguments: claimSigner = the EOA, reserve = the 171-byte contract (Safe-proxy-sized), token = the 2888-byte contract. If the signer were one of the two contracts, the row would be refuted. The study note calls this a presale; the code is an airdrop with no deposits."
---

## Summary

The claim signer is immutable and has no setter, no code check and no ERC-1271 path. The only bytecode-pushed address with no code is the EOA 0xabcb…83ab. If that key's account gets code, airdrop claims stop. The tokens stay in the operator's reserve, so nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address immutable public claimSigner` is assigned only in the constructor
- claimTokens: `require(ECDSA.recover(message, _signature) == claimSigner)`
- token.safeTransferFrom(reserveAddress, _recipient, _amount): tokens are pulled from the reserve and the contract holds no balance
- Setter list has only transferOwnership; there is no upgrade path

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new Airdrop with a new claimSigner, then have the reserve approve the new contract and revoke the old allowance.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
