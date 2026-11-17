# Trace notes (Review06, 2026-11-17)

debug_traceTransaction (callTracer) via https://eth.drpc.org; tx hashes from data/agg/y1_tx_caller.parquet (caller = this contract, precompile ecrecover). Summary printed by a throwaway script: frames to/from the contract and every call to precompile 0x01.

```
== 0x7e3365144aba9d14a0de76cd03c06b6ecc6e5080a8df30cf73947d077bb1131b top input 0x07ed2379 to 0x111111125421ca6dc452d289314280a0f8842a65
          STATICCALL 0x11111112->0xfbeedcfe378866dab6abbafd8b2986f5c1768737 0x1626ba7e val=None
          CALL 0x11111112->0xfbeedcfe378866dab6abbafd8b2986f5c1768737 0x0986bdd5 val=0x0
ECRECOVER {"depth": 6, "ecrecover_from_frame": "0xfbeedcfe378866dab6abbafd8b2986f5c1768737", "ctx": ["0x11111112", "0x990636ec", "0x990636ec", "0x990636ec", "0x11111112", "0xfbeedcfe"], "input": "0x32d2cff469a99b661de76c427c28a21af5ce1e1cd48c0d33cbab14fdb0778d4c000000000000000000000000000000000000000000000000000000000000001bddae6cfedbcbc27e7e8fafd98e982075af0617e2f0092b14997e2425e7ceea095d942f948a4c8ad471a75773d655827eceb49d889fc23181be22d35f21598077", "output": "0x000000000000000000000000a009fa1ac416ec02f6f902a3a4a584b092ae6123"}
== 0x878f7fb77827d652f5129ea1ea3bf091bf82c35a2948b8cfe512652c84492e70 top input 0x5f575529 to 0x881d40237659c251811cec9c364ef91dc08d300c
ECRECOVER {"depth": 7, "ecrecover_from_frame": "0xfbeedcfe378866dab6abbafd8b2986f5c1768737", "ctx": ["0x881d4023", "0x74de5d4f", "0x7cdf68ce", "0x11111112", "0x5141b82f", "0x11111112", "0xfbeedcfe"], "input": "0x294a51f75096adf861272445000f7d0d2ea8779e4683e8622eb317653d5f8375000000000000000000000000000000000000000000000000000000000000001bed08fe90779a7768a00655fb44bddc0fe33afea2bd2aff210947b40d3bc82f32214d59e6f43b8bd727ef6c03fd2baad7406981a96263c4796187bae692275f3c", "output": "0x000000000000000000000000a009fa1ac416ec02f6f902a3a4a584b092ae6123"}
== 0x443208622922b8719df43f0f7b911565cc937819be701b4a8f0a3d170b991952 top input 0x00000002 to 0xfbeedcfe378866dab6abbafd8b2986f5c1768737
CALL 0xa009fa1a->0xfbeedcfe378866dab6abbafd8b2986f5c1768737 0x00000002 val=0x1935057
  CALL 0xfbeedcfe->0x92560c178ce069cc014138ed3c2f5221ba71f58a 0x128acb08 val=0x0
    CALL 0x92560c17->0xfbeedcfe378866dab6abbafd8b2986f5c1768737 0xfa461e33 val=0x0
      CALL 0xfbeedcfe->0xc18360217d8f7ab5e7c516566761ea12ce7f9d72 0xa9059cbb val=0x0
  CALL 0xfbeedcfe->0x4838b106fce9647bdf1e7877bf73ce8b0bad5f97 0x val=0x3b3af4e4cfe
```

- Router 0x111111125421ca6dc452d289314280a0f8842a65 = 1inch AggregationRouterV6; selector 0x1626ba7e = isValidSignature(bytes32,bytes).
- ecrecover inside the contract's frame returns 0xa009fa1ac416ec02f6f902a3a4a584b092ae6123 (EOA, nonce 749,392 at 2026-11-17), which also sends the contract's own transactions (selectors 0x00000002, 0x00000033).
- 0xa009fa1a… appears verbatim in the runtime bytecode (immutable); storage slot 0 = 0x72e21ff5f6436345ae3781daa2bca02b7850fbee (the deployer, EOA).
- Deployer 0x72e21ff5… also created 0x4347983e483ea47099e8cbca160c92599791b76a (unverified), which the contract DELEGATECALLs in fills of UniswapX V2DutchOrderReactor 0x00000011f84b9aa48e5f8aa8b9897600006289be orders (tx 0xc7143268…).
