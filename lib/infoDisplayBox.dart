import 'package:air_cleaner/status.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class InfoDisplayBox extends StatefulWidget {
  InfoDisplayBox({Key key, this.title, this.value}) : super(key: key);

  String title;
  double value;

  @override
  _InfoDisplayBoxState createState() => _InfoDisplayBoxState();
}


class _InfoDisplayBoxState extends State<InfoDisplayBox> {

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Expanded(
      flex: 1,
        child: Container(
          alignment: Alignment.center,
          // padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
          margin: const EdgeInsets.all(5),
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
                    widget.title.toString(),
                    style: TextStyle(
                        fontSize: 15,
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
                  widget.value.toString(),
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'YangJin'
                  )
              ),
            ],
          ),
        )
    );
  }
}