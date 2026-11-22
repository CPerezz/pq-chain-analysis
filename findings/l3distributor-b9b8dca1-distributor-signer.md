---
id: l3distributor-b9b8dca1-distributor-signer
format: 2
title: Layer3 L3Distributor accepts ECDSA claim approvals a quantum attacker can forge
status: confirmed
severity: LOW
justification: Forged signer approval only lets tree members claim their own allocation; nothing redirects, so LOW
  and no fix needed.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb9b8dca169122421ba123d23bf52175d2be755c0'
  name: L3Distributor
  project: layer3
  code: verified
  code_url: https://etherscan.io/address/0xb9b8dca169122421ba123d23bf52175d2be755c0#code
  copies: 1
  upgradeable: 'no'
  admin: '0x49a941d7d7d40f340fabb17d25a9e2a76b72fac6'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
evidence_level: source
checks:
- id: c1
  source: '0xb9b8dca169122421ba123d23bf52175d2be755c0'
  file: src/contracts/L3Distributor.sol
  line: 123
  has: address _recoveredSigner = _ethSignedMessageHash.recover(signature);
  says: _claim recovers the signer with ECDSA.
  for:
  - evidence-1
  - justification
  - what
- id: sigcheck
  source: '0xb9b8dca169122421ba123d23bf52175d2be755c0'
  file: src/contracts/L3Distributor.sol
  has: if (_recoveredSigner != s_signer) revert L3Distributor__InvalidSigner();
  line: 124
  says: Recovered signer must equal s_signer.
  for:
  - evidence-1
  - what
- id: leaf
  source: '0xb9b8dca169122421ba123d23bf52175d2be755c0'
  file: src/contracts/L3Distributor.sol
  has: keccak256(bytes.concat(keccak256(abi.encode(msg.sender, amount))))
  line: 121
  says: Hash commits to msg.sender and amount.
  for:
  - evidence-1
  - justification
  - what
- id: merkle
  source: '0xb9b8dca169122421ba123d23bf52175d2be755c0'
  file: src/contracts/L3Distributor.sol
  has: if (!MerkleProof.verify(merkleProof, i_merkleRoot, _messageHash)) revert L3Distributor__InvalidProof();
  line: 127
  says: Merkle proof of same leaf is required.
  for:
  - evidence-2
  - justification
  - what
- id: root
  source: '0xb9b8dca169122421ba123d23bf52175d2be755c0'
  file: src/contracts/L3Distributor.sol
  has: bytes32 public immutable i_merkleRoot;
  line: 34
  says: Merkle root is immutable.
  for:
  - evidence-2
  - what
- id: claimed
  source: '0xb9b8dca169122421ba123d23bf52175d2be755c0'
  file: src/contracts/L3Distributor.sol
  has: s_hasClaimed[msg.sender] = true;
  line: 130
  says: Each address claims once.
  for:
  - what
- id: stake
  source: '0xb9b8dca169122421ba123d23bf52175d2be755c0'
  file: src/contracts/L3Distributor.sol
  has: IStaking(i_staking).stake(amount, _TWELVE_MONTHS, msg.sender);
  line: 71
  says: Stake goes to msg.sender.
  for:
  - evidence-3
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review18 (full Sourcify source, signer/owner/balance reads, Blockscout history)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

The distributor pays out L3 airdrop claims that need both an ECDSA signature from one signer key and a merkle proof against a fixed root. A quantum attacker who recovers the signer key can approve claims, but each claim stays bound to the caller's own address and amount in the tree.

## Evidence

- [_claim](https://etherscan.io/address/0xb9b8dca169122421ba123d23bf52175d2be755c0#code) reverts unless ECDSA recovers s_signer from a hash of msg.sender and amount.
- [_claim](https://etherscan.io/address/0xb9b8dca169122421ba123d23bf52175d2be755c0#code) also requires a merkle proof of the same leaf against the immutable i_merkleRoot.
- [claimAndStake](https://etherscan.io/address/0xb9b8dca169122421ba123d23bf52175d2be755c0#code) stakes the claimed amount for msg.sender, not an address the signer picks.

## Reviewer notes

### Mechanism

claim / claimAndStake(amount, merkleProof, signature) call _claim (L116). Line 121 builds _messageHash = keccak256(keccak256(abi.encode(msg.sender, amount))); line 123 recovers the signer via OpenZeppelin ECDSA (ecrecover, ECDSA.sol L148) and line 124 requires it to equal s_signer. Line 127 verifies the same hash as a leaf against immutable i_merkleRoot (L34), then line 130 marks msg.sender claimed. claimAndStake (L71) stakes amount for msg.sender. updateSigner (L94) is onlyOwner. A forged signer signature therefore only lets a tree member claim its own allocation; the merkle check is hash-based. Kev records the contract as empty and inactive.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Redirecting allocations to another address: leaf binds msg.sender.
- Ruled out: Upgrading the logic: not a proxy, root immutable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
