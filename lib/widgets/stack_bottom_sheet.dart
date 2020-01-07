import 'package:flutter/material.dart';

class StackBottomSheet extends StatefulWidget {
  final BuildContext context;
  final Scaffold body;
  final double sheetHeight;
  final Widget sheetHeader;
  final Widget sheetBody;

  const StackBottomSheet({
    @required this.context,
    @required this.body,
    this.sheetHeight,
    this.sheetHeader,
    this.sheetBody,
  })  : assert(context != null),
        assert(body != null);

  @override
  _StackBottomSheetState createState() => _StackBottomSheetState();
}

class _StackBottomSheetState extends State<StackBottomSheet>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  CurvedAnimation _curve;
  Animation<double> _animation;
  double _height = 0.0;
  double _pageHeight = 0.0;
  double _pagePaddingBottom = 0.0;
  double _offset = 0.0;
  double _maxOffest = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _height = widget.sheetHeight ?? 320.0;
    _pageHeight = MediaQuery.of(widget.context).size.height;
    _pagePaddingBottom = MediaQuery.of(widget.context).padding.bottom;
    // print("pageHeight: $_pageHeight   $_pagePaddingBottom");
    _maxOffest = _height - (_pagePaddingBottom + 50);
    // print("_maxOffest: $_maxOffest");
    // print("_offset: $_offset");
    setState(() {});
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
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
    // print(_offset);
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
        Transform.translate(
          offset:
              Offset(0.0, _pageHeight - (_pagePaddingBottom + 50 + _offset)),
          child: Container(
            height: _height,
            color: Colors.red,
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
                        child: widget.sheetHeader == null
                            ? Container()
                            : widget.sheetHeader,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      widget.sheetBody == null ? Container() : widget.sheetBody,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _offset == _maxOffest
            ? Row(
                children: <Widget>[
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      _updateOffset(_offset, 0.0);
                    },
                    child: Container(
                      height: _pageHeight - _height,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  )),
                ],
              )
            : Container(),
      ],
    );
  }
}
