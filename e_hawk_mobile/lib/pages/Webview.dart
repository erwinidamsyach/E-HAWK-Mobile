import 'dart:ui';

import 'package:e_hawk_mobile/authentication/Authentication.dart';
import 'package:e_hawk_mobile/layouts/CustomScaffold.dart';
import 'package:e_hawk_mobile/pages/Transactions.dart';
import 'package:e_hawk_mobile/utilities/Global.dart';
import 'package:e_hawk_mobile/utilities/routes.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class Webview extends StatefulWidget {
  Webview(
      {Key? key,
      this.origin,
      this.useAppBar = true,
      required this.url,
      this.bottomPadding = 0})
      : super(key: key);

  final String? origin;
  final bool useAppBar;
  final String url;
  final double bottomPadding;

  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  BuildContext? _ctx;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    return WillPopScope(
        onWillPop: () async {
          switch (widget.origin) {
            case Global.screen_register:
              Navigator.of(context).pushAndRemoveUntil(
                  transitionWrapper(const Authentication()),
                  (Route<dynamic> route) => false);
              break;
            case Global.screen_transactions:
              Navigator.of(context).pushAndRemoveUntil(
                  transitionWrapper(const Transactions()),
                  (Route<dynamic> route) => false);
              break;
            default:
              Navigator.of(context).pop(false);
              break;
          }
          return false;
        },
        child: CustomScaffold(
            screen: Global.screen_webview,
            useAppBar: widget.useAppBar,
            useAction: false,
            useDrawer: false,
            context: _ctx!,
            child: Column(children: [
              Flexible(
                  child: Container(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height -
                              (widget.bottomPadding)),
                      child: Center(
                          child: WebView(
                        javascriptMode: JavascriptMode.unrestricted,
                        initialUrl: widget.url,
                      )))),
            ])));
  }
}
