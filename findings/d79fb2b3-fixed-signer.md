---
id: d79fb2b3-fixed-signer
title: "0xd79fb2b3: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd79fb2b308c0ba81ade0c59dc7ce679094f1d40b"
  family: "53335b2030d5c27eac7db25d68431ca1"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator (the hard-coded signer, which is also the fee recipient and the owner)"
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
  note: "The function can complete (shown by the code-override eth_call), so the row is not refuted. No update path: the signer is a code constant and Ownable only covers transferOwnership and setFee. Nothing is held and only the operator's own payment flow is lost, so MEDIUM, not HIGH. The row's description 'launchpad mint' is wrong: the code is a signed fee-taking ETH forwarder."
---

## Summary

Signed payment forwarder (selector 0xda12ea8c, args id, recipient, deadline, r, s, v): it checks a deadline and a one-time id, recovers the signer, requires it to equal the constant 0xf2ec2fe12edfeb03e6241bfc8a8e918b63da4f93, then forwards msg.value minus a fee to the recipient and sends the fee to that same constant. Under EIP-8151, if that key takes real code, every call reverts 'bad-signature' and the operator can no longer accept these payments.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Disassembly: dispatcher sends 0xda12ea8c to a payable body that ends in ecrecover (STATICCALL 0x01), a 'bad-signer' check against PUSH20 0xf2ec2fe12edfeb03e6241bfc8a8e918b63da4f93 (immutable code constant, no setter), then two value CALLs (recipient, fee to the same constant). heimdall's 'revert()' for this function is a decompiler failure
- eth_call at block 26438999 with the real code: empty args revert; an expired deadline reverts 'signature-expired'; a random signature reverts 'bad-signature'; a valid signature from a non-signer key reverts 'bad-signer'. With --override-code swapping only the signer constant for a test key, a correctly signed call returns successfully (0x)
- Balance 0 ETH at block 26438999: payments are forwarded in the same call, so nothing is held. Signer 0xf2ec…4f93 = owner(): EOA, nonce 5 at block.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The operator keeps the signer key code-free (an EIP-7702 delegation is fine), or deploys a new forwarder with a new signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
