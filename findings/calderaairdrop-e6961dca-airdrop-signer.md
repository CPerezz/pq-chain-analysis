---
id: calderaairdrop-e6961dca-airdrop-signer
format: 2
title: Caldera ERA airdrop's GitHub claims rest on one forgeable ECDSA key
status: confirmed
severity: MEDIUM
justification: One ECDSA signer key gates GitHub claims; the owner Safe can fix it by upgrade or by revoking the
  vault allowance.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe6961dca8d597136fad600cf9ae4be2eb6254b30'
  name: CalderaAirdrop
  project: caldera
  code: verified
  code_url: https://etherscan.io/address/0x2f4a01b9de95889f8c6dadda579a3b7dddef600e#code
  proxy_of: '0x2f4a01b9de95889f8c6dadda579a3b7dddef600e'
  copies: 1
  upgradeable: 'yes'
  admin: '0xf50ca866cdf7e810c17b267553595656ad78f606'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Revoke the vault's ERA allowance to the airdrop, or upgrade to a post-quantum attestation before any reopening.
evidence_level: source
checks:
- id: c2
  source: '0x2f4a01b9de95889f8c6dadda579a3b7dddef600e'
  file: src/CalderaAirdrop.sol
  line: 467
  has: bytes(githubOwnershipVerificationMessage).toEthSignedMessageHash().recover(
  says: GitHub claim signature is checked by ECDSA recovery.
  for:
  - evidence-1
  - justification
  - what
- id: c6
  source: '0x2f4a01b9de95889f8c6dadda579a3b7dddef600e'
  file: lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol
  line: 92
  has: function upgradeToAndCall(address newImplementation, bytes memory data) public payable virtual onlyProxy
    {
  says: The contract is UUPS-upgradeable.
  for:
  - action
  - justification
- id: s-signer
  source: '0x2f4a01b9de95889f8c6dadda579a3b7dddef600e'
  file: src/CalderaAirdrop.sol
  has: ) != githubSigner
  line: 469
  says: Recovered signer must equal githubSigner.
  for:
  - evidence-1
  - justification
- id: s-transfer
  source: '0x2f4a01b9de95889f8c6dadda579a3b7dddef600e'
  file: src/CalderaAirdrop.sol
  has: IERC20(token).safeTransferFrom(airdropVault, sender, amount - automaticStakingAmount);
  line: 425
  says: Claim pays ERA from the vault to the sender.
  for:
  - action
  - evidence-2
  - what
- id: s-ended
  source: '0x2f4a01b9de95889f8c6dadda579a3b7dddef600e'
  file: src/CalderaAirdrop.sol
  has: revert ClaimPeriodEnded();
  line: 434
  says: Claims revert after endTime.
  for:
  - evidence-3
  - what
- id: s-setend
  source: '0x2f4a01b9de95889f8c6dadda579a3b7dddef600e'
  file: src/CalderaAirdrop.sol
  has: function setEndTime(uint256 timestamp) external onlyOwner {
  line: 243
  says: Owner can move endTime.
  for:
  - evidence-3
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

The airdrop pays GitHub allocations from the vault to whoever presents a githubSigner ECDSA signature for a username. With that key a quantum attacker could claim unclaimed GitHub allocations, but claims revert after endTime unless the owner reopens the period.

## Evidence

- [_requireValidGithubOwnershipVerificationSignature](https://etherscan.io/address/0x2f4a01b9de95889f8c6dadda579a3b7dddef600e#code) requires ECDSA recovery to equal githubSigner.
- [_githubClaim](https://etherscan.io/address/0x2f4a01b9de95889f8c6dadda579a3b7dddef600e#code) moves the amount from airdropVault to the sender with transferFrom.
- [_requireWithinClaimPeriod](https://etherscan.io/address/0x2f4a01b9de95889f8c6dadda579a3b7dddef600e#code) reverts after endTime, which the owner can move with setEndTime.

## Reviewer notes

### Mechanism

githubClaim/combinedClaim call _requireValidGithubOwnershipVerificationSignature (lines 456-473), which builds getGithubClaimVerificationMessage(msg.sender, githubUsername) and requires ECDSA.recover (line 467, ecrecover at ECDSA.sol 142) to equal githubSigner (line 469). _githubClaim then verifies a Merkle proof for the username leaf (line 412), marks it claimed, and transfers ERA from airdropVault to the sender, part staked via CalderaStaking.stakeFor (lines 420-425). Forging githubSigner signatures for the attacker's address takes unclaimed allocations. Claims are gated by _requireWithinClaimPeriod (lines 429-436); the closed period only reopens if the owner calls setEndTime (line 243). _requireValidAddressSignature (line 448) adds an ECDSA check on msg.sender, which locks out contract accounts.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The proxy itself holds no funds; exposure is the vault's ERA within its allowance.
- Ruled out: Claims are closed unless the owner reopens the period.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
