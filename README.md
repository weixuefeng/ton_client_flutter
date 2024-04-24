# ton_client_flutter

A Flutter plugin for [ever-sdk](https://github.com/everx-labs/ever-sdk/)



## Getting Started

### Add dependencies
```
  ton_client_flutter: 
    git:
      url: https://github.com/weixuefeng/ton_client_flutter.git
```


### Add iOS Call

- `Runner/AppDelegate.swift`
```
import TonClient
...
init_sdk_for_ios()
```

## Guide

```dart
var client = TonClient()
client.connect(CLIENT_DEFAULT_SETUP);
var keypair = await client.crypto.generate_random_sign_keys();
var encodeBoc = await client.abi.encode_boc(ParamsOfAbiEncodeBoc(params: [
    AbiParam(name: "publicKey", type: "uint256"),
    AbiParam(name: "timestamp", type: "uint64")
], data: {
    "publicKey": "0x${keypair.public!}",
    "timestamp": 0
}));
var initData = encodeBoc.boc!;
var encodeStateInit = await client.boc.encode_state_init(ParamsOfEncodeStateInit(
    code: everCode,
    data: initData
));
var stateInit = encodeStateInit.state_init!;
var hash = await client.boc.get_boc_hash(ParamsOfGetBocHash(boc: stateInit));
var address = "0:$hash";
print(address);
client.disconnect();
```