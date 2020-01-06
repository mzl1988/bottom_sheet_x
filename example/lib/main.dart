import 'package:flutter/material.dart';
import 'package:bottom_sheet_x/bottom_sheet_x.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatelessWidget {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                showNavBottomSheet(
                  context: context,
                  backdropColor: Colors.white.withOpacity(0.2),
                  backgroundColor: Colors.red,
                  height: 360.0,
                  hasScrollView: true,
                  scrollController: _scrollController,
                  header: Container(
                    color: Colors.grey[300],
                    height: 50.0,
                    child: Text('Header'),
                  ),
                  body: ListView(
                    controller: _scrollController,
                    children: <Widget>[
                      Container(
                        color: Colors.yellow,
                        height: 200.0,
                        child: Text('data'),
                      ),
                      Container(
                        color: Colors.green,
                        height: 200.0,
                        child: Text('data'),
                      ),
                      Container(
                        color: Colors.indigo,
                        height: 200.0,
                        child: Text('data'),
                      ),
                      Container(
                        color: Colors.yellow,
                        height: 200.0,
                        child: Text('data'),
                      ),
                      Container(
                        color: Colors.green,
                        height: 200.0,
                        child: Text('data'),
                      ),
                      Container(
                        color: Colors.indigo,
                        height: 200.0,
                        child: Text('data'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('navBottomSheet'),
            )
          ],
        ),
      ),
    );
  }
}
