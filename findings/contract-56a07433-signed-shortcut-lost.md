---
id: contract-56a07433-signed-shortcut-lost
format: 2
title: USDC owners whose accounts take real code lose this gasless bridge to Base
status: candidate
severity: INFORMATIONAL
justification: Breaks only for owners who move to real code; their USDC stays in their wallets and Circle stays
  open.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x56a0743392255227c7bc3e5a7aee874dab3b5f84'
  code: decompiled
  code_url: code/0x6fba9bf3b7c280b0b2c30c166dcc747f6be0e0015c001100f3f2494904902bd6.sol
  copies: 1
  upgradeable: 'no'
  admin: '0x37f70cd02c5d8bfa4be5700eb529efd8ac9143f4'
value:
  usd: 0
  whose: users
  basis: held
activity:
  txs_90d: 10
  last: 2026-11-17
impact: liveness
action: Accept ERC-1271 intent signatures from owners whose accounts have real code, in the next deployment.
evidence_level: bytecode
checks:
- id: owner-sig
  call: '0x56a0743392255227c7bc3e5a7aee874dab3b5f84'
  data: '0xb1f5b084000000000000000000000000d32af4f031abb217d0d709f020ac36d1089225dc00000000000000000000000000000000000000000000000000000000000f424000000000000000000000000000000000000000000000000000000000000f42400000000000000000000000000000000000000000000000000000000000000006000000000000000000000000d32af4f031abb217d0d709f020ac36d1089225dc00000000000000000000000000000000000000000000000000000000000003e800000000000000000000000000000000000000000000000000000000f4865700000000000000000000000000000000000000000000000000000000000000001b00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f486570000000000000000000000000000000000000000000000000000000000000001a000000000000000000000000000000000000000000000000000000000000000419f0e3f9683f737901eac5f41b28b03913c66b5b4c53b23d6b8acd906441f609b46593d456407f4313b26c9dbc01421d414f9884406565f7471c2375734e163961b00000000000000000000000000000000000000000000000000000000000000'
  from: '0xdd4d02a1d2e77eb987b20b46160e30457dcc20ab'
  reverts_with: Permit failed
  says: an intent signed by the named owner passes the signature check and stops at the USDC permit, which this
    test owner never gave
  for:
  - evidence-1
  - what
  - whose
- id: other-sig
  call: '0x56a0743392255227c7bc3e5a7aee874dab3b5f84'
  data: '0xb1f5b084000000000000000000000000d32af4f031abb217d0d709f020ac36d1089225dc00000000000000000000000000000000000000000000000000000000000f424000000000000000000000000000000000000000000000000000000000000f42400000000000000000000000000000000000000000000000000000000000000006000000000000000000000000d32af4f031abb217d0d709f020ac36d1089225dc00000000000000000000000000000000000000000000000000000000000003e800000000000000000000000000000000000000000000000000000000f4865700000000000000000000000000000000000000000000000000000000000000001b00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f486570000000000000000000000000000000000000000000000000000000000000001a0000000000000000000000000000000000000000000000000000000000000004110878a62476c0e021501a9e9ab87dc0ca3cd4418e3f188c8ae4571dcf5fcc8a520da73a2f1dfb80bd5c204347026a6c02fd9cf29fce0e8d110cf65c058afe52a1b00000000000000000000000000000000000000000000000000000000000000'
  from: '0xdd4d02a1d2e77eb987b20b46160e30457dcc20ab'
  reverts_with: Invalid intent signature
  says: the same intent signed by any other key is refused
  for:
  - evidence-1
  - justification
  - what
- id: not-relayer
  call: '0x56a0743392255227c7bc3e5a7aee874dab3b5f84'
  data: '0xb1f5b084000000000000000000000000d32af4f031abb217d0d709f020ac36d1089225dc00000000000000000000000000000000000000000000000000000000000f424000000000000000000000000000000000000000000000000000000000000f42400000000000000000000000000000000000000000000000000000000000000006000000000000000000000000d32af4f031abb217d0d709f020ac36d1089225dc00000000000000000000000000000000000000000000000000000000000003e800000000000000000000000000000000000000000000000000000000f4865700000000000000000000000000000000000000000000000000000000000000001b00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f486570000000000000000000000000000000000000000000000000000000000000001a000000000000000000000000000000000000000000000000000000000000000419f0e3f9683f737901eac5f41b28b03913c66b5b4c53b23d6b8acd906441f609b46593d456407f4313b26c9dbc01421d414f9884406565f7471c2375734e163961b00000000000000000000000000000000000000000000000000000000000000'
  from: '0xd32af4f031abb217d0d709f020ac36d1089225dc'
  reverts_with: Not relayer
  says: only the relayer can submit an intent; the owner cannot call it directly
  for:
  - what
- id: ecrecover
  bytecode: '0x56a0743392255227c7bc3e5a7aee874dab3b5f84'
  has: 60015afa
  says: the code calls precompile 0x01 with all remaining gas
  for:
  - evidence-1
- id: no1271
  bytecode: '0x56a0743392255227c7bc3e5a7aee874dab3b5f84'
  has: 1626ba7e
  absent: true
  says: the code has no ERC-1271 isValidSignature call
  for:
  - action
  - evidence-3
  - what
