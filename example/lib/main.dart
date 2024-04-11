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
    print("object");

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> onClick() async {
    print("-----");
      var client = TonClient();
      var config = ClientConfig(abi: AbiConfig(workchain: 0, message_expiration_timeout: 40000, message_expiration_timeout_grow_factor: 2), 
      binding: BindingConfig(library: "libton_client", version: "1.45"), 
      boc: BocConfig(cache_max_size: 10240),
      proofs: ProofsConfig(cache_in_local_storage: false),
      network: NetworkConfig(endpoints: [""], message_retries_count: 5, message_processing_timeout: 40000, wait_for_timeout: 40000, out_of_sync_threshold: 15000));
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

    client.connect(CLIENT_DEFAULT_SETUP);
      var boc =
          'te6ccgEBAQEAWAAAq2n+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAE/zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzSsG8DgAAAAAjuOu9NAL7BxYpA';
      var res = await client.boc.parse_message(ParamsOfParse(boc: boc));
      print(res);
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
