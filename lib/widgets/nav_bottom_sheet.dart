import 'dart:async';
import 'package:flutter/material.dart';
import '../common/index.dart' show TransparentRoute;

Future showNavBottomSheet({
  @required BuildContext context,
  @required NavBottomSheetController navBottomSheetController,
  bool isDismissible = false,
  Color backdropColor = Colors.transparent,
  double bottomSheetHeight = 320.0,
  bool bottomSheetBodyHasScrollView,
  ScrollController bottomSheetBodyScrollController,
  Widget bottomSheetHeader,
  Widget bottomSheetBody,
}) {
  assert(context != null);
  assert(navBottomSheetController != null);
  if (bottomSheetBodyHasScrollView && bottomSheetBodyScrollController == null) {
    assert(bottomSheetBodyScrollController != null);
    // return null;
  }
  if (bottomSheetBodyScrollController != null &&
      bottomSheetBodyHasScrollView == null) {
    assert(bottomSheetBodyHasScrollView != null);
    // return null;
  }

  double maxHeight =
      MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
  bottomSheetHeight =
      bottomSheetHeight > maxHeight ? maxHeight : bottomSheetHeight;

  return Navigator.of(context).push(TransparentRoute(
      builder: (BuildContext context) => TestPage(
          navBottomSheetController: navBottomSheetController,
          isDismissible: isDismissible,
          backdropColor: backdropColor,
          bottomSheetHeight: bottomSheetHeight,
          bottomSheetHeader: bottomSheetHeader,
          bottomSheetBodyHasScrollView: bottomSheetBodyHasScrollView,
          bottomSheetBodyScrollController: bottomSheetBodyScrollController,
          bottomSheetBody: bottomSheetBody)));
}

class TestPage extends StatefulWidget {
  final NavBottomSheetController navBottomSheetController;
  final bool isDismissible;
  final Color backdropColor;
  final Widget bottomSheetHeader;
  final double bottomSheetHeight;
  final Widget bottomSheetBody;
  final bool bottomSheetBodyHasScrollView;
  final ScrollController bottomSheetBodyScrollController;

  const TestPage(
      {Key key,
      this.navBottomSheetController,
      this.isDismissible,
      this.backdropColor,
      this.bottomSheetHeader,
      this.bottomSheetHeight,
      this.bottomSheetBody,
      this.bottomSheetBodyHasScrollView,
      this.bottomSheetBodyScrollController})
      : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin {
  NavBottomSheetController get _navBottomSheetController =>
      widget.navBottomSheetController;
  AnimationController _animationController;
  ScrollController get _scrollController =>
      widget.bottomSheetBodyScrollController;
  CurvedAnimation _curve;
  Animation<double> _animation;
  double _scrollOffset = 0.0;
  double _offset = 0.0;
  bool _isBacked = false;

  ScrollHoldController _hold;
  void _disposeHold() {
    _hold = null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _offset = widget.bottomSheetHeight;
    _navBottomSheetController.addListener(_navBottomSheetControllerListener);
    _scrollController.addListener(_scrollControllerListener);
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

    _updateOffset(widget.bottomSheetHeight, 0.0);
  }

  _navBottomSheetControllerListener() {
    if (_navBottomSheetController.eventType == 'close') {
      if (_offset == 0.0) {
        _updateOffset(0.0, widget.bottomSheetHeight);
      }
    }
  }

  _scrollControllerListener() {
    _scrollOffset = _scrollController.position.pixels;
    if (_scrollOffset < 0) {
      _scrollController.jumpTo(0);
      _hold = _scrollController.position.hold(_disposeHold);
    }
  }

  _updateOffset(double begin, double end) {
    _animationController.value = 0.0;
    _animation = Tween(begin: begin, end: end).animate(_curve)
      ..addListener(() {
        _offset = _animation.value;
        setState(() {});
      });
    _animationController.forward();
    Timer(Duration(milliseconds: 350), () {
      if (end >= widget.bottomSheetHeight && !_isBacked) {
        _isBacked = true;
        setState(() {});
        Navigator.of(context).pop(_navBottomSheetController.parameter);
        _scrollController.removeListener(_scrollControllerListener);
        _navBottomSheetController
            .removeListener(_navBottomSheetControllerListener);
      }
    });
  }

  _onPointerMove(PointerMoveEvent e, [bool flag = false]) {
    if (_scrollOffset <= 0 && e.delta.dy > 0 || flag) {
      _offset += e.delta.dy;
    } else if (e.delta.dy < 0 && _offset > 0) {
      _offset += e.delta.dy;
    }

    if (_offset < 0) {
      _offset = 0.0;
    }
    setState(() {});
  }

  _onPointerUp(PointerUpEvent e) {
    if (_offset == 0) {
      return;
    }
    // print('===========: $_offset');
    if (_offset >= widget.bottomSheetHeight * 0.4) {
      _updateOffset(_offset, widget.bottomSheetHeight);
    } else {
      _updateOffset(_offset, 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: Material(
        color: _offset == 0 ? widget.backdropColor : Colors.transparent,
        child: Column(
          children: <Widget>[
            Expanded(
              child: widget.isDismissible
                  ? GestureDetector(
                      onTap: () {
                        _updateOffset(_offset, widget.bottomSheetHeight);
                      },
                    )
                  : Container(),
            ),
            Transform.translate(
              offset: Offset(0.0, _offset),
              child: Container(
                color: Colors.transparent,
                height: widget.bottomSheetHeight,
                child: Column(
                  children: <Widget>[
                    widget.bottomSheetHeader == null
                        ? Container()
                        : Listener(
                            onPointerMove: (PointerMoveEvent e) {
                              _onPointerMove(e, true);
                            },
                            onPointerUp: _onPointerUp,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: widget.bottomSheetHeader,
                                )
                              ],
                            ),
                          ),
                    Expanded(
                      child: Listener(
                        onPointerMove: _onPointerMove,
                        onPointerUp: _onPointerUp,
                        child: widget.bottomSheetBody == null
                            ? Container()
                            : widget.bottomSheetBody,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavBottomSheetController extends ChangeNotifier {
  dynamic _parameter;
  String _eventType;
  String get eventType => this._eventType;
  dynamic get parameter => this._parameter;

  close([dynamic parameter]) {
    this._parameter = parameter;
    this._eventType = 'close';
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
