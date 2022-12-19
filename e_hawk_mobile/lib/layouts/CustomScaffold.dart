import 'package:e_hawk_mobile/layouts/BackgroundLayer.dart';
import 'package:e_hawk_mobile/provider/txProvider.dart';
import 'package:e_hawk_mobile/utilities/Global.dart';
import 'package:e_hawk_mobile/widgets/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CustomScaffold extends StatefulWidget {
  CustomScaffold(
      {Key? key,
      this.title = '',
      required this.screen, //special screen identifier
      this.subtitle = '',
      this.shrinkBody = true,
      this.minBodyHeight,
      this.inlet,
      required this.context,
      required this.child,
      this.useAppBar = true,
      this.useDrawer = true,
      this.useAction = true,
      this.useLogo = false, //disable bgimage
      this.bottomNavigation,
      this.pct,
      this.panel})
      : super(key: key);

  final dynamic title;
  final String subtitle;
  final BuildContext context;
  final Widget child;
  final String screen;
  final double? minBodyHeight;
  final bool shrinkBody;
  final bool useAppBar;
  final bool useDrawer;
  final bool useAction;
  final bool useLogo;
  final Widget? bottomNavigation;
  final Widget? inlet;
  final PanelController? pct;
  final Widget? panel;

  //final BoolCallback onWillPop; //<= only use for app exit callbacks

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  BuildContext? _ctx;

  late bool useLogo = false;
  late double minBodyH;
  late double maxBodyH;

  PanelController? pct;

  @override
  void initState() {
    super.initState();
    _useBackgroundIcon();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _useBackgroundIcon() {
    useLogo = widget.useLogo;
  }

  @override
  Widget build(BuildContext context) {
    pct = widget.pct ?? PanelController();
    _ctx = widget.context;
    maxBodyH = MediaQuery.of(context).size.height - (kToolbarHeight * 1.6);
    minBodyH =
        widget.minBodyHeight ?? MediaQuery.of(context).size.height * 1 / 3;
    return Consumer<TxProvider>(builder: (context, tx, __) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(true);
          return true;
        },
        child: BackgroundLayer(
          useTopCurve: true,
          customColor:
              widget.screen != Global.screen_login ? Global.primary : null,
          child: SlidingUpPanel(
            onPanelClosed: () {
              if (!tx.hasSelectedFilter) {
                tx.resetSelectedDateRange();
                tx.resetSelectedTxStatus();
              }
            },
            boxShadow: [],
            isDraggable: true,
            color: Colors.transparent,
            controller: pct,
            backdropEnabled: true,
            minHeight: 0,
            maxHeight: Global.mqh(context) * 0.8,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)),
            panel: widget.panel ??
                Material(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //SizedBox(height: 10),
                      Divider(
                        color: Global.grey,
                        indent: Global.mqw(context) * 0.45,
                        endIndent: Global.mqw(context) * 0.45,
                        thickness: 4,
                      ),
                      Global.spacer_v10(),
                      Container(
                        padding: const EdgeInsets.all(20),
                        constraints: const BoxConstraints(
                          maxHeight: 100,
                        ),
                        child: const Text(
                          'Menu',
                          style: Global.titleText,
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            pct!.close();
                          },
                          child: const ListTile(
                            leading: Icon(FontAwesomeIcons.bell,
                                color: Global.accent, size: 40),
                            title:
                                Text("Placehlodelr", style: Global.genericText),
                          )),
                    ],
                  ),
                ),
            body: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              drawer:
                  widget.useDrawer ? CustomDrawer(screen: widget.screen) : null,
              appBar: widget.useAppBar
                  ? AppBar(
                      elevation: 0,
                      // toolbarHeight: widget.screen == Global.screen_home
                      //     ? Global.mqh(context) * 0.15
                      //     : kToolbarHeight,
                      automaticallyImplyLeading: true,
                      centerTitle: widget.screen != Global.screen_temp,
                      title: widget.title
                              is String //title accept string or widget for customs
                          ? Text(widget.title)
                          : widget.title,
                      backgroundColor: Global.primary,
                      actions: widget.useAction && widget.useAppBar
                          ? <Widget>[
                              widget.screen == Global.screen_login
                                  ? Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: GestureDetector(
                                          onTap: () {
                                            //NAVIGATOR OBS HERE
                                          },
                                          child: const Icon(Icons.settings,
                                              size: 28),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ]
                          : null,
                    )
                  : null,
              body: widget.inlet !=
                      null //SPECIAL LAYOUT THAT WILL APPEAR WHEN MAIN BODY IS SHRINKED
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          widget.inlet != null
                              ? Expanded(
                                  child: widget.inlet!,
                                )
                              : Container(),
                          TweenAnimationBuilder(
                            //need to make a reusable layouting component with this
                            curve: Curves.fastOutSlowIn,
                            tween: Tween<double>(
                                begin: widget.shrinkBody ? maxBodyH : minBodyH,
                                end: widget.shrinkBody ? minBodyH : maxBodyH),
                            duration: const Duration(milliseconds: 500),
                            builder: (BuildContext context, double _val,
                                Widget? child) {
                              return SizedBox(height: _val, child: child);
                            },
                            child: BackgroundLayer(
                              useJ: useLogo,
                              customColor: widget.screen == Global.screen_temp
                                  ? Global.color
                                  : widget.screen == Global.screen_temp
                                      ? null
                                      : Colors.white,
                              useTopCurve: widget.screen == Global.screen_temp
                                  ? false
                                  : true,
                              child: widget.child,
                            ),
                          )
                        ])
                  : BackgroundLayer(
                      //useCrescent: widget.screen == Global.screen_temp,
                      useJ: useLogo,
                      useGradient: false,
                      useTopCurve: widget.screen != Global.screen_login,
                      child: widget.child,
                    ),
              bottomNavigationBar: widget.bottomNavigation,
              floatingActionButton: widget.bottomNavigation != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: FloatingActionButton(
                          //elevation: 2,
                          backgroundColor: Global.color,
                          onPressed: () {},
                          child: const Icon(
                            Icons.add,
                            size: 40,
                          ),
                        ),
                      ),
                    )
                  : null,
              floatingActionButtonLocation: widget.bottomNavigation != null
                  ? FloatingActionButtonLocation.centerDocked
                  : null,
            ),
          ),
        ),
      );
    });
    // });
  }
}
