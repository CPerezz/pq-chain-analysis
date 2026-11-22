---
id: contract-2173f6ec-sender-gas-limits
format: 2
title: Wormhole relay transactions run out of gas at the relayer's limit
status: confirmed
severity: LOW
justification: A relay sent with today's gas limit fails under EIP-8151 and passes with more; the relayer raises
  its limit.
category: breaks-at-activation
pattern: PQ-18
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2173f6ece25768e7efc5199f70f8783d88ba63c8'
  code: decompiled
  code_url: code/0xbd9916aa07ed1ccaf18b13e54407a2ad951f010dc0745fbe090342bc332f3de7.sol
  proxy_of: '0xe764b4d69465455a4fead62c0a6937bec8323c3f'
  copies: 1
  upgradeable: 'yes'
  admin: '0xd557aeaf1e0cb3d226bff3b7a10c2cda9da081e7'
value:
  usd: 0
  whose: operator
  basis: held
activity: {}
impact: liveness
action: 'Re-estimate the relayer''s gas limit under EIP-8151: this relay used about 48,700 more gas than today,
  36,600 above its limit.'
evidence_level: executed
checks:
- id: tx
  tx: '0x51e845dd46e10ac4c2ed7bb3240ff05f5b68868b59d14e7d2f8905eec926230c'
  to: '0x2173f6ece25768e7efc5199f70f8783d88ba63c8'
  ok: true
  says: the relay transaction was sent to this address and succeeded
  for:
  - evidence-1
  - what
  - whose
- id: replay-today
  replay: '0x51e845dd46e10ac4c2ed7bb3240ff05f5b68868b59d14e7d2f8905eec926230c'
  run: today
  ok: true
  says: replayed under today's rules the transaction passes
  for:
  - action
  - evidence-1
  - what
- id: replay-8151
  replay: '0x51e845dd46e10ac4c2ed7bb3240ff05f5b68868b59d14e7d2f8905eec926230c'
  run: eip8151
  ok: false
  says: replayed under EIP-8151 with its own gas limit the transaction fails
  for:
  - action
  - evidence-1
  - justification
  - what
- id: replay-more-gas
  replay: '0x51e845dd46e10ac4c2ed7bb3240ff05f5b68868b59d14e7d2f8905eec926230c'
  run: eip8151_more_gas
  ok: true
  says: under EIP-8151 with 300,000 more gas the transaction passes
  for:
  - action
  - evidence-1
  - justification
  - what
- id: verify-sel
  bytecode: '0xe764b4d69465455a4fead62c0a6937bec8323c3f'
  has: 63c0fd8bde
  says: the implementation pushes the selector of parseAndVerifyVM(bytes), Wormhole core's signature check
  for:
  - what
- id: wormhole
  call: '0x2173f6ece25768e7efc5199f70f8783d88ba63c8'
  fn: wormhole()(address)
  is: '0x98f3c9e6e3face36baad05fe09d375ef1464288b'
  says: the proxy points at the Wormhole core contract
  for:
  - what
- id: relayer
  call: '0x2173f6ece25768e7efc5199f70f8783d88ba63c8'
  fn: authorizedRelayer(address)(bool)
  args:
  - '0x43a8a728e2514edeae8e0c9fab8b79fb5e4ecd5f'
  is: true
  says: the transaction's sender is an authorized relayer of this contract
  for:
  - action
  - evidence-2
  - justification
  - whose
- id: relayer-eoa
  code: '0x43a8a728e2514edeae8e0c9fab8b79fb5e4ecd5f'
  is: empty
  says: the relayer is an account without code
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

This contract takes a Wormhole message and has the Wormhole core contract check the guardians' signatures. Each signature check costs more under EIP-8151, so a real relay sent with today's gas limit runs out of gas. With 300,000 more gas the same transaction passes.

## Evidence

- [Relay transaction](https://etherscan.io/tx/0x51e845dd46e10ac4c2ed7bb3240ff05f5b68868b59d14e7d2f8905eec926230c) passes today, fails when replayed under EIP-8151, passes with 300,000 more gas.
- [Its sender](https://etherscan.io/address/0x43a8a728e2514edeae8e0c9fab8b79fb5e4ecd5f) is an account without code that this contract lists as an authorized relayer.

## Reviewer notes

### Mechanism

The address is an EIP-1967 proxy (implementation 0xe764b4d6…, unverified). Function 0x6455cbd7 takes an encoded Wormhole message; the implementation holds the selector of parseAndVerifyVM(bytes) and the proxy's wormhole() points at the Wormhole core 0x98f3c9e6…, which recovers each guardian signature (the replayed message carries 13, guardian set 7). The relay transaction 0x51e845dd… (gas limit 624,732, used 612,671) runs out of gas when replayed under EIP-8151 (615,922 used before failing) and passes with 300,000 more gas (661,371 used), so nothing in this code fixes the gas amount; the sender's limit is the whole cause. The sender 0x43a8a728… has no code and authorizedRelayer() returns true for it; authorizedRelayerCount is 1.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: a gas amount fixed in this code: the replay passes with 300,000 more gas, so the recovery is not capped below the new price.
- Ruled out: a migration hazard in this contract: the recovered keys are Wormhole guardians checked by the Wormhole core contract, which is its own row; this card covers only the gas limit of transactions sent to this address.
- Ruled out: another step checking the same signer: the transaction calls this address directly and the only signatures checked are the guardians' inside the Wormhole core call.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
