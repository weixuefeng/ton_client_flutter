import 'dart:ffi';
import 'dart:io' show Platform;

import 'package:ffi/ffi.dart';

DynamicLibrary loadTonLib() {
  if (Platform.isAndroid /*|| Platform.isLinux*/) {
    return DynamicLibrary.open('libton_client_dart.so');
  } else if (Platform.isIOS) {
    return DynamicLibrary.process();
  } else if (Platform.isMacOS) {
    //return DynamicLibrary.open('${basePath}libbabyjubjub.dylib');
    throw NotSupportedPlatform('${Platform.operatingSystem} is not supported!');
  } else if (Platform.isWindows) {
    //return DynamicLibrary.open('${basePath}libbabyjubjub.dll');
    throw NotSupportedPlatform('${Platform.operatingSystem} is not supported!');
  } else {
    throw NotSupportedPlatform('${Platform.operatingSystem} is not supported!');
  }
}

class NotSupportedPlatform implements Exception {
  NotSupportedPlatform(String s);
}

final class MyResponse extends Struct {
  @Uint8()
  external int finished;
  @Uint32()
  external int request_id;
  @Uint32()
  external int response_type;
  external Pointer<Utf8> params_json;
}

// store post cobject??
typedef _c_store_dart_post_cobject = Void Function(
    Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>>);
typedef _dart_store_dart_post_cobject = void Function(
    Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>>);

// create context
typedef _c_dart_create_context = Pointer<Utf8> Function(Int64, Pointer<Utf8>);
typedef _dart_dart_create_context = Pointer<Utf8> Function(int, Pointer<Utf8>);

// destroy context
typedef _c_dart_destroy_context = Void Function(Uint32);
typedef _dart_dart_destroy_context = void Function(int);

// dart string free
typedef _c_dart_string_free = Void Function(Pointer<Utf8>);
typedef _dart_dart_string_free = void Function(Pointer<Utf8>);

// dart response free
typedef _c_dart_response_free = Void Function(Pointer<MyResponse>);
typedef _dart_dart_response_free = void Function(Pointer<MyResponse>);

// dart request
typedef _c_dart_request = Void Function(
    Int32, Pointer<Utf8>, Pointer<Utf8>, Int32);
typedef _dart_dart_request = void Function(
    int, Pointer<Utf8>, Pointer<Utf8>, int);

class TonBridge {
  final DynamicLibrary lib = loadTonLib();

  TonBridge() {
    // create context
    _dart_create_context =
        lib.lookupFunction<_c_dart_create_context, _dart_dart_create_context>(
            "dart_create_context");

    // destroy context
    _dart_destroy_context =
        lib.lookupFunction<_c_dart_destroy_context, _dart_dart_destroy_context>(
            "dart_destroy_context");

    // store post object
    _store_dart_post_cobject = lib.lookupFunction<_c_store_dart_post_cobject,
        _dart_store_dart_post_cobject>("store_dart_post_cobject");

    // dart string free
    _dart_string_free =
        lib.lookupFunction<_c_dart_string_free, _dart_dart_string_free>(
            "dart_string_free");

    // _dart_request
    _dart_request =
        lib.lookupFunction<_c_dart_request, _dart_dart_request>("dart_request");

    // dart response free
    _dart_response_free =
        lib.lookupFunction<_c_dart_response_free, _dart_dart_response_free>(
            "dart_response_free");
  }

  // create context
  late _dart_dart_create_context _dart_create_context;
  String createContext(int port, String config) {
    var resultPtr = _dart_create_context(port, config.toNativeUtf8());
    var res = resultPtr.toDartString();
    freeString(res);
    return res;
  }

  // destory context
  late _dart_dart_destroy_context _dart_destroy_context;
  void destoryContext(int context) {
    _dart_destroy_context(context);
  }

  // store post c object
  late _dart_store_dart_post_cobject _store_dart_post_cobject;
  void storePostObject(
      Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>>
          obj) {
    _store_dart_post_cobject(obj);
  }

  // dart string free
  late _dart_dart_string_free _dart_string_free;
  void freeString(String str) {
    _dart_string_free(str.toNativeUtf8());
  }

  // _dart_response_free
  late _dart_dart_response_free _dart_response_free;
  void freeResponse(Pointer<MyResponse> obj) {
    _dart_response_free(obj);
  }

  // dart request
  late _dart_dart_request _dart_request;
  void request(
      int context, String functionName, String functionParams, int requestId) {
    _dart_request(context, functionName.toNativeUtf8(),
        functionParams.toNativeUtf8(), requestId);
  }
}
