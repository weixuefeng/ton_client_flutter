import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ton_client_flutter/ton_client_dart.dart';
import 'package:ton_client_flutter/ton_client_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _tonClientFlutterPlugin = TonClientFlutter();
  var CLIENT_DEFAULT_SETUP = {
        'network': {
          'endpoints': ['http://localhost'],
          'message_retries_count': 5,
          'message_processing_timeout': 40000,
          'wait_for_timeout': 40000,
          'out_of_sync_threshold': 15000,
          'access_key': ''
        },
        'crypto': {'fish_param': ''},
        'abi': {
          'message_expiration_timeout': 40000,
          'message_expiration_timeout_grow_factor': 1.5
        }
      };
      var client = TonClient();
  var everCode = "te6cckEBBgEA/AABFP8A9KQT9LzyyAsBAgEgAgMABNIwAubycdcBAcAA8nqDCNcY7UTQgwfXAdcLP8j4KM8WI88WyfkAA3HXAQHDAJqDB9cBURO68uBk3oBA1wGAINcBgCDXAVQWdfkQ8qj4I7vyeWa++COBBwiggQPoqFIgvLHydAIgghBM7mRsuuMPAcjL/8s/ye1UBAUAmDAC10zQ+kCDBtcBcdcBeNcB10z4AHCAEASqAhSxyMsFUAXPFlAD+gLLaSLQIc8xIddJoIQJuZgzcAHLAFjPFpcwcQHLABLM4skB+wAAPoIQFp4+EbqOEfgAApMg10qXeNcB1AL7AOjRkzLyPOI+zYS/";
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _tonClientFlutterPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> generateAddress() async {

  }

  Future<void> onClick() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin a app'),
        ),
        body: Center(
          child: ElevatedButton(child: Text("click"), onPressed: () async {
              onClick();
          },),
        ),
      ),
    );
  }
}
