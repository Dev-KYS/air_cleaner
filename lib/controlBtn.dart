import 'package:air_cleaner/main.dart';
import 'package:air_cleaner/status.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


const GOOD_STATUS = '#7ca9d6';
const NORMAL_STATUS = '#7cd6c4';
const BAD_STATUS = '#ffcf5e';
const VERY_BAD_STATUS = '#c92929';

class FanControlBtn extends StatefulWidget {
  FanControlBtn({Key key, this.stepNum, this.sendData, this.nowState, this.nowColor}) : super(key: key);
  var stepNum;
  final ValueChanged<String> nowState;
  final ValueChanged<String> sendData;
  String nowColor;

  @override
  _FanControlState createState() => _FanControlState();
}

class _FanControlState extends State<FanControlBtn> {
  Status status = new Status();
  void sendData() {
    if(widget.stepNum == '1') {
      // widget.nowState(GOOD_STATUS);
      widget.sendData('b');
    }else if(widget.stepNum == '2') {
      // widget.nowState(NORMAL_STATUS);
      widget.sendData('c');
    }else if(widget.stepNum == '3') {
      // widget.nowState(BAD_STATUS);
      widget.sendData('d');
    }else if(widget.stepNum == '4') {
      // widget.nowState(VERY_BAD_STATUS);
      widget.sendData('e');
    }else if(widget.stepNum == 'Auto') {
      widget.sendData('f');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: const EdgeInsets.all(1),
      color: Colors.transparent,
      minWidth: 60,
      onPressed: () => {
        sendData()
      },
      child: Container(
        width: 45,
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Text(
            widget.stepNum,
            style: TextStyle(
                // fontSize: 32,
                fontSize: widget.stepNum == "Auto" ? 15 : 22,
                color: HexColor(widget.nowColor),
                fontWeight: FontWeight.bold,
                fontFamily: 'YangJin'
            )
        ),
      ),
    );
  }
}