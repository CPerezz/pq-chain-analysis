---
id: tokendistributor-ec7dc36c-rotate-signer-before-migrating
format: 2
title: Token distributor claims stop if its signer's account takes real code
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless the signer's account takes real code; the operator can replace it first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xec7dc36c1b1643f4881c968954c14a1683f58d25'
  name: TokenDistributor
  code: verified
  code_url: https://etherscan.io/address/0xec7dc36c1b1643f4881c968954c14a1683f58d25#code
  copies: 12
  family: ef167be567ecbb60d5b275ad49b31445
  upgradeable: 'no'
  admin: '0x41ca99b7a5f95f49c2b0861a8623c9f46293e09c'
value:
  usd: 0
  whose: operator
  basis: held
activity: {}
impact: liveness
action: Set a new signer with setSigner before the backend's signer account moves to real code.
evidence_level: source
checks:
- id: recover1
  source: '0xec7dc36c1b1643f4881c968954c14a1683f58d25'
  file: src/TokenDistributor.sol
  line: 286
  has: if (ECDSA.recover(digest, signature) != _signer) revert InvalidSignature();
  says: claim recovers the signature with ECDSA and requires the stored signer
  for:
  - evidence-1
  - justification
  - what
- id: recover2
  source: '0xec7dc36c1b1643f4881c968954c14a1683f58d25'
  file: src/TokenDistributor.sol
  line: 337
  has: if (ECDSA.recover(digest, signature) != _signer) revert InvalidSignature();
  says: batchClaim recovers the signature with ECDSA and requires the stored signer
  for:
  - evidence-1
  - what
- id: window
  source: '0xec7dc36c1b1643f4881c968954c14a1683f58d25'
  file: src/TokenDistributor.sol
  lines:
  - 385
  - 390
  has: if (block.timestamp < _startTime) revert TooEarly(); if (block.timestamp > endTime) revert TooLate();
  says: claims are accepted only between startTime and endTime
  for:
  - what
