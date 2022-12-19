import 'package:e_hawk_mobile/authentication/Authentication.dart';
import 'package:e_hawk_mobile/layouts/CustomScaffold.dart';
import 'package:e_hawk_mobile/pages/Transactions.dart';
import 'package:e_hawk_mobile/utilities/Global.dart';
import 'package:e_hawk_mobile/webservices/api.dart';
import 'package:e_hawk_mobile/widgets/CustomButton.dart';
import 'package:e_hawk_mobile/widgets/CustomDialog.dart';
import 'package:e_hawk_mobile/widgets/CustomSkeleton.dart';
import 'package:e_hawk_mobile/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key); //change all occurence for new class

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BuildContext? _ctx;
  bool isLoading = true;
  bool isSearching = false;
  bool showSearchResult = false;
  bool searchMode = true;
  bool warningSearch = false;
  bool animateInitial = false;

  TextEditingController search = TextEditingController();

  Map<String, dynamic> searchResult = {};

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

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> do_logout() {
    return prefs!.clear();
  }

  void searchNopol(BuildContext ctx) async {
    if (search.text.isNotEmpty) {
      var data = search.text.toString();
      setState(() {
        isSearching = true;
        showSearchResult = false;
      });
      bool isFound = false;
      Future<bool> checkresult = Api.getNopol(data).then((response) async {
        if (response['isExist']) {
          debugPrint('data: ${response['data']}');
          searchResult = response['data'];
          isFound = true;
          return true;
        } else {
          isFound = false;
          return true;
        }
      });
      List<bool> checknopol = await Future.wait([
        checkresult,
        Future.delayed(const Duration(seconds: 2), () {
          return true;
        })
      ]);

      if (checknopol.every((element) => element)) {
        if (mounted) {
          setState(() {
            isSearching = false;
            toggleSearchResult(isFound);
            if (!isFound) {
              const snackBar = SnackBar(
                backgroundColor: Global.errorText,
                content: Text('Nopol tidak ditemukan!'),
              );
              ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
            }
          });
        }
      }
    } else {
      const snackBar = SnackBar(
        backgroundColor: Global.errorText,
        content: Text('Nopol tidak boleh kosong!'),
      );
      ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
    }
  }

  void toggleSearchResult(bool val) {
    setState(() {
      showSearchResult = val;
    });
  }

  Future<bool> getPrefs() async {
    bool loadOk = false;
    prefs = await SharedPreferences.getInstance().then((val) {
      loadOk = true;
      return val;
    });
    return loadOk;
  }

  Widget searchButton(double _val) {
    double _exp = 1;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        margin: Global.p_a(10),
        padding: Global.p_a(7),
        // decoration: BoxDecoration(
        //     color: Colors.white,
        //     border: Border.all(
        //       color: Global.grey,
        //     ),
        //     //color: Colors.lightGreen,
        //     borderRadius: BorderRadius.circular(15)),
        height: (60 + (70 * _exp)) * _val,
        child: Column(
          mainAxisAlignment:
              _exp == 0.0 ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      'Cari Nomor Polisi',
                      style: Global.headerText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            _exp > 0.0
                ? Opacity(
                    opacity: _exp,
                    child: Divider(
                      height: 16 * _exp,
                      thickness: 2 * _exp,
                      indent: 10,
                      endIndent: 10,
                      color: Colors.black,
                    ),
                  )
                : SizedBox.shrink(),
            _exp > 0.0
                ? Opacity(
                    opacity: _exp,
                    child: SizedBox(
                      height: (50 * _exp) * _val,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: Focus(
                              onFocusChange: (_) {
                                if (!animateInitial) animateInitial = true;
                              },
                              child: CustomTextFormField(
                                  flb: FloatingLabelBehavior.never,
                                  entryTextColor: Global.grey,
                                  textColor: Global.grey,
                                  label: 'Nomor Polisi...',
                                  controller: search,
                                  onSubmit: (keyword) {
                                    searchNopol(context);
                                  },
                                  suffixIcon:
                                      Icon(FontAwesomeIcons.searchengin)),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: CustomButton(
                                margin: Global.p_a(5),
                                style: Global.btn_small,
                                color: Global.ctaPrimary,
                                label: 'Cari',
                                onpress: () {
                                  searchNopol(context);
                                }),
                          )
                        ],
                      ),
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Widget trxButton() {
    return TweenAnimationBuilder(
        curve: Curves.fastOutSlowIn,
        tween: Tween<double>(
            begin: !searchMode ? 0.0 : 1.0, end: !searchMode ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 500),
        builder: (BuildContext context, double _exp, Widget? child) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: Global.p_a(7),
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(15)),
              height: (60 * _exp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        'Cek Transaksi',
                        style: Global.headerText.apply(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget loader() {
    return TweenAnimationBuilder(
        curve: Curves.fastOutSlowIn,
        tween: Tween<double>(
            begin: isSearching ? 0.0 : 1.0, end: isSearching ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 500),
        builder: (BuildContext context, double _exp, Widget? child) {
          return Center(
            child: Container(
              padding: Global.p_a(25),
              height: 100,
              width: 100,
              child: const CircularProgressIndicator(
                color: Global.primary,
                strokeWidth: 10,
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
        builder: (BuildContext context, double exp, Widget? child) {
          double _exp = 0;
          if (animateInitial) {
            _exp = exp;
          }
          return _exp == 0.0
              ? SizedBox.shrink()
              : Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  margin: Global.p_a(10),
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Container(
                        padding: Global.p_a(15) * _exp,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nomor Polisi',
                                style: Global.headerText.apply(
                                    color: Global.grey, fontSizeFactor: _exp),
                              ),
                              Text(
                                searchResult['license_plate'] ?? "-",
                                style: Global.titleText
                                    .apply(fontSizeFactor: _exp),
                              ),
                              Global.spacer_v10(val: _exp),
                              Text(
                                'Model Kendaraan',
                                style: Global.headerText.apply(
                                    color: Global.grey, fontSizeFactor: _exp),
                              ),
                              Text(
                                searchResult['asset_type'] ?? "-",
                                style: Global.titleText
                                    .apply(fontSizeFactor: _exp),
                              ),
                              Global.spacer_v10(val: _exp),
                              Text(
                                'Finance',
                                style: Global.headerText.apply(
                                    color: Global.grey, fontSizeFactor: _exp),
                              ),
                              Text(
                                searchResult['agency'] ?? "-",
                                style: Global.titleText
                                    .apply(fontSizeFactor: _exp),
                              ),
                              Global.spacer_v10(val: _exp),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Cabang',
                                          style: Global.headerText.apply(
                                              color: Global.grey,
                                              fontSizeFactor: _exp),
                                        ),
                                        Text(
                                          searchResult['branch'] ?? "-",
                                          style: Global.titleText
                                              .apply(fontSizeFactor: _exp),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'No. Kontrak',
                                          style: Global.headerText.apply(
                                              color: Global.grey,
                                              fontSizeFactor: _exp),
                                        ),
                                        Text(
                                          searchResult['agreement_no'] ?? "-",
                                          style: Global.titleText
                                              .apply(fontSizeFactor: _exp),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Global.spacer_v10(val: _exp),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Nomor Mesin',
                                          style: Global.headerText.apply(
                                              color: Global.grey,
                                              fontSizeFactor: _exp),
                                        ),
                                        Text(
                                          searchResult['no_mesin'] ?? "-",
                                          style: Global.titleText
                                              .apply(fontSizeFactor: _exp),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Nomor Rangka',
                                          style: Global.headerText.apply(
                                              color: Global.grey,
                                              fontSizeFactor: _exp),
                                        ),
                                        Text(
                                          searchResult['no_rangka'] ?? '-',
                                          style: Global.titleText
                                              .apply(fontSizeFactor: _exp),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                      Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.only(
                              top: 10.0 * _exp, right: 10.0 * _exp),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                toggleSearchResult(false);
                              });
                            },
                            icon: Icon(
                              FontAwesomeIcons.xmark,
                              color: Global.grey,
                              size: 24 * _exp,
                            ),
                          )),
                    ],
                  ),
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _exit(context);
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: CustomScaffold(
          screen: Global.screen_home,
          title: "Dashboard E-HAWK Mobile",
          context: context,
          child: Column(children: [
            Flexible(
              child: Container(
                decoration: const BoxDecoration(
                    // border: Border.all(color: Colors.black, width: 5),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        // decoration: BoxDecoration(border: Border.all()),
                        // constraints: BoxConstraints(
                        //     maxHeight: Global.mqh(context) * 0.8),
                        child: TweenAnimationBuilder(
                            curve: Curves.fastOutSlowIn,
                            tween: Tween<double>(
                                begin: !showSearchResult ? 0.0 : 1.0,
                                end: !showSearchResult ? 1.0 : 0.0),
                            duration: const Duration(milliseconds: 500),
                            builder: (BuildContext context, double _val,
                                Widget? child) {
                              return ListView(
                                children: [
                                  searchButton(1),
                                  isSearching ? loader() : SizedBox.shrink(),
                                  // trxButton(),
                                  !isLoading
                                      ? nopolDisplay()
                                      : SizedBox.shrink(),
                                ],
                              );
                            }),
                      ),
                    ]),
              ),
            )
          ]),
        ),
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
                          var t = await do_logout();
                          Navigator.of(context).pop(t);
                        },
                        child: const Text('Ya'))
                  ],
                )) ??
        false;
  }
}
