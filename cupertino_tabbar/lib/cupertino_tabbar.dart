//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  © Cosmos Software | Ali Yigit Bireroglu                                                                                                          /
//  All material used in the making of this code, project, program, application, software et cetera (the "Intellectual Property")                    /
//  belongs completely and solely to Ali Yigit Bireroglu. This includes but is not limited to the source code, the multimedia and                    /
//  other asset files.                                                                                                                               /
//  If you were granted this Intellectual Property for personal use, you are obligated to include this copyright text at all times.                  /
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CupertinoTabBar extends StatefulWidget {
  ///The color of this [CupertinoTabBar].
  final Color _backgroundColor;

  ///The color of the moving selection bar.
  final Color _foregroundColor;

  ///The widgets that are to be displayed as the tabs of this [CupertinoTabBar].
  final List<Widget> _widgets;

  ///The function that is to be used to get the current index/value of this [CupertinoTabBar].
  final Function _valueGetter;

  ///The function that is to be called when the current index/value of this [CupertinoTabBar] changes.
  final Function(int) _onTap;

  ///Set this value to true if you want separator lines to be displayed between the [_widgets].
  final bool useSeparators;

  ///Set this value to true if you want a shadow to be displayed under the indicator.
  final bool useShadow;

  ///Breaking Change: Previously named [horizontalPadding]. The gap that is to be shown on the left and right sides of each [Widget] in the [_widgets].
  final double innerHorizontalPadding;

  ///Breaking Change: Previously named [verticalPadding]. The gap that is to be shown on the top and bottom sides of each [Widget] in the [_widgets].
  final double innerVerticalPadding;

  ///The border radius that is to be used to display this [CupertinoTabBar] and the moving selection bar. The default value corresponds to the default iOS 13 value.
  final BorderRadius borderRadius;

  ///The curve which this [CupertinoTabBar] uses to animate the switching of tabs.
  final Curve curve;

  ///The duration that is to be used for the animations of the moving selection bar.
  final Duration duration;

  ///Set this value to true if you want this [CupertinoTabBar] to expand to fill the available gap. Do not set both [allowExpand] and [allowScrollable] to true.
  final bool allowExpand;

  ///Set this value to true if you want to allow this [CupertinoTabBar] to be scrollable. Do not set both [allowExpand] and [allowScrollable] to true.
  final bool allowScrollable;

  ///Set this value to true if you want this [CupertinoTabBar] to have a restricted size even while [allowScrollable] is set to true.
  final bool fittedWhenScrollable;

  ///Set this value to true if you want this [CupertinoTabBar] to remind the user that it is scrollable with an animation.
  final bool animateWhenScrollable;

  ///Set this value to true if you want this [CupertinoTabBar] to continue reminding the user that it is scrollable with an animation until it is scrolled by the user.
  final bool animateUntilScrolled;

  ///The gap that is to be shown on the left and right sides of this [CupertinoTabBar] if [allowScrollable] is set to true.
  final double outerHorizontalPadding;

  ///The gap that is to be shown on the top and bottom sides of this [CupertinoTabBar] if [allowScrollable] is set to true.
  final double outerVerticalPadding;

  const CupertinoTabBar(
    this._backgroundColor,
    this._foregroundColor,
    this._widgets,
    this._valueGetter,
    this._onTap, {
    Key? key,
    this.useSeparators: false,
    this.useShadow: true,
    this.innerHorizontalPadding: 10.0,
    this.innerVerticalPadding: 10.0,
    this.borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
    this.curve: Curves.linearToEaseOut,
    this.duration: const Duration(milliseconds: 350),
    this.allowExpand: false,
    this.allowScrollable: false,
    this.fittedWhenScrollable: false,
    this.animateWhenScrollable: true,
    this.animateUntilScrolled: true,
    this.outerHorizontalPadding: 10.0,
    this.outerVerticalPadding: 0.0,
  }) : super(key: key);

  @override
  _CupertinoTabBarState createState() {
    return _CupertinoTabBarState();
  }
}

