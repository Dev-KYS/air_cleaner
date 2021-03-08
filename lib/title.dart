import 'dart:convert';

import 'package:air_cleaner/bleSearch.dart';
import 'package:air_cleaner/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:hexcolor/hexcolor.dart';


class TitleWidget extends StatefulWidget {
  TitleWidget({Key key, this.nowStatus, this.disconnect, this.connected, this.sendData, this.connect, this.device}) : super(key: key);
  String nowStatus;
  // BluetoothConnection connection;
  final ValueChanged<BluetoothDevice> connect;
  final ValueChanged<BluetoothDevice> device;
  final ValueChanged<String> sendData;
  var disconnect;
  bool connected;

  @override
  _TitleWidgetState createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  Status status = new Status();

  void _sendData(data) {
    widget.sendData(data);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Air-V Puri\n공기청정기', style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
              color: HexColor(widget.nowStatus),
              fontFamily: 'YangJin',
              height: 1.4
          )),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10.0),
                child: Material(
                  type: MaterialType.transparency,
                  child: Ink(
                    decoration: BoxDecoration(
                      border: Border.all(color: HexColor(widget.nowStatus), width: 2.0),
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(1000.0),
                      onTap: () {
                        // _sendOnMessageToBluetooth();
                        _sendData('a');
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.power_settings_new,
                          size: 20,
                          color: HexColor(widget.nowStatus),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Material(
                  type: MaterialType.transparency,
                  child: Ink(
                    decoration: BoxDecoration(
                      border: Border.all(color: HexColor(widget.nowStatus), width: 2.0),
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(1000.0),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BluetoothApp(
                                  bleConnection: widget.connect,
                                  device: widget.device,
                                  connected: widget.connected,
                                  disconnect: widget.disconnect
                                )));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.bluetooth,
                          size: 20,
                          color: HexColor(widget.nowStatus),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}