- id: messenger
  bytecode: '0x56a0743392255227c7bc3e5a7aee874dab3b5f84'
  has: 28b5a0e9c621a5badaa536219b3a228c8168cf5d
  says: the code holds Circle's TokenMessenger address, which it calls to bridge
  for:
  - what
- id: base
  bytecode: '0x56a0743392255227c7bc3e5a7aee874dab3b5f84'
  has: 4e6f742042617365
  says: the code holds the revert text 'Not Base' for a destination other than domain 6
  for:
  - what
- id: direct
  call: '0x28b5a0e9c621a5badaa536219b3a228c8168cf5d'
  data: '0x8e0250ee00000000000000000000000000000000000000000000000000000000000f42400000000000000000000000000000000000000000000000000000000000000006000000000000000000000000ebaca5700b2e2bf478044aef41bb6bd676bb791a000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007d0'
  from: '0xebaca5700b2e2bf478044aef41bb6bd676bb791a'
  reverts_with: 'ERC20: transfer amount exceeds allowance'
  says: Circle's TokenMessenger takes a direct depositForBurn to Base from an owner and stops only at that owner's
    USDC allowance
  for:
  - justification
  - what
- id: usdc-held
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0x56a0743392255227c7bc3e5a7aee874dab3b5f84'
  is: '0'
  says: the contract holds no USDC
  for:
  - justification
  - what
- id: tx
  tx: '0x22c4844c0a718040a00cd78659d079190566c3214deaa5c77ecd973a460f0694'
  to: '0x56a0743392255227c7bc3e5a7aee874dab3b5f84'
  ok: true
  says: a real bridge submitted by the relayer for owner 0xebac...791a succeeded
  for:
  - evidence-2
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

This relayer bridges a user's USDC to Base through Circle once the user signs an intent; only the relayer submits. The intent counts only as an ECDSA signature by the USDC owner, which an account with real code cannot give. Nothing is locked: such owners can still bridge by calling Circle directly.

## Evidence

- [Code](https://etherscan.io/address/0x56a0743392255227c7bc3e5a7aee874dab3b5f84#code): the relayer's call recovers the intent with ECDSA and reverts unless it recovers to the owner named in the call.
- [A real bridge transaction](https://etherscan.io/tx/0x22c4844c0a718040a00cd78659d079190566c3214deaa5c77ecd973a460f0694): the relayer submits one owner's signed intent and USDC permit.
- The [code](https://etherscan.io/address/0x56a0743392255227c7bc3e5a7aee874dab3b5f84#code) has no ERC-1271 call, the way a signer with real code would be asked.

## Reviewer notes

### Mechanism

Unverified; read from bytecode, decompiled output as a lead. Function 0xb1f5b084 (owner, permitAmount, bridgeAmount, domain, mintRecipient, uint32, permitDeadline, v, r, s, nonce, deadline, sig) requires msg.sender == relayer() (slot 3, the real sender 0xdd4d...20ab), domain 6 (Base), mintRecipient == owner, permitAmount >= bridgeAmount > 0, a fee of at most 10 USDC, deadline not passed, nonce == nonces(owner). It hashes an EIP-712 struct (typehash 0xc72fa533..., fields owner, permitAmount, domain, mintRecipient, destinationCaller from slot 4, feeRecipient from slot 0, nonce, deadline) with DOMAIN_SEPARATOR, calls precompile 0x01 with all gas (0x76e-0x771), reverts 'Invalid signer' on a zero result and 'Invalid intent signature' unless the result equals calldata word 0 (the owner; stack traced 0x777-0x78a), then increments nonces(owner). Only after that it tries USDC permit (owner -> this), falls back to allowance, else reverts 'Permit failed'; then transferFrom the owner, approve and depositForBurn on Circle's TokenMessenger 0x28b5...cf5d, and pays the fee to feeRecipient. cancelIntent() lets an owner bump its own nonce directly. Under EIP-8151 an owner whose account has real code yields an empty recovery, so the call reverts before USDC is touched.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: rotate-signer (the old row): the relayer is checked as msg.sender, not by a signature (a call from another address reverts 'Not relayer'); the only recovered address is the owner named in the call, which no setter replaces.
- Ruled out: ERC-1271 or a code-size branch for owners with code: no isValidSignature selector (1626ba7e) in the code.
- Ruled out: fixed gas: the call to 0x01 forwards all gas (PUSH1 01 GAS STATICCALL); the replay under EIP-8151 alone succeeds (201,386 gas of a 304,462 limit), so nothing breaks with nobody migrating.
- Ruled out: replays not cited: the transaction also carries the owner's USDC permit, checked by USDC against the same owner. The run with code at the signer reverts at 42,629 gas, consistent with this check (it runs before the permit).
- Ruled out: the run with an EIP-7702 delegation at the signer also reverts, later (86,127 gas), so this check passed; likely USDC's permit asks the delegated account by ERC-1271 and the fallback reverts 'Permit failed'. Not settled, not caused by EIP-8151; the card says nothing about delegated owners.
- Ruled out: path closed: relayer() is set to the active sender, nonces(0xebac...791a) is 2 after its two bridges, and the last call was 2026-11-17.
- Ruled out: signature checked again later: the intent is checked once, when the relayer submits it; nobody relies on it before that.
- Ruled out: funds held: the contract holds no USDC; it pulls the owner's USDC and burns it in the same call.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