class _CupertinoTabBarState extends State<CupertinoTabBar> with SingleTickerProviderStateMixin {
  late List<GlobalKey> _globalKeys;
  double? _maxWidth;
  double? _maxHeight;
  double? _fullWidth;
  double? _fullHeight;
  double? _preferredHeight;
  double? _preferredWidth;
  double? _usedHeight;
  double? _usedWidth;
  double? _singleHeight;
  late double _singleWidth;
  double? _outerContainerHeight;
  double? _outerContainerWidth;
  double? _innerContainerHeight;
  double? _innerContainerWidth;
  double? _separatorHeight;
  double? _separatorWidth;
  double? _indicatorHeight;
  double? _indicatorWidth;
  late bool _showSelf;

  ScrollController? _scrollController;
  late double _initialScrollOffset;
  late bool _userHasScrolled;

  AnimationController? _animationController;
  Timer? _animationTimer;
  late List<double> _tresholds;

  bool get _shouldBeExpanded => widget.allowExpand && !widget.allowScrollable;
  bool get _shouldBeScrollable => !widget.allowExpand && widget.allowScrollable && _preferredWidth! > _fullWidth!;
  bool get _shouldBeFitted => widget.fittedWhenScrollable;
  bool get _shouldBeAnimated => widget.animateWhenScrollable;
  bool get _shouldCalculateFullDimensions => widget.allowExpand || widget.allowScrollable;

  bool get _isScrollByUser => _animationController == null || !_animationController!.isAnimating;
  bool get _shouldBeReanimated => widget.animateUntilScrolled && !_userHasScrolled && _animationController!.isCompleted;

  bool get _shouldBeRescrolled => _scrollController!.offset != _offset;
  double get _offset {
    double _scrollControllerOffset = _scrollController != null && _scrollController!.positions.isNotEmpty ? _scrollController!.offset : 0.0;
    double _areaStartingPoint = _scrollControllerOffset;
    double _areaEndingPoint = _areaStartingPoint + _fullWidth!;
    double _tabStartingPoint = widget.outerHorizontalPadding / 2.0 + _singleWidth * widget._valueGetter();
    double _tabEndingPoint = _tabStartingPoint + _singleWidth + widget.outerHorizontalPadding / 2.0;
    double _targetOffset = _scrollControllerOffset;
    if (_tabEndingPoint > _areaEndingPoint - _singleWidth * 0.25) {
      _targetOffset += (_tabEndingPoint - _areaEndingPoint) + _singleWidth * 1.25;
    } else if (_tabStartingPoint < _areaStartingPoint + _singleWidth * 0.25) {
      _targetOffset -= (_areaStartingPoint - _tabStartingPoint) + _singleWidth * 1.25;
    }
    _targetOffset = _targetOffset.clamp(0.0, _preferredWidth! - _fullWidth! + widget.outerHorizontalPadding * 2);
    return _targetOffset;
  }

  bool get _isRTL => Directionality.of(context) == TextDirection.rtl;
  Alignment get _alignment => Alignment((_isRTL ? -1 : 1) * (-1.0 + widget._valueGetter() / (widget._widgets.length - 1) * 2), 0.0);

  void _startAnimation() {
    _animationTimer = Timer(const Duration(seconds: 4), () => _animationController!.forward(from: 0.0));
  }

  void _stopAnimation() {
    _userHasScrolled = true;
    _animationController?.stop();
    _animationTimer?.cancel();
  }

