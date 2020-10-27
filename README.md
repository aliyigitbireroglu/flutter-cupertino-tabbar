# cupertino_tabbar

[comment]: <> (Badges)
<a href="https://www.cosmossoftware.coffee">
   <img alt="Cosmos Software" src="https://img.shields.io/badge/Cosmos%20Software-Love%20Code-red" />
</a>

[![Pub](https://img.shields.io/pub/v/cupertino_tabbar?color=g)](https://pub.dev/packages/cupertino_tabbar)
[![License](https://img.shields.io/github/license/aliyigitbireroglu/flutter-cupertino-tabbar?color=blue)](https://github.com/aliyigitbireroglu/flutter-cupertino-tabbar/blob/master/LICENSE)

[comment]: <> (Introduction)
A highly customisable and simple widget for having iOS 13 style tab bars.

**It is highly recommended to read the documentation and run the example project on a real device to fully understand and inspect the full range of capabilities.**

[comment]: <> (ToC)
[Media](#media) | [Description](#description) | [Installation](#installation) | [How-to-Use](#howtouse)

[comment]: <> (Recent)
## Recent
* **[useShadow] is added. If set to true, a shadow will be displayed under the indicator that is much more similar to the actual iOS version.
    See [Media](#media) for examples.**
    
* **[allowScrollable], [fittedWhenScrollable], [animateWhenScrollable], [animateUntilScrolled], [outerHorizontalPadding] and [outerVerticalPadding] are added.
    These all work towards making an easy-to-use scrollable tab bar. Please refer to the documentation and the examples for instructions and see [Media](#media) for 
    examples.**
* * *
[comment]: <> (Warning)
## Warning
* **Variables previously named as [horizontalPadding], [verticalPadding] and [expand] are now named [innerHorizontalPadding], [innerVerticalPadding] and [allowExpand].**
* * *


[comment]: <> (Media)
<a name="media"></a>
## Media

Watch on **Youtube**:

[**v1.1.0**](https://youtu.be/rK_FhhJI0Og)
<br><br>
[v1.0.0](https://youtu.be/UELwqzHGFOE)

<br><br>
<img src="https://www.cosmossoftware.coffee/Common/Portfolio/GIFs/FlutterCupertinoTabBarNew.gif" height="450" max-height="450"/>
<br><br>


[comment]: <> (Description)
<a name="description"></a>
## Description
This is a highly customisable and simple widget for having iOS 13 style tab bars.


[comment]: <> (How-to-Use)
<a name="howtouse"></a>
## How-to-Use
Simply create a CupertinoTabBar as shown in the example:

```
CupertinoTabBar(
  Colors.black                  //_backgroundColor
  Colors.white                  //_foregroundColor
  [...],                        //_widgets
  cupertinoTabBarValueGetter,   //_valueGetter
  (int index) {                 //_onTap
    setState(() {
      cupertinoTabBarValue = index;
    });
  },
  {Key key,
  useSeparators             : false,
  innerHorizontalPadding    : 10.0,
  innerVerticalPadding      : 10.0,
  borderRadius              : const BorderRadius.all(const Radius.circular(10.0)),
  curve                     : Curves.linearToEaseOut,
  duration                  : const Duration(milliseconds: 350),
  allowExpand               : false,
  allowScrollable           : false,
  fittedWhenScrollable      : false,
  animateWhenScrollable     : false,
  animateUntilScrolled      : false,
  outerHorizontalPadding    : 10.0,,
  outerVerticalPadding      : 0})
)

int cupertinoTabBarValue = 0;
int cupertinoTabBarValueGetter() => cupertinoTabBarValue;
```

**Further Explanations:**

*For a complete set of descriptions for all parameters and methods, see the [documentation](https://pub.dev/documentation/cupertino_tabbar/latest/).*

* Do not set both [allowExpand] and [allowScrollable] to true.


[comment]: <> (Notes)
## Notes
Any help, suggestion or criticism is appreciated! 

Cheers.

[comment]: <> (CosmosSoftware)
<br><br>
<img align="right" src="https://www.cosmossoftware.coffee/Common/Images/CosmosSoftwareIconTransparent.png" width="150" height="150"/>
<br><br>
