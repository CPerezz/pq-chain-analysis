# BridgeContract 0x972a7a92d92796a98801a8818bcf91f1648f2f68 (Blockscout verified, read 2026-11-17)

Excerpt from `BridgeContract.sol` (line numbers of the Blockscout flattened source).

```solidity
1251    address constant BLS12_PAIRING = 0x000000000000000000000000000000000000000F;       // BLS12_PAIRING_CHECK
1252    address constant BLS12_MAP_FP_TO_G1 = 0x0000000000000000000000000000000000000010;  // BLS12_MAP_FP_TO_G1
...
1346    function setGroupKey(uint64 epochId, bytes calldata groupPublicKey) external onlyOwner onlyAdminControl {
...
1402    function submitGroupKey(uint64 epochId, bytes calldata groupPublicKey, bytes calldata validationSig) public onlyNormalOperation {
...         require(_verifyTransitionSignature(prevGroupKeyStruct, newGroupKeyStruct, validationSig, epochId - 1), "Invalid transition signature");
...
1449    function withdraw(WithdrawalCommand calldata cmd) external nonReentrant onlyNormalOperation {
...         GroupKey memory groupKeyStruct = epochGroupKeys[cmd.epochId];
...         bytes32 messageHash = keccak256(abi.encodePacked(cmd.epochId, GONKA_CHAIN_ID, cmd.requestId, ETHEREUM_CHAIN_ID,
...             WITHDRAW_OPERATION, cmd.recipient, address(this), cmd.tokenContract, cmd.amount));
...         if (!_verifyBLSSignature(groupKey, messageHash, cmd.signature)) revert InvalidSignature();
...             IERC20(cmd.tokenContract).safeTransfer(cmd.recipient, cmd.amount);   // or ETH via call
...
1513    function mintWithSignature(MintCommand calldata cmd) external nonReentrant onlyNormalOperation {
...         if (!_verifyBLSSignature(groupKey, messageHash, cmd.signature)) revert InvalidSignature();
...         _mint(cmd.recipient, cmd.amount);
...
1601    function checkAndHandleTimeout() external {   // anyone; after 30 days without a new epoch -> ADMIN_CONTROL
...
1730    function _verifyBLSSignature(bytes memory groupPublicKey, bytes32 messageHash, bytes memory signature) internal view returns (bool) {
...         bytes memory hG1 = _mapMessageToG1(messageHash);
...         bytes memory negHG1 = _negateG1(hG1);
...         bytes memory pairingInput = abi.encodePacked(signature, G2_GENERATOR, negHG1, groupPublicKey);
...         (bool success, bytes memory result) = BLS12_PAIRING.staticcall(pairingInput);
```

No proxy, no upgrade function; the owner's only powers are `setGroupKey` and `resetToNormalOperation`, both
`onlyAdminControl`.
