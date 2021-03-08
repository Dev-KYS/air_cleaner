import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

// For using PlatformException
import 'package:air_cleaner/main.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';


class BleSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Air Puri',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BluetoothApp(),
    );
  }
}

class BluetoothApp extends StatefulWidget {
  BluetoothApp({Key key, this.bluetoothState, this.connected, this.disconnect, this.device, this.bluetooth, this.bleConnection}) : super(key: key);
  final ValueChanged<BluetoothState> bluetoothState;
  final ValueChanged<FlutterBluetoothSerial> bluetooth;
  // BluetoothConnection connection;
  final ValueChanged<BluetoothDevice> bleConnection;
  final ValueChanged<BluetoothDevice> device;
  var disconnect;
  bool connected;

  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  // Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection connection;

  int _deviceState;

  bool isDisconnecting = false;

  Map<String, Color> colors = {
    'onBorderColor': Colors.green,
    'offBorderColor': Colors.red,
    'neutralBorderColor': Colors.transparent,
    'onTextColor': Colors.green[700],
    'offTextColor': Colors.red[700],
    'neutralTextColor': Colors.blue,
  };

  // To track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection.isConnected;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  // bool _connected = widget.connected;
  bool _isButtonUnavailable = false;

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
        widget.bluetoothState(state);
      });
    });

    _deviceState = 0; // neutral

    // If the bluetooth of the device is not enabled,
    // then request permission to turn on bluetooth
    // as the app starts up
    enableBluetooth();

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  // Request Bluetooth permission from the user
  Future<void> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  // For retrieving and storing the paired devices
  // in a list.
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  // Now, its time to build the UI
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Air Furi"),
          backgroundColor: Colors.deepPurple,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              label: Text(
                "새로고침",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              splashColor: Colors.deepPurple,
              onPressed: () async {
                // So, that when new devices are paired
                // while the app is running, user can refresh
                // the paired devices list.
                await getPairedDevices().then((_) {
                  show('블루투스 목록을 갱신했습니다.');
                });
              },
            ),
          ],
        ),
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Visibility(
                visible: _isButtonUnavailable &&
                    _bluetoothState == BluetoothState.STATE_ON,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.yellow,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: [
                          Icon(
                            Icons.bluetooth,
                            color: HexColor('#7ca9d6'),
                            size: 50,
                          ),
                          Text(
                              'Bluetooth',
                              style: TextStyle(
                                color: HexColor('#7ca9d6'),
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              )),
                          Switch(
                            value: _bluetoothState.isEnabled,
                            onChanged: (bool value) {
                              future() async {
                                if (value) {
                                  await FlutterBluetoothSerial.instance
                                      .requestEnable();
                                } else {
                                  await FlutterBluetoothSerial.instance
                                      .requestDisable();
                                }

                                await getPairedDevices();
                                _isButtonUnavailable = false;

                                if (widget.connected) {
                                  _disconnect();
                                }
                              }

                              future().then((_) {
                                setState(() {});
                              });
                            },
                          ),
                          Text(
                            '\'Air Furi\'로 현재 인식 가능합니다',
                            style: TextStyle(
                              color: HexColor('#7ca9d6'),
                              fontSize: 18
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 60),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          child: DropdownButton(
                            isExpanded: true,
                            items: _getDeviceItems(),
                            onChanged: (value) =>
                                setState(() => _device = value),
                            value: _devicesList.isNotEmpty ? _device : null,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: OutlineButton(
                          borderSide: BorderSide(
                              color: HexColor('#7ca9d6'),
                              width: 1
                          ),
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5)),
                          onPressed: _isButtonUnavailable
                              ? null
                              : widget.connected ? widget.disconnect : _connect,
                          child: Text(widget.connected ? '해제' : '연결', style: TextStyle(color: HexColor('#7ca9d6')),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "블루투스 기기가 등록이 안되었다면\n설정에서 등록을 진행해주세요",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: HexColor('#7ca9d6'),
                          ),
                        ),
                        SizedBox(height: 15),
                        OutlineButton(
                          borderSide: BorderSide(
                            color: HexColor('#7ca9d6'),
                            width: 1,
                          ),
                          color: HexColor('#e7edf3'),
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5)),
                          child: Text("Bluetooth Settings", style: TextStyle(color: HexColor('#7ca9d6')),),
                          onPressed: () {
                            FlutterBluetoothSerial.instance.openSettings();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Create the List of devices to be shown in Dropdown Menu
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  // Method to connect to bluetooth
  void _connect() async {
    widget.bleConnection(_device);

    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(
    //         builder: (context) => MyApp()),
    //         (Route<dynamic> route) => false);
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
        widget.connected = false;
        _isButtonUnavailable = false;
      });
    }
  }


  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
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
  }

  // Method to disconnect bluetooth
  // void _disconnect() async {
  //   setState(() {
  //     _isButtonUnavailable = true;
  //     _deviceState = 0;
  //   });
  //
  //   await connection.close();
  //   show('Device disconnected');
  //   if (!connection.isConnected) {
  //     setState(() {
  //       _connected = false;
  //       _isButtonUnavailable = false;
  //     });
  //   }
  // }

  // Method to send message,
  // for turning the Bluetooth device on
  void _sendOnMessageToBluetooth() async {
    connection.output.add(utf8.encode("1" + "\r\n"));
    await connection.output.allSent;
    show('Device Turned On');
    setState(() {
      _deviceState = 1; // device on
    });
  }

  // Method to send message,
  // for turning the Bluetooth device off
  void _sendOffMessageToBluetooth() async {
    connection.output.add(utf8.encode("0" + "\r\n"));
    await connection.output.allSent;
    show('Device Turned Off');
    setState(() {
      _deviceState = -1; // device off
    });
  }

  // Method to show a Snackbar,
  // taking message as the text
  Future show(
      String message, {
        Duration duration: const Duration(seconds: 3),
      }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}