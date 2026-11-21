---
id: contract-ab3482b9-fixed-signer
format: 2
title: Fixed signer's ERC-1271 approvals stop if its account takes real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only if the signer moves its account to real code; the signer is written into the code.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xab3482b95a33bf953177b5667646c83603d30fd3'
  code: decompiled
  code_url: code/0x4e40b7ec56a8eaf68636239e44f880f740070570911c27a6496537b5bcd5f870.sol
  copies: 1
value:
  usd: 0
  whose: operator
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Stop relying on this contract's signatures, or deploy one with another signer, before moving the signer
  account to real code.
evidence_level: bytecode
checks:
- id: sel1271
  selector: '0xab3482b95a33bf953177b5667646c83603d30fd3'
  fn: isValidSignature(bytes32,bytes)
  says: the contract exposes the ERC-1271 isValidSignature function
  for:
  - evidence-1
  - what
- id: rec
  bytecode: '0xab3482b95a33bf953177b5667646c83603d30fd3'
  has: 60015afa5073ad7149152a65e6ec97add7b1b1f917dcafcf9b21
  says: ecrecover's result is compared with the constant 0xad71...cf9b21 written into the code
  for:
  - action
  - evidence-1
  - justification
  - what
- id: magic
  bytecode: '0xab3482b95a33bf953177b5667646c83603d30fd3'
  has: 630b135d3f60e11b
  says: on a match the function builds and returns the ERC-1271 success value 0x1626ba7e
  for:
  - evidence-1
  - what
- id: signer
  code: '0xad7149152a65e6ec97add7b1b1f917dcafcf9b21'
  is: delegation
  target: '0x63c0c19a282a1b52b07dd5a65b58948a07dae32b'
  says: the signer is an account with an EIP-7702 delegation, not real code
  for:
  - evidence-2
  - justification
  - what
- id: signernonce
  nonce: '0xad7149152a65e6ec97add7b1b1f917dcafcf9b21'
  is: 16957
  says: the signer account has sent 16,957 transactions
  for:
  - evidence-2
- id: seldelegate
  selector: '0xab3482b95a33bf953177b5667646c83603d30fd3'
  fn: delegate()
  says: the contract exposes delegate()
  for:
  - evidence-3
- id: delegateauth
  bytecode: '0xab3482b95a33bf953177b5667646c83603d30fd3'
  has: 3373ad7149152a65e6ec97add7b1b1f917dcafcf9b2114
  says: delegate() compares the caller with the same constant signer address
  for:
  - action
  - evidence-3
  - whose
- id: delegatecall
  bytecode: '0xab3482b95a33bf953177b5667646c83603d30fd3'
  has: 60401c6001600160a01b03165af4
  says: delegate() delegate-calls an address taken from its calldata with all remaining gas
  for:
  - evidence-3
  - whose
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews: []
related: []
---

## What happens

This unverified contract answers ERC-1271 checks as valid only when the signature recovers to one address written into its code. If that account takes real code, its signatures stop counting here; an EIP-7702 delegation, which it holds now, keeps working.

## Evidence

- The [contract code](https://etherscan.io/address/0xab3482b95a33bf953177b5667646c83603d30fd3#code) recovers the signature, compares it with a fixed address and then returns the ERC-1271 success value.
- The [signer account](https://etherscan.io/address/0xad7149152a65e6ec97add7b1b1f917dcafcf9b21) has sent 16,957 transactions and holds an EIP-7702 delegation.
- The same account can call the [contract](https://etherscan.io/address/0xab3482b95a33bf953177b5667646c83603d30fd3#code)'s delegate function directly, which runs code of its choice without a signature.

## Reviewer notes

### Mechanism

Dispatcher: 3b50d421 and fa461e33 (swap routines guarded by an 8-address caller / tx.origin allowlist), c89e4361 delegate(), 1944799f, 1626ba7e isValidSignature(bytes32,bytes), and a fallback for calldata starting 0x02 that forwards to 0xa88800cd...7647 after the allowlist check. isValidSignature accepts 65-byte (r,s,v) or 64-byte (r,vs) signatures, rejects high s, calls precompile 0x01 with STATICCALL and all remaining gas (PUSH1 1 GAS STATICCALL), and returns 0x1626ba7e only when the recovered address equals the PUSH20 constant 0xad7149152a65e6ec97add7b1b1f917dcafcf9b21; otherwise it returns 0. The constant is in the runtime code, not in storage (slots 0-2 are zero; no proxy slots, per the tool). delegate() requires CALLER == the same constant and DELEGATECALLs to an address taken from calldata with all gas, so the signer controls the contract directly. Under EIP-8151, if 0xad71 takes real code, isValidSignature returns 0 for every signature; delegate() still works because it checks msg.sender. At block 26,438,999 the signer is an EIP-7702 delegated EOA (to 0x63c0c19a282a1b52b07dd5a65b58948a07dae32b), nonce 16,957, so it still recovers today.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: the old root issue signer-upgrade-only: the tool found no EIP-1967/1822/beacon slot and the signer is a PUSH20 constant; neither DELEGATECALL (delegate() to a caller-chosen target, and one to the constant 0xeefba1e63905ef1d7acba5a8513c70307c1ce441 in the swap path) can rewrite runtime code, so nothing replaces the signer: fixed-signer.
- Ruled out: fixed-gas-recovery: both precompile calls pass GAS (all remaining gas), not a constant.
- Ruled out: an ERC-1271 or code-size path for a signer with code: none; the recovered address is only compared with the constant.
- Ruled out: a direct path: delegate() lets the signer act as the contract by msg.sender, which EIP-8151 does not affect; named on the card.
- Ruled out: key-state: the signer is live (nonce 16,957) and holds a 7702 delegation, not real code, so it recovers today.
- Ruled out: breaks-by-itself / sender-gas-limits: the dossier has no window calls and no replays for this family; nothing shows a transaction that fails on price alone.

### Questions

- Which protocol asks this contract for isValidSignature, and whether anyone still does: the study counted no calls to it in the 90 days to the block, and the contract holds no ETH or priced tokens.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