  void _applyAnimation() {
    if (_animationController!.value < _tresholds[0]) {
      _scrollController!.jumpTo(_initialScrollOffset + _animationController!.value);
    } else if (_animationController!.value >= _tresholds[0] && _animationController!.value < _tresholds[1]) {
      _scrollController!.jumpTo(_initialScrollOffset + _tresholds[0] - (_animationController!.value - _tresholds[0]));
    } else if (_animationController!.value >= _tresholds[1] && _animationController!.value < _tresholds[2]) {
      _scrollController!.jumpTo(_initialScrollOffset - _tresholds[0] + (_animationController!.value - _tresholds[1]));
    } else if (_animationController!.value >= _tresholds[2] && _animationController!.value < _animationController!.upperBound * 0.95) {
      _scrollController!.jumpTo(_initialScrollOffset + _tresholds[0] - (_animationController!.value - _tresholds[2]));
    } else {
      _scrollController!.jumpTo(_initialScrollOffset);
    }
  }

  void scrollControllerListener() {
    if (!_userHasScrolled && _isScrollByUser) {
      _stopAnimation();
    }
  }

  void animationListener() {
    setState(() {
      if (_animationController!.isAnimating) {
        _applyAnimation();
      }
      if (_shouldBeReanimated) {
        _startAnimation();
      }
    });
  }

