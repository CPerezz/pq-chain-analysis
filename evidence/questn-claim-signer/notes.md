# Review notes: questn-claim-signer (2026-11-17)

Reads with `cast` against https://ethereum-rpc.publicnode.com at block 26,431,601 (logs and receipts via
https://eth.drpc.org); Blockscout for names.

## Identification: QuestN (formerly Quest3)

- `nftSingleton()` = `0xe828fc03e19808a4cb94e136bea87a45382f19da` and `nft()` = `0x36b0017aa6d08f8d663223d56aac9148a3268a6b`;
  both return `name()` = "Quest3NFT", `symbol()` = "Quest3".
- `baseTokenURI()` = `https://nft.questn.com/nft/meta/reward/`.
- The proxy, ProxyAdmin, NFT contracts and reward vault were all created by EOA `0xb32d9aa786e4f53f9484539cf44b1e092f94d483`.

## Proxy and roles

- `0x7c838b25…` TransparentUpgradeableProxy: implementation slot = `0x43f985fc517b50c5fbfdf43ff1bf2896a314cb1d`
  (unverified, 12,040 bytes, `version()` = "0.4.0"); admin slot = ProxyAdmin `0x9ce99901b23fc9f65c5ff839405545b8168c6e4e`
  (verified), `owner()` = EOA `0x2f6f4be9ef26ef1cf6ebb4ab9c4b36873651fc83` (nonce 57).
- Logic `owner()` = the same EOA `0x2f6f4be9…`; `claimSigner()` = `0x6288454b799cfe11447449f49a03d4578bc18087` (no code,
  nonce 0: it never sends transactions, but its signatures in claim calldata reveal its public key); `operatorSize()` = 0;
  `paused()` = false.
- `vaultAddress()` = `0x0376a35639dac611c49327426db9b342cdb553b8` (unverified, not a proxy, `owner()` = `0x2f6f4be9…`);
  `vaultStrategy()` = `0xfc2f5310665fd04db71d1571d0609c80f9c1dff8`.

## Selectors (implementation, `cast selectors --resolve`)

`claim(string,uint256,bytes)`, `claimSigner()`, `setClaimSigner(address)`, `isClaimable(string)`,
`claimed(string,address,uint256)`, `getEventInfo(string)`, `setVaultAddress(address)`, `setVaultStrategy(address)`,
`setNFT(address)`, `setNFTSinglton(address)`, `addOperator`/`delOperator`, `proposeOwnership`/`acceptOwnership`,
`setPaused(bool)`, plus unresolved entry points such as `0x1bcfaa66(bytes,address,address,uint256,address,uint256,bool,uint256,bytes,address)`.

## Sample claim

Transaction `0x632b8e302f6ff4421bb1093014e4f845c1185818131dd32f80b82ec87833840c` (block 26,182,770), selector `0x1bcfaa66`,
from `0xacfc0ec43be2c386c0e334944bc0199db48a7d49`: mints Quest3NFT token 50,467 to the caller and transfers 10.0666 USDT
from vault `0x0376a356…` to the caller. The precompile trace shows `ecrecover` calls from this contract.

## Holdings

Proxy: $0 (`onchain.json`, block 26,431,214). Vault `0x0376a356…` (Blockscout, 2026-11-17): 0 ETH; USDT `balanceOf` = 0;
other balances are dust or unpriced tokens (TUSD 0.0001). `vaultStrategy` `0xfc2f5310…`: nothing.
