//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  © Cosmos Software | Ali Yigit Bireroglu                                                                                                          /
//  All material used in the making of this code, project, program, application, software et cetera (the "Intellectual Property")                    /
//  belongs completely and solely to Ali Yigit Bireroglu. This includes but is not limited to the source code, the multimedia and                    /
//  other asset files.                                                                                                                               /
//  If you were granted this Intellectual Property for personal use, you are obligated to include this copyright text at all times.                  /
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cupertino_tabbar/cupertino_tabbar.dart' as CupertinoTabBar;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cupertino Tab Bar Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Cupertino Tab Bar Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int cupertinoTabBarIValue = 0;
  int cupertinoTabBarIValueGetter() => cupertinoTabBarIValue;
  int cupertinoTabBarIIValue = 1;
  int cupertinoTabBarIIValueGetter() => cupertinoTabBarIIValue;
  int cupertinoTabBarIIIValue = 3;
  int cupertinoTabBarIIIValueGetter() => cupertinoTabBarIIIValue;
  int cupertinoTabBarIVValue = 2;
  int cupertinoTabBarIVValueGetter() => cupertinoTabBarIVValue;
  int cupertinoTabBarVValue = 0;
  int cupertinoTabBarVValueGetter() => cupertinoTabBarVValue;
  int cupertinoTabBarVIValue = 0;
  int cupertinoTabBarVIValueGetter() => cupertinoTabBarVIValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoTabBar.CupertinoTabBar(
              cupertinoTabBarIValue == 0 ? const Color(0xFF293a80) : const Color(0xFFf88020),
              cupertinoTabBarIValue == 0 ? const Color(0xFF537ec5) : const Color(0xFFd1274b),
              [
                Text(
                  " 􀆬 ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: cupertinoTabBarIValue == 0 ? 18.75 * 2 : 18.75,
                    fontWeight: FontWeight.w400,
                    fontFamily: "SFProRounded",
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  " 􀇁 ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: cupertinoTabBarIValue == 1 ? 18.75 * 2 : 18.75,
                    fontWeight: FontWeight.w400,
                    fontFamily: "SFProRounded",
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              cupertinoTabBarIValueGetter,
              (int index) {
                setState(() {
                  cupertinoTabBarIValue = index;
                });
              },
            ),
            Container(
              constraints: const BoxConstraints.expand(height: 20.0),
            ),
            CupertinoTabBar.CupertinoTabBar(
              const Color(0xFF3c4245),
              const Color(0xFF719192),
              [
                const Text(
                  "Option A",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.75,
                    fontWeight: FontWeight.w400,
                    fontFamily: "SFProRounded",
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Option B",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.75,
                    fontWeight: FontWeight.w400,
                    fontFamily: "SFProRounded",
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Option C",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.75,
                    fontWeight: FontWeight.w400,
                    fontFamily: "SFProRounded",
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              cupertinoTabBarIIValueGetter,
              (int index) {
                setState(() {
                  cupertinoTabBarIIValue = index;
                });
              },
              useSeparators: true,
            ),
            Container(
              constraints: const BoxConstraints.expand(height: 20.0),
            ),
            CupertinoTabBar.CupertinoTabBar(
              const Color(0xFFd4d7dd),
              const Color(0xFFf7f7f7),
              [
                const Text(
                  "Home",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.75,
                    fontWeight: FontWeight.w400,
                    fontFamily: "SFProRounded",
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Play",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.75,
                    fontWeight: FontWeight.w400,
                    fontFamily: "SFProRounded",
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Share",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.75,
                    fontWeight: FontWeight.w400,
                    fontFamily: "SFProRounded",
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Settings",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.75,
                    fontWeight: FontWeight.w400,
                    fontFamily: "SFProRounded",
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              cupertinoTabBarIIIValueGetter,
              (int index) {
                setState(() {
                  cupertinoTabBarIIIValue = index;
                });
              },
              horizontalPadding: 5,
            ),
            Container(
              constraints: const BoxConstraints.expand(height: 20.0),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: CupertinoTabBar.CupertinoTabBar(
                cupertinoTabBarIVValue == 0 ? const Color(0xFF943855) : cupertinoTabBarIVValue == 1 ? const Color(0xFF207561) : cupertinoTabBarIVValue == 2 ? const Color(0xFFf0dd92) : const Color(0xFF4f81c7),
                cupertinoTabBarIVValue == 0 ? const Color(0xFFeb7070) : cupertinoTabBarIVValue == 1 ? const Color(0xFF589167) : cupertinoTabBarIVValue == 2 ? const Color(0xFFffffc5) : const Color(0xFF64c4ed),
                [
                  Text(
                    "A",
                    style: TextStyle(
                      color: cupertinoTabBarIVValue == 2 ? Colors.black : Colors.white,
                      fontSize: 18.75,
                      fontWeight: FontWeight.w400,
                      fontFamily: "SFProRounded",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "BC",
                    style: TextStyle(
                      color: cupertinoTabBarIVValue == 2 ? Colors.black : Colors.white,
                      fontSize: 18.75,
                      fontWeight: FontWeight.w400,
                      fontFamily: "SFProRounded",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "DEFG",
                    style: TextStyle(
                      color: cupertinoTabBarIVValue == 2 ? Colors.black : Colors.white,
                      fontSize: 18.75,
                      fontWeight: FontWeight.w400,
                      fontFamily: "SFProRounded",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "HIJKLM",
                    style: TextStyle(
                      color: cupertinoTabBarIVValue == 2 ? Colors.black : Colors.white,
                      fontSize: 18.75,
                      fontWeight: FontWeight.w400,
                      fontFamily: "SFProRounded",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                cupertinoTabBarIVValueGetter,
                (int index) {
                  setState(() {
                    cupertinoTabBarIVValue = index;
                  });
                },
                useSeparators: true,
              ),
            ),
            Container(
              constraints: const BoxConstraints.expand(height: 20.0),
            ),
            CupertinoTabBar.CupertinoTabBar(
              Colors.transparent,
              const Color(0xFFe9e5dd),
              [
                const Text(
                  "Tab 1",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.75 * 1.5,
                    fontWeight: FontWeight.w400,
                    fontFamily: "SFProRounded",
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Tab 2",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.75 * 1.5,
                    fontWeight: FontWeight.w400,
                    fontFamily: "SFProRounded",
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Tab 3",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.75 * 1.5,
                    fontWeight: FontWeight.w400,
                    fontFamily: "SFProRounded",
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              cupertinoTabBarVValueGetter,
              (int index) {
                setState(() {
                  cupertinoTabBarVValue = index;
                });
              },
              useSeparators: true,
            ),
            Container(
              constraints: const BoxConstraints.expand(height: 20.0),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: CupertinoTabBar.CupertinoTabBar(
                cupertinoTabBarIVValue == 0 ? const Color(0xFF943855) : cupertinoTabBarIVValue == 1 ? const Color(0xFF207561) : cupertinoTabBarIVValue == 2 ? const Color(0xFFf0dd92) : const Color(0xFF4f81c7),
                cupertinoTabBarIVValue == 0 ? const Color(0xFFeb7070) : cupertinoTabBarIVValue == 1 ? const Color(0xFF589167) : cupertinoTabBarIVValue == 2 ? const Color(0xFFffffc5) : const Color(0xFF64c4ed),
                [
                  Text(
                    "A",
                    style: TextStyle(
                      color: cupertinoTabBarIVValue == 2 ? Colors.black : Colors.white,
                      fontSize: 18.75,
                      fontWeight: FontWeight.w400,
                      fontFamily: "SFProRounded",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "BC",
                    style: TextStyle(
                      color: cupertinoTabBarIVValue == 2 ? Colors.black : Colors.white,
                      fontSize: 18.75,
                      fontWeight: FontWeight.w400,
                      fontFamily: "SFProRounded",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "DEFG",
                    style: TextStyle(
                      color: cupertinoTabBarIVValue == 2 ? Colors.black : Colors.white,
                      fontSize: 18.75,
                      fontWeight: FontWeight.w400,
                      fontFamily: "SFProRounded",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "HIJKLM",
                    style: TextStyle(
                      color: cupertinoTabBarIVValue == 2 ? Colors.black : Colors.white,
                      fontSize: 18.75,
                      fontWeight: FontWeight.w400,
                      fontFamily: "SFProRounded",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                cupertinoTabBarIVValueGetter,
                (int index) {
                  setState(() {
                    cupertinoTabBarIVValue = index;
                  });
                },
                horizontalPadding: 2.5,
                useSeparators: true,
                expand: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
