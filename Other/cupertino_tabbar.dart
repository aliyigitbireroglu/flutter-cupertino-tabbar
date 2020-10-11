import 'dart:async';

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  © Cosmos Software | Ali Yigit Bireroglu                                                                                                          /
//  All material used in the making of this code, project, program, application, software et cetera (the "Intellectual Property")                    /
//  belongs completely and solely to Ali Yigit Bireroglu. This includes but is not limited to the source code, the multimedia and                    /
//  other asset files.                                                                                                                               /
//  If you were granted this Intellectual Property for personal use, you are obligated to include this copyright text at all times.                  /
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

  ///The gap that is to be shown on the left and right sides of each [Widget] in the [_widgets].
  final double horizontalPadding;

  ///The gap that is to be shown on the top and bottom sides of each [Widget] in the [_widgets].
  final double verticalPadding;

  ///The border radius that is to be used to display this [CupertinoTabBar] and the moving selection bar. The default value corresponds to the default iOS 13 value.
  final BorderRadius borderRadius;

  ///The curve which this [CupertinoTabBar] uses to animate the switching of tabs.
  final Curve curve;

  ///The duration that is to be used for the animations of the moving selection bar.
  final Duration duration;

  ///Set this value to true if you want this [CupertinoTabBar] to expand to fill the available gap.
  final bool expand;

  ///Set this value to true if you want to allow this [CupertinoTabBar] to be scrollable.
  final bool allowScrollable;

  ///Two widgets that are to be displayed to remind the user that this [CupertinoTabBar] is scrollable.
  final Widget leftWidget;
  final Widget rightWidget;

  ///Set this value to true if you want to show [leftWidget] and [rightWidget] only until this [CupertinoTabBar] is scrolled by the user.
  final bool showSideWidgetsOnlyUntilScrolled;

  ///Set this value to true if you want this [CupertinoTabBar] to remind the user that it is scrollable with an animation.
  final bool animateWhenScrollable;

  ///Set this value to true if you want this [CupertinoTabBar] to continue reminding the user that it is scrollable with an animation until it is scrolled by the user.
  final bool animateUntilScrolled;

  ///Set this value to true if you want a gradient matching the [_backgroundColor] to be applied to this [CupertinoTabBar] if it is scrollable.
  final bool useGradient;

  const CupertinoTabBar(
    this._backgroundColor,
    this._foregroundColor,
    this._widgets,
    this._valueGetter,
    this._onTap, {
    Key key,
    this.useSeparators: false,
    this.horizontalPadding: 10.0,
    this.verticalPadding: 10.0,
    this.borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
    this.curve: Curves.linearToEaseOut,
    this.duration: const Duration(milliseconds: 350),
    this.expand: false,
    this.allowScrollable: false,
    this.useGradient: true,
    this.leftWidget,
    this.rightWidget,
    this.showSideWidgetsOnlyUntilScrolled: false,
    this.animateWhenScrollable: true,
    this.animateUntilScrolled: true,
  }) : super(key: key);

  @override
  _CupertinoTabBarState createState() {
    return _CupertinoTabBarState();
  }
}

