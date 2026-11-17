# On-chain reads (Review15, 2026-11-17)

RPC https://ethereum-rpc.publicnode.com, latest block ~26,431,426; logs from Blockscout `module=logs`.

## Solver `0xae68b7117be0026cbd4366303f74eecbb19e4042` (Sourcify `src/solver/Solver.sol`)

| Read | Result |
|---|---|
| `owner()` | `0xf76e73720ec93df7e823b755e10c38a877c34bd5` (EOA: code size 0, nonce 328) |
| storage slot 2 (`SOLVER_SIGNER`, internal) | `0xf76e73720ec93df7e823b755e10c38a877c34bd5` (same key as owner) |
| proxy slots | none (no proxy; `onchain.json`) |
| holdings | USD 8 (`onchain.json`, block 26,431,214) |

## Entrypoint `0x2837593949f6c5f7abb66dd848ed4e5b774d4ef5` (Blockscout-verified `src/core/Entrypoint.sol`)

| Read | Result |
|---|---|
| `MOFA_SIGNER()` | `0x9033472ec5dcf3e2905ed93108de5f8961005f40` (EOA, nonce 0: signs off-chain only) |
| `BUNGEE_GATEWAY()` | `0xe772551f88e2c14aecc880df6b7cbd574561bf82` |
| gateway `ENTRYPOINT()` | `0x2837593949f6c5f7abb66dd848ed4e5b774d4ef5` (still the live entrypoint) |
| `owner()` | `0xdaee4d2156de6fe6f7d50ca047136d758f96a6f0` (EOA, nonce 494) |
| `hasRole(CONFIG_ROLE, owner)` | false |
| `RoleGranted(CONFIG_ROLE, …)` logs | `0x58a2f301e4bef98c78da7cc2b480d43ee5a4743b` (block 22,022,736; EOA, nonce 0); no `RoleRevoked` |

## BungeeGateway `0xe772551f88e2c14aecc880df6b7cbd574561bf82`

| Read | Result |
|---|---|
| `owner()` | `0xdaee4d2156de6fe6f7d50ca047136d758f96a6f0` |
| `RoleGranted` logs | CONFIG_ROLE: `0xdaee…a6f0` (21,966,713), `0x58a2…743b` (22,022,736); RESCUE_ROLE: `0xdaee…a6f0`, `0x0e551461bc47ee6127d888679c5fcc3ac49b81be`; CANCEL_ROLE: `0x86c950fe91d96fa113a96ee23edc7c517b94bfdc` |

CONFIG_ROLE on the gateway can call `setEntrypoint(address)` (`BungeeGatewayBase.sol`).