  void onPostFrameCallback(Duration duration) {
    if (!_showSelf) {
      setState(() {
        _maxWidth = 0;
        _maxHeight = 0;
        for (int i = 0; i < widget._widgets.length; i++) {
          RenderBox _renderBox = _globalKeys[i].currentContext!.findRenderObject() as RenderBox;
          if (_renderBox.size.width > _maxWidth!) {
            _maxWidth = _renderBox.size.width;
          }
          if (_renderBox.size.height > _maxHeight!) {
            _maxHeight = _renderBox.size.height;
          }
        }
        _maxWidth = _maxWidth! + widget.innerHorizontalPadding * 2.0;
        _maxHeight = _maxHeight! + widget.innerVerticalPadding * 2.0;

        if (_shouldCalculateFullDimensions) {
          RenderBox _renderBox = _globalKeys.last.currentContext!.findRenderObject() as RenderBox;
          _fullWidth = _renderBox.size.width > _maxWidth! ? _renderBox.size.width : _maxWidth;
          _fullHeight = _renderBox.size.height > _maxHeight! ? _renderBox.size.height : _maxHeight;
        }

        _preferredHeight = _maxHeight;
        _preferredWidth = _maxWidth! * widget._widgets.length;

        _usedHeight = _preferredHeight;
        _usedWidth = _shouldBeExpanded ? _fullWidth : _preferredWidth;

        _singleHeight = _usedHeight;
        _singleWidth = _usedWidth! / widget._widgets.length;

        _outerContainerHeight = _fullHeight;
        _outerContainerWidth = _fullWidth;

        _innerContainerHeight = _preferredHeight;
        _innerContainerWidth = _preferredWidth;

        _separatorHeight = _maxHeight! / 2.0;
        _separatorWidth = 1.0;

        _indicatorHeight = _singleHeight;
        _indicatorWidth = _singleWidth - (widget.useSeparators ? 4.0 : 0.0);

        _showSelf = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _globalKeys = [];
    for (int i = 0; i < widget._widgets.length; i++) {
      _globalKeys.add(GlobalKey());
    }
    if (_shouldCalculateFullDimensions) {
      _globalKeys.add(GlobalKey());
    }
    _showSelf = false;
    WidgetsBinding.instance!.addPostFrameCallback(onPostFrameCallback);
  }

  @override
  void dispose() {
    if (_scrollController != null) _scrollController!.dispose();
    if (_animationController != null) _animationController!.dispose();
    super.dispose();
  }

  void onTap(int index) {
    widget._onTap(index);
    if (_shouldBeScrollable && _shouldBeRescrolled) {
      _scrollController!.animateTo(_offset, duration: widget.duration, curve: Curves.decelerate);
    }
  }

  Widget _wrapByRegularOuterContainer(Widget child) {
    return _RegularOuterContainer(
      child,
      _outerContainerHeight,
      _outerContainerWidth,
    );
  }

  Widget _wrapByFittedOuterContainer(Widget child) {
    return _FittedOuterContainer(
      child,
      _outerContainerHeight,
      _outerContainerWidth,
      widget.outerHorizontalPadding,
      widget.outerVerticalPadding,
      widget.borderRadius,
    );
  }

  Widget _wrapByRegularMiddleContainer(Widget child) {
    return _RegularMiddleContainer(
      _scrollController,
      child,
      widget.outerHorizontalPadding,
      widget.outerVerticalPadding,
    );
  }

  Widget _wrapByFittedMiddleContainer(Widget child) {
    return _FittedMiddleContainer(
      _scrollController,
      child,
    );
  }

  Widget _wrapByRegularInnerContainer(Widget child) {
    return _RegularInnerContainer(
      child,
      _innerContainerHeight,
      _innerContainerWidth,
      widget._backgroundColor,
      widget.borderRadius,
    );
  }

  Widget _wrapByExpandedInnerContainer(Widget child) {
    return _ExpandedInnerContainer(
      child,
      _maxHeight,
      widget._backgroundColor,
      widget.borderRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_showSelf) {
      return Stack(
        children: List<Widget>.generate(_shouldCalculateFullDimensions ? widget._widgets.length + 1 : widget._widgets.length, (int index) {
          if (index < widget._widgets.length) {
            return Container(
              key: _globalKeys[index],
              child: widget._widgets[index],
            );
          } else {
            return Container(
              key: _globalKeys[index],
              constraints: BoxConstraints.expand(height: 1),
            );
          }
        }),
      );
    } else {
      Widget _widget = Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          _Indicator(
            _alignment,
            widget.duration,
            widget.curve,
            _indicatorHeight,
            _indicatorWidth,
            widget._foregroundColor,
            widget.borderRadius,
            widget.useShadow,
          ),
          Row(
            children: List<Widget>.generate(widget.useSeparators ? widget._widgets.length * 2 - 1 : widget._widgets.length, (int index) {
              if (!widget.useSeparators || index % 2 == 0) {
                int _trueIndex = !widget.useSeparators ? index : (index / 2.0).floor();
                return _Tab(
                  widget._widgets[_trueIndex],
                  onTap,
                  _trueIndex,
                );
              } else {
                return _Separator(
                  _separatorHeight,
                  _separatorWidth,
                  widget._foregroundColor,
                );
              }
            }),
          ),
        ],
      );

      if (_shouldBeScrollable) {
        if (_scrollController == null) {
          _scrollController = new ScrollController(initialScrollOffset: _offset)..addListener(scrollControllerListener);
          _initialScrollOffset = _offset;
          _userHasScrolled = false;
        }
        if (_shouldBeAnimated) {
          if (_animationController == null) {
            _animationController = AnimationController(
              vsync: this,
              lowerBound: 0.0,
              upperBound: _singleWidth * 2.0,
              duration: const Duration(milliseconds: 500),
            )..addListener(animationListener);
            _animationTimer = Timer(const Duration(seconds: 2), () => _animationController!.forward(from: 0.0));
            _tresholds = [
              _animationController!.upperBound / 6.0,
              _animationController!.upperBound / 6.0 * 3.0,
              _animationController!.upperBound / 6.0 * 5.0,
            ];
          }
        }
      }

      if (_shouldBeScrollable) {
        if (_shouldBeFitted) {
          return _wrapByFittedOuterContainer(
            _wrapByFittedMiddleContainer(
              _wrapByRegularInnerContainer(
                _widget,
              ),
            ),
          );
        }
        return _wrapByRegularOuterContainer(
          _wrapByRegularMiddleContainer(
            _wrapByRegularInnerContainer(
              _widget,
            ),
          ),
        );
      }
      if (_shouldBeExpanded) {
        return _wrapByExpandedInnerContainer(
          _widget,
        );
      }
      return _wrapByRegularInnerContainer(
        _widget,
      );
    }
  }
}

class _Separator extends StatelessWidget {
  final double? _height;
  final double? _width;
  final Color _color;

