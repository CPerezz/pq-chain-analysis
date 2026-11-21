---
id: morpho-bbbbbbbb-authorization-signature
format: 2
title: Morpho accepts ECDSA-signed authorizations over users' positions
status: confirmed
severity: HIGH
justification: Users' positions can be taken with a forged signature, even after they migrate, and the check cannot
  be changed.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb'
  name: Morpho
  project: morpho
  code: verified
  code_url: https://etherscan.io/address/0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb#code
  copies: 1
  upgradeable: 'no'
  admin: '0xcba28b38103307ec8da98377fff9816c164f9afa'
value:
  usd: 2226804360
  whose: users
  basis: held
activity: {}
impact: funds-loss
action: Warn users who adopt post-quantum keys to move their positions to an address with no ECDSA key; withdrawals
  need no signature.
evidence_level: source
checks:
- id: ecdsa
  source: '0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb'
  file: src/Morpho.sol
  lines:
  - 453
  - 455
  has: require(signatory != address(0) && authorization.authorizer == signatory, ErrorsLib.INVALID_SIGNATURE);
  says: setAuthorizationWithSig accepts the signature when ecrecover returns the authorizer
  for:
  - action
  - evidence-1
  - justification
  - what
- id: set-auth
  source: '0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb'
  file: src/Morpho.sol
  line: 459
  has: isAuthorized[authorization.authorizer][authorization.authorized] = authorization.isAuthorized;
  says: a valid signature makes the authorized address a manager of the authorizer's positions
  for:
  - evidence-1
  - what
- id: sender-auth
  source: '0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb'
  file: src/Morpho.sol
  line: 468
  has: return msg.sender == onBehalf || isAuthorized[onBehalf][msg.sender];
  says: the position owner itself or an authorized manager may act for the position
  for:
  - action
  - what
- id: withdraw
  source: '0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb'
  file: src/Morpho.sol
  lines:
  - 212
  - 228
  has: IERC20(marketParams.loanToken).safeTransfer(receiver, assets);
  says: withdraw takes onBehalf's supply and pays any receiver, gated only by the sender check
  for:
  - action
  - what
- id: borrow
  source: '0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb'
  file: src/Morpho.sol
  line: 247
  has: require(_isSenderAuthorized(onBehalf), ErrorsLib.UNAUTHORIZED);
  says: borrow on behalf of a position is gated by the same sender check
  for:
  - what
- id: withdraw-collateral
  source: '0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb'
  file: src/Morpho.sol
  lines:
  - 331
  - 341
  has: IERC20(marketParams.collateralToken).safeTransfer(receiver, assets);
  says: withdrawCollateral takes onBehalf's collateral and pays any receiver, gated by the sender check
  for:
  - what
- id: no-1271
  selector: '0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the code never asks a signer's contract code through ERC-1271
  for:
  - action
  - evidence-1
  - justification
  - what
- id: no-proxy
  storage: '0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty
  for:
  - evidence-3
  - justification
- id: no-upgrade
  selector: '0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - evidence-3
  - justification
- id: owner-fns
  source: '0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb'
  file: src/Morpho.sol
  lines:
  - 93
  - 145
  has: function setFeeRecipient(address newFeeRecipient) external onlyOwner {
  says: the owner functions set the owner, enable IRMs and LLTVs, and set fees; none touches the signature check
  for:
  - evidence-3
  - justification
- id: domain
  source: '0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb'
  file: src/Morpho.sol
  line: 49
  has: bytes32 public immutable DOMAIN_SEPARATOR;
  says: the signing domain is fixed at deployment
  for:
  - evidence-3
  - justification
- id: supply
  source: '0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb'
  file: src/Morpho.sol
  line: 186
  has: position[id][onBehalf].supplyShares += shares;
  says: supplied assets are credited to the supplier's position
  for:
  - whose
- id: collateral
  source: '0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb'
  file: src/Morpho.sol
  line: 313
  has: position[id][onBehalf].collateral += assets.toUint128();
  says: collateral is credited to the depositor's position
  for:
  - whose
- id: relayed
  tx: '0xbaf1b6a48c4cfa77d14888885eb206b5e24ef112651dc21fb8e3023ff2ab56fc'
  to: '0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb'
  ok: true
  says: a direct, successful setAuthorizationWithSig call sent by an address other than the authorizer
  for:
  - evidence-2
- id: author
  source: '0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb'
  file: src/Morpho.sol
  line: 35
  has: /// @author Morpho Labs
  says: the verified source names Morpho Labs as author
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
  who: Review23 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
- study: eip-8151-impact
  who: Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by
    a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews: []
related: []
---

## What happens

Morpho lets a user's ECDSA signature appoint a manager who can withdraw that user's supply and collateral and borrow against it. A quantum attacker who recovers a user's key can sign such an authorization, even after the user moves the address to post-quantum keys.

## Evidence

- [setAuthorizationWithSig](https://etherscan.io/address/0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb#code) sets a manager when ecrecover returns the authorizer, and never asks the account's code.
- A relayer used it on a user's behalf in [this transaction](https://etherscan.io/tx/0xbaf1b6a48c4cfa77d14888885eb206b5e24ef112651dc21fb8e3023ff2ab56fc).
- The [contract](https://etherscan.io/address/0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb#code) is not a proxy; its owner sets fees and enables rate models and LLTVs, but cannot change this check.

## Reviewer notes

### Mechanism

setAuthorizationWithSig (Morpho.sol lines 446-464) checks the deadline and consumes nonce[authorizer], builds an EIP-712 digest from the immutable DOMAIN_SEPARATOR, and requires ecrecover(digest, v, r, s) to be non-zero and equal to authorization.authorizer (lines 453-455). It then sets isAuthorized[authorizer][authorized] (line 459). _isSenderAuthorized (line 468) lets an authorized address act for onBehalf in withdraw (line 212), borrow and withdrawCollateral (line 331), paying any receiver; borrow and withdrawCollateral keep the victim's position healthy, so an attacker takes the victim's supply, collateral, or a loan against that collateral. Nothing beyond the signer's own positions is reachable. The code has no isValidSignature call and no code-size branch, so a key holder who keeps the address under a 7702 delegation or a post-quantum frame-transaction scheme still has the old ECDSA key accepted here. The owner (0xcba2...9afa) can only call setOwner, enableIrm, enableLltv, setFee and setFeeRecipient (lines 95-145); the contract is not a proxy and has no DELEGATECALL. Users keep direct paths: setAuthorization and withdraw by msg.sender need no signature.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path for signers with code: the runtime code has no isValidSignature(bytes32,bytes) selector and setAuthorizationWithSig has no other branch (lines 446-464).
- Ruled out: an owner or upgrade path that could change the check: EIP-1967 slot empty, no upgradeTo selector, the owner functions (lines 95-145) touch only owner, IRMs, LLTVs and fees; DOMAIN_SEPARATOR is immutable.
- Ruled out: a bundled replay: tx 0xbaf1...56fc is a direct call to Morpho's setAuthorizationWithSig from a relayer (0xb77e...4b7a) for authorizer 0x37b6...f696; the study's replays show it passes under EIP-8151 and with a 7702 delegation at the signer, and reverts with real code at the signer. Not cited on the card: under this category EIP-8151 is not assumed.
- Ruled out: copies: the dossier lists none; the MetaMorpho vaults named in the old finding are separate contracts with their own permit and are not part of this row.
- Ruled out: value: what the contract holds is credited to suppliers' and borrowers' positions (lines 186, 313); the fee recipient's interest shares are a small part of supply and are not separated here.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
