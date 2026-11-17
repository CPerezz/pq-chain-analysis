# Review notes: hyperlane-multisig-ism-validators (2026-11-17, Review18)

## The two clones

Both are EIP-3448 meta-proxies (`cast code`) of `0x5371942d3ed75b10d77f0f4184ddc85cc35a1420`
(`StaticMessageIdMultisigIsm`, Sourcify match). Implementation source `contracts/isms/multisig/AbstractMultisigIsm.sol`:
`verify(_metadata, _message)` (line 71) reads `validatorsAndThreshold(_message)` from the appended immutable args, then
for `i < threshold` runs `ECDSA.recover(_digest, signatureAt(_metadata, i))` (line 87) and requires each signer to be
a later validator in the list (line 96). The digest (`AbstractMessageIdMultisigIsm.digest`) commits to the origin
merkle tree hook, root, index and message id. No owner, no setter.

`cast call validatorsAndThreshold(0x)` (latest, block ~26,431,600):

- `0x5bdfda33…`: threshold 3; validators `0x34a14934…`, `0x5450447a…`, `0xb8cf45d7…`, `0xb9453d67…`, `0xe957310e…`.
- `0x572c5674…`: threshold 4; validators `0x0d4c1394…`, `0x5450447a…`, `0x55880ac0…`, `0x68f3a3b2…`, `0x6ff4554c…`,
  `0xdc2b87cb…`.
- Both created by `0xfa21d9628adce86531854c2b7ef00f07394b0b69` (Blockscout).

## Where they were used (eth.drpc.org archive reads)

- Last use (Xatu): `0x5bdfda33…` in tx `0x4d924e84…` (block 25,991,011): `Mailbox.process` on Mailbox
  `0xc005dc82818d67af737725bd4bf75435d065d239`, message from domain 8453 (Base) to `HypERC20Collateral` proxy
  `0xd11874d565f0b64083433f767f67b15eb110bc8b` (collateral token ARC `0x672fdba7…`). `0x572c5674…` in tx
  `0x2b3331fd…` (block 25,883,209): message from domain 5330 (Superseed, router `0xa1863b4b…`) to the SUPR
  `HypXERC20` route `0xbc808c98bea0a097346273a9fd7a5b231fc2d889` (registry `deployments/warp_routes/SUPR`).
- Both recipients have `interchainSecurityModule()` = 0, so they use the Mailbox default ISM.
- `Mailbox.defaultIsm()` at block 25,991,011 = `0x7e1cdfb6a12284fa41a2ae8dab8e6379e4f0faf1` (aggregation, 2 of
  [`0x07088f42…` type 6, routing `0x86ac4855…`]); routing `module(8453)` = aggregation `0xe4e5b614…` (1 of
  [`0x5bdfda33…`, `0x97c8e7f6…`]); `module(5330)` = aggregation `0x73145ab2…` (1 of [`0x2cc6bc04…`, `0x572c5674…`]).
- Default ISM changed at block 25,991,130 (bisected; 2026-09-16) to `0xb05bbc4793d8db2b87115bb7e6304f0216a8c6eb`
  (aggregation, 2 of [routing `0xb9343ec5ca3e46cd47a0fb7122d733a15e88c72a`, `0xcb6e681c…` type 6, `paused()` false]).
  Current routing `module(8453)` = aggregation `0x53718f08…` (1 of [merkle-root clone `0x5eb42b1b…`, message-id
  clone `0xeb2a48dd…`]), both 3 of 5 with validator `0xa5962efa…` replacing `0xb9453d67…`. `module(5330)` reverts
  ("No ISM found for origin: 5330").
- Both recipients' `Mailbox.recipientIsm()` = `0xb05bbc47…` now. The two clones in this finding are therefore no
  longer on the default path; any recipient could still name them as its own ISM (not checked across all apps).

## Admin

- `Mailbox.owner()` = `0x562dfaac27a84be6c96273f5c9594da1681c0da7` (Safe, threshold 6 of 10). Routing ISM
  `0xb9343ec5…` `owner()` = the same Safe. Pausable module `0xcb6e681c…` owner `0x60cc386c…` (no code: EOA).

## Escrow (partial)

- `HypERC20Collateral 0xd11874d5…` holds 16,375,104.6 ARC (`balanceOf`, latest); Blockscout ARC rate USD 0.00076737
  → about USD 12.6k. SUPR route is an xERC20 mint/burn route (exposure = SUPR mintable within bridge limits, not
  measured). All other warp routes on Ethereum that rely on the default ISM: not measured.
