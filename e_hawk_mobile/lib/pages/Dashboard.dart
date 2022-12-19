import 'package:e_hawk_mobile/layouts/CustomScaffold.dart';
import 'package:e_hawk_mobile/utilities/Global.dart';
import 'package:e_hawk_mobile/webservices/api.dart';
import 'package:e_hawk_mobile/widgets/CustomButton.dart';
import 'package:e_hawk_mobile/widgets/CustomSkeleton.dart';
import 'package:e_hawk_mobile/widgets/CustomTextFormField.dart';
import 'package:e_hawk_mobile/widgets/MenuTile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key})
      : super(key: key); //change all occurence for new class

  @override
  _BacalegStatsState createState() => _BacalegStatsState();
}

class _BacalegStatsState extends State<Dashboard> {
  BuildContext? _ctx;

  bool animateInitial = false;
  bool isLoading = true;
  bool isSearching = false;
  bool showSearchResult = false;
  bool searchMode = false;
  bool warningSearch = false;

  List<Map<String, dynamic>> toRender = [
    {
      'title': 'Cari Nopol',
      'color': Colors.lightGreen,
      'icon': FontAwesomeIcons.magnifyingGlass,
      'ontap': () {}
    },
    {
      'title': 'Riwayat Transaksi',
      'color': Colors.orange,
      'icon': FontAwesomeIcons.clockRotateLeft,
      'ontap': () {}
    },
    {
      'title': 'Ganti Password',
      'color': Colors.lightBlue,
      'icon': FontAwesomeIcons.key,
      'ontap': () {}
    }
  ];

  Map<String, dynamic> searchResult = {};

  TextEditingController search = TextEditingController();

