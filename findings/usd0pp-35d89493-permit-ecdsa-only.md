---
id: usd0pp-35d89493-permit-ecdsa-only
format: 2
title: bUSD0 permit accepts only ECDSA, letting a forged signature take holders' tokens
status: confirmed
severity: MEDIUM
justification: A forged permit can take a holder's tokens; the fix is a contract upgrade by an 8-signature Safe.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x35d8949372d46b7a3d5a56006ae77b215fc69bc0'
  name: Usd0PP
  project: usual
  code: verified
  code_url: https://etherscan.io/address/0x9f2bd21bf8012fce0d5845537c1deff3a89bc85b#code
  proxy_of: '0x9f2bd21bf8012fce0d5845537c1deff3a89bc85b'
  copies: 1
  upgradeable: 'yes'
  admin: '0x65a7042460932a8e7b6aa9c765c2bae5f4535c22'
value:
  usd: 499265914
  whose: users
  basis: held
activity: {}
impact: funds-loss
action: Upgrade bUSD0 so permit asks owners whose accounts have code through ERC-1271 only, and never accepts ECDSA
  for them.
evidence_level: source
checks:
- id: permit-ecdsa
  source: '0x9f2bd21bf8012fce0d5845537c1deff3a89bc85b'
  file: lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/ERC20PermitUpgradeable.sol
  lines:
  - 66
  - 71
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA, reverts unless it is the owner, then approves the spender for the
    owner's tokens
  for:
  - action
  - evidence-1
  - justification
  - what
  - whose
- id: no-1271
  selector: '0x9f2bd21bf8012fce0d5845537c1deff3a89bc85b'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the implementation's code never names the ERC-1271 selector, so it never asks an account to check a signature
  for:
  - evidence-1
  - justification
  - what
- id: author
  source: '0x9f2bd21bf8012fce0d5845537c1deff3a89bc85b'
  file: src/token/Usd0PP.sol
  lines:
  - 67
  - 75
  has: /// @author  Usual Tech team
  says: the verified source is by the Usual team and Usd0PP inherits ERC20PermitUpgradeable
  for:
  - what
- id: name
  call: '0x35d8949372d46b7a3d5a56006ae77b215fc69bc0'
  fn: name()(string)
  is: Bond USD0
  says: the token's name is Bond USD0
  for:
  - what
- id: supply
  call: '0x35d8949372d46b7a3d5a56006ae77b215fc69bc0'
  fn: totalSupply()(uint256)
  is: '499692096076469797018685681'
  says: 499.69M bUSD0 are in circulation, held by holders
  for:
  - evidence-2
  - whose
- id: not-paused
  call: '0x35d8949372d46b7a3d5a56006ae77b215fc69bc0'
  fn: paused()(bool)
  is: false
  says: the token is not paused
  for:
  - evidence-2
- id: admin-slot
  storage: '0x35d8949372d46b7a3d5a56006ae77b215fc69bc0'
  slot: '0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103'
  is: '0x65a7042460932a8e7b6aa9c765c2bae5f4535c22'
  says: the proxy's admin is ProxyAdmin 0x65a70424
  for:
  - evidence-3
- id: upgrade
  source: '0x35d8949372d46b7a3d5a56006ae77b215fc69bc0'
  file: lib/openzeppelin-contracts/contracts/proxy/transparent/ProxyAdmin.sol
  lines:
  - 38
  - 43
  has: 'proxy.upgradeToAndCall{value: msg.value}(implementation, data);'
  says: the ProxyAdmin's owner can point the proxy at new code
  for:
  - action
  - evidence-3
  - justification
- id: admin-owner
  call: '0x65a7042460932a8e7b6aa9c765c2bae5f4535c22'
  fn: owner()(address)
  is: '0xaada24358620d4638a2ee8788244c6f4b197ca16'
  says: the ProxyAdmin is owned by Safe 0xaada2435
  for:
  - action
  - evidence-3
  - justification
- id: safe-threshold
  call: '0xaada24358620d4638a2ee8788244c6f4b197ca16'
  fn: getThreshold()(uint256)
  is: 8
  says: the Safe needs 8 signatures
  for:
  - evidence-3
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review12)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read or judged, the registry text read; not executed; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews: []
related: []
---

## What happens

Usual's Bond USD0 (bUSD0) token lets a holder approve a spender with a permit signed in ECDSA, never asking the account itself. A quantum attacker who recovers a holder's key can sign a permit and take that holder's bUSD0, even after the holder moves to post-quantum authorisation.

## Evidence

- [permit](https://etherscan.io/address/0x9f2bd21bf8012fce0d5845537c1deff3a89bc85b#code) recovers the signer with ECDSA and approves the spender if it is the owner; the code has no ERC-1271 call.
- The [token](https://etherscan.io/token/0x35d8949372d46b7a3d5a56006ae77b215fc69bc0) has 499.7M bUSD0 in circulation and is not paused.
- Upgrades go through a [ProxyAdmin](https://etherscan.io/address/0x65a7042460932a8e7b6aa9c765c2bae5f4535c22) owned by a Safe that needs 8 signatures.

## Reviewer notes

### Mechanism

The proxy 0x35d89493 (EIP-1967, implementation 0x9f2bd21b, Usd0PP) inherits OpenZeppelin ERC20PermitUpgradeable and does not override permit. permit (lines 49-72) builds the EIP-712 hash with the owner's nonce, calls ECDSA.recover(hash, v, r, s), reverts unless the result equals owner, then _approve(owner, spender, value). The runtime code holds no isValidSignature selector, so no account is ever asked. permit has no pause modifier; transfers are gated by whenNotPaused in ERC20Pausable._update and by the USD0 blacklist in Usd0PP._update. paused() is false at the block. A CRQC holder recovers the private key of any bUSD0 holder whose key has signed on-chain, signs a permit, and pulls the balance with transferFrom. For a plain key the attacker could already send transactions; what this contract adds is that a holder who moves the same address to post-quantum authorisation is still drained here. Fix: ProxyAdmin 0x65a70424 (admin slot) upgradeAndCall, onlyOwner; owner() is Safe 0xaada2435, threshold 8.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path: no isValidSignature selector in the implementation's runtime code, and no source file mentions isValidSignature or SignatureChecker.
- Ruled out: unused implementation: this is the proxy in use; eip712Domain() names 'Bond USD0', totalSupply is 499.69M, and scan.window shows 85 recoveries by this code in the two-week window.
- Ruled out: path closed: paused() is false, and permit is not pause-gated anyway.
- Ruled out: children: mintWithPermit and unlockUsd0ppWithUsualWithPermit call permit on the USD0 and USUAL tokens; those recoveries belong to those tokens and are not counted here.
- Ruled out: replay 0x516aec7f (signer 0x2b0682c7) not cited: the old finding records it as a batch whose first recovery is an account module, so its revert with signer code does not isolate this permit; I did not re-read its calls.
- Ruled out: direct path: approve() is a direct call that still works for post-quantum accounts, so they are not locked out; it does not close the forged-permit path.
- Ruled out: no copies and no dependents in the dossier; the rating follows the quantum-exposure table (fix is a contract upgrade: MEDIUM).

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
