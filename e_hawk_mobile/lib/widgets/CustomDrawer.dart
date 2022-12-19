import 'package:e_hawk_mobile/authentication/Authentication.dart';
import 'package:e_hawk_mobile/pages/Home.dart';
import 'package:e_hawk_mobile/pages/Transactions.dart';
import 'package:e_hawk_mobile/pages/UserSetting.dart';
import 'package:e_hawk_mobile/utilities/Global.dart';
import 'package:e_hawk_mobile/utilities/routes.dart';
import 'package:e_hawk_mobile/widgets/CustomDialog.dart';
import 'package:e_hawk_mobile/widgets/CustomSkeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({Key? key, required this.screen}) : super(key: key);

  final String screen;

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  BuildContext? _ctx;
  bool isLoading = true;

  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    checkLoading();
  }

  void checkLoading() async {
    if (!isLoading) isLoading = true;
    debugPrint('checking loading state...');
    List<bool> states = await Future.wait([
      getPrefs()
      //add futures here to check
      //mostly api-loading functions
    ]);

    if (states.every((element) => element)) {
      isLoading = false;
      debugPrint('states loaded');
      // do something when all futures loaded
    } else {
      debugPrint('state loading error');
      debugPrint(states.toString());
      // we need to handle the error somewhere
    }
    if (mounted) setState(() {});
  }

  Future<bool> getPrefs() async {
    bool loadOk = false;
    prefs = await SharedPreferences.getInstance().then((val) {
      loadOk = true;
      return val;
    });
    return loadOk;
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
            decoration: const BoxDecoration(
              color: Global.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "E-HAWK Mobile",
                    style: Global.headerText.apply(color: Colors.white),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.white,
                  indent: 0,
                  endIndent: 0,
                ),
                Global.filler(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomSkeleton(
                            loadState: isLoading,
                            child: Text(
                              'Halo, ${prefs?.getString('sess_cust_name')}',
                              style: Global.headerText
                                  .apply(color: Colors.white, fontSizeDelta: 4),
                            ),
                          ),
                          CustomSkeleton(
                            loadState: isLoading,
                            child: Text(
                                "Aktif sampai: ${prefs?.getString('sess_active_end') ?? "-"}",
                                style: Global.genericText
                                    .apply(color: Colors.white)),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          CustomSkeleton(
                              loadState: isLoading,
                              child: Container(
                                padding: Global.p_a(10),
                                decoration: BoxDecoration(
                                    color: prefs?.getString('sess_status') ==
                                            "ACTIVE"
                                        ? Global.succesText
                                        : Global.errorText,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  prefs?.getString('sess_status') ?? "-",
                                  style: Global.genericText
                                      .apply(color: Colors.white),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Global.filler(),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              if (widget.screen != Global.screen_home) {
                Navigator.of(context).push(transitionWrapper(const Home()));
              }
            },
            leading: Icon(
              FontAwesomeIcons.house,
              color: widget.screen != Global.screen_home
                  ? Colors.black
                  : Global.accent,
            ),
            title: Text("Dashboard",
                style: Global.titleText.apply(
                    color: widget.screen != Global.screen_home
                        ? Colors.black
                        : Global.accent)),
          ),
          ListTile(
            onTap: () {
              if (widget.screen != Global.screen_transactions) {
                Navigator.of(context)
                    .push(transitionWrapper(const Transactions()));
              }
            },
            leading: Icon(
              FontAwesomeIcons.listCheck,
              color: widget.screen != Global.screen_transactions
                  ? Colors.black
                  : Global.accent,
            ),
            title: Text("Cek Transaksi",
                style: Global.titleText.apply(
                    color: widget.screen != Global.screen_transactions
                        ? Colors.black
                        : Global.accent)),
          ),
          ListTile(
            onTap: () {
              if (widget.screen != Global.screen_settings) {
                Navigator.of(context)
                    .push(transitionWrapper(const UserSetting()));
              }
            },
            leading: Icon(
              FontAwesomeIcons.gear,
              color: widget.screen != Global.screen_settings
                  ? Colors.black
                  : Global.accent,
            ),
            title: Text("Pengaturan",
                style: Global.titleText.apply(
                    color: widget.screen != Global.screen_settings
                        ? Colors.black
                        : Global.accent)),
          ),
          ListTile(
            onTap: () {
              _exit(context);
            },
            leading: Icon(
              FontAwesomeIcons.rightFromBracket,
              color: Global.grey,
            ),
            title: Text("Keluar",
                style: Global.titleText.apply(
                  color: Global.grey,
                )),
          )
        ],
      ),
    );
  }

  Future<bool> _exit(BuildContext context) async {
    return await showDialog(
            context: context,
            builder: (context) => CustomDialog(
                  label: 'Keluar',
                  content: "Keluar dari aplikasi?",
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('Tidak')),
                    TextButton(
                        onPressed: () async {
                          await do_logout().then((value) {
                            debugPrint("exitting...");
                            Navigator.of(context).pushAndRemoveUntil(
                                transitionWrapper(const Authentication()),
                                (route) => false);
                          });
                        },
                        child: const Text('Ya'))
                  ],
                )) ??
        false;
  }

  Future<bool> do_logout() {
    return prefs!.clear();
  }
}
