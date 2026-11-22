---
id: omnibridge-e00c629a-operator-key
format: 2
title: OmniBridge releases its escrow on one ECDSA key a quantum computer could forge
status: confirmed
severity: MEDIUM
justification: Users' escrowed funds can be taken with the recovered key; the fix is a contract upgrade by the admin.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe00c629afaccb0510995a2b95560e446a24c85b9'
  name: OmniBridge
  code: verified
  code_url: https://etherscan.io/address/0x53785920165fbdf33b3f56885dbc8d12854ac414#code
  proxy_of: '0x53785920165fbdf33b3f56885dbc8d12854ac414'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 24620179
  whose: users
  basis: held
activity:
  txs_90d: 5920
impact: funds-loss
action: Upgrade OmniBridge to check a post-quantum signature or proof on transfers; replacing the key with another
  ECDSA key does not help.
evidence_level: source
checks:
- id: recover-fin
  source: '0x53785920165fbdf33b3f56885dbc8d12854ac414'
  file: OmniBridge.sol
  line: 216
  has: if (ECDSA.recover(hashed, signatureData) != nearBridgeDerivedAddress) {
  says: finTransfer accepts a transfer only if its ECDSA signature recovers to the stored nearBridgeDerivedAddress
  for:
  - evidence-1
  - justification
  - what
- id: recover-deploy
  source: '0x53785920165fbdf33b3f56885dbc8d12854ac414'
  file: OmniBridge.sol
  line: 107
  has: if (ECDSA.recover(hashed, signatureData) != nearBridgeDerivedAddress) {
  says: deployToken uses the same key check to create bridged tokens
  for:
  - notes
- id: pay-eth
  source: '0x53785920165fbdf33b3f56885dbc8d12854ac414'
  file: OmniBridge.sol
  line: 221
  has: 'payload.recipient.call{value: payload.amount}("");'
  says: after the check, finTransfer sends the signed amount of ETH to the signed recipient
  for:
  - evidence-1
  - what
- id: pay-mint
  source: '0x53785920165fbdf33b3f56885dbc8d12854ac414'
  file: OmniBridge.sol
  line: 227
  has: BridgeToken(payload.tokenAddress).mint(payload.recipient, payload.amount);
  says: after the check, finTransfer mints bridged tokens to the signed recipient
  for:
  - evidence-1
  - what
- id: pay-token
  source: '0x53785920165fbdf33b3f56885dbc8d12854ac414'
  file: OmniBridge.sol
  line: 229
  has: IERC20(payload.tokenAddress).safeTransfer(payload.recipient, payload.amount);
  says: after the check, finTransfer transfers escrowed tokens to the signed recipient
  for:
  - evidence-1
  - justification
  - what
- id: fin-pause
  source: '0x53785920165fbdf33b3f56885dbc8d12854ac414'
  file: OmniBridge.sol
  line: 193
  has: whenNotPaused(PAUSED_FIN_TRANSFER)
  says: finTransfer runs only while its pause flag is clear
  for:
  - notes
- id: unpaused
  call: '0xe00c629afaccb0510995a2b95560e446a24c85b9'
  fn: pausedFlags()(uint256)
  is: 0
  says: no pause flag is set at the block, so finTransfer is open
  for:
  - what
- id: key
  call: '0xe00c629afaccb0510995a2b95560e446a24c85b9'
  fn: nearBridgeDerivedAddress()(address)
  is: '0x22eb4d37677ed931d9de2218cece1a832a147490'
  says: the key the bridge checks at the block
  for:
  - evidence-2
  - what
- id: key-eoa
  code: '0x22eb4d37677ed931d9de2218cece1a832a147490'
  is: empty
  says: the key's account holds no code
  for:
  - notes
- id: signed
  call: '0x0000000000000000000000000000000000000001'
  data: '0xd7605d1144e059788f768ad531e82b3bf747791596e46591e6c89dfa126d225f000000000000000000000000000000000000000000000000000000000000001ba1e661a862daf42612f9dba18e6ccd9683173f0947f09c8b4fa0b3e257faf5b015d351b0b05d08e86a39f8e3a47da7f947fda7e9e059cb80b59134ce67ce219e'
  is: 00000000000000000000000022eb4d37677ed931d9de2218cece1a832a147490
  says: the signature in tx 0xae81f997 over the Borsh hash of its transfer recovers to the stored key, so its public
    key is on-chain
  for:
  - evidence-2
  - what
- id: sig-tx
  tx: '0xae81f997a37ebcfd8a83df1e9d427504d6d995b2152999417ccf659849c63749'
  to: '0xe00c629afaccb0510995a2b95560e446a24c85b9'
  ok: true
  says: a finTransfer call carrying that signature succeeded on this bridge
  for:
  - evidence-2
  - what
- id: deposit
  source: '0x53785920165fbdf33b3f56885dbc8d12854ac414'
  file: OmniBridge.sol
  line: 273
  has: IERC20(tokenAddress).safeTransferFrom(msg.sender, address(this), amount);
  says: initTransfer pulls the bridging user's tokens into the contract
  for:
  - justification
  - whose
- id: eth-deposit
  source: '0x53785920165fbdf33b3f56885dbc8d12854ac414'
  file: OmniBridge.sol
  line: 264
  has: extensionValue = msg.value - amount - nativeFee;
  says: initTransfer keeps the user's ETH amount and native fee in the contract
  for:
  - whose
- id: eth-balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xe00c629afaccb0510995a2b95560e446a24c85b9'
  is: 2191192625406083648656
  says: the bridge holds 2,191.19 ETH
  for:
  - what
- id: usdc-balance
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0xe00c629afaccb0510995a2b95560e446a24c85b9'
  is: 14534154338454
  says: the bridge holds 14.53M USDC
  for:
  - what
- id: impl-slot
  storage: '0xe00c629afaccb0510995a2b95560e446a24c85b9'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x53785920165fbdf33b3f56885dbc8d12854ac414'
  says: the proxy runs the OmniBridge implementation
  for:
  - evidence-1
- id: upgrade
  source: '0x53785920165fbdf33b3f56885dbc8d12854ac414'
  file: OmniBridge.sol
  lines:
  - 334
  - 336
  has: internal override onlyRole(DEFAULT_ADMIN_ROLE) {}
  says: holders of DEFAULT_ADMIN_ROLE can upgrade the implementation (UUPS)
  for:
  - action
  - evidence-3
  - justification
  - what
- id: setter
  source: '0x53785920165fbdf33b3f56885dbc8d12854ac414'
  file: OmniBridge.sol
  lines:
  - 316
  - 320
  has: external onlyRole(DEFAULT_ADMIN_ROLE) { nearBridgeDerivedAddress = nearBridgeDerivedAddress_;
  says: the admin can only replace the stored key address; the check stays ECDSA
  for:
  - action
  - evidence-3
  - justification
  - what
- id: admin-role
  call: '0xe00c629afaccb0510995a2b95560e446a24c85b9'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0x0000000000000000000000000000000000000000000000000000000000000000'
  - '0x2468603819bf09ed3fb6f3efeff24b1955f3cde1'
  is: true
  says: the Safe holds DEFAULT_ADMIN_ROLE at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: safe-threshold
  call: '0x2468603819bf09ed3fb6f3efeff24b1955f3cde1'
  fn: getThreshold()(uint256)
  is: 3
  says: the admin Safe needs 3 signatures
  for:
  - evidence-3
- id: safe-owners
  call: '0x2468603819bf09ed3fb6f3efeff24b1955f3cde1'
  fn: getOwners()(address[])
  is:
  - '0xed9cB50304991951Cbee747900484E9a041DA464'
  - '0xF58096A602C960c841Bd83A29DE21c808a9c1ac9'
  - '0xCFB9C137E21E199757Ae3Ce705B199CB26A3b91d'
  - '0x1180c536465413eE05b206b3a99d4C6a9934D2b7'
  - '0x8F3A347Eb3eB62fEa4975d293e052cD96abd36C6'
  says: the admin Safe has 5 owners
  for:
  - evidence-3
- id: replay-today
  replay: '0xae88af19e2ab26c6417a6a1abfeceb05487f67eac560bb925d0a4f78a944da1e'
  run: eip8151
  ok: true
  says: a real finTransfer still passes under EIP-8151 with nobody migrating
  for:
  - notes
- id: replay-code
  replay: '0xae88af19e2ab26c6417a6a1abfeceb05487f67eac560bb925d0a4f78a944da1e'
  run: eip8151_signer_code
  ok: false
  says: the same finTransfer reverts if the key's account holds real code (the separate migration notice)
  for:
  - notes
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review09 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

OmniBridge pays out the ETH and tokens it holds, and mints bridged tokens, on transfers signed by one stored ECDSA key. That key has signed on-chain, so a quantum computer could recover it and sign transfers that drain the bridge. The admin can upgrade it; a new ECDSA key would be as exposed.

## Evidence

- [finTransfer](https://etherscan.io/address/0x53785920165fbdf33b3f56885dbc8d12854ac414#code) sends ETH, mints or transfers tokens once `ECDSA.recover` equals the stored `nearBridgeDerivedAddress`.
- The stored key signed this [transfer](https://etherscan.io/tx/0xae81f997a37ebcfd8a83df1e9d427504d6d995b2152999417ccf659849c63749), so its public key is known.
- A 3-of-5 [Safe](https://etherscan.io/address/0x2468603819bf09ed3fb6f3efeff24b1955f3cde1) holds the admin role, which can upgrade the contract; the key setter swaps one ECDSA key for another.

## Reviewer notes

### Mechanism

The proxy (EIP-1967 slot) delegates to OmniBridge 0x5378...c414. finTransfer (lines 190-242), gated by whenNotPaused(PAUSED_FIN_TRANSFER), Borsh-encodes the payload and reverts unless ECDSA.recover(hash, signatureData) equals nearBridgeDerivedAddress (line 216); it then sends ETH (221), calls a custom minter (225), mints a BridgeToken (227) or transfers escrowed ERC-20 (229). deployToken (97-142) uses the same key check (107). initTransfer escrows users' tokens (273) or ETH (264). A quantum computer recovers the key of 0x22eb...7490 from any on-chain signature (tx 0xae81f997 recovers to it) and signs new payloads. setNearBridgeDerivedAddress (316-320, DEFAULT_ADMIN_ROLE) only swaps in another ECDSA key. _authorizeUpgrade (334-336, same role) lets the Safe 0x2468...cde1 (1.3.0, 3 of 5) upgrade. Rated by the quantum-exposure table: pooled users' funds, fixable only by a contract upgrade: MEDIUM.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: erc1271: finTransfer and deployToken compare ECDSA.recover with nearBridgeDerivedAddress only (lines 107, 216); no ERC-1271 or code-size branch.
- Ruled out: unused-implementation/wrong-code: the proxy's EIP-1967 slot holds 0x5378...c414 (verified OmniBridge); tx 0xae81f997 called finTransfer here and succeeded.
- Ruled out: key-state: nearBridgeDerivedAddress() is 0x22eb...7490 (no code) at the block; the finTransfer signature of tx 0xae81f997 recovers to it, so it is the checked key and its public key is on-chain.
- Ruled out: path-closed: pausedFlags() is 0, so finTransfer is open; the admin or pausable admin can pause it, but that halts payouts, it does not fix the check.
- Ruled out: setter: setNearBridgeDerivedAddress only swaps in another ECDSA-checked address; the upgrade path is live (hasRole(DEFAULT_ADMIN_ROLE, Safe) true, Safe threshold 3 of 5).
- Ruled out: direct-path: no function pays ETH or tokens without the signature; other payout routes (upgrade, custom minters) are admin-only.
- Ruled out: value-whose: value is what this proxy holds (2,191.19 ETH, 14.53M USDC, others); the first study's $50.9M also counted unpriced AURORA. Some ETH may be relayer fees; the bulk is bridged users' escrow.
- Ruled out: A migration notice sits beside this: replay of tx 0xae88af19 passes under EIP-8151 and reverts with code at the signer; the admin can rotate the key first. Belongs to rotate-signer-before-migrating.
- Ruled out: Who holds the key: variable names and an 'aurora' storage namespace suggest NEAR's MPC network, and the fee recipient in tx 0xae81f997 is omni-relayer.bridge.near, but nothing checkable names the team; project left out.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