- id: setsigner
  source: '0xec7dc36c1b1643f4881c968954c14a1683f58d25'
  file: src/TokenDistributor.sol
  lines:
  - 190
  - 194
  has: function setSigner(address _signer) external onlyOperator { if (_signer == ZERO_ADDRESS) revert ZeroAddress();
    signer = _signer;
  says: the operator replaces the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: backend
  source: '0xec7dc36c1b1643f4881c968954c14a1683f58d25'
  file: src/TokenDistributor.sol
  line: 82
  has: Backend uses this address's private key to sign user claim data for verification
  says: the team's backend holds the signer key
  for:
  - action
- id: signer
  call: '0xec7dc36c1b1643f4881c968954c14a1683f58d25'
  fn: signer()(address)
  is: '0xA6f30d69a1dE79De755824FF9649243Ac5767bd4'
  says: the stored signer at the block
  for:
  - evidence-1
- id: signercode
  code: '0xa6f30d69a1de79de755824ff9649243ac5767bd4'
  is: empty
  says: the signer's account has no code yet
  for:
  - evidence-1
- id: operator
  call: '0xec7dc36c1b1643f4881c968954c14a1683f58d25'
  fn: operator()(address)
  is: '0x7a39C61adbd6d4767D858DA6ce2AE3253780EA2E'
  says: the operator that can replace the signer and set the window
  for:
  - evidence-2
  - justification
- id: opcode
  code: '0x7a39c61adbd6d4767d858da6ce2ae3253780ea2e'
  is: empty
  says: the operator is an account without code
  for:
  - evidence-2
- id: opnonce-then
  nonce: '0x7a39c61adbd6d4767d858da6ce2ae3253780ea2e'
  at: 26000000
  is: 92
  says: the operator had sent 92 transactions by block 26,000,000
  for:
  - evidence-2
- id: opnonce-now
  nonce: '0x7a39c61adbd6d4767d858da6ce2ae3253780ea2e'
  is: 110
  says: and 110 by the block, so it sent transactions in 2026
  for:
  - evidence-2
- id: setsigner-ok
  call: '0xec7dc36c1b1643f4881c968954c14a1683f58d25'
  fn: setSigner(address)()
  args:
  - '0x0000000000000000000000000000000000000001'
  from: '0x7a39C61adbd6d4767D858DA6ce2AE3253780EA2E'
  is: ''
  says: a setSigner call from the operator succeeds at the block
  for:
  - action
  - evidence-2
  - justification
  - what
- id: endtime
  call: '0xec7dc36c1b1643f4881c968954c14a1683f58d25'
  fn: endTime()(uint64)
  is: 1785427200
  says: the claim window ended at 2026-07-30 16:00 UTC
  for:
  - evidence-3
  - what
- id: now
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getCurrentBlockTimestamp()(uint256)
  is: 1794969479
  says: the block time is after endTime
  for:
  - evidence-3
  - what
- id: toolate
  call: '0xec7dc36c1b1643f4881c968954c14a1683f58d25'
  fn: claim(address,bytes32,uint256,uint256,bytes)()
  args:
  - '0x0000000000000000000000000000000000000001'
  - '0x0000000000000000000000000000000000000000000000000000000000000001'
  - 1
  - 1099511627776
  - 0x
  reverts_with: '0xecdd1c29'
  says: a claim at the block reverts with TooLate() before the signature is checked
  for:
  - evidence-3
  - what
- id: reopen
  call: '0xec7dc36c1b1643f4881c968954c14a1683f58d25'
  fn: setTime(uint256,uint256)()
  args:
  - 1795055879
  - 86400
  from: '0x7a39C61adbd6d4767D858DA6ce2AE3253780EA2E'
  is: ''
  says: the operator can schedule a new claim window at the block
  for:
  - what
- id: withdrawsrc
  source: '0xec7dc36c1b1643f4881c968954c14a1683f58d25'
  file: src/TokenDistributor.sol
  lines:
  - 173
  - 181
  has: function withdraw() external onlyOwner { if (block.timestamp <= endTime) revert InvalidTime();
  says: the owner takes the whole balance once the window has ended
  for:
  - whose
- id: withdraw-ok
  call: '0xec7dc36c1b1643f4881c968954c14a1683f58d25'
  fn: withdraw()()
  from: '0x41ca99b7a5f95f49c2b0861a8623c9f46293e09c'
  is: ''
  says: a withdraw by the owner succeeds at the block
  for:
  - whose
- id: balance
  call: '0x9ad37205d608b8b219e6a2573f922094cec5c200'
  fn: balanceOf(address)(uint256)
  args:
  - '0xec7dc36c1b1643f4881c968954c14a1683f58d25'
  is: 6000000000000000000
  says: the contract holds 6 iZi
  for:
  - evidence-3
- id: no1271
  selector: '0xec7dc36c1b1643f4881c968954c14a1683f58d25'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the code has no ERC-1271 call
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: r-ec7dc36c, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: INFORMATIONAL notice (PQ-17): a TokenDistributor copy whose claims trust one ECDSA signer the live
    operator can rotate with setSigner; its window ended (TooLate) but the operator can reopen it; holds 6 iZi,
    withdrawable by the owner (a different key from the operator: refuter''s wording note). Refuter agrees; Claude
    read the sheet.'
related: []
---

## What happens

This distributor pays tokens to users holding a claim signed by one stored signer key, during a claim window. The window closed in July 2026; the operator can open a new one. If the signer's account takes real code, claims fail until the operator sets a new signer.

## Evidence

- [claim and batchClaim](https://etherscan.io/address/0xec7dc36c1b1643f4881c968954c14a1683f58d25#code) recover the signature with ECDSA and require it to equal the stored signer.
- [setSigner](https://etherscan.io/address/0xec7dc36c1b1643f4881c968954c14a1683f58d25#code) lets the operator, an account without code that sent transactions in 2026, replace the signer.
- The [claim window](https://etherscan.io/address/0xec7dc36c1b1643f4881c968954c14a1683f58d25#code) ended on 2026-07-30; a claim at the block reverts as too late. It holds 6 iZi.

## Reviewer notes

### Mechanism

claim (lines 250-298) and batchClaim (lines 312-340) first run _validateClaim (lines 384-391): the signer must be set and the block time inside [startTime, endTime]. They then build an EIP-712 digest and require ECDSA.recover(digest, signature) == signer (lines 286, 337), then pay `user` from the contract's token balance. The signer is a storage variable that setSigner (lines 190-194, onlyOperator) replaces; operator and owner are immutables. The comment at line 82 says the backend holds the signer key. At block 26,438,999 the signer is 0xa6f30d69…7bd4 (no code, nonce 0), endTime 1785427200 is before the block time 1794969479, so claims revert TooLate. setTime (lines 206-220) is open to the operator again because the block time is past endTime; a simulated setTime and setSigner from the operator succeed. The owner can withdraw the balance now (lines 173-182; simulated withdraw from the owner succeeds).

### Checks

- Header facts: this address alone, at block 26,438,999; 12 addresses run this code.
- Ruled out: an ERC-1271 path for a signer with code: claim and batchClaim use ECDSA.recover only (lines 286, 337) and the runtime code has no isValidSignature selector.
- Ruled out: an unused address: the signer, start and end time are set here, so this copy was configured and ran a window; it is dormant, and the operator can reopen it (simulated setTime succeeds).
- Ruled out: a fixed gas amount to the precompile: OpenZeppelin ECDSA.recover calls ecrecover with all remaining gas, so nothing fails under the change with nobody migrating.
- Ruled out: a direct path without a signature: none for users; the owner's withdraw takes the whole balance after endTime, which is not a claim.
- Ruled out: the other 11 addresses with this code (dossier copies, e.g. 0xab8cba5e…783a with 10 recoveries in the study window) have their own state and are their own rows; this card covers this address only.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
