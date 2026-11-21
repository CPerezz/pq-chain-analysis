---
id: gatewayminter-2222222d-attestation-key
format: 2
title: A forged attestation key could mint USDC, EURC and cirBTC through Circle Gateway
status: confirmed
severity: MEDIUM
justification: One ECDSA key authorises mints; only an upgrade by Circle's owner key can change the scheme.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  name: GatewayMinter
  project: circle
  code: verified
  code_url: https://etherscan.io/address/0xc2ff68068362aea1ca22a3896d05b2b812ce51b1#code
  proxy_of: '0xc2ff68068362aea1ca22a3896d05b2b812ce51b1'
  copies: 1
  upgradeable: 'yes'
  admin: '0x3c54ffa14d01ef3a555106007a4fed6e8964aab6'
value:
  usd: 0
  basis: held
activity: {}
impact: funds-loss
action: Upgrade GatewayMinter to verify attestations with a post-quantum signature scheme.
evidence_level: source
checks:
- id: copyright
  source: '0xc2ff68068362aea1ca22a3896d05b2b812ce51b1'
  file: src/modules/minter/Mints.sol
  line: 2
  has: Copyright 2025 Circle Internet Group, Inc.
  says: the verified source is Circle's
  for:
  - what
- id: recover
  source: '0xc2ff68068362aea1ca22a3896d05b2b812ce51b1'
  file: src/modules/minter/Mints.sol
  lines:
  - 256
  - 261
  has: address recoveredSigner = ECDSA.recover(keccak256(attestation).toEthSignedMessageHash(), signature);
  says: the attestation signer is recovered with ECDSA and must be in the listed set
  for:
  - evidence-1
  - justification
  - what
- id: mint
  source: '0xc2ff68068362aea1ca22a3896d05b2b812ce51b1'
  file: src/modules/minter/Mints.sol
  lines:
  - 339
  - 349
  has: IMintableToken(minter).mint(recipient, value);
  says: a valid attestation mints its value to the recipient it names
  for:
  - evidence-1
  - what
- id: cirbtc-supported
  call: '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  fn: isTokenSupported(address)(bool)
  args:
  - '0x72dfb2e44f59c5ad2bafe84314e5b99a7cd5075e'
  is: true
  says: cirBTC is a supported token
  for:
  - what
- id: cirbtc-minter
  call: '0x72dfb2e44f59c5ad2bafe84314e5b99a7cd5075e'
  fn: isMinter(address)(bool)
  args:
  - '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  is: true
  says: the minter can mint cirBTC
  for:
  - what
- id: cirbtc-allow
  call: '0x72dfb2e44f59c5ad2bafe84314e5b99a7cd5075e'
  fn: minterAllowance(address)(uint256)
  args:
  - '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  is: 30000099400
  says: 300.000994 cirBTC (8 decimals) of mint allowance remain
  for:
  - what
- id: usdc-auth
  call: '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  fn: tokenMintAuthority(address)(address)
  args:
  - '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  is: '0x0000000000000000000000000000000000000000'
  says: USDC has no mint authority, so the minter calls USDC's mint directly
  for:
  - what
- id: eurc-auth
  call: '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  fn: tokenMintAuthority(address)(address)
  args:
  - '0x1abaea1f7c830bd89acc67ec4af516284b1bc33c'
  is: '0x0000000000000000000000000000000000000000'
  says: EURC has no mint authority, so the minter calls EURC's mint directly
  for:
  - what
- id: cirbtc-auth
  call: '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  fn: tokenMintAuthority(address)(address)
  args:
  - '0x72dfb2e44f59c5ad2bafe84314e5b99a7cd5075e'
  is: '0x0000000000000000000000000000000000000000'
  says: cirBTC has no mint authority, so the minter calls cirBTC's mint directly
  for:
  - what
