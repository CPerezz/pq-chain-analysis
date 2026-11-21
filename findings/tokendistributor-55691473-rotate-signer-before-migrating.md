---
id: tokendistributor-55691473-rotate-signer-before-migrating
format: 2
title: Replace the claim signer before it takes real code
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless the signer's account takes real code, and the operator can set a new signer
  first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x556914730fd4d6af4da8f50f78d195af9d468cff'
  name: TokenDistributor
  code: verified
  code_url: https://etherscan.io/address/0x556914730fd4d6af4da8f50f78d195af9d468cff#code
  copies: 12
  family: ef167be567ecbb60d5b275ad49b31445
  upgradeable: 'no'
  admin: '0x2c825edb17c2c04983a481ebd2da2a39424c7cb7'
value:
  usd: 0
  whose: operator
  basis: held
activity: {}
impact: liveness
action: Set a new signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x556914730fd4d6af4da8f50f78d195af9d468cff'
  file: src/TokenDistributor.sol
  line: 286
  has: if (ECDSA.recover(digest, signature) != _signer) revert InvalidSignature();
  says: claim reverts unless the recovered address is the stored signer
  for:
  - evidence-1
  - justification
  - what
- id: recoverbatch
  source: '0x556914730fd4d6af4da8f50f78d195af9d468cff'
  file: src/TokenDistributor.sol
  line: 337
  has: if (ECDSA.recover(digest, signature) != _signer) revert InvalidSignature();
  says: batchClaim reverts unless the recovered address is the stored signer
  for:
  - evidence-1
  - what
- id: purpose
  source: '0x556914730fd4d6af4da8f50f78d195af9d468cff'
  file: src/TokenDistributor.sol
  line: 11
  has: This contract allows users to claim tokens based on EIP-712 signatures
  says: the contract distributes tokens to users who claim with a signature
  for:
  - what
- id: setsigner
  source: '0x556914730fd4d6af4da8f50f78d195af9d468cff'
  file: src/TokenDistributor.sol
  lines:
  - 190
  - 194
  has: function setSigner(address _signer) external onlyOperator {
  says: the operator can replace the signer
  for:
  - action
  - evidence-2
  - justification
- id: settime
  source: '0x556914730fd4d6af4da8f50f78d195af9d468cff'
  file: src/TokenDistributor.sol
  lines:
  - 206
  - 220
  has: function setTime(uint256 _startTime, uint256 _duration) external onlyOperator {
  says: the operator can schedule a new claim window
  for:
  - what
- id: operator
  call: '0x556914730fd4d6af4da8f50f78d195af9d468cff'
  fn: operator()(address)
  is: '0x7a39c61adbd6d4767d858da6ce2ae3253780ea2e'
  says: the operator that can set the signer and the window
  for:
  - action
  - evidence-2
  - justification
- id: operatornonce
  nonce: '0x7a39c61adbd6d4767d858da6ce2ae3253780ea2e'
  min: 110
  says: the operator account is in use
  for:
  - notes
- id: signer
  call: '0x556914730fd4d6af4da8f50f78d195af9d468cff'
  fn: signer()(address)
  is: '0xa6f30d69a1de79de755824ff9649243ac5767bd4'
  says: the signer is set at the block
  for:
  - evidence-2
- id: signercode
  code: '0xa6f30d69a1de79de755824ff9649243ac5767bd4'
  is: empty
  says: the signer's account has no code at the block
  for:
  - notes
- id: endtime
  call: '0x556914730fd4d6af4da8f50f78d195af9d468cff'
  fn: endTime()(uint64)
  is: '1780588800'
  says: the claim window ends at 1780588800
  for:
  - what
  - whose
- id: now
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getCurrentBlockTimestamp()(uint256)
  is: '1794969479'
  says: the block time is after the window's end
  for:
  - what
- id: src-withdraw
  source: '0x556914730fd4d6af4da8f50f78d195af9d468cff'
  file: src/TokenDistributor.sol
  lines:
  - 173
  - 181
  has: function withdraw() external onlyOwner {
  says: the owner takes the whole balance once block.timestamp > endTime
  for:
  - whose
- id: src-toolate
  source: '0x556914730fd4d6af4da8f50f78d195af9d468cff'
  file: src/TokenDistributor.sol
  line: 390
  has: if (block.timestamp > endTime) revert TooLate();
  says: no claim is possible after endTime
  for:
  - whose
- id: sel-withdraw
  selector: '0x556914730fd4d6af4da8f50f78d195af9d468cff'
  fn: withdraw()
  says: withdraw is in the code that runs
  for:
  - whose
- id: owner-code
  code: '0x2c825edb17c2c04983a481ebd2da2a39424c7cb7'
  is: empty
  says: the owner who can withdraw is an EOA
  for:
  - whose
- id: token-balance
  call: '0xf280b16ef293d8e534e370794ef26bf312694126'
  fn: balanceOf(address)(uint256)
  args:
  - '0x556914730fd4d6af4da8f50f78d195af9d468cff'
  is: '10000000'
  says: the contract holds 0.01 ASTEROID (9 decimals)
  for:
  - whose
- id: eth-balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x556914730fd4d6af4da8f50f78d195af9d468cff'
  is: '0'
  says: no ETH held
  for:
  - whose
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

This distributor pays tokens to users who present a claim signed by one stored signer key, recovered with ECDSA. If the signer's account takes real code, every claim fails; an EIP-7702 delegation keeps working. Its claim window has ended, and the operator can open a new one.

## Evidence

- [claim](https://etherscan.io/address/0x556914730fd4d6af4da8f50f78d195af9d468cff#code) and batchClaim revert unless the recovered address equals the stored signer.
- [setSigner](https://etherscan.io/address/0x556914730fd4d6af4da8f50f78d195af9d468cff#code) lets the operator replace the signer at any time.

## Reviewer notes

### Mechanism

claim (lines 250-298) and batchClaim (lines 312-340) check the window in _validateClaim (signer set, startTime <= now <= endTime), build an EIP-712 digest and revert with InvalidSignature unless ECDSA.recover(digest, signature) equals the stored signer (lines 286, 337). There is no ERC-1271 or code-size branch. setSigner (lines 190-194), onlyOperator, replaces the signer; operator is immutable, an account without code at the block. setTime (lines 206-220) lets the operator schedule a new window. At the block the signer is 0xa6f3...7bd4 (no code, nonce 0), endTime 1780588800 is before the block time 1794969479, so claims revert with TooLate until the operator calls setTime. The contract holds 10,000,000 base units (0.01 at 9 decimals) of ASTEROID.

### Checks

- Header facts: this address alone, at block 26,438,999; 12 addresses run this code.
- Ruled out: an ERC-1271 or code-size path for a signer with code: claim and batchClaim only compare ECDSA.recover with the stored signer (lines 286, 337).
- Ruled out: path closed for good: the window ended, but setTime (lines 206-220) lets the operator, an account without code that has sent 110 transactions, open a new one.
- Ruled out: a direct path for users without a signature: none; the owner can withdraw the remaining balance after endTime (lines 173-182), which needs no signature.
- Ruled out: breaks by itself: ECDSA.recover forwards all gas and the signer has no code at the block, so nothing fails with nobody migrating.
- Ruled out: other copies of this code (for example 0xab8cba5e... with recoveries in the study window) have their own signer and window state and are separate rows.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
