---
id: bridgecontract-972a7a92-bridge-bls12-381-group-key
format: 2
title: Gonka bridge trusts one BLS12-381 group key a quantum attacker could break
status: confirmed
severity: MEDIUM
justification: Breaking one on-chain BLS group key releases bridge funds; only a new bridge from Gonka consensus
  fixes it.
category: quantum-exposure
pattern: PQ-6
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x972a7a92d92796a98801a8818bcf91f1648f2f68'
  name: BridgeContract
  project: gonka
  code: verified
  code_url: https://etherscan.io/address/0x972a7a92d92796a98801a8818bcf91f1648f2f68#code
  copies: 1
  upgradeable: 'no'
  admin: '0x1d806d0e3c7df74c14a49d58de98c189614e1768'
value:
  usd: 883928
  basis: held
activity:
  txs_90d: 8848
impact: funds-loss
action: Deploy a bridge with a post-quantum signature check, migrate the locked tokens to it and stop honouring
  this one.
evidence_level: source
checks:
- id: c1
  source: '0x972a7a92d92796a98801a8818bcf91f1648f2f68'
  file: BridgeContract.sol
  line: 1257
  has: address constant BLS12_PAIRING = 0x000000000000000000000000000000000000000F;       // BLS12_PAIRING_CHECK
  says: The contract uses the EIP-2537 BLS12-381 pairing precompile.
  for:
  - justification
- id: c2
  source: '0x972a7a92d92796a98801a8818bcf91f1648f2f68'
  file: BridgeContract.sol
  line: 1258
  has: address constant BLS12_MAP_FP_TO_G1 = 0x0000000000000000000000000000000000000010;  // BLS12_MAP_FP_TO_G1
  says: The contract uses the EIP-2537 map-to-G1 precompile.
  for:
  - evidence-3
- id: c3
  source: '0x972a7a92d92796a98801a8818bcf91f1648f2f68'
  file: BridgeContract.sol
  line: 1754
  has: (bool success, bytes memory result) = BLS12_PAIRING.staticcall(pairingInput);
  says: Signature verification calls the BLS12-381 pairing precompile.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c4
  source: '0x972a7a92d92796a98801a8818bcf91f1648f2f68'
  file: BridgeContract.sol
  line: 1769
  has: (bool ok, bytes memory out) = BLS12_MAP_FP_TO_G1.staticcall(fp);
  says: The message hash is mapped to G1 via the precompile.
  for:
  - evidence-3
  - what
- id: c5
  source: '0x972a7a92d92796a98801a8818bcf91f1648f2f68'
  file: BridgeContract.sol
  line: 1031
  has: function transferOwnership(address newOwner) public virtual onlyOwner {
  says: The contract has a single Ownable owner.
  for:
  - justification
- id: pair
  source: '0x972a7a92d92796a98801a8818bcf91f1648f2f68'
  file: BridgeContract.sol
  has: e(signature, G2) * e(-H(m), pubkey) == 1
  line: 1745
  says: Signature validity is a BLS pairing equation against the group public key.
  for:
  - evidence-1
  - what
- id: g2key
  source: '0x972a7a92d92796a98801a8818bcf91f1648f2f68'
  file: BridgeContract.sol
  has: mapping(uint64 => GroupKey) public epochGroupKeys;
  line: 1242
  says: Epoch G2 group public keys are stored publicly on-chain.
  for:
  - evidence-2
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
reviews: []
related: []
---

## What happens

The bridge releases locked tokens and mints WGNK when a BLS12-381 signature checks against a stored epoch group key. A quantum attacker who recovers that key's secret can sign withdrawals and mints on their own.

## Evidence

- [_verifyBLSSignature](https://etherscan.io/address/0x972a7a92d92796a98801a8818bcf91f1648f2f68#code) accepts a message when the BLS12-381 pairing check against the group key passes.
- [epochGroupKeys](https://etherscan.io/address/0x972a7a92d92796a98801a8818bcf91f1648f2f68#code) stores each epoch's 256-byte G2 public key on-chain.
- [_mapMessageToG1](https://etherscan.io/address/0x972a7a92d92796a98801a8818bcf91f1648f2f68#code) hashes the message to G1 with the EIP-2537 precompile.

## Reviewer notes

### Mechanism

withdraw(WithdrawalCommand) and mintWithSignature(MintCommand) look up epochGroupKeys[cmd.epochId] (line 1242) and call _verifyBLSSignature (line 1730). It maps keccak256(message) to G1 via BLS12_MAP_FP_TO_G1 (0x10, line 1769), negates it, and checks e(sig, G2) * e(-H(m), groupKey) == 1 with BLS12_PAIRING (0x0f, line 1754). The group key is public on-chain, so recovering its discrete log lets an attacker forge withdrawals of any token or ETH and mint WGNK. submitGroupKey accepts epoch n+1's key when signed by epoch n's key, so a forged key also lets the attacker install their own next key. The owner (transferOwnership, line 1031) can set keys only in ADMIN_CONTROL and cannot change the scheme; the contract has no upgrade path.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No proxy or upgrade function; owner cannot replace the BLS verification.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