class _CupertinoTabBarState extends State<CupertinoTabBar> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Timer _animationTimer;

  bool _userHasScrolled;
  double _initialScrollOffset;
  ScrollController _scrollController;
  double _leftShadowOpacity;
  double _rightShadowOpacity;
  double _leftWidgetOpacity;
  double _rightWidgetOpacity;
  Timer _opacityTimer;

  List<GlobalKey> _globalKeys;
  bool _showSelf;
  double _maxWidth;
  double _maxHeight;
  double _fullHeight;
  double _fullWidth;

  double get _constrainedHeight => _maxHeight;
  double get _preferredHeight => _maxHeight;
  double get _indicatorHeight => _maxHeight;

  double get _constrainedWidth => _shouldBeScrollable ? _fullWidth : _preferredWidth;
  double get _preferredWidth => (_maxWidth + widget.horizontalPadding * 2.0) * widget._widgets.length;
  double get _indicatorWidth => (widget.expand ? _fullWidth / widget._widgets.length : _preferredWidth / widget._widgets.length) - (widget.useSeparators ? 5.0 : 0.0);

  double get _singleWidth => _preferredWidth / (widget._widgets.length + 1);

  Alignment get _alignment => Alignment(-1.0 + widget._valueGetter() / (widget._widgets.length - 1) * 2, 0.0);
  double get _offset => (widget._valueGetter() * _singleWidth).clamp(0.0, _preferredWidth - _singleWidth);
  bool get _shouldBeScrollable => !widget.expand && widget.allowScrollable && _preferredWidth > _fullWidth;
  bool get _requiresScrolling => _offset < _scrollController.offset - _singleWidth || _offset > _scrollController.offset + _singleWidth;

  void _checkAnimation() {
    if (_animationController == null || !_animationController.isAnimating) {
      _userHasScrolled = true;
      _animationTimer?.cancel();
    }
  }

  void _checkSideWidgets() {
    _opacityTimer?.cancel();
    if (_leftWidgetOpacity == 1.0 || _rightWidgetOpacity == 1.0) {
      _hideSideWidgets();
    } else if (!widget.showSideWidgetsOnlyUntilScrolled) {
      _showSideWidgets();
    }
  }

  void _hideSideWidgets() {
    setState(() {
      _leftWidgetOpacity = 0.0;
      _rightWidgetOpacity = 0.0;
    });
  }

  void _showSideWidgets() {
    _opacityTimer = Timer(Duration(seconds: 2), () {
      setState(() {
        _leftWidgetOpacity = _scrollController.offset < 10.0 ? 0.0 : 1.0;
        _rightWidgetOpacity = _scrollController.offset > _preferredWidth - _singleWidth - 10.0 ? 0.0 : 1.0;
      });
    });
  }

  void _checkShadows() {
    bool _isDirty = false;
    if (_scrollController.offset < 10.0 && _leftShadowOpacity != 0.0) {
      _leftShadowOpacity = 0.0;
      _isDirty = true;
    }
    if (_scrollController.offset > 10.0 && _leftShadowOpacity != 1.0) {
      _leftShadowOpacity = 1.0;
      _isDirty = true;
    }
    if (_scrollController.offset > _preferredWidth - _constrainedWidth - 10.0 && _rightShadowOpacity != 0.0) {
      _rightShadowOpacity = 0.0;
      _isDirty = true;
    }
    if (_scrollController.offset < _preferredWidth - _constrainedWidth - 10.0 && _rightShadowOpacity != 1.0) {
      _rightShadowOpacity = 1.0;
      _isDirty = true;
    }
    if (_isDirty) {
      setState(() {});
    }
  }

  void scrollControllerListener() {
    if (!_userHasScrolled) {
      _checkAnimation();
    }

    if (_userHasScrolled) {
      _checkSideWidgets();
    }

    if (widget.useGradient) {
      _checkShadows();
    }
  }

  void animationListener() {
    setState(() {
      if (_animationController.isAnimating) {
        if (_animationController.value < 25.0) {
          _scrollController.jumpTo(_initialScrollOffset + _animationController.value); //0 - 25
        } else if (_animationController.value >= 25.0 && _animationController.value < 75.0) {
          _scrollController.jumpTo(_initialScrollOffset + 25.0 - (_animationController.value - 25.0)); //25 - -25
        } else if (_animationController.value >= 75.0 && _animationController.value < 125.0) {
          _scrollController.jumpTo(_initialScrollOffset - 25.0 + (_animationController.value - 75.0)); //-25 - 25
        } else {
          _scrollController.jumpTo(_initialScrollOffset + 25.0 - (_animationController.value - 125.0));
        }
      }
      if (widget.animateUntilScrolled && !_userHasScrolled && _animationController.isCompleted) {
        _animationTimer = Timer(const Duration(seconds: 4), () => _animationController.forward(from: 0.0));
      }
    });
  }

  void onPostFrameCallback(Duration duration) {
    if (!_showSelf) {
      setState(() {
        _maxWidth = 0;
        _maxHeight = 0;
        for (int i = 0; i < widget._widgets.length; i++) {
          RenderBox _renderBox = _globalKeys[i].currentContext.findRenderObject();
          if (_renderBox.size.width > _maxWidth) {
            _maxWidth = _renderBox.size.width;
          }
          if (_renderBox.size.height > _maxHeight) {
            _maxHeight = _renderBox.size.height;
          }
        }
        _maxWidth += widget.horizontalPadding * 2.0;
        _maxHeight += widget.verticalPadding * 2.0;

        if (widget.expand || widget.allowScrollable) {
          RenderBox _renderBox = _globalKeys.last.currentContext.findRenderObject();
          _fullWidth = _renderBox.size.width;
          _fullHeight = _renderBox.size.height;
        }

        _showSelf = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _globalKeys = List<GlobalKey>();
    for (int i = 0; i < (widget.expand || widget.allowScrollable ? widget._widgets.length + 1 : widget._widgets.length); i++) {
      _globalKeys.add(GlobalKey());
    }
    _showSelf = false;
    WidgetsBinding.instance.addPostFrameCallback(onPostFrameCallback);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showSelf) {
      return Stack(
        children: List<Widget>.generate((widget.expand || widget.allowScrollable ? widget._widgets.length + 1 : widget._widgets.length), (int index) {
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
<<<<<<< Updated upstream
      return Container(
        height: widget.expand ? null : _maxHeight,
        width: widget.expand ? null : (_maxWidth + widget.horizontalPadding * 2.0) * widget._widgets.length,
        constraints: widget.expand ? BoxConstraints.expand(height: _maxHeight) : null,
        decoration: BoxDecoration(
          color: widget._backgroundColor,
          borderRadius: widget.borderRadius,
        ),
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            AnimatedAlign(
              alignment: _getAlignment(),
              duration: widget.duration,
              curve: widget.curve,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  height: widget.expand ? null : _maxHeight,
                  width: widget.expand ? null : _maxWidth + widget.horizontalPadding * 2.0,
                  constraints: widget.expand ? BoxConstraints.expand(width: _maxWidth / widget._widgets.length - widget.horizontalPadding * 2.0) : null,
                  decoration: BoxDecoration(
                    color: widget._foregroundColor,
                    borderRadius: widget.borderRadius,
=======
      if (_shouldBeScrollable) {
        if (_scrollController == null) {
          _userHasScrolled = false;
          _initialScrollOffset = _offset;
          _scrollController = new ScrollController(initialScrollOffset: _initialScrollOffset)..addListener(scrollControllerListener);
          _leftShadowOpacity = _initialScrollOffset < 10.0 ? 0.0 : 1.0;
          _rightShadowOpacity = _initialScrollOffset < 10.0 ? 0.0 : 1.0;
          _leftWidgetOpacity = _initialScrollOffset > _preferredWidth - _constrainedWidth - 10.0 ? 0.0 : 1.0;
          _rightWidgetOpacity = _initialScrollOffset > _preferredWidth - _constrainedWidth - 10.0 ? 0.0 : 1.0;
        }
        if (widget.animateWhenScrollable && _animationController == null) {
          _animationController = AnimationController(
            vsync: this,
            lowerBound: 0.0,
            upperBound: 150.0,
            duration: const Duration(milliseconds: 500),
          )..addListener(animationListener);
          _animationTimer = Timer(const Duration(seconds: 2), () => _animationController.forward(from: 0.0));
        }
        return Container(
          height: _constrainedHeight,
          width: _constrainedWidth,
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.only(left: widget.horizontalPadding, right: widget.horizontalPadding),
                  child: Container(
                    height: _preferredHeight,
                    width: _preferredWidth,
                    decoration: BoxDecoration(
                      color: widget._backgroundColor,
                      borderRadius: widget.borderRadius,
                    ),
                    child: Stack(
                      alignment: AlignmentDirectional.centerStart,
                      children: [
                        AnimatedAlign(
                          alignment: _alignment,
                          duration: widget.duration,
                          curve: Curves.decelerate,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              height: _indicatorHeight,
                              width: _indicatorWidth,
                              decoration: BoxDecoration(
                                color: widget._foregroundColor,
                                borderRadius: widget.borderRadius,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: List<Widget>.generate(widget.useSeparators ? widget._widgets.length * 2 - 1 : widget._widgets.length, (int index) {
                            if (!widget.useSeparators || index % 2 == 0) {
                              int _trueIndex = widget.useSeparators ? (index / 2.0).floor() : index;
                              return Expanded(
                                child: GestureDetector(
                                  child: widget._widgets[_trueIndex],
                                  onTap: () {
                                    widget._onTap(_trueIndex);
                                    if (_requiresScrolling) {
                                      _scrollController.animateTo(_offset, duration: widget.duration, curve: Curves.decelerate);
                                    }
                                  },
                                ),
                              );
                            } else {
                              return Container(
                                height: _maxHeight / 2.0,
                                width: 1.0,
                                color: widget._foregroundColor,
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (widget.useGradient)
                ClipRect(
                  child: Row(
                    children: [
                      Expanded(
                        child: AnimatedOpacity(
                          opacity: _leftShadowOpacity,
                          duration: widget.duration,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: _preferredHeight,
                              width: 1.0,
                              decoration: BoxDecoration(
                                color: widget._backgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: widget._backgroundColor,
                                    offset: const Offset(-10.0, 0.0),
                                    spreadRadius: 40.0,
                                    blurRadius: 20.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: AnimatedOpacity(
                          opacity: _rightShadowOpacity,
                          duration: widget.duration,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              height: _preferredHeight,
                              width: 1.0,
                              decoration: BoxDecoration(
                                color: widget._backgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: widget._backgroundColor,
                                    offset: const Offset(10.0, 0.0),
                                    spreadRadius: 40.0,
                                    blurRadius: 20.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              if (widget.leftWidget != null && widget.rightWidget != null)
                Row(
                  children: [
                    Expanded(
                      child: AnimatedOpacity(
                        opacity: _leftWidgetOpacity,
                        duration: widget.duration,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: widget.horizontalPadding, right: widget.horizontalPadding),
                            child: widget.leftWidget,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: AnimatedOpacity(
                        opacity: _rightWidgetOpacity,
                        duration: widget.duration,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(left: widget.horizontalPadding, right: widget.horizontalPadding),
                            child: widget.rightWidget,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
            ],
          ),
        );
      } else {
        return Container(
          height: widget.expand ? null : _constrainedHeight,
          width: widget.expand ? null : _constrainedWidth,
          constraints: widget.expand ? BoxConstraints.expand(height: _maxHeight) : null,
          decoration: BoxDecoration(
            color: widget._backgroundColor,
            borderRadius: widget.borderRadius,
          ),
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              AnimatedAlign(
                alignment: _alignment,
                duration: widget.duration,
                curve: Curves.decelerate,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    height: widget.expand ? null : _indicatorHeight,
                    width: widget.expand ? null : _indicatorWidth,
                    constraints: widget.expand ? BoxConstraints.expand(height: _indicatorHeight, width: _indicatorWidth) : null,
                    decoration: BoxDecoration(
                      color: widget._foregroundColor,
                      borderRadius: widget.borderRadius,
                    ),
>>>>>>> Stashed changes
                  ),
                ),
              ),
              Row(
                children: List<Widget>.generate(widget.useSeparators ? widget._widgets.length * 2 - 1 : widget._widgets.length, (int index) {
                  if (!widget.useSeparators || index % 2 == 0) {
                    int _trueIndex = widget.useSeparators ? (index / 2.0).floor() : index;
                    return Expanded(
                      child: GestureDetector(
                        child: widget._widgets[_trueIndex],
                        onTap: () {
                          widget._onTap(_trueIndex);
                        },
                      ),
                    );
                  } else {
                    return Container(
                      height: _maxHeight / 2.0,
                      width: 1.0,
                      color: widget._foregroundColor,
                    );
                  }
                }),
              ),
            ],
          ),
        );
      }
    }
  }
}
