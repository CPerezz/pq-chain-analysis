---
id: bridge-94c9d55f-sender-gas-limits
format: 2
title: Whitechain bridge deposits sent with tight gas limits fail under EIP-8151
status: confirmed
severity: LOW
justification: A real deposit fails at its sender's own gas limit under the change; the same deposit with a higher
  gas limit succeeds.
category: breaks-at-activation
pattern: PQ-18
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x94c9d55f064980ed1faf0abb42f3548700619039'
  name: Bridge
  project: whitechain
  code: verified
  code_url: https://etherscan.io/address/0xd09d5dec00e48a148ab2bf74a5c6f82325d39d41#code
  proxy_of: '0xd09d5dec00e48a148ab2bf74a5c6f82325d39d41'
  copies: 6
  family: 6fb6da97e90112380370e0f619f23191
  upgradeable: 'yes'
value:
  usd: 70051
  basis: held
activity: {}
impact: liveness
action: 'Re-estimate bridgeTokens gas limits under EIP-8151: this deposit used 3,100 more gas and still failed at
  its 138,419 limit.'
evidence_level: executed
checks:
- id: callpath
  source: '0xd09d5dec00e48a148ab2bf74a5c6f82325d39d41'
  file: contracts/main/modules/bridge/Bridge.sol
  lines:
  - 198
  - 201
  has: bytes32 _hash = _validateECDSA({
  says: every bridgeTokens deposit goes through the signature check
  for:
  - action
  - what
- id: recover
  source: '0xd09d5dec00e48a148ab2bf74a5c6f82325d39d41'
  file: contracts/main/modules/bridge/Bridge.sol
  line: 646
  has: address signer = ECDSAChecks.recoverSigner(
  says: the deposit's hash is recovered with ECDSA
  for:
  - action
  - evidence-1
  - what
- id: role
  source: '0xd09d5dec00e48a148ab2bf74a5c6f82325d39d41'
  file: contracts/main/modules/bridge/Bridge.sol
  line: 656
  has: 'require(hasRole(RELAYER_ROLE, signer), "Bridge: Signer must have RELAYER_ROLE");'
  says: the recovered signer must hold RELAYER_ROLE
  for:
  - evidence-1
  - what
- id: ecrecover
  source: '0xd09d5dec00e48a148ab2bf74a5c6f82325d39d41'
  file: '@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: the recovery is Solidity's ecrecover, which gives the precompile all remaining gas
  for:
  - justification
  - what
- id: relayer
  call: '0x94c9d55f064980ed1faf0abb42f3548700619039'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0xe2b7fb3b832174769106daebcfd6d1970523240dda11281102db9363b83b0dc4'
  - '0x01831f1fc1f797dd40c4f22cbc08ee62ba8fee55'
  is: true
  says: the recovered relayer key holds RELAYER_ROLE
  for:
  - evidence-1
  - what
- id: signer-eoa
  code: '0x01831f1fc1f797dd40c4f22cbc08ee62ba8fee55'
  is: empty
  says: the relayer has no code, so EIP-8151 changes only the price of its recovery
  for:
  - evidence-2
- id: tx
  tx: '0x8f4fc360766a86aa7bf875016c078d4e90d56759f2e05f4cc2bbd3b6143f4226'
  to: '0x94c9d55f064980ed1faf0abb42f3548700619039'
  ok: true
  says: the deposit was a direct call to this bridge and succeeded
  for:
  - evidence-2
- id: replay-today
  replay: '0x8f4fc360766a86aa7bf875016c078d4e90d56759f2e05f4cc2bbd3b6143f4226'
  run: today
  ok: true
  says: the engine reproduces the real receipt
  for:
  - evidence-2
  - justification
- id: replay-8151
  replay: '0x8f4fc360766a86aa7bf875016c078d4e90d56759f2e05f4cc2bbd3b6143f4226'
  run: eip8151
  ok: false
  says: under EIP-8151 the same deposit, with its own gas limit, reverts
  for:
  - evidence-2
  - justification
  - what
- id: replay-delegated
  replay: '0x8f4fc360766a86aa7bf875016c078d4e90d56759f2e05f4cc2bbd3b6143f4226'
  run: eip8151_signer_delegated
  ok: false
  says: 'it fails the same way with a 7702 delegation at the signer: the price fails it, not code'
  for:
  - evidence-2
- id: map
  call: '0x81250edf514cb5918dc57858010dfc67b5125770'
  fn: mapInfo(uint256)(uint256,uint256,uint8,uint8,bytes32,bytes32,bool,bool,bool)
  args:
  - 1
  is:
  - 1
  - 1875
  - 1
  - 0
  - '0x000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  - '0x000000000000000000000000f97b9bf62916f1eb42dd906a7254603e7b9fc4a7'
  - false
  - true
  - false
  says: the USDC route the deposit used is allowed at the block
  for:
  - notes
- id: user-deposit
  source: '0xd09d5dec00e48a148ab2bf74a5c6f82325d39d41'
  file: contracts/main/modules/bridge/Bridge.sol
  lines:
  - 173
  - 181
  has: external payable nonReentrant
  says: bridgeTokens is open to any caller, not role-gated, and (lines 217-222) pulls the tokens from that caller
  for:
  - notes
- id: author
  source: '0xd09d5dec00e48a148ab2bf74a5c6f82325d39d41'
  file: contracts/main/modules/bridge/Bridge.sol
  line: 23
  has: '@author Whitechain'
  says: the verified source names Whitechain as its author
  for:
  - notes
- id: spec
  ref: https://github.com/ethereum/EIPs/blob/8194528a2ee9a4893a398a5871c470ab0ac3b09a/EIPS/eip-8151.md
  says: 'EIP-8151 at the study''s commit: a successful recovery costs 200 gas more warm, 3,100 more cold'
  for:
  - action
  - what
- id: replay-more
  replay: '0x8f4fc360766a86aa7bf875016c078d4e90d56759f2e05f4cc2bbd3b6143f4226'
  run: eip8151_more_gas
  ok: true
  says: the same deposit under EIP-8151 succeeds once 300,000 more gas is given
  for:
  - action
  - evidence-2
  - justification
- id: proxy-gas
  source: '0x94c9d55f064980ed1faf0abb42f3548700619039'
  file: '@openzeppelin/contracts/proxy/Proxy.sol'
  line: 31
  has: let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
  says: this address's fallback delegatecalls the implementation with gas(), which keeps back 1/64 of the gas forwarded
  for:
  - action
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-94c9d55f, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection (the card was edited after this answer)
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: 'kept: LOW (PQ-18): Whitechain bridge deposits sent with tight gas limits fail under EIP-8151. A real deposit
    fails at its sender''s own gas limit under the change; the same deposit with a higher gas limit succeeds. Two
    refuters had agreed (one objected to the flat per-signature figure); Claude replaced that figure with what the
    replays measured. Settled by Claude (D-029). Claude read the card and the answers.'
related: []
---

## What happens

Whitechain's bridge accepts a deposit only with a quote signed by its relayer, checked with ecrecover on every bridgeTokens call. Under EIP-8151 that check costs up to 3,100 gas more, so a deposit sent with a tight gas limit runs out of gas and reverts.

## Evidence

- [bridgeTokens](https://etherscan.io/address/0xd09d5dec00e48a148ab2bf74a5c6f82325d39d41#code) recovers the relayer's signature and requires RELAYER_ROLE; the relayer holds it.
- A [real USDC deposit](https://etherscan.io/tx/0x8f4fc360766a86aa7bf875016c078d4e90d56759f2e05f4cc2bbd3b6143f4226) succeeds today, fails under EIP-8151 as sent, and succeeds with more gas.

## Reviewer notes

### Mechanism

This address is an ERC-1967 proxy; its fallback delegatecalls the implementation with gas() (Proxy.sol line 31), which keeps back 1/64 of the gas. bridgeTokens (Bridge.sol 173-245) calls _validateECDSA (622-659): it hashes the deposit's parameters, checks the hash is unused and the deadline, recovers the signer with OpenZeppelin ECDSA (ecrecover with all remaining gas, ECDSAUpgradeable.sol line 139) and requires RELAYER_ROLE (line 656). One recovery per deposit. Under EIP-8151 a cold recovery costs 3,100 gas more. Transaction 0x8f4f...4226 (block 26,406,219, a direct bridgeTokens call from 0x745e...0eb2, 3 USDC on map 1) had a gas limit of 138,419 and used 126,357 today. On the fork engine it succeeds today, reverts under EIP-8151 at 136,741 gas (the 1,678 left is the 1/64 the proxy kept back), and succeeds under EIP-8151 with 300,000 more gas, using 129,457 (run eip8151_more_gas). The recovered relayer 0x0183...ee55 has no code, and the run with a 7702 delegation at the signer fails the same way, so the price is what fails, not code at the signer. Nothing in Bridge or the libraries it uses sets a gas amount, so the only limit that runs out is the sender's. At block 26,438,999 the relayer still holds RELAYER_ROLE and Mapper 0x8125...5770 reports map 1 (USDC, chain 1 to 1875) as allowed.

### Checks

- Header facts: this address alone, at block 26,438,999; 6 addresses run this code.
- Ruled out: fixed gas in code: the recovery is Solidity ecrecover, which forwards all gas (ECDSAUpgradeable line 139); the scanner reports no gas constant; SafeERC20 and the Mapper read forward all gas too.
- Ruled out: code at the signer: the relayer 0x01831f1f...ee55 has no code at the block (nonce 180); the delegated-signer replay fails exactly like the plain EIP-8151 run, so the failure is the price.
- Ruled out: a bundled step failing instead: the tx is a direct bridgeTokens call; its other steps are a Mapper read and a USDC transferFrom, neither checks a signature.
- Ruled out: path closed: map 1 is allowed at the block and the relayer still holds RELAYER_ROLE; the address had 5 recoveries in the two-week window, the last on block 26,406,219.
- Ruled out: whose money: bridgeTokens pulls the caller's tokens, but EMERGENCY_ROLE can add operator liquidity with depositTokens (404-407); the USDC held may be mixed, and the split needs logs I cannot read, so whose is left empty.
- Ruled out: a separate migration notice sits beside this: if the relayer key's account takes real code, deposits stop until the multisig grants RELAYER_ROLE to a new key (rotate-signer-before-migrating); not folded here.
- Ruled out: copies: this address is the one in use, holding about $70,051 of the family's $70,075 and 5 of its 7 window recoveries.
- Ruled out: Number from the replays (126,357 today, 129,457 with more gas).

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
