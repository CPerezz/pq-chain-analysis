---
id: tokendistributor-f5746080-rotate-signer-before-migrating
format: 2
title: Token claims stop if the claim signer's account takes real code
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless the signer's account takes real code, and the operator can replace the key
  first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf5746080656347087d8a1607284d1b52f7dc390a'
  name: TokenDistributor
  code: verified
  code_url: https://etherscan.io/address/0xf5746080656347087d8a1607284d1b52f7dc390a#code
  copies: 12
  family: ef167be567ecbb60d5b275ad49b31445
  upgradeable: 'no'
  admin: '0x7a39c61adbd6d4767d858da6ce2ae3253780ea2e'
value:
  usd: 0
  whose: operator
  basis: held
activity: {}
impact: liveness
action: Replace the signer with setSigner before that signer's account moves to real code.
evidence_level: source
checks:
- id: ecdsa
  source: '0xf5746080656347087d8a1607284d1b52f7dc390a'
  file: src/TokenDistributor.sol
  line: 286
  has: if (ECDSA.recover(digest, signature) != _signer) revert InvalidSignature();
  says: claim reverts unless the ECDSA-recovered address is the stored signer
  for:
  - evidence-1
  - justification
  - what
- id: ecdsa2
  source: '0xf5746080656347087d8a1607284d1b52f7dc390a'
  file: src/TokenDistributor.sol
  line: 337
  has: if (ECDSA.recover(digest, signature) != _signer) revert InvalidSignature();
  says: batchClaim reverts unless the ECDSA-recovered address is the stored signer
  for:
  - evidence-1
  - what
- id: signer
  call: '0xf5746080656347087d8a1607284d1b52f7dc390a'
  fn: signer()(address)
  is: '0xa6f30d69a1de79de755824ff9649243ac5767bd4'
  says: the stored signer key at the block
  for:
  - action
  - what
- id: signercode
  code: '0xa6f30d69a1de79de755824ff9649243ac5767bd4'
  is: empty
  says: the signer account has no code yet, so its signatures still count
  for:
  - what
- id: setsigner
  source: '0xf5746080656347087d8a1607284d1b52f7dc390a'
  file: src/TokenDistributor.sol
  lines:
  - 190
  - 192
  has: function setSigner(address _signer) external onlyOperator {
  says: the operator replaces the stored signer with setSigner
  for:
  - action
  - admin
  - evidence-2
  - justification
  - what
- id: settime
  source: '0xf5746080656347087d8a1607284d1b52f7dc390a'
  file: src/TokenDistributor.sol
  lines:
  - 206
  - 210
  has: function setTime(uint256 _startTime, uint256 _duration) external onlyOperator {
  says: the operator schedules a new claim window when none is active
  for:
  - admin
  - evidence-2
  - what
- id: operator
  call: '0xf5746080656347087d8a1607284d1b52f7dc390a'
  fn: operator()(address)
  is: '0x7a39c61adbd6d4767d858da6ce2ae3253780ea2e'
  says: the operator that can set the signer and the claim window
  for:
  - action
  - admin
  - evidence-2
  - justification
  - what
- id: opnonce
  nonce: '0x7a39c61adbd6d4767d858da6ce2ae3253780ea2e'
  is: 110
  says: the operator is an account that has sent 110 transactions, so it is live
  for:
  - evidence-2
  - justification
  - what
- id: endtime
  call: '0xf5746080656347087d8a1607284d1b52f7dc390a'
  fn: endTime()(uint64)
  is: 1785481200
  says: the claim window ended at 1785481200, 2026-07-31 07:00 UTC
  for:
  - what
- id: toolate
  call: '0xf5746080656347087d8a1607284d1b52f7dc390a'
  data: '0xa64f377c00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000002540be3ff00000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000000'
  reverts_with: '0xecdd1c29'
  says: 'a claim at the block reverts TooLate(): the window is over'
  for:
  - what
  - whose
- id: balance
  call: '0x526526528f35ac738177003b8773b402b8df8143'
  fn: balanceOf(address)(uint256)
  args:
  - '0xf5746080656347087d8a1607284d1b52f7dc390a'
  is: 2501070000000000000000
  says: the contract still holds tokens of its distribution token
  for:
  - what
- id: withdraw
  source: '0xf5746080656347087d8a1607284d1b52f7dc390a'
  file: src/TokenDistributor.sol
  lines:
  - 173
  - 174
  has: function withdraw() external onlyOwner {
  says: after the window ends, the owner withdraws the whole balance
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

This distributor pays tokens to a user who brings a claim signed by its stored signer key. Its claim window ended on 2026-07-31 and it still holds tokens; the operator can open a new window and replace the signer. Claims fail if the signer's account takes real code before it is replaced.

## Evidence

- [claim and batchClaim](https://etherscan.io/address/0xf5746080656347087d8a1607284d1b52f7dc390a#code) recover the signature with ECDSA and revert unless it is the stored signer.
- The [operator](https://etherscan.io/address/0x7a39c61adbd6d4767d858da6ce2ae3253780ea2e) can replace the signer with setSigner and schedule a new claim window with setTime.

## Reviewer notes

### Mechanism

claim (lines 250-298) and batchClaim (312-340) first run _validateClaim (384-391): signer set, signature not expired, startTime set, start <= now <= endTime. They then build the EIP-712 digest and require ECDSA.recover(digest, signature) == signer (lines 286, 337); OpenZeppelin's recover calls ecrecover with all remaining gas (ECDSA.sol line 139), so no fixed gas amount. There is no ERC-1271 or code-size branch. signer is set by setSigner (190-194, onlyOperator); setTime (206-220, onlyOperator) schedules a new window up to 90 days ahead whenever no window is active. operator and owner are immutables set in the constructor. At block 26,438,999: signer 0xa6f3...7bd4 has no code and nonce 0; operator 0x7a39...ea2e has no code and nonce 110; endTime 1785481200 (2026-07-31) is past, so a claim reverts TooLate (0xecdd1c29) before the signature is checked; the contract holds 2,501.07e18 of token 0x5265...8143 (unpriced). withdraw (173-182, onlyOwner) lets owner 0xb7ae...1fec take the whole balance now that endTime has passed, without any signature.

### Checks

- Header facts: this address alone, at block 26,438,999; 12 addresses run this code.
- Ruled out: an ERC-1271 or second path for a signer with code: claim and batchClaim only compare ECDSA.recover with the stored signer (lines 286, 337).
- Ruled out: a fixed gas amount for the recovery (would be a rated issue): OpenZeppelin's recover uses the ecrecover builtin, which forwards all gas (ECDSA.sol line 139).
- Ruled out: an unused implementation: not a proxy, not a clone; this address has its own signer, a past claim window and a token balance at the block.
- Ruled out: the path closed for good: the window has ended, but the live operator (EOA, nonce 110) can open a new one with setTime, so the card states the dormancy.
- Ruled out: a direct path for users: none; the owner's withdraw moves the balance to the owner, not to claimants.
- Ruled out: the other 11 addresses running this code (for example 0xab8cba5e...783a and 0x6fed8dab...58a7) have their own state and are their own rows; this card covers this address only.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
