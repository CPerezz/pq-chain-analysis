# Bytecode and state reads: block-street-airdrop-signer

Contract `0x974b08e3ca65406451cb5867c032eb276fcf90b4` (2,755 bytes, not verified on Sourcify or Blockscout; Blockscout
creator `0x39830bb4a204278e7d2efd6ae6da50454add9999`). Read 2026-11-17 with `cast` against
`ethereum-rpc.publicnode.com` at latest (block about 26,431,500).

## Selectors (`cast selectors`, names from `cast 4byte`)

`claim(uint256,uint256,bytes)` 0x5eddd157, `signer()` 0x238ac933, `setSigner(address)` 0x6c19e783, `endAirdrop()`
0x726b5bad, `isEnded()` 0xa4fd6f56, `withdrawRemaining(address)` 0xfd0cdcdb, `hasClaimed(address)` 0x73b2e80e,
`claimedAmount(address)` 0x04e86903, `totalClaimed()` 0xd54ad2a1, `token()` 0xfc0c546a, OpenZeppelin `Ownable`
(`owner`, `transferOwnership`, `renounceOwnership`, error `OwnableUnauthorizedAccount` 0x118cdaa7).

## Claim path (`cast disassemble`)

`claim(amount, deadline, signature)`: reentrancy guard (ERC-7201 slot `0x9b779b17…`); revert if the ended flag in slot 1
is set; revert if `hasClaimed[msg.sender]`; require `deadline > block.timestamp` and `deadline <= block.timestamp + 300`;
require `amount > 0`; digest = `keccak256(abi.encodePacked(msg.sender, amount, deadline, chainid, address(this)))`
wrapped with `"\x19Ethereum Signed Message:\n32"`; OpenZeppelin `ECDSA` (s-value bound
`0x7fff…5d576e7357a4501ddfe92f46681b20a0`) then `STATICCALL` to precompile `0x01`; the recovered address must equal
the signer stored in slot 1; then `balanceOf(this)` on BSB and `transfer(msg.sender, amount)`.

## State

| Read | Value |
|---|---|
| `owner()` | `0x39830bb4a204278e7d2efd6ae6da50454add9999` (no code: EOA) |
| `signer()` | `0x7777ca93a25733502999ffff9eeb9ca139e35629` (no code, nonce 0: signs off-chain only) |
| `token()` | `0xdb6ba5d510f114f9b2ea08bea7d30e32eee33411` (BSB, "Block Street") |
| `isEnded()` | false |
| `totalClaimed()` | 1,024,511.16 BSB |
| BSB `balanceOf(contract)` | 225,488.84 BSB |
| Blockscout token-balances (2026-11-17) | BSB at USD 0.073252 = USD 16,517; USDT 16.23; HEX and ETIM dust |
