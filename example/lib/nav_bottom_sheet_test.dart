import 'package:flutter/material.dart';
import 'package:bottom_sheet_x/bottom_sheet_x.dart';

class NavBottomSheetTest extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final NavBottomSheetController _navBottomSheetController =
      NavBottomSheetController();

  @override
  Widget build(BuildContext context) {
    Widget _bottomSheetHeader = ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Container(
        color: Colors.red.withOpacity(0.8),
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 6.0,
              width: 100.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Widget _bottomSheetBody = ListView(
      controller: _scrollController,
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            _navBottomSheetController.close({'name': 'lili', 'age': 18});
          },
          child: Text('close navBottomSheet'),
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
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('NavBottomSheet'),
      ),
      body: ListView(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              showNavBottomSheet(
                context: context,
                navBottomSheetController: _navBottomSheetController,
                isDismissible: true,
                backdropColor: Colors.white.withOpacity(0.1),
                bottomSheetHeight: 360.0,
                bottomSheetBodyHasScrollView: true,
                bottomSheetBodyScrollController: _scrollController,
                bottomSheetHeader: _bottomSheetHeader,
                bottomSheetBody: _bottomSheetBody,
              ).then((onValue) {
                print(onValue);
              });
            },
            child: Text('show navBottomSheet'),
          ),
          Image.network(
              'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1578456212691&di=9c441493ee0206b788cfad871aa1055a&imgtype=0&src=http%3A%2F%2Ft8.baidu.com%2Fit%2Fu%3D1484500186%2C1503043093%26fm%3D79%26app%3D86%26f%3DJPEG%3Fw%3D1280%26h%3D853'),
          Image.network(
              'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1578456212691&di=dc56929190653756f42d05b6a46fdd7e&imgtype=0&src=http%3A%2F%2Ft8.baidu.com%2Fit%2Fu%3D2247852322%2C986532796%26fm%3D79%26app%3D86%26f%3DJPEG%3Fw%3D1280%26h%3D853'),
          Image.network(
              'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1578456212691&di=969bacdbb32609172acdc0b08c181b46&imgtype=0&src=http%3A%2F%2Ft9.baidu.com%2Fit%2Fu%3D583874135%2C70653437%26fm%3D79%26app%3D86%26f%3DJPEG%3Fw%3D3607%26h%3D2408'),
          Image.network(
              'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1578456212690&di=89a37618fdf6468215a3d7c957e1effe&imgtype=0&src=http%3A%2F%2Ft9.baidu.com%2Fit%2Fu%3D2268908537%2C2815455140%26fm%3D79%26app%3D86%26f%3DJPEG%3Fw%3D1280%26h%3D719'),
          Image.network(
              'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1578456301874&di=91e5d32f15e303c1ba869adb7b7b550a&imgtype=0&src=http%3A%2F%2Ft9.baidu.com%2Fit%2Fu%3D3949188917%2C63856583%26fm%3D79%26app%3D86%26f%3DJPEG%3Fw%3D1280%26h%3D875'),
          Image.network(
              'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1578456212689&di=a907d731b6eaebde3509f58c5a830a23&imgtype=0&src=http%3A%2F%2Ft8.baidu.com%2Fit%2Fu%3D2857883419%2C1187496708%26fm%3D79%26app%3D86%26f%3DJPEG%3Fw%3D1280%26h%3D763'),
        ],
      ),
    );
  }
}
