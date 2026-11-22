---
id: contract-735a2a58-sender-gas-limits
format: 2
title: Bridged USDC receipts here fail at their sender's gas limit under EIP-8151
status: confirmed
severity: LOW
justification: A real call fails under EIP-8151 at the gas limit its sender chose and passes with more gas, so LOW.
category: breaks-at-activation
pattern: PQ-18
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x735a2a58f646cb7a40b8fed3f521215ae2c365f6'
  code: bytecode
  code_url: https://etherscan.io/address/0x735a2a58f646cb7a40b8fed3f521215ae2c365f6#code
  copies: 1
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: 'The owner 0x39ace7e3… must re-estimate its gas limit under EIP-8151: a limit just above the gas used fails,
  as nested calls keep 1/64.'
evidence_level: executed
checks:
- id: clone
  bytecode: '0x735a2a58f646cb7a40b8fed3f521215ae2c365f6'
  has: 363d3d373d3d3d363d73c4f076f0df65f5671d88b2c1354ef58ce2b0952a5af4
  says: the address is a clone that delegatecalls all gas to 0xc4f076f0df65f5671d88b2c1354ef58ce2b0952a
  for:
  - evidence-1
  - what
- id: owner
  call: '0x735a2a58f646cb7a40b8fed3f521215ae2c365f6'
  fn: getOwner()(address)
  is: '0x39ace7e33c2d8c720ac7b843fb3444188e88311e'
  says: the clone's owner, read from its appended bytes, is set
  for:
  - action
- id: sel
  selector: '0xc4f076f0df65f5671d88b2c1354ef58ce2b0952a'
  fn: cctpReceiveMessage(bytes,bytes)
  says: the implementation has cctpReceiveMessage, the function the real call used
  for:
  - evidence-1
  - what
- id: open
  source: '0xc4f076f0df65f5671d88b2c1354ef58ce2b0952a'
  file: contracts/StorageHyperEVM.sol
  line: 190
  has: function cctpReceiveMessage(bytes calldata message, bytes calldata attestation) external returns (bool) {
  says: cctpReceiveMessage has no owner check
  for:
  - what
- id: fwd
  source: '0xc4f076f0df65f5671d88b2c1354ef58ce2b0952a'
  file: contracts/StorageHyperEVM.sol
  line: 201
  has: return IMessageTransmitterV2(CCTP_MESSAGE_TRANSMITTER_V2).receiveMessage(message, attestation);
  says: the message is handed to the CCTP message transmitter with no gas argument
  for:
  - action
  - evidence-1
  - what
- id: mt
  source: '0xc4f076f0df65f5671d88b2c1354ef58ce2b0952a'
  file: contracts/StorageHyperEVM.sol
  line: 40
  has: address public constant CCTP_MESSAGE_TRANSMITTER_V2 = 0x81D40F21F12A8F0E3252Bccb954D722d4c464B64;
  says: the transmitter called is CCTP's MessageTransmitterV2
  for:
  - evidence-1
  - what
- id: threshold
  call: '0x81d40f21f12a8f0e3252bccb954d722d4c464b64'
  fn: signatureThreshold()(uint256)
  is: 2
  says: the transmitter needs two attester signatures per message
  for:
  - action
  - what
- id: tx
  tx: '0xa4a5b4de71f4a23080582424a032d5a80139fea91769fc19765981c6f6be575c'
  to: '0x735a2a58f646cb7a40b8fed3f521215ae2c365f6'
  ok: true
  says: a real call to this address succeeded
  for:
  - action
  - evidence-2
  - justification
  - what
- id: r8151
  replay: '0xa4a5b4de71f4a23080582424a032d5a80139fea91769fc19765981c6f6be575c'
  run: eip8151
  ok: false
  says: replayed under EIP-8151 as sent, it fails
  for:
  - action
  - evidence-2
  - justification
  - what
- id: rmore
  replay: '0xa4a5b4de71f4a23080582424a032d5a80139fea91769fc19765981c6f6be575c'
  run: eip8151_more_gas
  ok: true
  says: 'under EIP-8151 with 300,000 more gas, it passes: the sender''s gas limit is the cause'
  for:
  - action
  - evidence-2
  - justification
  - what
- id: usdc
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0x735a2a58f646cb7a40b8fed3f521215ae2c365f6'
  is: 0
  says: the clone holds no USDC at the block
  for:
  - what
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

This clone receives USDC bridged over CCTP: cctpReceiveMessage hands the message to the CCTP message transmitter, which checks two attester signatures. A real call to it succeeds today, fails under EIP-8151 at its sender's gas limit, and passes with more gas. It holds no USDC at the block.

## Evidence

- [cctpReceiveMessage](https://etherscan.io/address/0xc4f076f0df65f5671d88b2c1354ef58ce2b0952a#code), the code this address runs, passes the message to the CCTP message transmitter with no gas cap.
- [A real call](https://etherscan.io/tx/0xa4a5b4de71f4a23080582424a032d5a80139fea91769fc19765981c6f6be575c) succeeds today, fails when replayed under EIP-8151, and passes with 300,000 more gas.

## Reviewer notes

### Mechanism

The address is a 77-byte EIP-1167 clone with 32 extra bytes: it delegatecalls every call to 0xc4f076f0df65f5671d88b2c1354ef58ce2b0952a (verified on Sourcify as StorageHyperEVM) and carries its owner, 0x39ace7e33c2d8c720ac7b843fb3444188e88311e, in its last 20 bytes (getOwner reads them). cctpReceiveMessage (lines 190-202) is open to any caller: it checks the message's destination domain and mint recipient, then calls MessageTransmitterV2.receiveMessage at 0x81d40f21f12a8f0e3252bccb954d722d4c464b64 with no gas argument, so all but 1/64 of the remaining gas goes on. The transmitter recovers the attesters' signatures (signatureThreshold is 2 at the block) and mints USDC to this address through TokenMinterV2. This contract recovers nothing itself and fixes no gas amount. Tx 0xa4a5b4de...575c (block 26,389,949, sent by the owner with a 186,621 gas limit, 179,982 used) succeeds today; under EIP-8151 it fails (175,096 used), and with 300,000 more gas it passes using 186,182: the two cold recoveries cost 6,200 more, and the 1/64 kept back at each call layer leaves the inner call short below the sender's limit. A failed receive does not use the message's nonce, so it can be sent again with more gas.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: fixed-gas-recovery: line 201 is a plain external call with no gas argument, and the clone's delegatecall forwards all gas (opcode 5a before f4); the amount is the sender's.
- Ruled out: children: the recovery is in the CCTP MessageTransmitterV2, which has its own row; the failing transaction calls this address and its sender sets the limit, so the gas-limit card belongs here.
- Ruled out: unused-implementation: this address is a clone in use (owner set, a real call at block 26,389,949), not the implementation; the implementation 0xc4f076f0... and any other clones of it are other rows.
- Ruled out: the replay bundles no other signed step: the transaction is one cctpReceiveMessage call; the only signatures are the CCTP attesters', checked once by the transmitter, and the failure clears with more gas alone.
- Ruled out: direct-path: the message in the transaction names this address as destinationCaller (calldata bytes after the recipient), so the transmitter accepts it only through this clone; not put on the card because no check kind reads calldata.
- Ruled out: proxy_of left to the tool: the tool's clone detector misses this clone because of its 32 appended bytes, and the registry wants a call or storage read naming the implementation, which this clone has none of; the bytecode check `clone` shows the target.
- Ruled out: value: 0 USDC and 0 ETH at block 26,438,999; whose is left empty because nothing on chain shows whether the bridged USDC is the owner's or its users'.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