- id: addsigner
  source: '0xc2ff68068362aea1ca22a3896d05b2b812ce51b1'
  file: src/modules/minter/Mints.sol
  lines:
  - 231
  - 235
  has: function addAttestationSigner(address signer) public onlyOwner {
  says: only the owner lists attestation signers
  for:
  - evidence-3
  - what
- id: removesigner
  source: '0xc2ff68068362aea1ca22a3896d05b2b812ce51b1'
  file: src/modules/minter/Mints.sol
  lines:
  - 243
  - 247
  has: function removeAttestationSigner(address signer) public onlyOwner {
  says: only the owner removes attestation signers
  for:
  - evidence-3
- id: authup
  source: '0xc2ff68068362aea1ca22a3896d05b2b812ce51b1'
  file: src/GatewayCommon.sol
  line: 72
  has: function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
  says: the owner can upgrade the implementation
  for:
  - action
  - evidence-3
  - justification
- id: owner
  call: '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  fn: owner()(address)
  is: '0x3c54ffa14d01ef3a555106007a4fed6e8964aab6'
  says: the owner that can upgrade and manage signers
  for:
  - action
  - evidence-3
  - justification
- id: ownercode
  code: '0x3c54ffa14d01ef3a555106007a4fed6e8964aab6'
  is: empty
  says: the owner is an account without code
  for:
  - action
  - evidence-3
- id: paused
  call: '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  fn: paused()(bool)
  is: false
  says: minting is not paused
  for:
  - what
- id: signer
  call: '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  fn: isAttestationSigner(address)(bool)
  args:
  - '0x311ac5f3a327c18e27ea544694e20abd15caa85d'
  is: true
  says: 0x311ac5f3… is a listed attestation signer
  for:
  - evidence-2
  - what
- id: signer-tx
  tx: '0xe30984fb69dafe7949107ab9f4002239f49c296c28e5f244199f679076e8790d'
  to: '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  ok: true
  says: a real gatewayMint carrying an attestation signature in public calldata succeeded
  for:
  - what
- id: replay-today
  replay: '0xdb952db6647f2b5d4fe9b364d80230b2c3b928ba30d8f51d0dda0f6659ede89f'
  run: today
  ok: true
  says: a real gatewayMint, called directly on this proxy, passes as sent
  for:
  - evidence-2
  - what
- id: replay-code
  replay: '0xdb952db6647f2b5d4fe9b364d80230b2c3b928ba30d8f51d0dda0f6659ede89f'
  run: eip8151_signer_code
  ok: false
  says: the same mint reverts when 0x311ac5f3… has code, so that key signed it
  for:
  - evidence-2
  - what
- id: usdc-supported
  call: '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  fn: isTokenSupported(address)(bool)
  args:
  - '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  is: true
  says: USDC is a supported token
  for:
  - what
- id: eurc-supported
  call: '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  fn: isTokenSupported(address)(bool)
  args:
  - '0x1abaea1f7c830bd89acc67ec4af516284b1bc33c'
  is: true
  says: EURC is a supported token
  for:
  - what
- id: usdc-minter
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: isMinter(address)(bool)
  args:
  - '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  is: true
  says: the minter can mint USDC
  for:
  - what
- id: eurc-minter
  call: '0x1abaea1f7c830bd89acc67ec4af516284b1bc33c'
  fn: isMinter(address)(bool)
  args:
  - '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  is: true
  says: the minter can mint EURC
  for:
  - what
- id: usdc-allow
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: minterAllowance(address)(uint256)
  args:
  - '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  is: 86608632328621
  says: 86,608,632.33 USDC of mint allowance remain
  for:
  - what
- id: eurc-allow
  call: '0x1abaea1f7c830bd89acc67ec4af516284b1bc33c'
  fn: minterAllowance(address)(uint256)
  args:
  - '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  is: 20000099790000
  says: 20,000,099.79 EURC of mint allowance remain
  for:
  - what
sources:
- study: top-callers-classification
  who: Review09 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
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

Circle's Gateway minter mints USDC, EURC and cirBTC to the recipient named in an attestation whose ECDSA signature recovers to a signer the owner listed. A quantum attacker could forge attestations and mint new tokens up to the unused mint allowances: 86.6M USDC, 20M EURC and 300 cirBTC.

## Evidence

- The [verified source](https://etherscan.io/address/0xc2ff68068362aea1ca22a3896d05b2b812ce51b1#code) recovers the attestation signer with ECDSA, checks it is listed, then mints to the recipient.
- The listed [signer](https://etherscan.io/address/0x311ac5f3a327c18e27ea544694e20abd15caa85d) authorises live mints such as [this one](https://etherscan.io/tx/0xdb952db6647f2b5d4fe9b364d80230b2c3b928ba30d8f51d0dda0f6659ede89f).
- The [owner](https://etherscan.io/address/0x3c54ffa14d01ef3a555106007a4fed6e8964aab6), an account without code, can upgrade the minter and list or remove signers.

## Reviewer notes

### Mechanism

gatewayMint (Mints.sol 161-193, whenNotPaused, caller not denylisted) calls _verifyAttestationSignature (256-261): ECDSA.recover over the eth-signed hash of the attestation payload; the recovered address must be in attestationSigners, set by the owner through addAttestationSigner/removeAttestationSigner (231-248). Each attestation is then checked for expiry, destination domain, destination contract (this proxy), a supported token, an optional destination caller and the denylist; _mint (333-353) marks the transfer-spec hash used and calls mint(recipient, value) on the token, or on its mint authority when one is set (tokenMintAuthority is zero for USDC, EURC and cirBTC at the block, so each is minted directly). Anyone holding a listed key can therefore mint any supported token to any recipient, bounded by the token's minterAllowance for this proxy. _authorizeUpgrade (GatewayCommon.sol 72) is onlyOwner (UUPS); the owner is an account with no code and nonce 3; pendingOwner is zero. Rotating the ECDSA signer does not help against a quantum attacker: any key that signs a public attestation exposes its public key. The pauser can pause minting as a stopgap.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: erc1271: the only check is ECDSA.recover against the listed set (Mints.sol 257-259); no ERC-1271 or code-size branch.
- Ruled out: unused-implementation: this address is the proxy users call; real mints go to it (tx 0xe30984fb…, 0xdb952db6…) and it is not paused at the block.
- Ruled out: key-state: isAttestationSigner(0x311ac5f3…) is true and the signer has no code at the block; the dossier's two-week window recovered only that signer in 8,268 calls. Whether other signers are listed needs logs and does not change the finding.
- Ruled out: cirBTC: 0x72dfb2e4… is supported, has no mint authority, lists this proxy as a minter and leaves 300.000994 cirBTC of mint allowance at the block; it is named beside USDC and EURC.
- Ruled out: value: the tool reads $0 held; the exposure is the unused mint allowances (86,608,632.33 USDC, 20,000,099.79 EURC and 300.000994 cirBTC at the block), i.e. newly minted tokens, not held funds. Whose loss it is (Circle's backing or token holders) is not settled by a check, so whose is left empty.
- Ruled out: separate rated issue, not folded in: replay 0x1b822742… (block 26,405,739) passes today and reverts under EIP-8151 alone; its sender 0x9938b157… set gas limit 154,379 and the today run used 152,005, so the extra recovery cost exceeds the limit. This looks like a sender-gas-limit failure on the relayer's side; the dossier lists no more-gas run, so the main reviewer should replay it with more gas and file it as its own row.

### History

- 2026-11-17: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
