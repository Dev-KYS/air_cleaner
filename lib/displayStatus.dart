import 'package:air_cleaner/status.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

const GOOD_STATUS = '#7ca9d6';
const NORMAL_STATUS = '#7cd6c4';
const BAD_STATUS = '#ffcf5e';
const VERY_BAD_STATUS = '#c92929';

class displayStatus extends StatefulWidget {
  displayStatus({Key key, this.nowState}) : super(key: key);
  String nowState;

  @override
  _displayStatusState createState() => _displayStatusState();
}


class _displayStatusState extends State<displayStatus> {
  final String goodIcon = 'assets/images/status-good.png';
  final String normalIcon = 'assets/images/status-normal.png';
  final String badIcon = 'assets/images/status-bad.png';
  final String verybadIcon = 'assets/images/status-verybad.png';

  String nowIcon;
  String nowText;
  double nowTextSize;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    if(widget.nowState == GOOD_STATUS) {
      nowIcon = goodIcon;
      nowText = '좋음';
      nowTextSize = 40.0;
    }else if(widget.nowState == NORMAL_STATUS) {
      nowIcon = normalIcon;
      nowText = '보통';
      nowTextSize = 40.0;
    }else if(widget.nowState == BAD_STATUS) {
      nowIcon = badIcon;
      nowText = '나쁨';
      nowTextSize = 40.0;
    }else if(widget.nowState == VERY_BAD_STATUS){
      nowIcon = verybadIcon;
      nowText = '매우나쁨';
      nowTextSize = 28;
    }

    return Container(
        width: width / 2.5,
        height: width / 2.5,
        // margin: const EdgeInsets.only(top: 50),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: HexColor(widget.nowState)
        ),
        child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('청정도', style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.asset(nowIcon),
                        )
                      ],
                    )
                ),
                Container(
                  width: 100,
                  margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: const Divider(
                    color: Colors.white,
                    height: 1,
                    thickness: 1,
                  ),
                ),
                Container(
                  child: Text(nowText, style: TextStyle(
                      fontSize: nowTextSize,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'YangJin'
                  )),
                )
              ],
            )
        )
    );
  }
}