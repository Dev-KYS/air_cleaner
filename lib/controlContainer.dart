import 'package:air_cleaner/fanControllerBox.dart';
import 'package:air_cleaner/infoDisplayBox.dart';
import 'package:air_cleaner/status.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class ControlContainer extends StatefulWidget {
  ControlContainer({Key key, this.nowState, this.temp, this.humidity, this.sendData, this.nowColor}) : super(key: key);
  final ValueChanged<String> nowState;
  final ValueChanged<String> sendData;

  String nowColor;
  // 온도
  double temp;
  // 습도
  double humidity;

  @override
  _ControlContainerState createState() => _ControlContainerState();
}


class _ControlContainerState extends State<ControlContainer> {
  @override
  Widget build(BuildContext context) {

    return Container(
      color: HexColor(widget.nowColor),
      // padding: const EdgeInsets.only(top: 35.0, bottom: 25.0, left: 25.0, right: 25.0),
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
      alignment: Alignment.center,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InfoDisplayBox(
                    title: '온도 (℃)',
                    value: widget.temp,
                  ),
                  InfoDisplayBox(
                    title: '습도 (%)',
                    value: widget.humidity,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: FanControllerBox(
                    nowState: widget.nowState,
                    nowColor: widget.nowColor,
                    sendData: widget.sendData
                ),
              ),
            )
          ]
      ),
    );
  }
}