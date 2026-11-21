---
id: ecdsadkgvalidator-97bb9bee-signature-rechecked
format: 2
title: Honest DKG submitters can be slashed when a signer's account takes real code
status: confirmed
severity: LOW
justification: A signer moving to real code gets an honest submitter slashed; a timelocked 6-of-N Safe can upgrade
  the wallet registry.
category: voided-by-migration
pattern: PQ-15
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x97bb9beebad6873b70e694c6a97a8a933ba85724'
  name: EcdsaDkgValidator
  code: verified
  code_url: https://etherscan.io/address/0x97bb9beebad6873b70e694c6a97a8a933ba85724#code
  copies: 3
  family: c7877dc4855722a5f03bf4c0c064af61
  upgradeable: 'no'
value:
  usd: 0
  whose: operator
  basis: held
activity: {}
impact: funds-loss
action: Upgrade the registry to check signatures at submission, or stop treating a signer's real code as a malicious
  result.
evidence_level: source
checks:
- id: ecdsa
  source: '0x97bb9beebad6873b70e694c6a97a8a933ba85724'
  file: contracts/EcdsaDkgValidator.sol
  line: 250
  has: address recoveredAddress = hash.recover(current);
  says: each DKG result signature is recovered with ECDSA
  for:
  - evidence-1
  - what