  const _Separator(
    this._height,
    this._width,
    this._color,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: _width,
      color: _color,
    );
  }
}

class _Tab extends StatelessWidget {
  final Widget _child;
  final Function(int) _onTap;
  final int _index;

  const _Tab(
    this._child,
    this._onTap,
    this._index,
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        child: _child,
        onTap: () => _onTap(_index),
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  final Alignment _alignment;
  final Duration _duration;
  final Curve _curve;
  final double? _height;
  final double? _width;
  final Color _color;
  final BorderRadius _borderRadius;
  final bool _useShadow;

  const _Indicator(
    this._alignment,
    this._duration,
    this._curve,
    this._height,
    this._width,
    this._color,
    this._borderRadius,
    this._useShadow,
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      alignment: _alignment,
      duration: _duration,
      curve: _curve,
      child: Padding(
        padding: _useShadow ? const EdgeInsets.only(left: 2.0, top: 2.0, right: 3.0, bottom: 4.0) : const EdgeInsets.all(2.0),
        child: Container(
          height: _height,
          width: _width,
          decoration: BoxDecoration(
            color: _color,
            borderRadius: _borderRadius,
            boxShadow: _useShadow
                ? [
                    BoxShadow(
                      color: const Color.fromARGB(170, 0, 0, 0),
                      offset: const Offset(2.0, 4.0),
                      blurRadius: 10.0,
                      spreadRadius: 0.5,
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}

class _ExpandedInnerContainer extends StatelessWidget {
  final Widget _child;
  final double? _maxHeight;
  final Color _color;
  final BorderRadius _borderRadius;

  const _ExpandedInnerContainer(
    this._child,
    this._maxHeight,
    this._color,
    this._borderRadius,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(height: _maxHeight),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: _borderRadius,
      ),
      child: _child,
    );
  }
}

class _RegularInnerContainer extends StatelessWidget {
  final Widget _child;
  final double? _height;
  final double? _width;
  final Color _color;
  final BorderRadius _borderRadius;

  const _RegularInnerContainer(
    this._child,
    this._height,
    this._width,
    this._color,
    this._borderRadius,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: _width,
      decoration: BoxDecoration(
        color: _color,
        borderRadius: _borderRadius,
      ),
      child: _child,
    );
  }
}

class _FittedMiddleContainer extends StatelessWidget {
  final ScrollController? _scrollController;
  final Widget _child;

  const _FittedMiddleContainer(
    this._scrollController,
    this._child,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: _child,
    );
  }
}

class _RegularMiddleContainer extends StatelessWidget {
  final ScrollController? _scrollController;
  final Widget _child;
  final double _horizontalPadding;
  final double _verticalPadding;

  const _RegularMiddleContainer(
    this._scrollController,
    this._child,
    this._horizontalPadding,
    this._verticalPadding,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.only(left: _horizontalPadding, top: _verticalPadding, right: _horizontalPadding, bottom: _verticalPadding),
        child: _child,
      ),
    );
  }
}

class _FittedOuterContainer extends StatelessWidget {
  final Widget _child;
  final double? _height;
  final double? _width;
  final double _horizontalPadding;
  final double _verticalPadding;
  final BorderRadius _borderRadius;

  const _FittedOuterContainer(
    this._child,
    this._height,
    this._width,
    this._horizontalPadding,
    this._verticalPadding,
    this._borderRadius,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: _width,
      child: Padding(
        padding: EdgeInsets.only(left: _horizontalPadding, top: _verticalPadding, right: _horizontalPadding, bottom: _verticalPadding),
        child: ClipRRect(
          borderRadius: _borderRadius,
          child: _child,
        ),
      ),
    );
  }
}

class _RegularOuterContainer extends StatelessWidget {
  final Widget _child;
  final double? _height;
  final double? _width;

  const _RegularOuterContainer(
    this._child,
    this._height,
    this._width,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: _width,
      child: _child,
    );
  }
}
