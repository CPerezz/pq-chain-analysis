# Review reads: lido-steth-permit-code-first (2026-11-17, Review07)

## Source (Sourcify full match, implementation `0x028271e30a695c0527a0c50ca30603fed004cdb0`, `Lido`)

`contracts/0.4.24/StETHPermit.sol`:

```solidity
   99      function permit(
  100          address _owner, address _spender, uint256 _value, uint256 _deadline, uint8 _v, bytes32 _r, bytes32 _s
  101      ) external {
  ...
  108          bytes32 hash = IEIP712StETH(getEIP712StETH()).hashTypedDataV4(address(this), structHash);
  110          require(SignatureUtils.isValidSignature(_owner, hash, _v, _r, _s), "INVALID_SIGNATURE");
  111          _approve(_owner, _spender, _value);
```

`contracts/common/lib/SignatureUtils.sol`:

```solidity
   29      function isValidSignature(address signer, bytes32 msgHash, uint8 v, bytes32 r, bytes32 s)
   35      internal view returns (bool) {
   36          if (_hasCode(signer)) {
   37              bytes memory sig = abi.encodePacked(r, s, v);
   40              bytes memory data = abi.encodeWithSelector(ERC1271_IS_VALID_SIGNATURE_SELECTOR, msgHash, sig);
   48              let success := staticcall(gas(), signer, add(data, 32), mload(data), outDataOffset, 32)
   53              return retval == bytes32(ERC1271_IS_VALID_SIGNATURE_SELECTOR);
   54          } else {
   55              return ECDSA.recover(msgHash, v, r, s) == signer;
   56          }
```

The ERC-1271 call receives only the 65 bytes `r || s || v`: a post-quantum signature cannot be passed (PQ-3).

## On-chain reads (`cast`, publicnode)

- Block 26,431,457: proxy `0xae7ab965…fe84` (Aragon `AppProxyUpgradeable`) `implementation()` =
  `0x028271e30a695c0527a0c50ca30603fed004cdb0`; `kernel()` = `0xb8ffc3cd6e7cf5a098a1c92f48009765b24088dc`;
  `appId()` = `0x3ca7c3e3…f320`; Kernel `getApp(keccak("base"), appId)` = same implementation.
- Block 26,431,458: Kernel `acl()` = `0x9895f0f17cc1d1891b6f18ee0b483b6f221b37bb`;
  `getPermissionManager(kernel, APP_MANAGER_ROLE)` = Agent `0x3e40d73eb977dc6a537af587d48316fee66e9c8c`
  (an app of the same Kernel). Neither Voting `0x2e59a20f…e618e` nor the Agent holds APP_MANAGER_ROLE now: an
  upgrade is a governance action that grants it and calls `Kernel.setApp`.
- Agent `RUN_SCRIPT_ROLE` and `EXECUTE_ROLE`: held by `0x23e0b465633ff5178808f4a75186e2f2f9537021` (Dual Governance
  admin executor; `owner()` = `0xce0425301c85c5ea2a0873a2dee44d78e02d2316`), not by Voting.
- Block 26,431,455: `totalSupply()` = 9,753,965.09 stETH. Blockscout token data 2026-11-17: `exchange_rate`
  $1,813.23, market cap $17,686,182,123 (supply × rate). The draft's $22.21B came from a stale cached market cap.
