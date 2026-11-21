---
id: tokendistributor-ab8cba5e-rotate-signer-before-migrating
format: 2
title: USDT claims stop if the claim signer's account takes real code before rotation
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless the signer's account moves to real code; the operator can replace it first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xab8cba5ee3d625f4c2c13148edc84e0e470d783a'
  name: TokenDistributor
  code: verified
  code_url: https://etherscan.io/address/0xab8cba5ee3d625f4c2c13148edc84e0e470d783a#code
  copies: 12
  family: ef167be567ecbb60d5b275ad49b31445
  upgradeable: 'no'
  admin: '0x336097f0f49b3b2ab279402ef103cba8ffe33cf8'
value:
  usd: 8876
  whose: mixed
  basis: held
activity: {}
impact: liveness
action: Install a new signer key with setSigner before the current signer's account moves to real code; an EIP-7702
  delegation keeps working.
evidence_level: source
checks:
- id: recover
  source: '0xab8cba5ee3d625f4c2c13148edc84e0e470d783a'
  file: src/TokenDistributor.sol
  line: 286
  has: if (ECDSA.recover(digest, signature) != _signer) revert InvalidSignature();
  says: claim reverts unless the ECDSA-recovered address is the stored signer
  for:
  - evidence-1
  - justification
  - what
- id: recover-batch
  source: '0xab8cba5ee3d625f4c2c13148edc84e0e470d783a'
  file: src/TokenDistributor.sol
  line: 337
  has: if (ECDSA.recover(digest, signature) != _signer) revert InvalidSignature();
  says: batchClaim does the same check
  for:
  - evidence-1
- id: transfer-user
  source: '0xab8cba5ee3d625f4c2c13148edc84e0e470d783a'
  file: src/TokenDistributor.sol
  line: 297
  has: _transfer(user, pendingAmount);
  says: a valid claim pays the user
  for:
  - what
  - whose
- id: withdraw
  source: '0xab8cba5ee3d625f4c2c13148edc84e0e470d783a'
  file: src/TokenDistributor.sol
  lines:
  - 173
  - 174
  has: if (block.timestamp <= endTime) revert InvalidTime();
  says: the owner can withdraw the rest only after the window ends
  for:
  - whose
- id: setsigner
  source: '0xab8cba5ee3d625f4c2c13148edc84e0e470d783a'
  file: src/TokenDistributor.sol
  lines:
  - 190
  - 192
  has: signer = _signer;
  says: the operator replaces the signer with setSigner
  for:
  - action
  - evidence-2
  - justification
  - what
- id: operator
  call: '0xab8cba5ee3d625f4c2c13148edc84e0e470d783a'
  fn: operator()(address)
  is: '0x7a39c61adbd6d4767d858da6ce2ae3253780ea2e'
  says: the operator that can call setSigner
  for:
  - action
  - evidence-2
  - justification
- id: op-nonce
  nonce: '0x7a39c61adbd6d4767d858da6ce2ae3253780ea2e'
  is: 110
  says: the operator account has sent transactions
  for:
  - notes
- id: signer
  call: '0xab8cba5ee3d625f4c2c13148edc84e0e470d783a'
  fn: signer()(address)
  is: '0xa6f30d69a1de79de755824ff9649243ac5767bd4'
  says: the signer is set
  for:
  - notes
- id: signer-code
  code: '0xa6f30d69a1de79de755824ff9649243ac5767bd4'
  is: empty
  says: the signer has no code yet
  for:
  - notes
- id: token
  call: '0xab8cba5ee3d625f4c2c13148edc84e0e470d783a'
  fn: token()(address)
  is: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  says: the distributed token is USDT
  for:
  - what
- id: balance
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0xab8cba5ee3d625f4c2c13148edc84e0e470d783a'
  is: 8884701119
  says: the distributor holds 8,884.70 USDT
  for:
  - notes
- id: start
  call: '0xab8cba5ee3d625f4c2c13148edc84e0e470d783a'
  fn: startTime()(uint64)
  is: 1789957800
  says: the window opened on 21 September 2026
  for:
  - what
- id: end
  call: '0xab8cba5ee3d625f4c2c13148edc84e0e470d783a'
  fn: endTime()(uint64)
  is: 1801396800
  says: the window closes on 31 January 2027
  for:
  - what
- id: now
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getCurrentBlockTimestamp()(uint256)
  is: 1794969479
  says: the block's time is inside the window
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

This distributor pays USDT to a user when the stored signer signs a claim, and its claim window is open until 31 January 2027. If the signer's account takes real code, every claim fails until the operator sets a new signer.

## Evidence

- [claim and batchClaim](https://etherscan.io/address/0xab8cba5ee3d625f4c2c13148edc84e0e470d783a#code) recover the signature with ECDSA and revert unless it is the stored signer.
- The [operator](https://etherscan.io/address/0x7a39c61adbd6d4767d858da6ce2ae3253780ea2e) can replace the signer at any time with setSigner.

## Reviewer notes

### Mechanism

claim (lines 250-298) and batchClaim (312-340) read the stored signer, check the window in _validateClaim (384-391), build an EIP-712 digest and revert with InvalidSignature unless ECDSA.recover equals the signer (lines 286, 337). On success they record the claim and transfer the token to user. setSigner (190-194, onlyOperator) replaces the signer; operator is immutable. At block 26,438,999 the signer 0xa6f3...7bd4 has no code and nonce 0 (a backend key, per the source comment at line 82), the operator 0x7a39...ea2e has no code and nonce 110, the token is USDT, the balance is 8,884.701119 USDT, and the timestamp 1794969479 is between startTime 1789957800 and endTime 1801396800. The owner can withdraw the rest only after endTime (line 174).

### Checks

- Header facts: this address alone, at block 26,438,999; 12 addresses run this code.
- Ruled out: an ERC-1271 or code-size path for a signer with code: claim and batchClaim only compare ECDSA.recover with the signer (lines 286, 337).
- Ruled out: an unset key or a closed window: signer is set and the block timestamp is inside the window (calls signer, startTime, endTime, Multicall3 timestamp).
- Ruled out: a direct path: users cannot claim without the signature; the owner's withdraw only works after endTime and pays the owner, not users.
- Ruled out: a fixed gas amount: OpenZeppelin ECDSA uses the ecrecover builtin, which forwards all gas, so nothing fails with nobody migrating.
- Ruled out: copies: 11 other addresses run this code with their own signer and window; they are not described here.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
