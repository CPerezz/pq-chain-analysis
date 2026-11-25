---
id: kmsverifier-77627828-kms-committee-ecdsa
format: 2
title: Zama's KMS signers use ECDSA; forging 7 keys can drain token wrappers
status: confirmed
severity: MEDIUM
justification: Forged KMS signatures would release wrapped tokens; fixing it takes a verifier upgrade by the owning
  DAO.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x77627828a55156b04ac0dc0eb30467f1a552bb03'
  name: KMSVerifier
  project: zama
  code: verified
  code_url: https://etherscan.io/address/0x390683dea46a61786f4f0807bf3559038cf43fa4#code
  proxy_of: '0x390683dea46a61786f4f0807bf3559038cf43fa4'
  copies: 1
  upgradeable: 'yes'
  admin: '0xb6d69d5f334d8b97b194617b53c6ab62f8681ef3'
value:
  usd: 0
  whose: users
  basis: held
activity:
  txs_90d: 6800
impact: funds-loss
action: Upgrade the verifier to require post-quantum KMS signatures; replacing the ECDSA signer set does not remove
  the exposure.
evidence_level: source
checks:
- id: ecdsa
  source: '0x390683dea46a61786f4f0807bf3559038cf43fa4'
  file: contracts/KMSVerifier.sol
  line: 412
  has: address signerRecovered = ECDSA.recover(message, signature);
  says: each KMS signature is recovered with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: no1271
  source: '0x390683dea46a61786f4f0807bf3559038cf43fa4'
  file: contracts/KMSVerifier.sol
  line: 406
  has: It does not support contract signature (EIP-1271).
  says: the recovery has no ERC-1271 path
  for:
  - evidence-1
  - what
