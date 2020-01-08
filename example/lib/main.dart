import 'package:flutter/material.dart';
import './stack_bottom_sheet_test.dart';
import './nav_bottom_sheet_test.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo'),
      ),
      body: ListView(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return StackBottomSheetTest();
              }));
            },
            child: Text('StackBottomSheet'),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NavBottomSheetTest();
              }));
            },
            child: Text('NavBottomSheet'),
          )
        ],
      ),
    );
  }
}
