---
id: archetype-750ee352-signer-upgrade-only
format: 2
title: Mondo Megabits referral mints stop if its signer's account takes real code
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if the affiliate signer's account takes real code; the proxy admin can upgrade this contract
  first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x750ee3529d13819e00e4e67063d6e500870d5af3'
  name: Archetype
  code: verified
  code_url: https://etherscan.io/address/0x6aad73c8ca98b8e34f314f74875f88f9bdbee339#code
  proxy_of: '0x6aad73c8ca98b8e34f314f74875f88f9bdbee339'
  copies: 1
  upgradeable: 'yes'
  admin: '0xcaf42ff1ca79bb4929f76cebd50ab0724c4ee0cd'
value:
  usd: 3235
  whose: mixed
  basis: held
activity:
  txs_90d: 8
impact: liveness
action: Upgrade to a version that can replace the affiliate signer, and replace it, before that signer's account
  takes real code.
evidence_level: source
checks:
- id: colname
  call: '0x750ee3529d13819e00e4e67063d6e500870d5af3'
  fn: name()(string)
  is: Mondo Megabits
  says: the collection's name
  for:
  - what
- id: erc1155
  source: '0x6aad73c8ca98b8e34f314f74875f88f9bdbee339'
  file: contracts/Archetype.sol
  lines:
  - 27
  - 29
  has: contract Archetype is Initializable, ERC1155Upgradeable,
  says: the implementation is an ERC-1155 token contract
  for:
  - what