- id: registered
  source: '0x390683dea46a61786f4f0807bf3559038cf43fa4'
  file: contracts/KMSVerifier.sol
  line: 351
  has: if (!PROTOCOL_CONFIG.isKmsSignerForContext(kmsContextId, signerRecovered)) {
  says: a recovered address that is not a registered signer of the context makes the check revert
  for:
  - evidence-1
  - what
- id: distinct
  source: '0x390683dea46a61786f4f0807bf3559038cf43fa4'
  file: contracts/KMSVerifier.sol
  lines:
  - 354
  - 361
  has: if (uniqueValidCount >= threshold) {
  says: the check passes once the threshold of distinct registered signers is reached
  for:
  - evidence-1
  - what
- id: threshold
  call: '0x77627828a55156b04ac0dc0eb30467f1a552bb03'
  fn: getThreshold()(uint256)
  is: 7
  says: the public decryption threshold is 7
  for:
  - evidence-1
  - justification
  - what
- id: signers
  call: '0x77627828a55156b04ac0dc0eb30467f1a552bb03'
  fn: getKmsSigners()(address[])
  is:
  - '0xe9f7ecff21a2e0ca58ea26ae869fef38ab49ed6f'
  - '0xdc472efa1642d5afb684aaaa546e22fb24aab965'
  - '0xbf05c17beb0bf2f2c78cd491a53a148e035279c3'
  - '0x915055c5f05c0d88bcdf1e3dfba18abd2a18350f'
  - '0x41b19eb4585450db79ac03ba9503106ec7895905'
  - '0x6e5f02cd4b33f0cf4ed5326ac9ee25e5aa8c4921'
  - '0x966188a1f697f6a1b5cfa51495dd8a8a7b5cdb8d'
  - '0x5d0e7033774dd43ee546d49b72bd0b561e52f7c8'
  - '0xdfc9dcb3d206aa164770874f36a4b5ad2ee5194f'
  - '0x7c5eeb4d8ced0101799b8cc212ee874097364f58'
  - '0x7c17be232e5968bda9516478b798b9e90d013fcc'
  - '0x6016dca5e91e62826e3fea1fb0a763602dc1e385'
  - '0xb7978e602d2af68258da614af949e014bf0de0eb'
  says: 13 KMS signers are registered
  for:
  - what
- id: context
  call: '0x77627828a55156b04ac0dc0eb30467f1a552bb03'
  fn: getCurrentKmsContextId()(uint256)
  is: 3166189940082864718613269121331309980362851143201109172953918312716374638593
  says: the current context id is the counter base plus one, so it is the first context ever defined
  for:
  - what
- id: ctx-valid
  call: '0xd8236b57394f90726b26ab25d38ceac776e1a7c4'
  fn: isValidKmsContext(uint256)(bool)
  args:
  - 3166189940082864718613269121331309980362851143201109172953918312716374638593
  is: true
  says: the current context is valid
  for:
  - what
- id: ctx-range
  source: '0x25c76298fb4d15bfadce4798519a7b37ac0076e7'
  file: contracts/ProtocolConfig.sol
  lines:
  - 409
  - 410
  has: kmsContextId >= KMS_CONTEXT_COUNTER_BASE + 1 && kmsContextId <= $.currentKmsContextId &&
  says: only contexts from the base plus one up to the current id are valid, so the current one is the only valid
    context
  for:
  - what
- id: pc-addr
  source: '0x390683dea46a61786f4f0807bf3559038cf43fa4'
  file: addresses/FHEVMHostAddresses.sol
  line: 15
  has: address constant protocolConfigAdd = 0xD8236B57394f90726b26aB25D38CeAC776E1a7C4;
  says: the verifier reads its signer set from this ProtocolConfig
  for:
  - what
- id: pc-impl
  storage: '0xd8236b57394f90726b26ab25d38ceac776e1a7c4'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x25c76298fb4d15bfadce4798519a7b37ac0076e7'
  says: ProtocolConfig runs the verified implementation cited here
  for:
  - what
- id: pc-define
  source: '0x25c76298fb4d15bfadce4798519a7b37ac0076e7'
  file: contracts/ProtocolConfig.sol
  lines:
  - 139
  - 142
  has: ) external virtual onlyACLOwner {
  says: defineNewKmsContext, which installs a new signer set, is reserved to the ACL owner
  for:
  - action
  - evidence-3
- id: upgrade
  source: '0x390683dea46a61786f4f0807bf3559038cf43fa4'
  file: contracts/KMSVerifier.sol
  line: 371
  has: function _authorizeUpgrade(address _newImplementation) internal virtual override onlyACLOwner {}
  says: upgrading the verifier is reserved to the ACL owner
  for:
  - action
  - admin
  - evidence-3
  - justification
- id: upgrade-fn
  selector: '0x390683dea46a61786f4f0807bf3559038cf43fa4'
  fn: upgradeToAndCall(address,bytes)
  says: the implementation has the UUPS upgrade function
  for:
  - action
  - evidence-3
- id: aclowner-mod
  source: '0x390683dea46a61786f4f0807bf3559038cf43fa4'
  file: contracts/shared/ACLOwnable.sol
  line: 26
  has: if (msg.sender != Ownable2StepUpgradeable(aclAdd).owner()) {
  says: onlyACLOwner admits only the owner of the ACL contract
  for:
  - action
  - admin
  - evidence-3
  - justification
- id: acl-addr
  source: '0x390683dea46a61786f4f0807bf3559038cf43fa4'
  file: addresses/FHEVMHostAddresses.sol
  line: 3
  has: address constant aclAdd = 0xcA2E8f1F656CD25C01F05d0b243Ab1ecd4a8ffb6;
  says: the ACL contract the modifier asks
  for:
  - admin
  - evidence-3
- id: acl-owner
  call: '0xca2e8f1f656cd25c01f05d0b243ab1ecd4a8ffb6'
  fn: owner()(address)
  is: '0xb6d69d5f334d8b97b194617b53c6ab62f8681ef3'
  says: the ACL owner, which can upgrade the verifier and replace its signers
  for:
  - action
  - admin
  - evidence-3
  - justification
- id: dao-code
  code: '0xb6d69d5f334d8b97b194617b53c6ab62f8681ef3'
  is: contract
  says: the ACL owner is a contract
  for:
  - evidence-3
- id: dao-impl
  storage: '0xb6d69d5f334d8b97b194617b53c6ab62f8681ef3'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x58c1f7bc62bb63fb137bc8f6d8ea6321a0501d29'
  says: the ACL owner is a proxy to this implementation
  for:
  - evidence-3
- id: dao-exec
  source: '0x58c1f7bc62bb63fb137bc8f6d8ea6321a0501d29'
  file: src/core/dao/DAO.sol
  lines:
  - 272
  - 280
  has: function execute(
  says: the owner's implementation is Aragon OSx's DAO, which calls other contracts through execute
  for:
  - evidence-3
  - justification
- id: impl
  storage: '0x77627828a55156b04ac0dc0eb30467f1a552bb03'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x390683dea46a61786f4f0807bf3559038cf43fa4'
  says: the verifier runs the verified KMSVerifier implementation
  for:
  - evidence-1
- id: zama
  source: '0x390683dea46a61786f4f0807bf3559038cf43fa4'
  file: contracts/KMSVerifier.sol
  line: 22
  has: https://github.com/zama-ai/fhevm/blob/main/SECURITY.md
  says: the verified source names Zama's fhevm repository as its security contact
  for:
  - what
- id: w-kms
  storage: '0xae0207c757aa2b4019ad96edd0092ddc63ef0c50'
  slot: '0x9e7b61f58c47dc699ac88507c4f5bb9f121c03808c5676a8078fe583e4649702'
  is: '0x77627828a55156b04ac0dc0eb30467f1a552bb03'
  says: the cUSDT wrapper's stored KMSVerifier address is this contract
  for:
  - evidence-2
  - what
- id: w-impl
  storage: '0xae0207c757aa2b4019ad96edd0092ddc63ef0c50'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x2abad2203eba104b52cf040cccfa100df15687f8'
  says: the cUSDT wrapper runs the verified ConfidentialWrapper implementation cited here
  for:
  - evidence-2
  - what
- id: w-fhe
  source: '0x2abad2203eba104b52cf040cccfa100df15687f8'
  file: '@fhevm/solidity/lib/FHE.sol'
  lines:
  - 9711
  - 9714
  has: IKMSVerifier($.KMSVerifierAddress).verifyDecryptionEIP712KMSSignatures(
  says: checkSignatures asks the stored KMSVerifier
  for:
  - what
- id: w-check
  source: '0x2abad2203eba104b52cf040cccfa100df15687f8'
  file: contracts/extensions/ERC7984ERC20WrapperUpgradeable.sol
  line: 161
  has: FHE.checkSignatures(handles, cleartexts, decryptionProof);
  says: finalizeUnwrap accepts the cleartext amount only if the KMS signatures check passes
  for:
  - evidence-2
  - justification
  - what
- id: w-pay
  source: '0x2abad2203eba104b52cf040cccfa100df15687f8'
  file: contracts/extensions/ERC7984ERC20WrapperUpgradeable.sol
  line: 163
  has: SafeERC20.safeTransfer(IERC20(underlying()), to, unwrapAmountCleartext * rate());
  says: finalizeUnwrap pays the signed cleartext amount of the underlying token
  for:
  - evidence-2
  - justification
  - what
- id: w-wrap
  source: '0x2abad2203eba104b52cf040cccfa100df15687f8'
  file: contracts/extensions/ERC7984ERC20WrapperUpgradeable.sol
  lines:
  - 110
  - 113
  has: euint64 wrappedAmountSent = _mint(to, FHE.asEuint64(SafeCast.toUint64(amount / rate())));
  says: wrap takes the depositor's tokens and mints confidential tokens to the depositor's chosen account
  for:
  - whose
- id: w-under
  call: '0xae0207c757aa2b4019ad96edd0092ddc63ef0c50'
  fn: underlying()(address)
  is: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  says: the cUSDT wrapper's underlying token is USDT
  for:
  - evidence-2
- id: w-bal
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0xae0207c757aa2b4019ad96edd0092ddc63ef0c50'
  is: 6099162038551
  says: the cUSDT wrapper holds 6,099,162.038551 USDT
  for:
  - evidence-2
  - whose
- id: w-paused
  call: '0xae0207c757aa2b4019ad96edd0092ddc63ef0c50'
  fn: paused()(bool)
  is: false
  says: the cUSDT wrapper is not paused
  for:
  - evidence-2
- id: signer-1
  code: '0xe9f7ecff21a2e0ca58ea26ae869fef38ab49ed6f'
  is: empty
  says: KMS signer 1 has no code
  for:
  - notes
- id: signer-2
  code: '0xdc472efa1642d5afb684aaaa546e22fb24aab965'
  is: empty
  says: KMS signer 2 has no code
  for:
  - notes
- id: signer-3
  code: '0xbf05c17beb0bf2f2c78cd491a53a148e035279c3'
  is: empty
  says: KMS signer 3 has no code
  for:
  - notes
- id: signer-4
  code: '0x915055c5f05c0d88bcdf1e3dfba18abd2a18350f'
  is: empty
  says: KMS signer 4 has no code
  for:
  - notes
- id: signer-5
  code: '0x41b19eb4585450db79ac03ba9503106ec7895905'
  is: empty
  says: KMS signer 5 has no code
  for:
  - notes
- id: signer-6
  code: '0x6e5f02cd4b33f0cf4ed5326ac9ee25e5aa8c4921'
  is: empty
  says: KMS signer 6 has no code
  for:
  - notes
- id: signer-7
  code: '0x966188a1f697f6a1b5cfa51495dd8a8a7b5cdb8d'
  is: empty
  says: KMS signer 7 has no code
  for:
  - notes
- id: signer-8
  code: '0x5d0e7033774dd43ee546d49b72bd0b561e52f7c8'
  is: empty
  says: KMS signer 8 has no code
  for:
  - notes
- id: signer-9
  code: '0xdfc9dcb3d206aa164770874f36a4b5ad2ee5194f'
  is: empty
  says: KMS signer 9 has no code
  for:
  - notes
- id: signer-10
  code: '0x7c5eeb4d8ced0101799b8cc212ee874097364f58'
  is: empty
  says: KMS signer 10 has no code
  for:
  - notes
- id: signer-11
  code: '0x7c17be232e5968bda9516478b798b9e90d013fcc'
  is: empty
  says: KMS signer 11 has no code
  for:
  - notes
- id: signer-12
  code: '0x6016dca5e91e62826e3fea1fb0a763602dc1e385'
  is: empty
  says: KMS signer 12 has no code
  for:
  - notes
- id: signer-13
  code: '0xb7978e602d2af68258da614af949e014bf0de0eb'
  is: empty
  says: KMS signer 13 has no code
  for:
  - notes
sources:
- study: top-callers-classification
  who: Review09 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: MEDIUM
reviews:
- who: r-77627828, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Zama''s KMSVerifier (an upgradeable proxy) accepts a decryption result when 7 of its 13 registered
    signers sign it with ECDSA; no ERC-1271 path. Confidential-token wrappers that use it pay out the signed amount:
    cUSDT holds 6,099,162 USDT, is not paused and has no pauser set. MEDIUM, PQ-5: seven forged signer keys let
    someone unwrap more than they wrapped; the DAO contract that owns Zama''s ACL and cUSDT can upgrade the verifier,
    and a new ECDSA signer set does not help. Author A-77627828; refuter R-77627828 agreed with no objection; the
    reader changed nothing. Not read: which plugin makes the DAO act (needs logs); the old 38.5M escrow total. The
    author''s lead, a real cUSDT unwrap that reverts under EIP-8151 alone, gets its own gas-limit row at the wrapper.'
related: []
---

## What happens

Zama's KMSVerifier accepts a decryption result when 7 of its 13 registered signers sign it with ECDSA. Confidential-token wrappers that use it, such as cUSDT, pay out whatever amount such a result states. With a quantum computer, forging 7 of those keys lets someone unwrap more than they wrapped.

## Evidence

- [The signature check](https://etherscan.io/address/0x390683dea46a61786f4f0807bf3559038cf43fa4#code) recovers each signature with ECDSA, needs 7 distinct registered signers and has no ERC-1271 path.
- The [cUSDT wrapper](https://etherscan.io/address/0xae0207c757aa2b4019ad96edd0092ddc63ef0c50#code) holds 6,099,162 USDT, is not paused, uses this verifier and pays the signed amount in finalizeUnwrap.
- The owner of Zama's ACL, a [DAO contract](https://etherscan.io/address/0xb6d69d5f334d8b97b194617b53c6ab62f8681ef3), can upgrade the verifier and replace its signer set.

## Reviewer notes

### Mechanism

Proxy to KMSVerifier v0.3.0. verifyDecryptionEIP712KMSSignatures (lines 141-185) splits the proof into 65-byte signatures and extra data, hashes an EIP-712 PublicDecryptVerification over handles, cleartexts and extra data, and picks the KMS context. _verifySignaturesDigestForContext (lines 332-366) recovers each signature with ECDSA.recover (line 412), reverts on an address that is not a signer of the context in ProtocolConfig, and passes at the threshold of distinct signers: 7 of 13 plain accounts in the only valid context. A wrapper's finalizeUnwrap calls FHE.checkSignatures over the request's handle and the cleartext amount, which calls this verifier (stored in the wrapper), then transfers that amount times rate() of the underlying. Forging 7 keys lets someone finalize a small unwrap request with a larger amount. Verifier and ProtocolConfig upgrades and new signer sets are onlyACLOwner: the owner of ACL 0xca2e...ffb6, a proxy to Aragon OSx's DAO. A new signer set is still ECDSA; the fix is an upgrade.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for signers: _recoverSigner is ECDSA.recover only, and its comment says contract signatures are not supported (lines 406-412).
- Ruled out: an unused implementation: this address is the proxy users call, with 6,800 transactions in 90 days; the cUSDT wrapper stores it as its verifier.
- Ruled out: an older, weaker signer set: the current context id is the counter base plus one, and only ids from the base plus one to the current one are valid, so one context exists.
- Ruled out: signers already contracts or unset: all 13 registered signers have no code at the block.
- Ruled out: a pause: KMSVerifier has none; the cUSDT wrapper is not paused at the block.
- Ruled out: a key rotation as the fix: defineNewKmsContext installs new ECDSA signer addresses, which a quantum computer forges the same way.
- Ruled out: value: this address holds nothing; the earlier escrow total over about 25 wrappers was not re-read here, only the cUSDT wrapper's balance is checked.
- Ruled out: the owner's ability to act: DAO.execute needs EXECUTE_PERMISSION_ID; its holder needs logs and was not read; the owner is presumed able to act.
- Ruled out: a separate EIP-8151 issue: replay 0xed1ebfde... (cUSDT finalizeUnwrap, limit 450,628, 426,887 used today) reverts under EIP-8151 alone at 443,850 gas, about 1/64 of the limit left: likely the sender's limit; no more-gas run in the dossier. It belongs to the cUSDT wrapper's row; main reviewer to replay.

### History

- 2026-11-17: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
