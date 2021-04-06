import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_plugin_qpos/flutter_plugin_qpos.dart';
import 'package:flutter_plugin_qpos/QPOSModel.dart';
import 'package:flutter_plugin_qpos_example/keyboard/view_keyboard.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

import '../Utils.dart';
//import 'package:permission_handler/permission_handler.dart';
//
//import 'package:fluttertoast/fluttertoast.dart';

class PluginPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

final communicationMode = const [
  'AUDIO',
  'BLUETOOTH_VER2',
  'UART',
  'UART_K7',
  'BLUETOOTH_2Mode',
  'USB',
  'BLUETOOTH_4Mode',
  'UART_GOOD',
  'USB_OTG',
  'USB_OTG_CDC_ACM',
  'BLUETOOTH',
  'BLUETOOTH_BLE',
  'UNKNOW',
];

class _MyAppState extends State<PluginPage> {
  FlutterPluginQpos _flutterPluginQpos = FlutterPluginQpos();
  String _platformVersion = 'Unknown';
  String display = "";
  QPOSModel trasactionData;
  StreamSubscription _subscription;
  List<String> items;
  int numPinField;
  var scanFinish = 0;
  String _mAddress;
  var _updateValue;
  bool _visibility = false;
  bool concelFlag = false;
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _subscription =
        _flutterPluginQpos.onPosListenerCalled.listen((QPOSModel datas) {
      parasListener(datas);
      setState(() {
        trasactionData = datas;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    //取消监听
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await _flutterPluginQpos.posSdkVersion;
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

  @override
  Widget build(BuildContext context) {
    Widget buttonSection = new Container(
      child: new Row(
        children: [
          RaisedButton(
            onPressed: () async {
              setState(() {
                scanFinish = -1;
                items = null;
              });
              selectDevice();
            },
            child: Text("select device"),
          ),
          RaisedButton(
            onPressed: () async {
              startDoTrade();
            },
            child: Text("start do trade"),
          ),
          RaisedButton(
            onPressed: () async {
              disconnectToDevice();
            },
            child: Text("disconnect"),
          ),
        ],
      ),
    );

    Widget btnMenuSection = new PopupMenuButton<String>(
        initialValue: "",
        child: RaisedButton(child: new Text("update button")),
        onSelected: (String string) {
          print(string.toString());
          onUpdateButtonSelected(string, context);
        },
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              PopupMenuItem(
                child: Text("update Emv Config"),
                value: "0",
              ),
              PopupMenuItem(
                child: Text("update Firmware"),
                value: "1",
              ),
              PopupMenuItem(
                child: Text("update IPEK"),
                value: "2",
              ),
              PopupMenuItem(
                child: Text("update Master Key"),
                value: "3",
              )
            ]);

    Widget btnMenuDeviceInfoSection = new PopupMenuButton<String>(
        initialValue: "",
        child: RaisedButton(child: new Text("device_info button")),
        onSelected: (String string) {
          print(string.toString());
          onDeviceInfoButtonSelected(string, context);
        },
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              PopupMenuItem(
                child: Text("get Device Id"),
                value: "0",
              ),
              PopupMenuItem(
                child: Text("get Device Info"),
                value: "1",
              ),
              PopupMenuItem(
                child: Text("get Device update Key CheckValue"),
                value: "2",
              ),
              PopupMenuItem(
                child: Text("get Device Key CheckValue"),
                value: "3",
              )
            ]);

    Widget textSection = new Container(
      child: new Column(
        children: [
          Text(
            '$_platformVersion',
          ),
//          Text(
//            '$display',
//          ),
          Text(
            '$trasactionData',
          ),
        ],
      ),
    );

    Widget textResultSection = new Container(
      child: new Column(
        children: [
          Text(
            '$display',
          ),
        ],
      ),
    );

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('plugin page'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                RaisedButton(
                  onPressed: () async {
                    openUart();
                  },
                  child: Text("open uart"),
                ),
                buttonSection,
                textSection,
                btnMenuSection,
                btnMenuDeviceInfoSection,
                ElevatedButton(
                    onPressed: () {
                      _flutterPluginQpos.generateIPEK(
                          "0123456789ABCDEFFEDCBA9876543210",
                          "00000332100300E00001");
                    },
                    child: Text("generate IPEK")),
                ElevatedButton(
                    onPressed: () {
                      _flutterPluginQpos
                          .generateCheckValue(
                              "0123456789ABCDEFFEDCBA9876543210")
                          .then((value) {
                        print(value);
                      });
                    },
                    child: Text("generate Check value")),
                ElevatedButton(
                    onPressed: () {
                      _flutterPluginQpos.generateTransportKey();
                      // _flutterPluginQpos
                      //     .tripleDesEncryption("0123456789ABCDEFFEDCBA9876543210",
                      //         "B579E9C92E84D7BF129DD468290D5FD8")
                      //     .then((value) {
                      //   print("tripledes: $value");
                      // });
                    },
                    child: Text("Genera transport key")),
                ElevatedButton(
                    onPressed: () {
                      _flutterPluginQpos.tlvDecoder(
                          "5F201A20202020202020202020202020202020202020202020202020209F160F4243544553543132333435363738399F4E04616263648E180000000000000000020141041E0401051E0501031E031F025F25031902024F07A00000000320109F0702FF809F0D059068D4F8009F0E0520102800009F0F059068D4F8009F3901059B0268005F280204849F4C00500D5649534120454C454354524F4E9F0607A00000000320109F21031659319F120D42414E434F4D455220564953419F1101015F24032404309A032104059F02060000000001009F03060000000000009F34030103025F3000C408415231FFFFFF7420C00A09118012400705E00010C2820198C08BAFBF7A8DB3E52DB68F838322935502B3E18D0C0A166C0D5660B61531FFBCC0762711C1BDDB069A0A233A34B5084FD502ED64AE288C555DF9F5DA8CB924A175CA3541786BB52282DE56BE90ECDDEBDD388D9921A134DF2A12552E6E3184A7D3F1CD8B82D6CC768B3BA5EF68718B2A2CF4E50964A91FA95C803AD8EFB958FA598BB2D10D6AEA4C70C5C3A8F4F0343D8EC1A55044068E7F028789B5A064742FC7945547BF535C6F99AB0FF0388C554FBC60D2D9BF044E6622464F47CB1415F6F5B541E2A5A935241C065704244F8E7FC75CBF1DD42F974F1AB809B3F3D6EEFAB6B7906433DC8D211B562EAD879D6BBA8642348FFC85183DF7EFD150DDA05F00235167B4A34AFCE695FEA5A7A92E557883B4B07072FEF357D58977CE2B6A31EBE18E056CAA8F423473D20E801A0CE899B7C7332230F2C1CFE46BA454517CA749707C4CCCC3653D43B9376A32443DE36F4AA80F47CE2A12E7CAA1FF2DB4A4E149BFE7B034379B6B69F1F9E2A7B8DC447F196427F1C8AAF3C9AD9B1FDD45299EDD65118E0FCDAB85EEA997BABC9A3741D07D7E66919E6CD259");
                    },
                    child: Text("TLV DECODER")),
                getListSection(),
                textResultSection,

//              getupdateSection()
              ],
            ),
          )),
    );
  }