- id: affgate
  source: '0x6aad73c8ca98b8e34f314f74875f88f9bdbee339'
  file: contracts/ArchetypeLogic.sol
  line: 214
  has: if (args.affiliate != address(0)) {
  says: the signature is checked only when a referrer is named
  for:
  - what
- id: affcall
  source: '0x6aad73c8ca98b8e34f314f74875f88f9bdbee339'
  file: contracts/ArchetypeLogic.sol
  line: 220
  has: validateAffiliate(args.affiliate, signature, config.affiliateSigner);
  says: a mint with a referrer checks the signature against the stored affiliate signer
  for:
  - what
- id: recover
  source: '0x6aad73c8ca98b8e34f314f74875f88f9bdbee339'
  file: contracts/ArchetypeLogic.sol
  line: 398
  has: address signer = ECDSA.recover(signedMessagehash, signature);
  says: the signer is recovered with ECDSA
  for:
  - evidence-1
  - what
- id: cmp
  source: '0x6aad73c8ca98b8e34f314f74875f88f9bdbee339'
  file: contracts/ArchetypeLogic.sol
  lines:
  - 400
  - 401
  has: if (signer != affiliateSigner) { revert InvalidSignature();
  says: the mint reverts unless the recovered signer is the affiliate signer
  for:
  - evidence-1
  - justification
  - what
- id: initwrite
  source: '0x6aad73c8ca98b8e34f314f74875f88f9bdbee339'
  file: contracts/Archetype.sol
  line: 99
  has: config = config_;
  says: initialize writes the config, including the affiliate signer
  for:
  - action
  - evidence-1
  - justification
  - what
- id: initializer
  source: '0x6aad73c8ca98b8e34f314f74875f88f9bdbee339'
  file: contracts/Archetype.sol
  line: 72
  has: ) external initializer {
  says: initialize can run once
  for:
  - what
- id: initslot
  storage: '0x750ee3529d13819e00e4e67063d6e500870d5af3'
  slot: '0x0'
  is: 1
  says: the proxy is initialized (_initialized is 1)
  for:
  - what
- id: signer
  call: '0x750ee3529d13819e00e4e67063d6e500870d5af3'
  fn: config()(string,address,address,address,uint32,uint16,uint16,uint16,uint16,uint16)
  is:
  - ipfs://bafybeic4botsnh3bhog7userbrrvjhanqzs7hkkgisixnycqljxboik26m/
  - '0x1f285dd528cf4cde3081c6d48d9df7a4f8fa9383'
  - '0x0b0d965af6b260fe27d92edc1db40017874a98fb'
  - '0x0000000000000000000000000000000000000000'
  - 3000
  - 100
  - 2000
  - 500
  - 500
  - 448
  says: the affiliate signer field of config is 0x1f28…9383
  for:
  - evidence-1
  - evidence-2
- id: signercode
  code: '0x1f285dd528cf4cde3081c6d48d9df7a4f8fa9383'
  is: empty
  says: the affiliate signer has no code
  for:
  - evidence-2
- id: signernonce
  nonce: '0x1f285dd528cf4cde3081c6d48d9df7a4f8fa9383'
  is: 1
  says: the affiliate signer has sent one transaction
  for:
  - evidence-2
- id: adminslot
  storage: '0x750ee3529d13819e00e4e67063d6e500870d5af3'
  slot: '0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103'
  is: '0xcaf42ff1ca79bb4929f76cebd50ab0724c4ee0cd'
  says: the proxy's admin is 0xcaf4…c0cd
  for:
  - evidence-2
- id: proxydispatch
  source: '0x750ee3529d13819e00e4e67063d6e500870d5af3'
  file: '@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol'
  lines:
  - 89
  - 93
  has: if (msg.sender == _getAdmin()) { bytes memory ret; bytes4 selector = msg.sig; if (selector == ITransparentUpgradeableProxy.upgradeTo.selector)
    { ret = _dispatchUpgradeTo();
  says: the admin can upgrade the proxy's implementation
  for:
  - action
  - justification
  - what
- id: adminupgrade
  selector: '0xcaf42ff1ca79bb4929f76cebd50ab0724c4ee0cd'
  fn: upgrade(address,address)
  says: the admin contract has an upgrade function
  for:
  - action
  - evidence-2
- id: adminowner
  call: '0xcaf42ff1ca79bb4929f76cebd50ab0724c4ee0cd'
  fn: owner()(address)
  is: '0x8e94188034136dce2be62c10eaa5471eaf23e86b'
  says: the owner of the proxy admin
  for:
  - action
  - evidence-2
  - justification
  - what
- id: adminownercode
  code: '0x8e94188034136dce2be62c10eaa5471eaf23e86b'
  is: empty
  says: the proxy admin's owner is an account without code
  for:
  - evidence-2
- id: invite0
  call: '0x750ee3529d13819e00e4e67063d6e500870d5af3'
  fn: invites(bytes32)(uint128,uint128,uint128,uint32,uint32,uint32,uint32,uint32,uint32,address)
  args:
  - '0x0000000000000000000000000000000000000000000000000000000000000000'
  is:
  - 150000000000000000
  - 150000000000000000
  - 0
  - 1696867200
  - 4294967295
  - 3000
  - 1836
  - 0
  - 0
  - '0x0000000000000000000000000000000000000000'
  says: 'public list 0: 0.15 ETH, started 2023-10-09, no end, limit 3,000 (not paused), 1,836 tokens'
  for:
  - evidence-3
- id: listsupply
  call: '0x750ee3529d13819e00e4e67063d6e500870d5af3'
  fn: listSupply(bytes32)(uint256)
  args:
  - '0x0000000000000000000000000000000000000000000000000000000000000000'
  is: 414
  says: 414 tokens minted on public list 0
  for:
  - evidence-3
- id: ownerbal
  call: '0x750ee3529d13819e00e4e67063d6e500870d5af3'
  fn: ownerBalance()(uint128,uint128)
  is:
  - 1211250000000000000
  - 63750000000000000
  says: 'owner and platform balances held for ETH: 1.21125 and 0.06375 ETH'
  for:
  - whose
- id: credit
  source: '0x6aad73c8ca98b8e34f314f74875f88f9bdbee339'
  file: contracts/ArchetypeLogic.sol
  lines:
  - 310
  - 313
  has: _affiliateBalance[affiliate][tokenAddress] += affiliateWad;
  says: referral commissions are credited to the referrer's balance in the contract
  for:
  - whose
- id: libaddr
  bytecode: '0x6aad73c8ca98b8e34f314f74875f88f9bdbee339'
  has: 365110b34b46927b2158e07e6d3c6d4802e032f0
  says: the implementation is linked to the ArchetypeLogic library at 0x3651…32f0
  for:
  - notes
- id: recovergas
  source: '0x6aad73c8ca98b8e34f314f74875f88f9bdbee339'
  file: solady/src/utils/ECDSA.sol
  line: 25
  has: gas(), // Amount of gas left for the transaction.
  says: the recovery passes all remaining gas to the precompile
  for:
  - notes
- id: clone1code
  bytecode: '0xf86a01143eedecd880aa2cbf4b3c7b125b583189'
  has: 363d3d373d3d3d363d736aad73c8ca98b8e34f314f74875f88f9bdbee3395af43d82803e903d91602b57fd5bf3
  says: 0xf86a…3189 is an EIP-1167 clone of the implementation 0x6aad…f339
  for:
  - notes
- id: clone2code
  bytecode: '0x87bfcb0487c030e4a471cb3b741d395ace5b185c'
  has: 363d3d373d3d3d363d736aad73c8ca98b8e34f314f74875f88f9bdbee3395af43d82803e903d91602b57fd5bf3
  says: 0x87bf…185c is an EIP-1167 clone of the implementation 0x6aad…f339
  for:
  - notes
- id: clone1signer
  call: '0xf86a01143eedecd880aa2cbf4b3c7b125b583189'
  fn: config()(string,address,address,address,uint32,uint16,uint16,uint16,uint16,uint16)
  is:
  - ipfs://bafybeihzqv5hkasxga73y5kkwsnik4ww35xh3qqzbe3sey45ryv7zxqgpe/
  - '0x1f285dd528cf4cde3081c6d48d9df7a4f8fa9383'
  - '0x0000000000000000000000000000000000000000'
  - '0x0000000000000000000000000000000000000000'
  - 4000
  - 100
  - 0
  - 500
  - 0
  - 448
  says: the clone 0xf86a…3189 trusts the same affiliate signer 0x1f28…9383
  for:
  - notes
- id: clone2signer
  call: '0x87bfcb0487c030e4a471cb3b741d395ace5b185c'
  fn: config()(string,address,address,address,uint32,uint16,uint16,uint16,uint16,uint16)
  is:
  - ipfs://bafybeifh5g66etfpqgvsfajmgyvl42niioclghman7insjvya4zor3pbtq/
  - '0x1f285dd528cf4cde3081c6d48d9df7a4f8fa9383'
  - '0x0000000000000000000000000000000000000000'
  - '0x0000000000000000000000000000000000000000'
  - 1337
  - 100
  - 0
  - 500
  - 500
  - 448
  says: the clone 0x87bf…185c trusts the same affiliate signer 0x1f28…9383
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-750ee352, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: INFORMATIONAL notice (PQ-17): Mondo Megabits (a live, upgradeable Archetype proxy) accepts a referral
    mint only when its affiliate signer 0x1f28…9383 signed the referrer; only an upgrade replaces that signer, so
    if its account takes real code referral mints revert until the proxy admin upgrades. Mints without a referrer
    keep working, referrers withdraw their commissions by their own call. Its two EIP-1167 clones are their own
    fixed-signer rows. Refuter agrees; Claude read the sheet.'
related: []
---

## What happens

Mondo Megabits, an NFT collection, accepts a mint that names a referrer only if its affiliate signer, set once at initialization, signed that referrer. If that signer's account takes real code, referral mints revert until an upgrade; an EIP-7702 delegation keeps working, and so do plain mints.

## Evidence

- [validateAffiliate](https://etherscan.io/address/0x6aad73c8ca98b8e34f314f74875f88f9bdbee339#code) recovers the signer with ECDSA and reverts unless it is the affiliate signer stored at initialization.
- The [affiliate signer](https://etherscan.io/address/0x1f285dd528cf4cde3081c6d48d9df7a4f8fa9383) is an account without code; the owner of the [proxy admin](https://etherscan.io/address/0xcaf42ff1ca79bb4929f76cebd50ab0724c4ee0cd) can upgrade.
- The [public mint list](https://etherscan.io/address/0x750ee3529d13819e00e4e67063d6e500870d5af3) is open at 0.15 ETH with no end date; 414 of its 1,836 tokens are minted.

## Reviewer notes

### Mechanism

The proxy (EIP-1967, admin 0xcaf4…c0cd) runs Archetype 0x6aad…f339, which calls the linked library ArchetypeLogic 0x3651…32f0. mint/mintTo call validateMint; when the affiliate argument is non-zero, validateMint calls validateAffiliate(affiliate, signature, config.affiliateSigner), which recovers the signer of the eth-signed hash of the affiliate address with solady ECDSA.recover (all remaining gas to the precompile) and reverts InvalidSignature unless it equals config.affiliateSigner. initialize (initializer, already run: slot 0 is 1) is the only writer of config.affiliateSigner and requires it non-zero, so an empty recovery never matches. No setter writes it; only an upgrade by the ProxyAdmin (owner EOA 0x8e94…e86b, nonce 68) can change it. At the block the affiliate signer 0x1f28…9383 is an EOA with nonce 1; public invite key 0 is open (0.15 ETH, start 2023-10-09, no end, list supply 414 of 1,836; total supply 1,361 of 3,000). With a referrer, the buyer gets a 10% discount and the referrer 20% of the price, credited to its balance. The contract holds owner and platform balances (1.275 ETH) plus affiliate credits. Owner is the platform constant 0x86b8…847b.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for a signer with code: validateAffiliate has none (ArchetypeLogic.sol lines 390-403).
- Ruled out: another writer of affiliateSigner: it appears only in the struct, the initialize check, validateMint and validateAffiliate; config is assigned whole only at Archetype.sol line 99; no assembly or sstore in Archetype.sol or ArchetypeLogic.sol; the library functions that take Config storage do not write it.
- Ruled out: re-initialization: slot 0 (_initialized) of the proxy is 1, and initializer allows a second run only while the contract has no code.
- Ruled out: an unused implementation: the address is an initialized proxy with total supply 1,361 and an open public list.
- Ruled out: a fixed gas amount: solady ECDSA.recover passes gas() to the precompile.
- Ruled out: a direct path to credit a referrer without the signature: any non-zero affiliate goes through validateAffiliate; a mint without a referrer still works, so only the referral feature stops.
- Ruled out: a rechecked signature that someone relied on for funds: a referral signature only grants a discount and a commission on future mints; nothing already paid depends on it.
- Ruled out: key unset or already code: config() returns 0x1f28…9383 and its code is empty at the block.
- Ruled out: other copies: EIP-1167 clones 0xf86a…3189 ('NFT.Storage Editions Event') and 0x87bf…185c ('Oekaki Souvenir') trust the same signer 0x1f28…9383 and cannot be upgraded; they are their own rows, this card covers 0x750ee352 alone.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
