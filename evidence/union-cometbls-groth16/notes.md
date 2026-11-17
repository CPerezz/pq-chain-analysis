# Review notes: union-cometbls-groth16 (2026-11-17)

Reads with `cast` against https://ethereum-rpc.publicnode.com at block 26,431,454; source from Sourcify
(implementation `0xf2b24b085080cef91f7bffdc6358fe054999e15f`, `contracts/clients/CometblsClient.sol`,
`contracts/lib/CometblsZKVerifier.sol`).

## Code path

- `IBCHandler.updateClient` → `CometblsClient.updateClient` (line 400, `onlyIBC`, `whenNotPaused`) → `verifyHeader`
  (line 336) → `internalVerifyZKP` (line 608) → `CometblsZKVerifier.verifyProof` (line 190): a gnark Groth16 proof with a
  Pedersen commitment (`verifyProofCommitmentPOK`, line 158) on BN254 that the Union validator set signed the header.
  The accepted consensus state's root is then used by `verifyMembership` (line 477) to prove IBC packets.
- `_authorizeUpgrade` (line 648) is `restricted` (OpenZeppelin AccessManaged).

## Who can change it

- `0x7700ea29…` EIP-1967 implementation slot = `0xf2b24b08…`; `IBC_HANDLER()` = `0xee4ea8d358473f0fcebf0329feed95d56e8c04d7`
  (ERC1967Proxy → IBCHandler); `authority()` = `0x40cdff51ae7487e0b4a4d6e5f86eb15fb7c1d9f4` (ERC1967Proxy → `Manager`,
  an OpenZeppelin AccessManager); `paused()` = false.
- AccessManager `getTargetFunctionRole(0x7700ea29…, upgradeToAndCall)` = 0 (ADMIN_ROLE).
  `hasRole(0, 0x6a742078f90c2e16d8c9f83e41749410c314edd4)` = (true, delay 0). From the manager's events (Blockscout logs):
  ADMIN_ROLE granted to `0x6a742078…` at block 23,283,375 and revoked from `0x95fb5cb304508d74d855514d7bc9bda75c304ce2` at
  block 23,283,914.
- `0x6a742078…` is a Safe 1.4.1, threshold 5 of 8 (owners `0xa55f584f…`, `0x2e06bc0e…`, `0x58ab4153…`, `0x6e8a43f1…`,
  `0x107d2d0e…`, `0x7eb1e318…`, `0xbc223488…`, `0x571aeba0…`).
- Role 1 (`RELAYER`) gates the IBCHandler entry points (`TargetFunctionRoleUpdated` for nine IBCHandler selectors); the latest
  page of events shows 23 grants of it between blocks 22,244,190 and 24,236,104 (revocations not traced). A forged
  header must be submitted by one of these relayer accounts.

## Escrow

- UCS03 ZKGM app `0x5fbe74a283f7954f10aa04c2edf55578811aeb03` (ERC1967Proxy → `UCS03Zkgm`, implementation
  `0x384932cb…`): `IBC_HANDLER()` = the same IBCHandler and `authority()` = the same AccessManager.
- Holdings (Blockscout, 2026-11-17): 0 ETH, $11,870 in tokens (uniBTC $5,228, U 63.9M = $3,961 at $0.000062, LBTC $1,203,
  SolvBTC $848, WETH $623, …), `escrow.json`. IBCHandler holds nothing.
- ZKGM can also mint wrapped tokens on a forged packet; their value is not measured.
