# Review notes (Review23, 2026-11-17)

Reads at block 26,431,624 (https://ethereum-rpc.publicnode.com):

- Proxy `0x319814051b9520ddd58a8269362f1e283866441a` (verified: `src/proxy/PausableProxy.sol:PausableUpgradableProxy`):
  EIP-1967 implementation = `0x32504034b3622d1459e9d5d55d93c2439ac17ea1` (unverified, 22,467 bytes);
  EIP-1967 admin = `0x7288b0132bbfce7eaa7361330319e1ec7a859059` (unverified); `0x7288b013….owner()` =
  `0x0105290a57f8c700a4d14ce0b4155b7bcab8789c`, no code (EOA, nonce 104).
- Implementation bytecode contains the BN254 base-field modulus `0x30644e72…fd47` and scalar-field modulus
  `0x30644e72…0001`; 34 selectors (none resolve to Railgun's verified names; `0xa495f6a1` and `0x032e0530` take
  arrays of proof tuples and are the user entry points seen in transactions). The census precompile trace shows the
  proxy calling BN254 precompiles.
- Holdings: $30 (DAI 29, USDS 1, block 26,431,214, onchain.json). Token transfers (Blockscout): DAI deposits and
  withdrawals of 0.1–13 DAI from a handful of EOAs (2025-12-01 and 2026-05-02/03); the pool holds deposits itself.
- Activity: 113 transactions in total (Blockscout counters); last 2026-05-03.

Attribution (INFERRED): the deployer/owner EOA `0x0105290a…` deployed, in the same session (2025-05-09), a verified
`ZkGardenPriceOracle` (`0x429df520c0eb7a96b7afbb07c2bf4d64918694ba`) behind a second PausableUpgradableProxy
(`0x48894a2ab926797e1e602ecfdf25b5b70d6a34e1`, holds nothing, `addTokenV3/V4` calls = oracle configuration) and
whitelist contracts `0x5c926a47…`, and set 20+ verification keys (`setVerificationKey`) on this pool in May 2025.
The same team ("zkGarden") is the most likely operator; no public project page was found.
