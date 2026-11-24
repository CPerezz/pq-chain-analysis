---
id: contract-eb513003-entry-by-own-signature-only
format: 2
title: Users whose accounts take real code can no longer have intents executed
status: confirmed
severity: INFORMATIONAL
justification: Only a user who moves its own account to real code loses this, and its prepaid fees stay withdrawable.
category: migration-notice
pattern: PQ-21
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xeb5130035d2ede512da245f5cbc293bc259c7b0d'
  code: bytecode
  code_url: https://etherscan.io/address/0xeb5130035d2ede512da245f5cbc293bc259c7b0d#code
  copies: 2
  family: afd10ce189a22698ddac418706819157
  upgradeable: 'no'
  admin: '0x8b7c98d80a65ccb0e09588e2e722fcaa27725cec'
value:
  usd: 114
  whose: users
  basis: held
activity: {}
impact: liveness
action: Tell users that intents they signed stop running once their account takes real code; an EIP-7702 delegation
  keeps them working.
evidence_level: executed
checks:
- id: intent-ok
  call: '0xeb5130035d2ede512da245f5cbc293bc259c7b0d'
  data: '0x7d435a31000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000003200000000000000000000000006654c4ca46db6003bf819803dd88ed6af118dcf9000000000000000000000000fa5118b604600ef1d7e97cd782a350308e4d00b000000000000000000000000000000000000000000000000000000000000001600000000000000000000000006dc77c188765dd07aad1df2e6720bb5f62a0224c00000000000000000000000000000000000000000000000000000000000002400000000000000000000000006a6a628f8551665c713c4be6a5a29143caa7771c00000000000000000000000000000000000000000000000000000000000002c0000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000006b54cafc00000000000000000000000000000000000000000000000000000000773594000000000000000000000000000000000000000000000000000000e35fa931a00000000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000a2eaad0d586cf9fd73bb2c09cf6a7e3e187d68cd00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009184e72a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000a2eaad0d586cf9fd73bb2c09cf6a7e3e187d68cd00000000000000000000000000000000000000000000512619ce4f11f267490f0000000000000000000000000000000000000000000000000000005b0b8123a6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000414eef6bda1c71d1394bba427ddc597c780e5454d74149f712da1fe49752a634384de8edfd674f6a911d4e6823b237e86e7f77f9bd21d8a8eec1d804c0077e0df81b00000000000000000000000000000000000000000000000000000000000000'
  is: '0x0000000000000000000000000000000000000000000000000000000000000001'
  says: the intent check returns true for the real intent and signature of the replayed transaction
  for:
  - evidence-2
  - what
- id: intent-other-user
  call: '0xeb5130035d2ede512da245f5cbc293bc259c7b0d'
  data: '0x7d435a3100000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000320000000000000000000000000a893eb6966b70d29bc02f4da619b73dde37ef88b000000000000000000000000fa5118b604600ef1d7e97cd782a350308e4d00b000000000000000000000000000000000000000000000000000000000000001600000000000000000000000006dc77c188765dd07aad1df2e6720bb5f62a0224c00000000000000000000000000000000000000000000000000000000000002400000000000000000000000006a6a628f8551665c713c4be6a5a29143caa7771c00000000000000000000000000000000000000000000000000000000000002c0000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000006b54cafc00000000000000000000000000000000000000000000000000000000773594000000000000000000000000000000000000000000000000000000e35fa931a00000000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000a2eaad0d586cf9fd73bb2c09cf6a7e3e187d68cd00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009184e72a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000a2eaad0d586cf9fd73bb2c09cf6a7e3e187d68cd00000000000000000000000000000000000000000000512619ce4f11f267490f0000000000000000000000000000000000000000000000000000005b0b8123a6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000414eef6bda1c71d1394bba427ddc597c780e5454d74149f712da1fe49752a634384de8edfd674f6a911d4e6823b237e86e7f77f9bd21d8a8eec1d804c0077e0df81b00000000000000000000000000000000000000000000000000000000000000'
  is: '0x0000000000000000000000000000000000000000000000000000000000000000'
  says: 'the same intent and signature with another user named returns false: the recovered address must equal the
    named user'
  for:
  - evidence-2
  - what
- id: no-1271
  bytecode: '0xeb5130035d2ede512da245f5cbc293bc259c7b0d'
  has: 1626ba7e
  absent: true
  says: the code never refers to the ERC-1271 isValidSignature selector
  for:
  - what
- id: replay-today
  replay: '0xd3aa51f0b834664e5b02242d75e0b0ff79890b7ca05c9970d92f19691b7fc25c'
  run: today
  ok: true
  says: the real execution succeeds as sent
  for:
  - evidence-1
- id: replay-code
  replay: '0xd3aa51f0b834664e5b02242d75e0b0ff79890b7ca05c9970d92f19691b7fc25c'
  run: eip8151_signer_code
  ok: false
  says: with real code at the intent's signer under EIP-8151 the execution reverts
  for:
  - action
  - evidence-1
  - justification
  - what
