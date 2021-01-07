import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

void main() {
  runApp(MyApp());
}

const GOOD_STATUS = '#7ca9d6';
const NORMAL_STATUS = '#7cd6c4';
const BAD_STATUS = '#ffcf5e';
const VERY_BAD_STATUS = '#c92929';

var NOW_STATUS = BAD_STATUS;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: '공기청정기',
      home: Scaffold(
        body: SafeArea(
          child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      TitleContainer,
                      Stack(
                        children: [
                          Positioned(
                            child: Align(
                              child: SizedBox(
                                width: 270,
                                height: 270,
                                child: Image.asset(
                                  'assets/images/status-good-bg.png',
                                  color: Colors.blue,
                                ),
                              ),
                            )
                          ),
                          Positioned(
                            child: Align(
                              alignment: Alignment.center,
                              child: displayStatus,
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ),
                Expanded(
                  flex: 1,
                  child: ControllerContainer,
                )
              ],
          ),
        ),
      )
    );
  }

  Widget TitleContainer = Container(
    margin: const EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('아두이노\n공기청정기', style: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.normal,
          color: HexColor(NOW_STATUS),
          fontFamily: 'YangJin',
          height: 1.4
        )),
        Column(
         children: [
           Container(
             margin: EdgeInsets.only(bottom: 10.0),
             child: Material(
               type: MaterialType.transparency,
               child: Ink(
                 decoration: BoxDecoration(
                   border: Border.all(color: HexColor(NOW_STATUS), width: 2.0),
                   color: Colors.white,
                   shape: BoxShape.circle,
                 ),
                 child: InkWell(
                   borderRadius: BorderRadius.circular(1000.0),
                   child: Padding(
                     padding: EdgeInsets.all(10.0),
                     child: Icon(
                       Icons.power_settings_new,
                       size: 35,
                       color: HexColor(NOW_STATUS),
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
                   border: Border.all(color: HexColor(NOW_STATUS), width: 2.0),
                   color: Colors.white,
                   shape: BoxShape.circle,
                 ),
                 child: InkWell(
                   borderRadius: BorderRadius.circular(1000.0),
                   child: Padding(
                     padding: EdgeInsets.all(10.0),
                     child: Icon(
                       Icons.bluetooth,
                       size: 35,
                       color: HexColor(NOW_STATUS),
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


  Widget displayStatus = Container(
    width: 160,
    height: 160,
    margin: const EdgeInsets.only(top: 50),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: HexColor(NOW_STATUS)
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
                 fontWeight: FontWeight.bold,
               ), textAlign: TextAlign.center,
               ),
               SizedBox(
                 height: 40,
                 width: 40,
                 child: Image.asset('assets/images/status-good.png'),
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
            child: Text('좋음', style: TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontFamily: 'YangJin'
            )),
          )
        ],
      )
    )
  );

  static Widget InfoDisplayBox(label, value) {
    return Container(
      width: 180,
      height: 180,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8.0),
            child: Text(
                label.toString(),
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                )
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 8.0),
            child: const Divider(
              color: Colors.white,
              height: 1,
              thickness: 1,
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 70,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'YangJin'
            )
          ),
        ],
      )
    );
  }

  static Widget FanControllerBox() {
    return Container (
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 7.0),
            child: Text('팬 속도', style: TextStyle(fontSize: 30, color: Colors.white),),
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
              FanControllerButton('1'),
              FanControllerButton('2'),
              FanControllerButton('3'),
              FanControllerButton('4'),
              FanControllerButton('5')
            ],
          )
        ],
      ),
    );
  }

  static Widget FanControllerButton(num) {
    return FlatButton(
      padding: const EdgeInsets.all(1),
      color: Colors.transparent,
      minWidth: 60,
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Text(
            num.toString(),
            style: TextStyle(
                fontSize: 32,
                color: HexColor(NOW_STATUS), fontWeight: FontWeight.bold, fontFamily: 'YangJin')
        ),
      ),
    );
  }

  Widget ControllerContainer = Container(
    color: HexColor(NOW_STATUS),
    margin: const EdgeInsets.only(top: 50),
    padding: const EdgeInsets.only(top: 35.0, bottom: 25.0, left: 25.0, right: 25.0),
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InfoDisplayBox('온도 (℃)', '20'),
            InfoDisplayBox('습도 (%)', '40'),
          ],
        ),
        Container(
          child: FanControllerBox(),
        )
      ]
    ),
  );
}