- id: compare
  source: '0x97bb9beebad6873b70e694c6a97a8a933ba85724'
  file: contracts/EcdsaDkgValidator.sol
  lines:
  - 252
  - 253
  has: if (signingMemberAddresses[i] != recoveredAddress) { return false;
  says: the result is rejected when a recovered address is not the signing operator's address
  for:
  - evidence-1
  - justification
  - what
- id: oz-revert
  source: '0x97bb9beebad6873b70e694c6a97a8a933ba85724'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  lines:
  - 157
  - 159
  has: address signer = ecrecover(hash, v, r, s); if (signer == address(0)) { return (address(0), RecoverError.InvalidSignature);
  says: an empty recovery is turned into an invalid-signature error, which recover reverts on
  for:
  - notes
- id: registry-validator
  storage: '0x827118841f6da1a440301bcac5912f56d689976d'
  slot: 152
  is: '0x97bb9beebad6873b70e694c6a97a8a933ba85724'
  says: the wallet registry stores this address as its DKG validator
  for:
  - what
- id: registry-pool
  call: '0x97bb9beebad6873b70e694c6a97a8a933ba85724'
  fn: sortitionPool()(address)
  is: '0xde8f101e10c2919452bcd8bfac9a372f64f4ce6d'
  says: this validator reads operators from sortition pool 0xde8f101e
  for:
  - notes
- id: pool-owner
  call: '0xde8f101e10c2919452bcd8bfac9a372f64f4ce6d'
  fn: owner()(address)
  is: '0x827118841f6da1a440301bcac5912f56d689976d'
  says: the sortition pool belongs to the wallet registry 0x82711884
  for:
  - notes
- id: pool-operators
  call: '0xde8f101e10c2919452bcd8bfac9a372f64f4ce6d'
  fn: operatorsInPool()(uint256)
  is: 3
  says: three operators are in the pool
  for:
  - notes
- id: op1-code
  code: '0x283534b33aa7198ad3427d7a347f4e189d658694'
  is: empty
  says: operator 1 has no code
  for:
  - notes
- id: op2-code
  code: '0x480ad386c7fe48c40f87dd09ab95d34358ac99ab'
  is: empty
  says: operator 2 has no code
  for:
  - notes
- id: op3-code
  code: '0x553297ea7588018ab6843ee16e66c3f3c3e5e919'
  is: empty
  says: operator 3 has no code
  for:
  - notes
- id: dkg-used
  storage: '0x827118841f6da1a440301bcac5912f56d689976d'
  slot: 158
  is: 24698334
  says: the registry locked its pool for a DKG at block 24,698,334
  for:
  - notes
- id: state-idle
  call: '0x827118841f6da1a440301bcac5912f56d689976d'
  fn: getWalletCreationState()(uint8)
  is: 0
  says: no wallet creation (DKG) is in progress at the block
  for:
  - what
- id: challenge-period
  storage: '0x827118841f6da1a440301bcac5912f56d689976d'
  slot: 154
  is: 115
  says: a submitted result can be challenged for 115 blocks
  for:
  - notes
- id: challenge
  source: '0xd156db4063f0d2be4a945fd8cd575ee3d3e1043a'
  file: contracts/libraries/EcdsaDkg.sol
  lines:
  - 411
  - 421
  has: self.dkgValidator.validate(result, self.seed, self.startBlock) returns ( // slither-disable-next-line uninitialized-local,variable-scope
    bool isValid, // slither-disable-next-line uninitialized-local,variable-scope string memory errorMsg ) { if
    (isValid) { revert("unjustified challenge");
  says: a challenge calls the validator and succeeds unless it says the result is valid
  for:
  - action
  - evidence-2
  - justification
  - what
- id: catch
  source: '0xd156db4063f0d2be4a945fd8cd575ee3d3e1043a'
  file: contracts/libraries/EcdsaDkg.sol
  lines:
  - 428
  - 439
  has: '} catch { // if the validation reverted we consider the DKG result as invalid'
  says: a reverting validation also counts as an invalid result, and the submitter is marked malicious
  for:
  - action
  - evidence-2
- id: slash
  source: '0xd156db4063f0d2be4a945fd8cd575ee3d3e1043a'
  file: contracts/WalletRegistry.sol
  lines:
  - 811
  - 825
  has: staking.seize( _maliciousDkgResultSlashingAmount, _maliciousDkgResultNotificationRewardMultiplier, msg.sender,
    operatorWrapper )
  says: after a successful challenge the registry seizes the submitter's staking provider's stake and rewards the
    challenger
  for:
  - evidence-2
  - justification
  - what
  - whose
- id: slash-amount
  call: '0x827118841f6da1a440301bcac5912f56d689976d'
  fn: slashingParameters()(uint96)
  is: '400000000000000000000'
  says: the slashing amount for a malicious DKG result is 400e18 at the block
  for:
  - evidence-2
  - what
- id: validator-set-once
  source: '0xd156db4063f0d2be4a945fd8cd575ee3d3e1043a'
  file: contracts/libraries/EcdsaDkg.sol
  lines:
  - 183
  - 186
  has: address(self.dkgValidator) == address(0), "DKG Validator address already set"
  says: the registry sets its DKG validator only once, so only an upgrade can replace it
  for:
  - action
- id: registry-impl
  storage: '0x827118841f6da1a440301bcac5912f56d689976d'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0xd156db4063f0d2be4a945fd8cd575ee3d3e1043a'
  says: the registry is an EIP-1967 proxy of implementation 0xd156db40
  for:
  - notes
- id: proxy-admin
  call: '0x7affa05f726d293eb1193807a91617318292008e'
  fn: getProxyAdmin(address)(address)
  args:
  - '0x827118841f6da1a440301bcac5912f56d689976d'
  is: '0x7affa05f726d293eb1193807a91617318292008e'
  says: ProxyAdmin 0x7affa05f administers the registry proxy
  for:
  - action
  - justification
- id: pa-owner
  call: '0x7affa05f726d293eb1193807a91617318292008e'
  fn: owner()(address)
  is: '0x92f2d8b72a7f6a551be60b9aa4194248e9b4913d'
  says: the ProxyAdmin is owned by 0x92f2d8b7
  for:
  - action
  - justification
- id: timelock
  call: '0x92f2d8b72a7f6a551be60b9aa4194248e9b4913d'
  fn: getMinDelay()(uint256)
  is: 86400
  says: the ProxyAdmin's owner is a timelock with a one-day delay
  for:
  - action
  - justification
- id: copy1-pool
  call: '0x0125c8977a02b2fa3970b1ed9af02f5bedd4ef27'
  fn: sortitionPool()(address)
  is: '0xc2731fb2823af3efc2694c9bc86f444d5c5bb4dc'
  says: copy 0x0125c897 validates another pool
  for:
  - notes
- id: copy2-pool
  call: '0x66efd63942809d8be972bcfac6bd8c0ed42e13ba'
  fn: sortitionPool()(address)
  is: '0x5d83c4faa18428f256bcb1bc5341e927fe2355d4'
  says: copy 0x66efd639 validates another pool
  for:
  - notes
- id: proposer
  call: '0x92f2d8b72a7f6a551be60b9aa4194248e9b4913d'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0xb09aa5aeb3702cfd50b6b62bc4532604938f21248a27a1d5ca736082b6819cc1'
  - '0x9f6e831c8f8939dc0c830c6e492e7cef4f9c2f5f'
  is: true
  says: Safe 0x9f6e831c holds the timelock's proposer role (keccak256 PROPOSER_ROLE)
  for:
  - action
  - justification
- id: safe-threshold
  call: '0x9f6e831c8f8939dc0c830c6e492e7cef4f9c2f5f'
  fn: getThreshold()(uint256)
  is: 6
  says: the proposer Safe needs 6 signatures
  for:
  - action
  - justification
- id: extra-gas
  storage: '0x827118841f6da1a440301bcac5912f56d689976d'
  slot: 155
  is: 50000
  says: the registry requires 50,000 gas left at the end of a challenge
  for:
  - notes
- id: guard-call
  source: '0xd156db4063f0d2be4a945fd8cd575ee3d3e1043a'
  file: contracts/WalletRegistry.sol
  line: 853
  has: dkg.requireChallengeExtraGas();
  says: challengeDkgResult checks the extra-gas guard after the validator call and the seize
  for:
  - notes
- id: guard
  source: '0xd156db4063f0d2be4a945fd8cd575ee3d3e1043a'
  file: contracts/libraries/EcdsaDkg.sol
  lines:
  - 461
  - 466
  has: gasleft() >= self.parameters.resultChallengeExtraGas,
  says: the guard reverts unless resultChallengeExtraGas is left
  for:
  - notes
- id: sig-limit
  source: '0x97bb9beebad6873b70e694c6a97a8a933ba85724'
  file: contracts/EcdsaDkgValidator.sol
  lines:
  - 164
  - 166
  has: if (signaturesCount > groupSize) {
  says: a result with more than groupSize (100) signatures is rejected
  for:
  - notes
- id: challenge-window
  storage: '0x827118841f6da1a440301bcac5912f56d689976d'
  slot: 154
  is: 115
  says: the challenge period is 115 blocks
  for:
  - what
- id: op3-auth
  call: '0x9abe40c9c1d8d99e42d6b6aa88f7673924deef76'
  fn: authorizedStake(address,address)(uint96)
  args:
  - '0x553297ea7588018ab6843ee16e66c3f3c3e5e919'
  - '0x827118841f6da1a440301bcac5912f56d689976d'
  is: '1000000000000000000000'
  says: the submitter has 1,000e18 authorized to the registry, enough for a 400e18 seize
  for:
  - notes
- id: stake-token
  bytecode: '0xc98cdb04bd0928512a5141ce20d0819b0a82cb38'
  has: 2ba64efb7a4ec8983e22a49c81fa216ac33f383a
  says: the staking implementation embeds token 0x2ba64efb as an immutable
  for:
  - what
- id: wbgl-symbol
  call: '0x2ba64efb7a4ec8983e22a49c81fa216ac33f383a'
  fn: symbol()(string)
  is: WBGL
  says: the staked token is WBGL
  for:
  - what
- id: wbgl-decimals
  call: '0x2ba64efb7a4ec8983e22a49c81fa216ac33f383a'
  fn: decimals()(uint8)
  is: 18
  says: 400e18 units is 400 WBGL
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

This validator re-checks operators' signatures on a key-generation result when it is challenged in its wallet registry. If a signer's account takes real code after submission, within the 115-block challenge window, the honest submitter is slashed 400 WBGL. No key generation runs at the block.

## Evidence

- [validateSignatures](https://etherscan.io/address/0x97bb9beebad6873b70e694c6a97a8a933ba85724#code) recovers each signature and rejects the result if it is not the operator's address.
- The registry's [challengeDkgResult](https://etherscan.io/address/0xd156db4063f0d2be4a945fd8cd575ee3d3e1043a#code) treats a rejected result as malicious and seizes 400e18 units of stake.

## Reviewer notes

### Mechanism

Wallet registry 0x82711884 (proxy, implementation 0xd156db40) stores this address as its DKG validator (storage slot 152). Operators sign the DKG result off-chain; one submits it, and during the challenge period (115 blocks at the block) anyone can call challengeDkgResult. EcdsaDkg.challengeResult calls validate() in a try: a valid result reverts the challenge, a false return or a revert marks the result malicious; challengeDkgResult then seizes the submitter's stake (400e18 at the block) and pays the challenger. validateSignatures recovers each 65-byte signature with OpenZeppelin ECDSA.recover and compares it with the operator address from the sortition pool. Under EIP-8151 ecrecover returns nothing for an operator whose account has real code: ECDSA.recover reverts ('invalid signature'), validate reverts, and the catch branch slashes the submitter. A signer can trigger this on purpose by moving to real code after signing. An EIP-7702 delegation still recovers. The registry sets the validator once (EcdsaDkg.init) and has no setter; the fix is an upgrade of the registry proxy, whose ProxyAdmin 0x7affa05f is owned by a timelock (1-day delay). Registry governance (an EOA with nonce 140) can also lower the slashing amount with updateSlashingParameters.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-size path for operators with code: validateSignatures has none (lines 245-255).
- Ruled out: this address being unused: registry 0x82711884 holds it as its DKG validator (slot 152), its sortition pool 0xde8f101e is owned by that registry, has three operators, and the registry locked a DKG at block 24,698,334.
- Ruled out: operators already with code: the three pool operators have no code at the block, so nothing breaks today; it starts when one takes real code.
- Ruled out: a gas break by itself: challengeDkgResult requires 50,000 gas left at its end (WalletRegistry.sol line 853, EcdsaDkg.sol lines 461-466; 50,000 at the block). A call keeps back 1/64, so a validator that ran out of gas would have had about 63 x 50,000 = 3.15M. Claude's fork replay of tBTC's last DKG approval (tx 0xdad12778…, block 26,409,794: 3,263,068 gas today, 3,347,668 under EIP-8151, 104 recoveries) bounds validate() at about 2.9M today and 2.97M under EIP-8151, about 6% below 3.15M, so nobody can fake an out-of-gas failure. Validator results hold at most 100 signatures (EcdsaDkgValidator.sol lines 164-166). The replay is not in this dossier.
- Ruled out: copies 0x0125c897 (pool 0xc2731fb2) and 0x66efd639 (pool 0x5d83c4fa) validate other pools; each is its own row and was not judged here.
- Ruled out: the registry's own signature checks (inactivity claims, wallet signatures) belong to the registry's row, not this one.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
