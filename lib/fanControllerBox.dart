import 'package:air_cleaner/controlBtn.dart';
import 'package:air_cleaner/status.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class FanControllerBox extends StatefulWidget {
  FanControllerBox({this.nowState, this.sendData, this.nowColor});
  final ValueChanged<String> nowState;
  final ValueChanged<String> sendData;
  String nowColor;

  @override
  _FanControllerBoxState createState() => _FanControllerBoxState();
}


class _FanControllerBoxState extends State<FanControllerBox> {
  @override
  Widget build(BuildContext context) {
    return Container (
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 7.0),
            child: Text('팬 속도', style: TextStyle(fontSize: 20, color: Colors.white),),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: const Divider(
              color: Colors.white,
              height: 1,
              thickness: 1,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: FanControlBtn(
                  stepNum: 'Auto',
                  nowState: widget.nowState,
                  nowColor: widget.nowColor,
                  sendData: widget.sendData,
                ),
              ),
              Expanded(
                flex: 1,
                child: FanControlBtn(
                  stepNum: '1',
                  nowState: widget.nowState,
                  nowColor: widget.nowColor,
                  sendData: widget.sendData,
                ),
              ),
              Expanded(
                flex: 1,
                child: FanControlBtn(
                  stepNum: '2',
                  nowState: widget.nowState,
                  nowColor: widget.nowColor,
                  sendData: widget.sendData,
                ),
              ),
              Expanded(
                flex: 1,
                child: FanControlBtn(
                  stepNum: '3',
                  nowState: widget.nowState,
                  nowColor: widget.nowColor,
                  sendData: widget.sendData,
                ),
              ),
              Expanded(
                flex: 1,
                child: FanControlBtn(
                  stepNum: '4',
                  nowState: widget.nowState,
                  nowColor: widget.nowColor,
                  sendData: widget.sendData,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}