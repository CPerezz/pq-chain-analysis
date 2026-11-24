---
id: contract-3b4d794a-blob-kzg-opening
format: 2
title: A quantum attacker can commit rollup batches whose blob lacks users' data
status: candidate
severity: MEDIUM
justification: Through this blob check exits can be frozen, not funds taken; the batch proof verifier is its own
  card. Upgrade only.
category: quantum-exposure
pattern: PQ-8
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7'
  code: decompiled
  code_url: code/0x0d2c3b541701ddc3767a6f99801627373e76086d169ac03d161e53a9f0ce1c3a.sol
  proxy_of: '0x9b4a5f3cf3bc80494fb02dd2eb5f20f86b27ec4f'
  copies: 1
  upgradeable: 'yes'
  admin: '0x94da8a995d0d82ef0fe7e509c6d76c22603b6f67'
value:
  usd: 488023977
  whose: users
  basis: held
activity: {}
impact: funds-locked
action: Have the 3-of-5 Safe move commitBatch off the blob path, to calldata or a post-quantum commitment.
evidence_level: bytecode
checks:
- id: tx-commit
  tx: '0x1d740559e636cab7a8031986d80326284ae4e8b43f432cef7871601446310893'
  to: '0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7'
  ok: true
  says: a batch commit to the proxy succeeded at block 26,438,995
  for:
  - evidence-1
  - what
- id: sel-commit
  selector: '0x9b4a5f3cf3bc80494fb02dd2eb5f20f86b27ec4f'
  fn: commitBatch((uint64,uint32,uint64,uint64,uint32,bytes32,bytes32,bytes32,bytes32,bytes),(uint64,uint64,uint32,uint64,uint64,uint32,bytes32,bytes32,bytes32,bytes32,bytes32))
  says: the implementation has commitBatch (0xe415f0f4)
  for:
  - evidence-1
  - what
- id: blobhash
  bytecode: '0x9b4a5f3cf3bc80494fb02dd2eb5f20f86b27ec4f'
  has: 88499384156152b257
  says: BLOBHASH of the indexed blob, revert if it is zero
  for:
  - evidence-2
  - what
- id: pointeval
  bytecode: '0x9b4a5f3cf3bc80494fb02dd2eb5f20f86b27ec4f'
  has: 600a5afa61554d614656565b901561559b57
  says: STATICCALL to the point-evaluation precompile 0x0a with all gas, revert if it fails
  for:
  - evidence-2
  - justification
  - what
- id: target
  call: '0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7'
  fn: getTarget()(address)
  is: '0x9b4a5f3cf3bc80494fb02dd2eb5f20f86b27ec4f'
  says: the proxy runs this implementation
  for:
  - evidence-2
- id: validator
  call: '0xa464da0b43f80ee3ffc4795cbbfc78472b5c81a1'
  data: '0x40550a1c000000000000000000000000191ff0ec830f83916a427d169a234c33e48aa79f'
  is: 0x
  says: Governance accepts the committer as an active validator
  for:
  - evidence-1
  - what
- id: nonvalidator
  call: '0xa464da0b43f80ee3ffc4795cbbfc78472b5c81a1'
  data: '0x40550a1c0000000000000000000000000000000000000000000000000000000000000001'
  reverts_with: '0xe4e4145d'
  says: isActiveValidator reverts for an address that is not a validator
  for:
  - evidence-1
- id: val-code
  code: '0x191ff0ec830f83916a427d169a234c33e48aa79f'
  is: empty
  says: the validator is an account with no code (an ECDSA key)
  for:
  - evidence-1
  - what
- id: val-nonce
  nonce: '0x191ff0ec830f83916a427d169a234c33e48aa79f'
  min: 167692
  says: the validator key has signed many transactions, so its public key is known
  for:
  - what
- id: sel-desert
  selector: '0x9b4a5f3cf3bc80494fb02dd2eb5f20f86b27ec4f'
  fn: performDesert(uint48,address,uint16,uint128,bytes)
  says: the implementation has the desert-mode exit
  for:
  - what
- id: desert
  call: '0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7'
  fn: desertMode()(bool)
  is: false
  says: desert mode is not active
  for:
  - what
- id: batches
  call: '0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7'
  fn: committedBatchesCount()(uint256)
  is: 270644
  says: '270,644 batches committed: the proxy is in use'
  for:
  - notes
- id: upgrade-src
  source: '0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7'
  file: contracts/proxy/Proxy.sol
  lines:
  - 56
  - 61
  has: requireMaster(msg.sender); setTarget(newTarget);
  says: the master can replace the implementation
  for:
  - action
  - justification
- id: master
  call: '0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7'
  fn: getMaster()(address)
  is: '0x94da8a995d0d82ef0fe7e509c6d76c22603b6f67'
  says: the proxy's master is the upgrade gatekeeper
  for:
  - action
  - evidence-3
  - justification
