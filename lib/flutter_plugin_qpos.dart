import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_plugin_qpos/QPOSModel.dart';
import 'package:meta/meta.dart' show visibleForTesting;

class FlutterPluginQpos {
  /// Initializes the plugin and starts listening for potential platform events.
  factory FlutterPluginQpos() {
    if (_instance == null) {
      final MethodChannel methodChannel =
          const MethodChannel('flutter_plugin_pos');
      final EventChannel eventChannel =
          const EventChannel('flutter_plugin_pos_event');
//      final EventChannel eventChannel = const EventChannel('plugins.flutter.io/charging');

      _instance = FlutterPluginQpos.private(methodChannel, eventChannel);
    }
    return _instance!;
  }

  /// This constructor is only used for testing and shouldn't be accessed by
  /// users of the plugin. It may break or change at any time.
  @visibleForTesting
  FlutterPluginQpos.private(this._methodChannel, this._eventChannel);

  static FlutterPluginQpos? _instance;

  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;
//  Stream<BatteryState> _onBatteryStateChanged;

//
//  /// Fires whenever the battery state changes.
  Stream<QPOSModel>? _onPosListenerCalled;

  Stream<QPOSModel>? get onPosListenerCalled {
    if (_onPosListenerCalled == null) {
      _onPosListenerCalled = _eventChannel
          .receiveBroadcastStream()
          .map((dynamic event) => _parsePosListenerCall(event));
    }
    return _onPosListenerCalled;
  }

  QPOSModel _parsePosListenerCall(String state) {
    //    {"parameters":"","method":"onRequestWaitingUser"}
    QPOSModel qposModel = QPOSModel.fromJson(json.decode(state));
    return qposModel;
  }

  init(String mode) {
    Map<String, String> params = Map<String, String>();
    params['CommunicationMode'] = mode;
    _methodChannel.invokeMethod('initPos', params);
  }

  Future<String?> get posSdkVersion async {
    String? version = await _methodChannel.invokeMethod('getPosSdkVersion');
    return version;
  }

  Future<bool?> connectBluetoothDevice(String addre) async {
    final bool? result = await _methodChannel
        .invokeMethod('connectBluetoothDevice', {"bluetooth_addr": addre});
    return result;
  }

  Future<void> getQposId() async {
    await _methodChannel.invokeMethod('getQposId');
  }

  void getQposInfo() async {
    await _methodChannel.invokeMethod('getQposInfo');
  }

  void getUpdateCheckValue() async {
    await _methodChannel.invokeMethod('getUpdateCheckValue');
  }

  void getKeyCheckValue(int i, String s) async {
    Map<String, String> params = Map<String, String>();
    params['keyIndex'] = i.toString();
    params['keyType'] = s;
    await _methodChannel.invokeMethod('getKeyCheckValue');
  }

  Future<void> disconnectBT() async {
    await _methodChannel.invokeMethod('disconnectBT');
  }

  Future<void> doTrade(Map map) async {
    await _methodChannel.invokeMethod('doTrade', map);
  }

  Future<void> doCheckCard() async {
    await _methodChannel.invokeMethod('doCheckCard');
  }

  void setAmount(Map<String, String> params) async {
    await _methodChannel.invokeMethod('setAmount', params);
  }

  void doEmvApp(String s) async {
    Map<String, String> params = Map<String, String>();
    params['EmvOption'] = s;
    await _methodChannel.invokeMethod('doEmvApp', params);
  }

  void sendTime(String s) async {
    Map<String, String> params = Map<String, String>();
    params['terminalTime'] = s;
    await _methodChannel.invokeMethod('sendTime', params);
  }

  Future<HashMap>? getNFCBatchData() async {
    Future<HashMap>? map = await _methodChannel.invokeMethod('getNFCBatchData');
    return map!;
  }

  void sendPin(String s) async {
    Map<String, String> params = Map<String, String>();
    params['pinContent'] = s;
    await _methodChannel.invokeMethod('sendPin', params);
  }

  void selectEmvApp(int i) async {
    Map<String, int> params = Map<String, int>();
    params['position'] = i;
    await _methodChannel.invokeMethod('selectEmvApp', params);
  }

  void sendOnlineProcessResult(String str) async {
    Map<String, String> params = Map<String, String>();
    params['onlineProcessResult'] = str;
    await _methodChannel.invokeMethod('sendOnlineProcessResult', params);
  }

  void stopScanQPos2Mode() async {
    await _methodChannel.invokeMethod('stopScanQPos2Mode');
  }

  void scanQPos2Mode(int i) async {
    Map<String, int> params = Map<String, int>();
    params['scanTime'] = i;
    await _methodChannel.invokeMethod('scanQPos2Mode', params);
  }

  void updateEmvConfig(String emvapp, String emvcapk) async {
    Map<String, String> params = Map<String, String>();
    params['emvApp'] = emvapp;
    params['emvCapk'] = emvcapk;
    await _methodChannel.invokeMethod('updateEmvConfig', params);
  }

  Future<void> updatePosFirmware(String upContent, String mAddress) async {
    Map<String, String> params = Map<String, String>();
    params['upContent'] = upContent;
    params['address'] = mAddress;
    return _methodChannel.invokeMethod('updatePosFirmware', params);
  }

