import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:ton_client_flutter/src/ton_birdge.dart';
import 'dart:convert';
import 'dart:isolate';
import 'dart:async';

import 'package:tuple/tuple.dart';

///Core class
class TonSdkCore {
  int _context = -1;
  late ReceivePort _interactiveCppRequests;
  int _nextId = 1;
  TonBridge bridge = TonBridge();

  final Map<int, Tuple2<Completer<Map<String, dynamic>>, Function>> _requests =
      {};

  void connect(Map<String, dynamic> config) async {
    // store c object
    bridge.storePostObject(NativeApi.postCObject);

    // create native port
    _interactiveCppRequests = ReceivePort()
      ..listen((data) {
        responseHandler(data);
      });

    final nativePort = _interactiveCppRequests.sendPort.nativePort;

    //create context
    final context = bridge.createContext(nativePort, jsonEncode(config));
    final contextJson = jsonDecode(context) as Map<String, dynamic>;

    if (!contextJson.containsKey('result')) {
      throw ("Can't create context! ${contextJson['error']}");
    }
    _context = contextJson['result'];
  }

  void disconnect() {
    bridge.destoryContext(_context);
    _interactiveCppRequests.close();
    _context = -1;
    _nextId = 1;
  }

  void responseHandler(int data) {
    final rs = Pointer<MyResponse>.fromAddress(data);
    final rsVal = rs.ref;
    final jsonStr = rsVal.params_json.toDartString();

    if (!_requests.containsKey(rsVal.request_id)) {
      return;
    }

    final completer = _requests[rsVal.request_id]!.item1;
    final responseHandler = _requests[rsVal.request_id]!.item2;

    if (rsVal.finished == 1) {
      _requests.remove(rsVal.request_id);
    }

    final json =
        jsonStr != '' ? jsonDecode(jsonStr) as Map<String, dynamic> : null;
    switch (rsVal.response_type) {
      case 0: // RESULT
        completer.complete(json);
        break;
      case 1: // ERROR
        completer.completeError(json ?? {"error": "unknow error"});
        break;
      default: // DATA
        if (rsVal.response_type >= 100) {
          responseHandler(json);
        }
        break;
    }
    bridge.freeResponse(rs);
  }

  Future<Map<String, dynamic>> request(
      String fnName, String? fnParams, Function? responseHandler) async {
    final id = _nextId++;
    final completer = Completer<Map<String, dynamic>>();
    final tuple = Tuple2<Completer<Map<String, dynamic>>, Function>(
        completer, responseHandler ?? () => {});
    _requests[id] = tuple;
    bridge.request(_context, fnName, fnParams ?? "", id);
    return completer.future;
  }
}