- id: replay-delegated
  replay: '0xd3aa51f0b834664e5b02242d75e0b0ff79890b7ca05c9970d92f19691b7fc25c'
  run: eip8151_signer_delegated
  ok: true
  says: with an EIP-7702 delegation at the signer the execution still succeeds
  for:
  - action
  - evidence-1
  - what
- id: withdraw-direct
  call: '0xeb5130035d2ede512da245f5cbc293bc259c7b0d'
  fn: withdrawFeeBalance(uint256)()
  args:
  - 1
  from: '0x6654c4ca46db6003bf819803dd88ed6af118dcf9'
  is: 0x
  says: a depositor withdraws its fee balance by a direct call, with no signature
  for:
  - justification
  - what
- id: fee-a
  call: '0xeb5130035d2ede512da245f5cbc293bc259c7b0d'
  fn: feeBalances(address)(uint256)
  args:
  - '0x6654c4ca46db6003bf819803dd88ed6af118dcf9'
  is: '29204106710388900'
  says: one user's prepaid fee balance held here
  for:
  - whose
- id: fee-b
  call: '0xeb5130035d2ede512da245f5cbc293bc259c7b0d'
  fn: feeBalances(address)(uint256)
  args:
  - '0xe26e8e942193f02dcfcaa798057df696a3b79811'
  is: '28858726394462654'
  says: a second user's prepaid fee balance; the two make most of the 0.063 ETH held
  for:
  - whose
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-eb513003, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Author and refuter agree; sheet read by Claude. Intent executor: an intent runs only if ECDSA recovers
    the named user (refuter''s throwaway-key call accepts and rejects accordingly); no ERC-1271; prepaid fees withdraw
    by a direct call with all gas (the decompiler''s 2,300-gas transfer is not in the bytecode). INFORMATIONAL (was
    LOW). The intent registry 0x419e2b34… may deserve its own row.'
related: []
---

## What happens

The contract runs a user's signed intent only if its ECDSA signature recovers to the user named in it, and asks no account for an ERC-1271 check. A user whose account takes real code can no longer have intents run; an EIP-7702 delegation still works. Prepaid fees stay withdrawable by a direct call.

## Evidence

- A [real execution](https://etherscan.io/tx/0xd3aa51f0b834664e5b02242d75e0b0ff79890b7ca05c9970d92f19691b7fc25c) replayed with real code at the intent's signer reverts; with an EIP-7702 delegation it succeeds.
- The [contract](https://etherscan.io/address/0xeb5130035d2ede512da245f5cbc293bc259c7b0d#code) accepts that intent's signature for its user and rejects the same signature when another user is named.

## Reviewer notes

### Mechanism

Unverified, 10,912 bytes, not a proxy; EIP-712 domain 'IntentSettlement' v1. The execute function (selector 0xf7a24be4: intent, intent signature, permit nonce, permit deadline, permit signature) takes a reentrancy lock, then validates the intent (0x1643): deadline, then the internal check at 0xc78, which returns false if intent.user is zero, otherwise recovers the EIP-712 intent hash with OpenZeppelin ECDSA (ecrecover forwarded all gas, 0x1edf) and compares it with intent.user (first struct word); false reverts with 8baa579f (InvalidSignature) and the nonce is marked used. Then an execution permit (typehash 0x3333ed15...) binding intent hash, caller, execution data, nonce and deadline must recover to CALLER (0x19e0), so each executor also signs its own permit. The same 0xc78 check is exposed as selector 0x7d435a31 (view), which the companion intent registry 0x419e2b34... (holds this address and that selector) calls when users publish intents (selector 0x9721b46b). No code path runs an intent without the user's signature: no msg.sender==user branch before 0x1643. Fees come from feeBalances, which withdrawFeeBalance pays to msg.sender without a signature. Owner 0x8b7c...5cec (EOA) only whitelists adapters. The one copy 0x671f2a42... has the same owner, holds 0 ETH and no recoveries in the trace window; this address is the one in use.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: ERC-1271 or a code-size branch: the runtime code has no 0x1626ba7e; the recovered address is compared directly with intent.user. The only EXTCODESIZE is OpenZeppelin's empty-code check after an adapter call.
- Ruled out: fixed gas: the ecrecover call forwards GAS; the replay under EIP-8151 alone succeeds (eip8151 run ok), so nothing breaks with nobody migrating.
- Ruled out: direct path: execute validates the intent signature unconditionally, even when the user sends the transaction; no other function runs an intent.
- Ruled out: rechecked-later: the executor sends execute after the user signed, but a failing signature only reverts the executor's transaction before any adapter call (45,659 gas, near the calldata floor of about 41,900); no party loses funds.
- Ruled out: replay attribution: the replayed transaction carries only the intent signature and the executor's permit; the signer with code is the intent's user, and the revert comes before any external call.
- Ruled out: path closed: the replayed transaction's adapters are still whitelisted at the block; there is no pause function.
- Ruled out: executors: the permit must recover to the caller, so an executor whose account takes real code also stops; that is the operator's own key and the same kind of notice.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