- id: gk-master
  call: '0x94da8a995d0d82ef0fe7e509c6d76c22603b6f67'
  fn: getMaster()(address)
  is: '0x97a90ec950b6bcd9b190b566525b2bb92a2c03a2'
  says: the gatekeeper's master is a Safe
  for:
  - action
  - evidence-3
  - justification
- id: threshold
  call: '0x97a90ec950b6bcd9b190b566525b2bb92a2c03a2'
  fn: getThreshold()(uint256)
  is: 3
  says: the Safe needs 3 signatures
  for:
  - action
  - evidence-3
  - justification
- id: owners
  call: '0x97a90ec950b6bcd9b190b566525b2bb92a2c03a2'
  fn: getOwners()(address[])
  is:
  - '0x2994d343b6b17ec23e9e4a08082184fd43f763a3'
  - '0x67d6c2569ab98a1f535e36b3bab1fbd825fa536e'
  - '0xa0b3781b830df57b1f018c434c58551c2fc6b3af'
  - '0x6fee6cdd595d12ec6cd1803474b3615f1d2fb9ed'
  - '0xf65f409d8f3fa3635287783256394d7eb7ad7835'
  says: the Safe has 5 owners
  for:
  - evidence-3
- id: notice
  call: '0x94da8a995d0d82ef0fe7e509c6d76c22603b6f67'
  fn: approvedUpgradeNoticePeriod()(uint256)
  is: 1814400
  says: upgrades wait 3 weeks unless cut
  for:
  - notes
- id: council
  call: '0x94da8a995d0d82ef0fe7e509c6d76c22603b6f67'
  fn: securityCouncilAddress()(address)
  is: '0x92b12c9d85bf7bd2ef5d2f53f4cd4ce0be432045'
  says: the security council that can cut the notice
  for:
  - notes
- id: bal
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7'
  is: '11247831009790000000000'
  says: the proxy holds 11,247.83 ETH
  for:
  - evidence-3
- id: tx-deposit
  tx: '0x14a979ea5f192bb4a36781175a2e842ee6576abac334a48b6af6459c7efcadc2'
  to: '0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7'
  ok: true
  says: an outside account pays ETH in (selector 0x8a857083, 0.906 ETH) at block 26,438,998
  for:
  - whose
- id: depositor-not-validator
  call: '0xa464da0b43f80ee3ffc4795cbbfc78472b5c81a1'
  data: '0x40550a1c000000000000000000000000e11e390307538e28c35470aaa87e743a0354c90c'
  reverts_with: '0xe4e4145d'
  says: that depositor is not a validator
  for:
  - whose
- id: sel-verify
  selector: '0x9b4a5f3cf3bc80494fb02dd2eb5f20f86b27ec4f'
  fn: verifyBatch((uint64,uint64,uint32,uint64,uint64,uint32,bytes32,bytes32,bytes32,bytes32,bytes32),bytes)
  says: the implementation has verifyBatch (0x23ff50e1)
  for:
  - what
- id: sel-execute
  selector: '0x9b4a5f3cf3bc80494fb02dd2eb5f20f86b27ec4f'
  fn: executeBatches((uint64,uint64,uint32,uint64,uint64,uint32,bytes32,bytes32,bytes32,bytes32,bytes32)[],bytes[])
  says: the implementation has executeBatches (0x2d320e28)
  for:
  - what
- id: gk-cut
  selector: '0x94da8a995d0d82ef0fe7e509c6d76c22603b6f67'
  fn: cutUpgradeNoticePeriod(uint256)
  says: the gatekeeper has cutUpgradeNoticePeriod (0x389b8b3a), the council's way to shorten the notice
  for:
  - notes
- id: verified-count
  call: '0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7'
  fn: verifiedBatchesCount()(uint64)
  is: 270634
  says: '270,634 batches verified: fewer than the 270,644 committed'
  for:
  - notes
- id: root
  call: '0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7'
  fn: stateRoot()(uint256)
  is: '71546390387619651915710706734400605806859775950091968608392468740822526601921'
  says: the rollup's current state root
  for:
  - notes
- id: root-verified
  call: '0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7'
  fn: lastVerifiedStateRoot()(uint256)
  is: '71546390387619651915710706734400605806859775950091968608392468740822526601921'
  says: 'equals stateRoot: no committed-but-unproven state is live at the block'
  for:
  - notes
- id: slot4
  storage: '0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7'
  slot: 4
  is: '0x000000000000000000000000ac3ce44b6ff4e402858c99d5699ff63131572baa'
  says: storage slot 4 holds the batch-proof verifier's address
  for:
  - notes
- id: ver-target
  call: '0xac3ce44b6ff4e402858c99d5699ff63131572baa'
  fn: getTarget()(address)
  is: '0x329d7d7f7b3f2879991b83e1a53bce6d7ce63e6f'
  says: the verifier proxy runs this implementation
  for:
  - notes
- id: ver-sel
  selector: '0x329d7d7f7b3f2879991b83e1a53bce6d7ce63e6f'
  fn: Verify(bytes,uint256[])
  says: the verifier implementation has Verify (0x7e4f7a8a)
  for:
  - notes