  void doUpdateIPEKOperation(
      int ipekgroup,
      String trackksn,
      String trackipek,
      String trackipekCheckvalue,
      String emvksn,
      String emvipek,
      String emvipekCheckvalue,
      String pinksn,
      String pinipek,
      String pinipekCheckvalue) async {
    Map<String, String> params = Map<String, String>();
    StringBuffer index = StringBuffer();
    index.write(ipekgroup);
    params['keyIndex'] = index.toString();
    params['trackksn'] = trackksn;
    params['trackipek'] = trackipek;
    params['trackipekCheckvalue'] = trackipekCheckvalue;
    params['emvksn'] = emvksn;
    params['emvipek'] = emvipek;
    params['emvipekCheckvalue'] = emvipekCheckvalue;
    params['pinksn'] = pinksn;
    params['pinipek'] = pinipek;
    params['pinipekCheckvalue'] = pinipekCheckvalue;
    await _methodChannel.invokeMethod('doUpdateIPEKOperation', params);
  }

  void setMasterKey(String key, String checkValue, int keyIndex) async {
    Map<String, String> params = Map<String, String>();
    params['key'] = key;
    params['checkValue'] = checkValue;
    StringBuffer index = StringBuffer();
    index.write(keyIndex);
    params['keyIndex'] = index.toString();
    await _methodChannel.invokeMethod('setMasterKey', params);
  }

  Future<int?> getUpdateProgress() async {
    int? process = await _methodChannel.invokeMethod('getUpdateProgress');
    return process;
  }

  void openUart(String s) async {
    Map<String, String> params = Map<String, String>();
    params['path'] = s;
    await _methodChannel.invokeMethod('openUart', params);
  }

  void pinMapSync(value) async {
    Map<String, String> params = Map<String, String>();
    params['value'] = value;
    await _methodChannel.invokeMethod('pinMapSync', params);
  }

  Future<String?> generateIPEK(String bdk, String ksn) async {
    Map<String, String> params = Map<String, String>();
    params['ksn'] = ksn;
    params['bdk'] = bdk;
    final String? result =
        await _methodChannel.invokeMethod('generateIPEK', params);
    return result;
  }

  Future<String?> generateCheckValue(String key) async {
    Map<String, String> params = Map<String, String>();
    params['key'] = key;
    final String? result =
        await _methodChannel.invokeMethod("generateCheckValue", params);
    return result;
  }

  Future<String?> tripleDesEncryption(String key, String data) async {
    Map<String, String> params = Map<String, String>();
    params['key'] = key;
    params['data'] = data;
    final String? result =
        await _methodChannel.invokeMethod("tripleDesEncryption", params);
    return result;
  }

  void generateTransportKey() async {
    await _methodChannel.invokeMethod("generateTransportKey");
  }

  void updateIPEKByTransportKey(
      {String? ksn, String? ipek, String? cvk}) async {
    Map<String, String?> params = Map<String, String?>();
    params['ksn'] = ksn;
    params['ipek'] = ipek;
    params['cvk'] = cvk;
    await _methodChannel.invokeMethod("updateIPEKByTransportKey");
  }

  Future<bool?> sendCvv(String cvv) async {
    Map<String, String> params = Map<String, String>();
    params['cvv'] = cvv;
    final bool? result = await _methodChannel.invokeMethod("sendCvv", params);
    return result;
  }

  Future<String?> getEncryptedDataBlock() async {
    final String? result =
        await _methodChannel.invokeMethod("getEncryptedDataBlock");
    return result;
  }

  Future<String?> tlvDecoder(String tlv) async {
    Map<String, String> params = Map<String, String>();
    params['tlv'] = tlv;
    final String? result =
        await _methodChannel.invokeMethod("parseTLV", params);
    return result;
  }

  void cancelTrade() async {
    await _methodChannel.invokeMethod("cancelTrade");
  }

  Future<bool?> updateRSA(String rsaFilename) async {
    Map<String, String> params = Map<String, String>();
    params['rsaName'] = rsaFilename;
    final result = await _methodChannel.invokeMethod("updateRSA", params);
    print("Update RSA Result: $result");
    return result;
  }

  void updateWorkKeyByTransportKey({String? key, String? cvk}) async {
    Map<String, String?> params = Map<String, String?>();
    params["key"] = key;
    params["cvk"] = cvk;
    await _methodChannel.invokeMethod("updateWorkKeyByTransportKey", params);
  }

  Future<String?> getICCTag(
      {bool? encryption, int? tagCounter, String? tagArrayStr}) async {
    Map<String, dynamic> params = Map<String, dynamic>();
    params['cipher'] = encryption;
    params['tagCounter'] = tagCounter;
    params['tagArrayStr'] = tagArrayStr;
    final String? result =
        await _methodChannel.invokeMethod("getICCTag", params);
    return result;
  }

  Future<bool?> requestBluePermision() async {
    final bool? result =
        await _methodChannel.invokeMethod("requestBluePermision");
    return result;
  }

  void updateEmvApp() async {
    await _methodChannel.invokeMethod("updateEmvApp");
  }
}