//
//  Future requestPermission(List<PermissionGroup> permissions) async {
//    if(permissions == null || permissions.length<1){
//      return false;
//    }
//    // 申请权限
//    Map<PermissionGroup, PermissionStatus> permissionsMap =
//        await PermissionHandler().requestPermissions(permissions);
//    PermissionStatus permission = null;
//    // 申请结果
//    for (int i = 0; i < permissions.length; i++) {
//      permission = await PermissionHandler()
//          .checkPermissionStatus(permissions[i]);
//      if (permission != PermissionStatus.granted) {
//        Fluttertoast.showToast(msg: "denied");
//        return false;
//      }
//      return true;
//    }
//  }

  void searchNearByDevice() {}

  Future<void> connectToDevice(String item) async {
    List<String> addrs = item.split("//");
    _mAddress = addrs[1];
    setState(() {
      scanFinish = 0;
      items = null;
    });
    await _flutterPluginQpos.connectBluetoothDevice(addrs[1]);
  }

  Future<void> disconnectToDevice() async {
    await _flutterPluginQpos.disconnectBT();
  }

  void startDoTrade() {
    Map<String, String> params = Map<String, String>();
    params['keyIndex'] = "0";
//    params['cardTradeMode'] = "SWIPE_TAP_INSERT_CARD_NOTUP";
//    params['formatId'] = "00";
//    params['doTradeMode'] = "CHECK_CARD_NO_IPNUT_PIN";
    _flutterPluginQpos.doTrade(params);
  }

  void parasListener(QPOSModel datas) {
    //Map map = new Map<String, dynamic>.from(json.decode(datas));
    // CustomerModel testModel = CustomerModel.fromJson(json.decode(datas));
    //String method = map["method"];
    String method = datas.method;
    List<String> paras;
    //String parameters = map["parameters"];
    String parameters = datas.parameters;
    if (parameters != null && parameters.length > 0) {
      paras = parameters.split("||");
    }

    switch (method) {
      case 'onRequestTransactionResult':
        setState(() {
          display = parameters;
        });
        break;
      case 'onRequestWaitingUser':
        setState(() {
          display = "Please insert/swipe/tap card";
        });
        break;
      case 'onReturnConverEncryptedBlockFormat':
        break;
      case 'onWaitingforData':
        break;
      case 'onRequestDevice':
        break;
      case 'onEncryptData':
        break;
      case 'onRequestDisplay':
        setState(() {
          display = parameters;
        });
        break;
      case 'onQposInfoResult':
        setState(() {
          display = parameters;
        });
        break;
      case 'onCbcMacResult':
        break;
      case 'onRequestTime':
        _flutterPluginQpos.sendTime("20200215175558");
        break;
      case 'onAddKey':
        break;
      case 'onTradeCancelled':
        break;
      case 'onRequestSetPin':
        setState(() {
          display = "Please input pin on your app";
        });
        _flutterPluginQpos.sendPin("1111");
        break;
      case 'onQposRequestPinResult':
        _showKeyboard(context, parameters);
        break;
      case 'onGetPosComm':
        break;
      case 'onDeviceFound':
        setState(() {
          if (items == null) {
            items = new List();
          }
          items.add(parameters);
        });
        StringBuffer buffer = new StringBuffer();
        for (int i = 0; i < items.length; i++) {
          buffer.write(items[i]);
        }
        print("onDeviceFound : ${buffer.toString()}");
        break;
      case 'onQposDoTradeLog':
        break;
      case 'onQposKsnResult':
        break;
      case 'onDoTradeResult':
        if (Utils.equals(paras[0], "ICC")) {
          _flutterPluginQpos.doEmvApp("START");
        }

        if (Utils.equals(paras[0], "NFC_ONLINE") ||
            Utils.equals(paras[0], "NFC_OFFLINE")) {
          Future<HashMap<String, String>> map =
              _flutterPluginQpos.getNFCBatchData();
          setState(() {
            display = map.toString();
          });
        } else if (Utils.equals(paras[0], "MCR")) {
          setState(() {
            display = paras[1];
          });
        }
        requestSendCVV();
        break;
      case 'onQposIdResult':
        break;
      case 'onError':
        setState(() {
          display = parameters;
        });
        break;
      case 'onReturnRSAResult':
        break;
      case 'onQposDoSetRsaPublicKey':
        break;
      case 'onGetShutDownTime':
        break;
      case 'writeMifareULData':
        break;
      case 'onQposGenerateSessionKeysResult':
        break;
      case 'verifyMifareULData':
        break;
      case 'transferMifareData':
        break;
      case 'onGetSleepModeTime':
        break;
      case 'onRequestNoQposDetectedUnbond':
        break;
      case 'onRequestBatchData':
        break;
      case 'onReturnGetPinResult':
        break;
      case 'onReturniccCashBack':
        break;
      case 'onReturnSetSleepTimeResult':
        break;
      case 'onPinKey_TDES_Result':
        break;
      case 'onEmvICCExceptionData':
        break;
      case 'onGetInputAmountResult':
        break;
      case 'onRequestQposDisconnected':
        setState(() {
          display = "device disconnected!";
        });
        break;
      case 'onReturnPowerOnIccResult':
        break;
      case 'onBluetoothBondTimeout':
        break;
      case 'onBluetoothBonded':
        break;
      case 'onReturnDownloadRsaPublicKey':
        break;
      case 'onReturnPowerOnNFCResult':
        break;
      case 'onConfirmAmountResult':
        break;
      case 'onQposIsCardExist':
        break;
      case 'onSearchMifareCardResult':
        break;
      case 'onReturnBatchSendAPDUResult':
        break;
      case 'onReturnApduResult':
        break;
      case 'onBatchReadMifareCardResult':
        break;
      case 'onSetBuzzerTimeResult':
        break;
      case 'onWriteBusinessCardResult':
        break;
      case 'onBatchWriteMifareCardResult':
        break;
      case 'onSetBuzzerResult':
        break;
      case 'onRequestSelectEmvApp':
        _flutterPluginQpos.selectEmvApp(1);

        break;
      case 'onLcdShowCustomDisplay':
        break;
      case 'onRequestQposConnected':
        setState(() {
          display = "device connected!";
        });
        break;
      case 'onUpdatePosFirmwareResult':
        concelFlag = true;
        if (pr.isShowing()) {
          pr.hide();
        }
        break;
      case 'onUpdatePosFirmwareProcessChanged':
        print('onUpdatePosFirmwareProcessChanged${parameters}');

        print('onUpdatePosFirmwareProcessChanged${double.parse(parameters)}');
        if (pr != null && pr.isShowing()) {
          pr.update(
            progress: double.parse(parameters),
            message: "Please wait...",
            progressWidget: Container(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator()),
            maxProgress: 100.0,
          );
        }
        break;

      case 'onReturnPowerOffNFCResult':
        break;
      case 'onReadBusinessCardResult':
        break;
      case 'onReturnPowerOffIccResult':
        break;
      case 'onSetBuzzerStatusResult':
        break;
      case 'onRequestTransactionLog':
        break;
      case 'onGetBuzzerStatusResult':
        break;
      case 'onSetManagementKey':
        break;
      case 'onUpdateMasterKeyResult':
        break;
      case 'onReturnUpdateIPEKResult':
        break;
      case 'onBluetoothBonding':
        break;
      case 'onSetParamsResult':
        break;
      case 'onReturnSetMasterKeyResult':
        break;
      case 'onReturnNFCApduResult':
        break;
      case 'onReturnCustomConfigResult':
        break;
      case 'onRequestUpdateWorkKeyResult':
        break;
      case 'onReturnUpdateEMVRIDResult':
        break;
      case 'onReturnReversalData':
        break;
      case 'onReturnUpdateEMVResult':
        break;
      case 'onBluetoothBoardStateResult':
        break;
      case 'onGetCardNoResult':
        break;
      case 'onRequestCalculateMac':
        break;
      case 'onRequestFinalConfirm':
        break;
      case 'onSetSleepModeTime':
        break;
      case 'onRequestSetAmount':
        Map<String, String> params = Map<String, String>();
        params['amount'] = "100";
        params['cashbackAmount'] = "";
        params['currencyCode'] = "156";
        params['transactionType'] = "GOODS";
        _flutterPluginQpos.setAmount(params);
        break;
      case 'onReturnGetEMVListResult':
        break;
      case 'onRequestDeviceScanFinished':
        setState(() {
          scanFinish = 1;
        });
        break;
      case 'onRequestSignatureResult':
        break;
      case 'onRequestIsServerConnected':
        break;
      case 'onRequestNoQposDetected':
        break;
      case 'onRequestOnlineProcess':
        String str = "8A023030"; //Currently the default value,
        _flutterPluginQpos.sendOnlineProcessResult(str); //脚本通知/55域/ICCDATA

        break;
      case 'onBluetoothBondFailed':
        break;
      case 'onWriteMifareCardResult':
        break;
      case 'onQposIsCardExistInOnlineProcess':
        break;
      case 'onSetPosBlePinCode':
        break;
      case 'onQposDoGetTradeLogNum':
        break;
      case 'onGetDevicePubKey':
        break;
      case 'onReturnGetQuickEmvResult':
        break;
      case 'onReturnSignature':
        break;
      case 'onReadMifareCardResult':
        break;
      case 'onOperateMifareCardResult':
        break;
      case 'getMifareFastReadData':
        break;
      case 'getMifareReadData':
        break;
      case 'getMifareCardVersion':
        break;
      case 'onFinishMifareCardResult':
        break;
      case 'onQposDoGetTradeLog':
        break;
      case 'onRequestUpdateKey':
        break;
      case 'onReturnSetAESResult':
        break;
      case 'onReturnAESTransmissonKeyResult':
        break;
      case 'onVerifyMifareCardResult':
        break;
      case 'onGetKeyCheckValue':
        break;
      case 'onReturnGetPinInputResult':
        setState(() {
          numPinField = int.parse(parameters);
        });
        break;
      case 'onRequestGenerateTransportKey':
        print(method);
        print(parameters);
        break;
      default:
        throw ArgumentError('error');
    }
  }

  void selectDevice() {
    // _flutterPluginQpos.requestPermission(communicationMode[10]);
    _flutterPluginQpos.init(communicationMode[10]);
    _flutterPluginQpos.scanQPos2Mode(20);
  }

  void openUart() {
    _flutterPluginQpos.init(communicationMode[2]);
    _flutterPluginQpos.openUart("/dev/ttyS1");
  }

  Widget _getListDate(BuildContext context, int position) {
    if (items != null) {
      return new FlatButton(
          onPressed: () => connectToDevice(items[position]),
          child: new Text("text ${items[position]}"));
    }
  }

  Widget getListSection() {
    if (items == null) {
      if (scanFinish == 0) {
        return new Text("");
      } else {
        if (scanFinish == -1)
          return new Center(child: new CircularProgressIndicator());
      }
    } else {
      if (scanFinish == 1) {
        Widget listSection = new ListView.builder(
          shrinkWrap: true,
          //解决无限高度问题
          physics: new NeverScrollableScrollPhysics(),
          padding: new EdgeInsets.all(5.0),
          itemExtent: 50.0,
          itemCount: items == null ? 0 : items.length,
          itemBuilder: (BuildContext context, int index) {
            return _getListDate(context, index);
          },
        );
        return listSection;
      } else {
        return new Center(child: new CircularProgressIndicator());
      }
    }
  }

  Widget getupdateSection() {
    if (_visibility) {
      return new LinearProgressIndicator(
        backgroundColor: Colors.blue,
        value: _updateValue,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
      );
    } else {
      return new Text("");
    }
  }

  operatUpdateProcess(ByteData value, BuildContext context) async {
    if (pr != null && pr.isShowing()) pr.hide();
    pr = new ProgressDialog(context, type: ProgressDialogType.Download);
    pr.style(
      message: 'Update Firmware...',
    );
    await pr.show();
    Uint8List list = value.buffer.asUint8List(0);
    var upContent = Utils.Uint8ListToHexStr(list);
    print("upContent:${upContent}");
    await _flutterPluginQpos.updatePosFirmware(upContent, _mAddress);
  }

  void updatePos(BuildContext context) async {
    DefaultAssetBundle.of(context).load('configs/upgrader.asc').then((value) {
      setState(() {
        _visibility = true;
      });

      operatUpdateProcess(value, context);

      print("点击事件结束");
    });
  }

  void onUpdateButtonSelected(String string, BuildContext context) {
    switch (string) {
      case "0":
        Future<ByteData> future =
            DefaultAssetBundle.of(context).load('configs/emv_capk.bin');
        DefaultAssetBundle.of(context)
            .load('configs/emv_app.bin')
            .then((value) {
          Uint8List list = value.buffer.asUint8List(0);
          var emvapp = Utils.Uint8ListToHexStr(list);
          print("emvConfig:${emvapp}");
          future.then((onValue) {
            Uint8List list = onValue.buffer.asUint8List(0);
            var emvcapk = Utils.Uint8ListToHexStr(list);
            print("emvConfig:${emvcapk}");
            _flutterPluginQpos.updateEmvConfig(emvapp, emvcapk);
          });
        });
        break;
      case "1":
        updatePos(context);
        break;
      case "2":
        _flutterPluginQpos.doUpdateIPEKOperation(
            0,
            "09118012400705E00000",
            "C22766F7379DD38AA5E1DA8C6AFA75AC",
            "B2DE27F60A443944",
            "09118012400705E00000",
            "C22766F7379DD38AA5E1DA8C6AFA75AC",
            "B2DE27F60A443944",
            "09118012400705E00000",
            "C22766F7379DD38AA5E1DA8C6AFA75AC",
            "B2DE27F60A443944");

        break;
      case "3":
        _flutterPluginQpos.setMasterKey(
            "1A4D672DCA6CB3351FD1B02B237AF9AE", "08D7B4FB629D0885", 0);

        break;
    }
  }

  void onDeviceInfoButtonSelected(String string, BuildContext context) {
    switch (string) {
      case "0":
        _flutterPluginQpos.getQposId();
        break;
      case "1":
        _flutterPluginQpos.getQposInfo();
        break;
      case "2":
        _flutterPluginQpos.getUpdateCheckValue();

        break;
      case "3":
        _flutterPluginQpos.getKeyCheckValue(0, 'DUKPT_MKSK_ALLTYPE');

        break;
    }
  }

  void _showKeyboard(BuildContext context, String parameters) {
    print("_showKeyboard:" + parameters);

    List<String> keyBoardList = new List();
    var paras = parameters.split("||");
    String keyMap = paras[0];

    for (int i = 0; i < keyMap.length; i += 2) {
      String keyValue = keyMap.substring(i, i + 2);
      print("POS" + keyValue);
      keyBoardList.add(int.parse(keyValue, radix: 16).toString());
    }

    for (int i = 0; i < keyBoardList.length; i++) {
      if (keyBoardList[i] == "13") {
        keyBoardList[i] = "cancel";
      } else if (keyBoardList[i] == "14") {
        keyBoardList[i] = "del";
      } else if (keyBoardList[i] == "15") {
        keyBoardList[i] = "confirm";
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return CustomKeyboard(
          pwdField: numPinField,
          initEvent: (value) {
            print("pinMapSync:" + value);
            _flutterPluginQpos.pinMapSync(value);
          },
          callback: (keyEvent) {
            if (keyEvent.isClose()) {
              print("POS keyEvent.isClose()");
              Navigator.pop(context);
            }
          },
          keyList: keyBoardList,
          keyHeight: 46,
          autoBack: false,
          onResult: (data) {
            Toast.show("POS onResult" + data, context,
                duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          },
        );
      },
    );
  }

  void requestSendCVV() async {
    final result = await _flutterPluginQpos.sendCvv("000");
    if (result) {
      print("Send cvv success");
      final data = await _flutterPluginQpos.getEncryptedDataBlock();
      print(data);
    } else {
      print("Send cvv fail");
    }
  }
}
