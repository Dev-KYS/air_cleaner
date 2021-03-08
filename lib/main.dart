import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:air_cleaner/controlContainer.dart';
import 'package:air_cleaner/status.dart';
import 'package:air_cleaner/title.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

import 'displayStatus.dart';

void main() {
  runApp(MyApp());
}

const GOOD_STATUS = '#7ca9d6';
const NORMAL_STATUS = '#7cd6c4';
const BAD_STATUS = '#ffcf5e';
const VERY_BAD_STATUS = '#c92929';

class MyApp extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MyApp> {
  Status status = new Status();
  // Track the Bluetooth connection with the remote device
  BluetoothConnection connection;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothDevice _device;

  int _deviceState;
  bool _connected = false;
  bool _isButtonUnavailable = false;
  bool isDisconnecting = false;
  bool get isConnected => connection != null && connection.isConnected;

  double temp = 0;
  double humidity = 0;
  String tempString = "";
  StreamController streamController;

  // widget build
  @override
  Widget build(BuildContext context) {
    // state init
    @override
    void initState() {
      super.initState();
      status.nowStatus = GOOD_STATUS;
      temp = 0;
      humidity = 0;
    }

    // _sendOnMessageToBluetooth();
    // print(_device.address);
    // readData(connection);
    return MaterialApp(
        title: '공기청정기',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TitleWidget(
                            nowStatus: status.nowStatus,
                            connect: _connect,
                            device: deviceState,
                            sendData: _sendOnMessageToBluetooth,
                            connected: _connected,
                            disconnect: _disconnect,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            // padding: EdgeInsets.only(bottom: 20),
                            child: Stack(
                              children: [
                                Center(
                                  // alignment: Alignment.center,
                                  // top: 30,
                                  // left: 65,
                                  child: SizedBox(
                                    width: 250,
                                    height: 250,
                                    child: Image.asset(
                                      'assets/images/status-bg.png',
                                      color: HexColor(status.nowStatus),
                                      colorBlendMode: BlendMode.modulate,
                                    ),
                                  ),
                                ),
                                Center(
                                  // top: 15,
                                  // left: 100,
                                  child: displayStatus(
                                    nowState: status.nowStatus,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                Expanded(
                  flex: 3,
                  child: ControlContainer(
                    nowState: stateChange,
                    nowColor: status.nowStatus,
                    temp: temp,
                    humidity: humidity,
                    sendData: _sendOnMessageToBluetooth,
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  void blueState(BluetoothConnection _connection) {
    print('connect is active');
    setState(() {
      connection = _connection;
    });
  }

  void deviceState(BluetoothDevice device) {
    setState(() {
      _device = device;
      _connected = true;
    });
    // readData(connection);
    print("device connect by arduino address : ${_device.address}");
  }


  void displayStatusChange(tem, hum) {
    setState(() {
      temp = tem;
      humidity = hum;
    });
  }

  // state change method
  void stateChange(nowColor) {
    setState(() {
      status.nowStatus = nowColor;
    });
  }

  void _sendOnMessageToBluetooth(String sendData) async {
    if(_connected == true) {
      connection.output.add(utf8.encode(sendData + "\r\n"));
      await connection.output.allSent;
    }
  }

  void bleMessageChange(data) {
    String localValue = "";
    print(data);
    if(data.contains('}')) {
      localValue += tempString + data.split('}')[0] + '}';
      setState(() {
        tempString = data.split('}')[1];
        // tempString += data.split('}')[0];
        // tempString += '}';
      });
      // print(tempString);
      // String test = '{"test": 10, "test1": "test"}';
      var jsonText = localValue.replaceAll('NAN', '0').toLowerCase();
      var jsonData = jsonDecode(jsonText.toString());
      // var jsonData = json.decode(tempString);
      print(jsonData);
      var temp;
      var hum;
      if(jsonData['temp'] == 'NAN') {
        temp = 0;
      }else{
        temp = jsonData['temp'];
      }
      if(jsonData['hum'] == 'NAN') {
        hum = 0;
      }else{
        hum = jsonData['hum'];
      }
      displayStatusChange(temp, hum);
      switch(jsonData['state']) {
        case 'good':
          stateChange(GOOD_STATUS);
          break;
        case 'moderate':
          stateChange(NORMAL_STATUS);
          break;
        case 'bad':
          stateChange(BAD_STATUS);
          break;
        case 'very bad':
          stateChange(VERY_BAD_STATUS);
          break;
        default:
          stateChange(NORMAL_STATUS);
      }
    }else{
      setState(() {
        tempString += data;
      });
    }
  }


  // Future<void> readData(bleConnection) async {
  //   bleConnection.input.listen((Uint8List data) {
  //     print('Data incoming: ${ascii.decode(data)}');
  //   }).onDone(() {
  //     print('Disconnected by remote request');
  //   });
  // }


  void _connect(BluetoothDevice device) async {
    print(device.address);

    setState(() {
      _isButtonUnavailable = true;
    });
    if (device == null) {
      print('No device selected is main dart');
    } else {
      if (!isConnected) {
        Fluttertoast.showToast(
            msg: '디바이스와 연결되었습니다'
        );
        await BluetoothConnection.toAddress(device.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection.input.listen((Uint8List data) {
            print('ss');
            print(ascii.decode(data));
            setState(() {
              bleMessageChange(ascii.decode(data));
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {

            });
          }).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              Fluttertoast.showToast(
                msg: '블루투스 연결이 해제되었습니다'
              );
              print('Disconnected remotely!');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred error : $error');
        });
        print('Device connected');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }


  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection.close();
    Fluttertoast.showToast(
      msg: '블루투스 연결이 해제되었습니다'
    );
    if (!connection.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    String tempText;
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }
    // print(buffer);
  }
}
