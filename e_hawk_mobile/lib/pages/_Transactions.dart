import 'package:e_hawk_mobile/layouts/CustomScaffold.dart';
import 'package:e_hawk_mobile/utilities/Alert.dart';
import 'package:e_hawk_mobile/utilities/Global.dart';
import 'package:e_hawk_mobile/webservices/api.dart';
import 'package:e_hawk_mobile/widgets/CustomButton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Transactions_table extends StatefulWidget {
  const Transactions_table({Key? key})
      : super(key: key); //change all occurence for new class

  @override
  _Transactions_tableState createState() => _Transactions_tableState();
}

class _Transactions_tableState extends State<Transactions_table> {
  BuildContext? _ctx;
  bool isLoading = true;

  ScrollController _trxSCr = ScrollController();

  SharedPreferences? prefs;

  List<Map<String, dynamic>> txList = [];

  Map<String, dynamic> sortSet = {'a': 0, 'b': 0, 'c': 0};

  final formatter = NumberFormat.simpleCurrency(
      locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLoading();
    popTxList();
  }

  void popTxList() {
    if (kDebugMode) {
      for (var i = 0; i < 100; i++) {
        var map = {
          "id": "17",
          "id_customer": "21",
          "order_no": "EHW-${20221107115142 + i}",
          "order_amount": "110000",
          "subscription_term": "1",
          "status": "0",
          "order_type": "INITIAL_PAYMENT",
          "received_amount": null,
          "transaction_date": null,
          "created_at": "2022-11-07 11:51:42",
          "TRX_CREATED_AT": "07-11-2022 11:51:42"
        };
        txList.add(map);
      }
    }
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
      _getTransactions().then((value) => isLoading = value);
      debugPrint('states loaded');
    } else {
      debugPrint('state loading error');
      debugPrint(states.toString());
      // we need to handle the error somewhere
    }
    if (mounted) setState(() {});
  }

  void toggleSort(String id) {
    setState(() {
      switch (id) {
        case 'a':
          if (sortSet['a'] == 2) {
            sortSet['a'] = 0;
          } else {
            sortSet['a']++;
          }
          sortSet['b'] = 0;
          sortSet['c'] = 0;
          break;
        case 'b':
          if (sortSet['b'] == 2) {
            sortSet['b'] = 0;
          } else {
            sortSet['b']++;
          }
          sortSet['a'] = 0;
          sortSet['c'] = 0;
          break;
        case 'c':
          if (sortSet['c'] == 2) {
            sortSet['c'] = 0;
          } else {
            sortSet['c']++;
          }
          sortSet['b'] = 0;
          sortSet['a'] = 0;
          break;
        default:
      }
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

  Future<bool> _getTransactions() async {
    var data = prefs!.getString('sess_id');
    return Api.getTransactions(data).then((response) async {
      if (response['status'] == 'SUCCESS') {
        // debugPrint('data: ${response['data']}');
        List<dynamic> dataBloc = response['data'];
        for (var element in dataBloc) {
          txList.add(element);
        }
        setState(() {});
        return true;
      } else {
        Alert.alert(context, "Error", response['message']);
        return false;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(true);
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: CustomScaffold(
          screen: Global.screen_transactions, //put in global
          title: "Transaksi",
          context: context,
          child: Column(children: [
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        padding: Global.p_a(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Daftar Transaksi",
                              style: Global.headerText,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: CustomButton(
                                  margin: EdgeInsets.zero,
                                  color: Global.ctaPrimary,
                                  label: 'Perpanjang Langganan',
                                  onpress: () {}),
                            ),
                          ],
                        ),
                      ),
                      Global.dvd(),
                      // Card(
                      //   margin: EdgeInsets.only(left: 15, bottom: 10),
                      //   child: Container(
                      //     padding: EdgeInsets.all(8),
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         Text(
                      //           "Filter",
                      //           style: Global.titleText
                      //               .apply(color: Global.primary),
                      //         ),
                      //         Global.spacer_h10(),
                      //         Icon(
                      //           FontAwesomeIcons.filter,
                      //           color: Global.primary,
                      //           size: 16,
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Card(
                        //t header
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5))),
                        child: Container(
                          padding: EdgeInsets.zero,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Global.primary))),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: Global.p_a(10),
                                      child: Text(
                                        "No. Order",
                                        style: Global.genericText.apply(
                                            color: Global.primary,
                                            fontWeightDelta: 2),
                                      ),
                                    ),
                                    IconButton(
                                        splashRadius: 14,
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          toggleSort('a');
                                        },
                                        icon: Icon(
                                          sortSet['a'] == 0
                                              ? FontAwesomeIcons.sort
                                              : sortSet['a'] == 1
                                                  ? FontAwesomeIcons.sortDown
                                                  : FontAwesomeIcons.sortUp,
                                          color: Global.primary,
                                          size: 14,
                                        ))
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Container(
                                  padding: Global.p_a(10),
                                  child: Text(
                                    "Nilai Transaksi",
                                    style: Global.genericText.apply(
                                        color: Global.primary,
                                        fontWeightDelta: 2),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: Global.p_a(10),
                                  child: Text(
                                    "Status",
                                    style: Global.genericText.apply(
                                        color: Global.primary,
                                        fontWeightDelta: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          constraints: BoxConstraints(
                              maxHeight: Global.mqh(context) * 0.4),
                          margin: Global.p_s(15, 'h'),
                          child: Scrollbar(
                            thumbVisibility: true,
                            controller: _trxSCr,
                            child: ListView.builder(
                              controller: _trxSCr,
                              shrinkWrap: true,
                              itemCount: txList.length,
                              itemBuilder: (BuildContext context, int index) {
                                Map<String, dynamic> blocc = txList[index];
                                String status = "";
                                Color clStat = Colors.black;
                                switch (blocc['status']) {
                                  case "0":
                                    status = "Pending";
                                    clStat = Colors.amber;
                                    break;
                                  case "1":
                                    status = "Success";
                                    clStat = Colors.green;
                                    break;
                                  default:
                                }
                                return GestureDetector(
                                  onTap: () {},
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            height: 40,
                                            margin: EdgeInsets.zero,
                                            padding: const EdgeInsets.only(
                                                top: 10.0, left: 10.0),
                                            child: Text(
                                              "${blocc['order_no']}",
                                              style: Global.genericText,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                            height: 40,
                                            margin: EdgeInsets.zero,
                                            padding: const EdgeInsets.only(
                                                top: 10.0, left: 10.0),
                                            child: Text(
                                              formatter.format(int.parse(
                                                  blocc['order_amount'])),
                                              style: Global.genericText,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            height: 40,
                                            margin: EdgeInsets.zero,
                                            padding: const EdgeInsets.only(
                                                top: 10.0, left: 10.0),
                                            child: Text(
                                              status,
                                              style: Global.genericText
                                                  .apply(color: clStat),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )),
                      Card(
                        margin: const EdgeInsets.only(
                            bottom: 15, left: 15, right: 15),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5))),
                        child: Container(
                          height: 15,
                          decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(color: Global.cardDefault!)),
                          ),
                        ),
                      ),
                    ]),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
