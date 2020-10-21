import 'dart:async';

import 'package:aayush_carrom_club/Screens/AppBarCommon.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

FloatingActionButtonLocation fab = FloatingActionButtonLocation.centerDocked;

class WebViewContainer extends StatefulWidget {
  @override
  _WebViewContainerState createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  bool isLoading;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //WebViewContainer _controller;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  void initState() {
    fab = FloatingActionButtonLocation.centerDocked;

    isLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: new AppBarCommon(
        title: getTitle(true),
        centerTile: false,
        context: context,
        notificationCount: Text("i"),
        isTabBar: false,
        searchOwner: "",
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            // onPageStarted: showLoader(),
            onPageFinished: (_) {
              setState(() {
                isLoading = false;
              });
            },
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            initialUrl:
                "https://www.youtube.com/playlist?list=PLzph2VNhVq_uKSo7zERVRewVHWjKo_jWB",
            javascriptMode: JavascriptMode.unrestricted,
            // onWebViewCreated: (WebViewController c) {
            //   _controller = c;
            // },
          ),
          isLoading ? Center(child: CircularProgressIndicator()) : Container(),
        ],
      ),
      floatingActionButtonLocation: fab,
      // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width,
        child: FloatingActionButton.extended(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            label: Text(" "),
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              return null;
            }),
      ),
    );
  }

  Widget getTitle(bool isTitle) {
    return Text(
      "ACC YOUTUBE CHANNEL".toUpperCase(),
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        wordSpacing: 1,
        fontStyle: FontStyle.normal,
      ),
    );
  }
}
