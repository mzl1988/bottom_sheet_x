import 'package:flutter/material.dart';

class StackBottomSheet extends StatefulWidget {
  final BuildContext context;
  final StackBottomSheetController stackBottomSheetController;
  final bool isDismissible;
  final Color backdropColor;
  final Scaffold body;
  final double bottomSheetHeight;
  final Widget bottomSheetHeader;
  final Widget bottomSheetBody;
  final bool bottomSheetBodyHasScrollView;
  final ScrollController bottomSheetBodyScrollController;

  StackBottomSheet({
    @required this.context,
    @required this.stackBottomSheetController,
    @required this.body,
    this.isDismissible = false,
    this.backdropColor = Colors.transparent,
    this.bottomSheetHeight,
    this.bottomSheetHeader,
    this.bottomSheetBody,
    this.bottomSheetBodyHasScrollView = false,
    this.bottomSheetBodyScrollController,
  }) {
    assert(context != null);
    assert(stackBottomSheetController != null);
    assert(body != null);
    if (bottomSheetBodyHasScrollView &&
        bottomSheetBodyScrollController == null) {
      assert(bottomSheetBodyScrollController != null);
      // return null;
    }
    if (bottomSheetBodyScrollController != null &&
        bottomSheetBodyHasScrollView == null) {
      assert(bottomSheetBodyHasScrollView != null);
      // return null;
    }
  }

  @override
  _StackBottomSheetState createState() => _StackBottomSheetState();
}

class _StackBottomSheetState extends State<StackBottomSheet>
    with TickerProviderStateMixin {
  StackBottomSheetController get _stackBottomSheetController =>
      widget.stackBottomSheetController;
  ScrollController get _scrollController =>
      widget.bottomSheetBodyScrollController;
  AnimationController _animationController;
  CurvedAnimation _curve;
  Animation<double> _animation;
  double _height = 0.0;
  double _pageHeight = 0.0;
  double _pagePaddingBottom = 0.0;
  double _scrollOffset = 0.0;
  double _offset = 0.0;
  double _maxOffest = 0.0;

  ScrollHoldController _hold;
  void _disposeHold() {
    _hold = null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    double maxHeight = MediaQuery.of(widget.context).size.height -
        MediaQuery.of(widget.context).padding.top;
    // print(maxHeight);
    _height = widget.bottomSheetHeight > maxHeight
        ? maxHeight
        : widget.bottomSheetHeight ?? 320.0;
    _pageHeight = MediaQuery.of(widget.context).size.height;
    _pagePaddingBottom = MediaQuery.of(widget.context).padding.bottom;
    _maxOffest = _height - (_pagePaddingBottom + 50);
    setState(() {});
    _stackBottomSheetController
        .addListener(_stackBottomSheetControllerListener);
    _scrollController.addListener(_scrollControllerListener);
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
  }

  _scrollControllerListener() {
    _scrollOffset = _scrollController.position.pixels;
    if (_scrollOffset < 0) {
      _scrollController.jumpTo(0);
      _hold = _scrollController.position.hold(_disposeHold);
    }
  }

  _stackBottomSheetControllerListener() {
    switch (_stackBottomSheetController.eventType) {
      case 'close':
        _updateOffset(_offset, 0.0);
        break;
      case 'show':
        _updateOffset(_offset, _maxOffest);
        break;
      default:
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
  }

  _onPointerMove(PointerMoveEvent e, [bool flag = false]) {
    if (_scrollOffset > 0 && !flag) {
      return;
    }
    if ((_offset == 0 && e.delta.dy > 0) ||
        (_offset == _maxOffest && e.delta.dy < 0)) {
      return;
    }
    if (_offset >= 0 && _offset <= _maxOffest) {
      _offset -= e.delta.dy;
    }
    if (_offset < 0) {
      _offset = 0;
    }
    if (_offset > _maxOffest) {
      _offset = _maxOffest;
    }

    setState(() {});
  }

  _onPointerUp(PointerUpEvent e) {
    if (_offset == 0 || _offset == _maxOffest) {
      return;
    }
    if (_offset < _maxOffest / 2) {
      _updateOffset(_offset, 0);
    } else {
      _updateOffset(_offset, _maxOffest);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.body ?? Row(),
        _offset == _maxOffest && widget.isDismissible
            ? Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _updateOffset(_offset, 0.0);
                      },
                      child: Container(
                        height: _pageHeight,
                        color: widget.backdropColor,
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
        Transform.translate(
          offset:
              Offset(0.0, _pageHeight - (_pagePaddingBottom + 50 + _offset)),
          child: Container(
            height: _height,
            child: Column(
              children: <Widget>[
                Listener(
                  onPointerMove: (PointerMoveEvent e) {
                    _onPointerMove(e, true);
                  },
                  onPointerUp: _onPointerUp,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: widget.bottomSheetHeader == null
                            ? Container()
                            : widget.bottomSheetHeader,
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Listener(
                      onPointerMove: _onPointerMove,
                      onPointerUp: _onPointerUp,
                      child: widget.bottomSheetBody == null
                          ? Container()
                          : widget.bottomSheetBody,
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StackBottomSheetController extends ChangeNotifier {
  dynamic _parameter;
  String _eventType;
  String get eventType => this._eventType;
  dynamic get parameter => this._parameter;

  close([dynamic parameter]) {
    this._parameter = parameter;
    this._eventType = 'close';
    notifyListeners();
  }

  show([dynamic parameter]) {
    this._parameter = parameter;
    this._eventType = 'show';
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