- id: ver-pairing
  bytecode: '0x329d7d7f7b3f2879991b83e1a53bce6d7ce63e6f'
  has: 60085afa
  says: a STATICCALL to the pairing precompile 0x08, the BN254 check a quantum computer could forge
  for:
  - notes
- id: slot7
  storage: '0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7'
  slot: 7
  is: '0x0000000000000000001e60fca40ecafe53abae5c62014f60819d6f907e58dfe6'
  says: storage slot 7 holds a second facet address
  for:
  - notes
- id: addl-verify
  bytecode: '0xa40ecafe53abae5c62014f60819d6f907e58dfe6'
  has: 7e4f7a8a
  says: 'that facet builds a call with the verifier''s Verify selector: this is where verifyBatch calls into the
    PLONK check'
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
  who: Review11 (Claude), finding review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews:
- who: r-3b4d794a, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM candidate (PQ-8): zkLighter''s commitBatch accepts only blob mode
    and binds each blob through a KZG point-evaluation opening; with the setup trapdoor and a validator key a batch
    can be committed and honestly proven while its blob lacks the data, stranding desert-mode exits (funds-locked;
    the batch verifier is its own card). No alternative path, so MEDIUM: the 3-of-5 Safe''s upgrade through the
    gatekeeper is the fix. Claude corrected its own earlier wrong feedback; the fifth version has two agreeing refuters
    (R-3b4d794a-6, -7). Claude read the sheet.'
related: []
---

## What happens

This rollup commits each batch with a blob and checks a KZG opening of that blob. With the KZG setup's secret and a validator key, an attacker can commit, prove and execute a batch whose blob lacks its data; if the operator then stops, users cannot rebuild their balances for desert-mode exits.

## Evidence

- [A batch commit](https://etherscan.io/tx/0x1d740559e636cab7a8031986d80326284ae4e8b43f432cef7871601446310893) is sent by an active validator, an account with no code.
- The [contract's code](https://etherscan.io/address/0x9b4a5f3cf3bc80494fb02dd2eb5f20f86b27ec4f#code) reads the blob's hash and calls the point-evaluation precompile, and reverts when the opening fails.
- The [contract](https://etherscan.io/address/0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7) holds 11,247 ETH plus tokens; upgrades go through a gatekeeper run by a 3-of-5 Safe.

## Reviewer notes

### Mechanism

Proxy 0x3b4d794a (verified zkSync-style Proxy) delegates to unverified 0x9b4a5f3c. commitBatch (0xe415f0f4) first calls Governance 0xa464da0b isActiveValidator(msg.sender) (0x40550a1c, empty for a validator, reverts 0xe4e4145d otherwise). Its trailing bytes field holds 160-byte chunks, one per blob; for each the code requires BLOBHASH(i) != 0, builds versioned hash || chunk and STATICCALLs the point-evaluation precompile 0x0a with all gas, reverting on failure. The real commit at block 26,438,995 is a type-3 tx with one blob. A KZG trapdoor lets the committer open the blob to the expected value at the challenge point while publishing other data. The withholding validator still knows the real data, so it proves the transition honestly via verifyBatch and executes it with executeBatches; no forged proof is needed. Nothing is minted, but the published blob no longer lets users rebuild state for performDesert exits. Upgrades: Proxy.upgradeTarget requires master UpgradeGatekeeper 0x94da8a99, whose master is Safe 0x97a90ec9 (3 of 5), with a 1,814,400 s notice a council (0x92b12c9d) can cut.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: unused implementation: the proxy is in use; committedBatchesCount is 270,644 and a batch was committed at block 26,438,995.
- Ruled out: the code being elsewhere: the point-evaluation call is in the implementation; slot 7's facet has no 600a5afa sequence.
- Ruled out: an EIP-8151 gas/ecrecover issue: the 0x0a call forwards all gas; this card is about the KZG setup only.
- Ruled out: desert mode already active: desertMode() is false at the block.
- Ruled out: a forged opening alone moving funds: stateRoot equals lastVerifiedStateRoot (270,644 committed, 270,634 verified); state only changes via verifyBatch's own PLONK check, which the withholding validator need not break.
- Ruled out: the batch-proof verifier (slot 4, 0xac3ce44b, BN254 pairing): a separate exposure, its own card (first/lighter-plonk-verifier, MEDIUM, funds-loss).
- Ruled out: value: tool reads $488.0M held at the block; the old card's $907.8M priced LIT differently. Not folded in: validators' own ECDSA keys.
- Ruled out: commitBatch's chunk loop allows zero chunks (calldata-only path): even so any validator could still choose blobs, so severity stays MEDIUM.

### Questions

- Is the value opened at the challenge point the data commitment verifyBatch's proof takes, decoupling the published blob from the proven state (inferred from bytecode)?
- The contract also keeps a validiumRoot: is part of state never published in blobs, changing what users can rebuild for desert exits?
- Can commitBatch be called with zero blob chunks (data only in calldata), and can the admin force that path?

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