  SharedPreferences? prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLoading();
  }

  void checkLoading() async {
    if (!isLoading) isLoading = true;
    debugPrint('checking loading state...');
    List<bool> states = await Future.wait([
      getPrefs(),
      Future.delayed(const Duration(seconds: 1), () {
        return true;
      })
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

  void searchNopol(BuildContext ctx) {
    if (search.text.isEmpty) {
      setState(() {
        warningSearch = true;
      });
    } else {
      setState(() {
        warningSearch = false;
      });
    }

    if (search.text.isNotEmpty) {
      var data = search.text.toString();
      setState(() {
        isSearching = true;
      });
      Api.getNopol(data).then((response) async {
        if (response['isExist']) {
          debugPrint('data: ${response['data']}');
          searchResult = response['data'];
          //if found
          setState(() {
            isSearching = false;
            toggleSearchResult(true);
          });
        } else {
          setState(() {
            isSearching = false;
          });
          const snackBar = SnackBar(
            backgroundColor: Global.errorText,
            content: Text('Nopol tidak ditemukan!'),
          );
          ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
        }
      });
    }
  }

  void toggleSearchMode() {
    setState(() {
      searchMode = !searchMode;
    });
  }

  void toggleSearchResult(bool val) {
    setState(() {
      showSearchResult = val;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget searchButton(double _val) {
    return TweenAnimationBuilder(
        curve: Curves.fastOutSlowIn,
        tween: Tween<double>(
            begin: searchMode ? 0.0 : 1.0, end: searchMode ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 500),
        builder: (BuildContext context, double _exp, Widget? child) {
          return GestureDetector(
            onTap: toggleSearchMode,
            child: Container(
              margin: Global.p_a(10),
              padding: Global.p_a(7),
              decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(15)),
              height: (60 + (60 * _exp)) * _val,
              child: Column(
                mainAxisAlignment: _exp == 0.0
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(left: 20, right: 15),
                        child: Icon(
                          FontAwesomeIcons.magnifyingGlass,
                          color: Colors.white,
                        ),
                      ),
                      const VerticalDivider(
                        indent: 12,
                        endIndent: 12,
                        thickness: 2,
                        color: Color(0xFFF6F4F4),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            'Cari Nomor Polisi',
                            style: Global.headerText.apply(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _exp > 0.0
                      ? Opacity(
                          opacity: _exp,
                          child: SizedBox(
                            height: (50 * _exp) * _val,
                            child: CustomTextFormField(
                                flb: FloatingLabelBehavior.never,
                                entryTextColor: Global.primary,
                                textColor: Global.primary,
                                label: 'Nomor Polisi...',
                                controller: search,
                                onSubmit: (keyword) {
                                  searchNopol(context);
                                },
                                suffixIcon: Icon(FontAwesomeIcons.searchengin)),
                          ),
                        )
                      : SizedBox.shrink()
                ],
              ),
            ),
          );
        });
  }

  Widget nopolDisplay() {
    return TweenAnimationBuilder(
        curve: Curves.fastOutSlowIn,
        tween: Tween<double>(
            begin: showSearchResult ? 0.0 : 1.0,
            end: showSearchResult ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 500),
        builder: (BuildContext context, double _exp, Widget? child) {
          return isSearching
              ? Center(
                  child: Container(
                    padding: Global.p_a(25),
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      color: Global.primary,
                      strokeWidth: 14,
                    ),
                  ),
                )
              : Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  margin: Global.p_a(10),
                  color: Colors.lightGreen[400],
                  child: Container(
                    padding: Global.p_a(15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nomor Polisi',
                            style:
                                Global.headerText.apply(color: Global.primary),
                          ),
                          Text(
                            searchResult['license_plate'],
                            style: Global.titleText.apply(color: Colors.white),
                          ),
                          Global.spacer_v10(),
                          Text(
                            'Model Kendaraan',
                            style:
                                Global.headerText.apply(color: Global.primary),
                          ),
                          Text(
                            searchResult['asset_type'],
                            style: Global.titleText.apply(color: Colors.white),
                          ),
                          Global.spacer_v10(),
                          Text(
                            'Finance',
                            style:
                                Global.headerText.apply(color: Global.primary),
                          ),
                          Text(
                            searchResult['agency'],
                            style: Global.titleText.apply(color: Colors.white),
                          ),
                          Global.spacer_v10(),
                          Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Cabang',
                                      style: Global.headerText
                                          .apply(color: Global.primary),
                                    ),
                                    Text(
                                      searchResult['branch'],
                                      style: Global.titleText
                                          .apply(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'No. Kontrak',
                                      style: Global.headerText
                                          .apply(color: Global.primary),
                                    ),
                                    Text(
                                      searchResult['agreement_no'],
                                      style: Global.titleText
                                          .apply(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Global.spacer_v10(),
                          Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nomor Mesin',
                                      style: Global.headerText
                                          .apply(color: Global.primary),
                                    ),
                                    Text(
                                      searchResult['no_mesin'] ?? "-",
                                      style: Global.titleText
                                          .apply(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nomor Rangka',
                                      style: Global.headerText
                                          .apply(color: Global.primary),
                                    ),
                                    Text(
                                      searchResult['no_rangka'] ?? '-',
                                      style: Global.titleText
                                          .apply(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: CustomScaffold(
          screen: Global.screen_temp,
          // title:
          context: context,
          child: Column(children: [
            Expanded(
              child: Container(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        backgroundColor: Global.primary,
                        leading: null,
                        automaticallyImplyLeading: false,
                        title: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            "E-HAWK Mobile System",
                            style: Global.bannerText.apply(color: Colors.white),
                          ),
                        ), // This is the title in the app bar.
                        flexibleSpace: LayoutBuilder(builder: (context, c) {
                          final settings =
                              context.dependOnInheritedWidgetOfExactType<
                                  FlexibleSpaceBarSettings>();
                          final deltaExtent =
                              settings!.maxExtent - settings.minExtent;
                          final t = (1.0 -
                                  (settings.currentExtent -
                                          settings.minExtent) /
                                      deltaExtent)
                              .clamp(0.0, 1.0);
                          final fadeStart =
                              math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
                          const fadeEnd = 1.0;
                          final opacity =
                              1.0 - Interval(fadeStart, fadeEnd).transform(t);
                          return t == 1.0
                              ? Center(
                                  child: Text(
                                  "E-HAWK Mobile System",
                                  style: Global.titleText,
                                ))
                              : Opacity(
                                  opacity: opacity,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 35),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 12,
                                          child: Container(
                                            padding: Global.p_a(20),
                                            width: Global.mqw(context) * 0.9,
                                            constraints: const BoxConstraints(
                                                maxWidth: 600),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomSkeleton(
                                                  loadState: isLoading,
                                                  child: Text(
                                                    'Halo ${prefs?.getString('sess_cust_name')}',
                                                    style: Global.headerText
                                                        .apply(
                                                            color:
                                                                Colors.white),
                                                  ),
                                                ),
                                                Global.dvd(),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text('Status Anda',
                                                              style: Global
                                                                  .titleText
                                                                  .apply(
                                                                      color: Colors
                                                                          .white)),
                                                          CustomSkeleton(
                                                            loadState:
                                                                isLoading,
                                                            child: CustomButton(
                                                                margin:
                                                                    EdgeInsets
                                                                        .zero,
                                                                style: Global
                                                                    .btn_small,
                                                                color: prefs?.getString(
                                                                            'sess_status') ==
                                                                        "ACTIVE"
                                                                    ? Global
                                                                        .succesText
                                                                    : Global
                                                                        .errorText,
                                                                label: prefs?.getString(
                                                                        'sess_status') ??
                                                                    "-",
                                                                onpress: () {}),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Global.filler(),
                                                    SizedBox(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              'Tanggal Kadaluarsa',
                                                              style: Global
                                                                  .titleText
                                                                  .apply(
                                                                      color: Colors
                                                                          .white)),
                                                          Global.spacer_v5(),
                                                          CustomSkeleton(
                                                            loadState:
                                                                isLoading,
                                                            child: Text(
                                                                prefs?.getString(
                                                                        'sess_active_end') ??
                                                                    "-",
                                                                style: Global
                                                                    .genericText
                                                                    .apply(
                                                                        color: Colors
                                                                            .white)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                        }),
                        pinned: true,
                        expandedHeight: 185.0,
                        forceElevated: true,
                      ),
                      isLoading
                          ? SliverList(
                              delegate: SliverChildListDelegate([
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                ),
                                const Center(
                                  child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: CircularProgressIndicator(
                                      color: Global.primary,
                                      strokeWidth: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                ),
                              ]),
                            )
                          : SliverList(
                              delegate: SliverChildListDelegate([
                                Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  constraints: BoxConstraints(maxHeight: 720),
                                  child: TweenAnimationBuilder(
                                      curve: Curves.fastOutSlowIn,
                                      tween: Tween<double>(
                                          begin: !showSearchResult ? 0.0 : 1.0,
                                          end: !showSearchResult ? 1.0 : 0.0),
                                      duration:
                                          const Duration(milliseconds: 500),
                                      builder: (BuildContext context,
                                          double _val, Widget? child) {
                                        return ListView(
                                          children: [
                                            searchButton(1),
                                            isSearching || showSearchResult
                                                ? nopolDisplay()
                                                : SizedBox.shrink()
                                          ],
                                        );
                                        // ListView.builder(
                                        //   itemCount: toRender.length + 1,
                                        //   // gridDelegate:
                                        //   //     const SliverGridDelegateWithFixedCrossAxisCount(
                                        //   //         crossAxisCount: 2,
                                        //   //         childAspectRatio: 1 / 1,
                                        //   //         crossAxisSpacing: 5,
                                        //   //         mainAxisSpacing: 5),
                                        //   itemBuilder:
                                        //       (BuildContext context, int index) {
                                        //     return index == 0
                                        //         ? Global.spacer_v(7.5)
                                        //         : MenuTile(
                                        //             alignment: Global
                                        //                 .menutile_horizontal,
                                        //             title: toRender[index - 1]
                                        //                 ['title'],
                                        //             icon: toRender[index - 1]
                                        //                 ['icon'],
                                        //             color: toRender[index - 1]
                                        //                 ['color'],
                                        //             ontap: toRender[index - 1]
                                        //                 ['ontap'],
                                        //           );
                                        //   },
                                        // );
                                      }),
                                ),
                              ]),
                            )
                    ],
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
