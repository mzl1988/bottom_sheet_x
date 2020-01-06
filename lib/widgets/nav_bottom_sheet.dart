import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../common/index.dart' show TransparentRoute;

showNavBottomSheet({
  @required BuildContext context,
  Color backdropColor,
  Color backgroundColor,
  double height,
  bool hasScrollView,
  ScrollController scrollController,
  Widget header,
  Widget body,
}) {
  assert(context != null);
  if (hasScrollView && scrollController == null) {
    assert(scrollController != null);
    return;
  }
  if (scrollController != null && hasScrollView == null) {
    assert(hasScrollView != null);
    return;
  }
  Navigator.of(context).push(TransparentRoute(
      builder: (BuildContext context) => TestPage(
          backdropColor: backdropColor,
          backgroundColor: backgroundColor,
          height: height,
          header: header,
          hasScrollView: hasScrollView,
          scrollController: scrollController,
          body: body)));
}

class TestPage extends StatefulWidget {
  final Color backdropColor;
  final Color backgroundColor;
  final Widget header;
  final double height;
  final Widget body;
  final bool hasScrollView;
  final ScrollController scrollController;

  const TestPage(
      {Key key,
      this.backdropColor,
      this.backgroundColor,
      this.header,
      this.height,
      this.body,
      this.hasScrollView,
      this.scrollController})
      : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin {
  AnimationController _animationController;
  ScrollController _scrollController;
  CurvedAnimation _curve;
  Animation<double> _animation;
  double _scrollOffset = 0.0;
  double _offset = 0.0;
  bool _isBacked = false;
  bool _isOnPointer = false;

  // Touch gestures
  Drag _drag;
  ScrollHoldController _hold;
  void _disposeHold() {
    _hold = null;
  }

  void _disposeDrag() {
    _drag = null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _offset = widget.height ?? 320.0;
    // print(_scrollController is ScrollController);
    _scrollController = widget.scrollController;
    setState(() {});
    _scrollController.addListener(() {
      _scrollOffset = _scrollController.position.pixels;
      if (_scrollOffset < 0) {
        _scrollController.jumpTo(0);
        _scrollController.position.hold(_disposeHold);
      }
    });
    _animationController = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );

    _curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

    _updateOffset(widget.height, 0.0);
  }

  _updateOffset(double begin, double end) {
    _animationController.value = 0.0;
    _animation = Tween(begin: begin, end: end).animate(_curve)
      ..addListener(() {
        _offset = _animation.value;
        setState(() {});
      });
    _animationController.forward();
    Timer(Duration(milliseconds: 250), () {
      if (end >= widget.height && !_isBacked) {
        _isBacked = true;
        setState(() {});
        Navigator.of(context).pop();
      }
    });
  }

  _onPointerMove(PointerMoveEvent e, [bool flag = false]) {
    if (_scrollOffset <= 0 && e.delta.dy > 0 || flag) {
      _isOnPointer = true;
      _offset += e.delta.dy;
    } else if (e.delta.dy < 0 && _offset > 0) {
      _offset += e.delta.dy;
    }

    if (_offset < 0) {
      _offset = 0.0;
    }
    if (_offset == 0 && _isOnPointer && !flag) {
      _scrollController.jumpTo(_scrollOffset - e.delta.dy);
    }
    setState(() {});
  }

  _onPointerUp(PointerUpEvent e) {
    _isOnPointer = false;
    if (_offset >= widget.height * 0.4) {
      _updateOffset(_offset, widget.height);
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
        color: widget.backdropColor ?? Colors.transparent,
        child: Column(
          children: <Widget>[
            Expanded(child: GestureDetector(
              onTap: () {
                _updateOffset(_offset, widget.height);
              },
            )),
            Transform.translate(
              offset: Offset(0.0, _offset),
              child: Container(
                color: widget.backgroundColor ?? Colors.white,
                height: widget.height,
                child: Column(
                  children: <Widget>[
                    widget.header == null
                        ? Container()
                        : Listener(
                            onPointerMove: (PointerMoveEvent e) {
                              _onPointerMove(e, true);
                            },
                            onPointerUp: _onPointerUp,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: widget.header,
                                )
                              ],
                            ),
                          ),
                    Expanded(
                      flex: 1,
                      child: Listener(
                        onPointerMove: _onPointerMove,
                        onPointerUp: _onPointerUp,
                        child: widget.body == null ? Container() : widget.body,
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
