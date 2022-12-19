import 'dart:math';

import 'package:e_hawk_mobile/layouts/CustomScaffold.dart';
import 'package:e_hawk_mobile/provider/txProvider.dart';
import 'package:e_hawk_mobile/utilities/Alert.dart';
import 'package:e_hawk_mobile/utilities/Global.dart';
import 'package:e_hawk_mobile/utilities/popUps.dart';
import 'package:e_hawk_mobile/webservices/api.dart';
import 'package:e_hawk_mobile/widgets/CustomButton.dart';
import 'package:e_hawk_mobile/widgets/CustomDialog.dart';
import 'package:e_hawk_mobile/widgets/CustomDropdownFormField.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key})
      : super(key: key); //change all occurence for new class

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  BuildContext? _ctx;
  bool isLoading = true;
  bool useFilteredList = false;

  ScrollController _trxSCr = ScrollController();

  SharedPreferences? prefs;

  List<Map<String, dynamic>> txList = [];

  Map<String, dynamic> ms_term = {'1': '1', '3': '3'}; //get from api

  Map<String, dynamic> sortSet = {'a': 0, 'b': 0, 'c': 0, 'd': 0};

  String filterMode = '';
  Widget? panelFace;

  List<Map<String, dynamic>> filteredList = [];

  PanelController pct = PanelController();

  final DateFormat rr = DateFormat("EEE, dd MMM yyyy", 'id');

  final formatter = NumberFormat.simpleCurrency(
      locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);

  final datetime = DateFormat('dd MMMM yyyy, hh:mm');

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
          "subscription_term": Random().nextBool() ? "1" : "3",
          "status": Random().nextBool() ? "1" : "0",
          "order_type": "INITIAL_PAYMENT",
          "received_amount": null,
          "transaction_date": null,
          "created_at": "2022-10-${Random().nextInt(17) + 11} 11:51:42",
          "TRX_CREATED_AT": "07-10-2022 11:51:42"
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
          sortSet['d'] = 0;
          sortSet['b'] = 0;
          sortSet['c'] = 0;
          break;
        case 'b':
          if (sortSet['b'] == 2) {
            sortSet['b'] = 0;
          } else {
            sortSet['b']++;
          }
          sortSet['d'] = 0;
          sortSet['a'] = 0;
          sortSet['c'] = 0;
          break;
        case 'c':
          if (sortSet['c'] == 2) {
            sortSet['c'] = 0;
          } else {
            sortSet['c']++;
          }
          sortSet['d'] = 0;
          sortSet['b'] = 0;
          sortSet['a'] = 0;
          break;
        case 'd':
          if (sortSet['d'] == 2) {
            sortSet['d'] = 0;
          } else {
            sortSet['d']++;
          }
          sortSet['c'] = 0;
          sortSet['b'] = 0;
          sortSet['a'] = 0;
          break;
        default:
      }
    });
  }

  void _resubscribe() {
    Api.getSubsData().then((response) {
      debugPrint("response: $response");
      popUps.paymentSelect(context, response['data'], false);
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

  Map<String, DateTime> getDate(String range) {
    DateTime start = DateTime.now();
    DateTime? end;
    switch (range) {
      case Global.l7d:
        end = DateTime(start.year, start.month, start.day - 7);
        break;
      case Global.l30d:
        end = DateTime(start.year, start.month, start.day - 30);
        break;
      case Global.l90d:
        end = DateTime(start.year, start.month, start.day - 90);
        break;
      default:
    }
    return {'end': end!, 'start': start};
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

  void filternsort(String filter) async {
    setState(() {
      filterMode = filter;
    });
    pct.open();
  }

  void _buildFilterList(Map<String, dynamic> filter) {
    Iterable<Map<String, dynamic>> params = [];
    switch (filterMode) {
      case 'txDate':
        params = txList.where((item) {
          DateTime txDate = DateTime.parse(item['created_at']);
          bool res = filter['end']!.isBefore(txDate) &&
              filter['start']!.isAfter(txDate);
          return res;
        });
        break;
      case 'status':
        params = txList.where((item) {
          String id = item['status'];
          Iterable<String> filters = filter['status'];
          bool res = filters.any((item) => id == item);
          return res;
        });
        break;
      case 'term':
        params = txList.where((item) {
          String id = item['subscription_term'];
          Iterable<String> filters = filter['terms'];
          bool res = filters.any((item) => id == item);
          return res;
        });
        break;
      default:
    }

    setState(() {
      filteredList.clear();
      useFilteredList = true;
      filteredList.addAll(params);
      useFilteredList = true;
      debugPrint('params: $params');
      debugPrint('filterd: $filteredList');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TxProvider>(builder: (context, tx, __) {
      switch (filterMode) {
        case 'txDate':
          panelFace = FilterTxDate(context, tx);
          break;
        case 'status':
          panelFace = FilterStatus(context, tx);
          break;
        case 'term':
          panelFace = FilterTerm(context, tx);
          break;
        default:
          panelFace = Container();
          break;
      }
      return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(true);
          return true;
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: CustomScaffold(
            pct: pct,
            panel: TxPanel(context, tx, panelFace!),
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
                              const Text(
                                "Daftar Transaksi",
                                style: Global.headerText,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: CustomButton(
                                    margin: EdgeInsets.zero,
                                    color: Global.ctaPrimary,
                                    label: 'Perpanjang Langganan',
                                    onpress: () {
                                      _resubscribe();
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, bottom: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomButton(
                                    suffixIcon: Icon(
                                      FontAwesomeIcons.filter,
                                      size: 12,
                                      color: tx.selectedDateRange
                                              .containsValue(true)
                                          ? Global.primary
                                          : Colors.black,
                                    ),
                                    style: Global.btn_controlSmall,
                                    textColor:
                                        tx.selectedDateRange.containsValue(true)
                                            ? Global.primary
                                            : Colors.black,
                                    label: 'Tanggal',
                                    onpress: () => filternsort('txDate')),
                                CustomButton(
                                    suffixIcon: Icon(
                                      FontAwesomeIcons.filter,
                                      size: 12,
                                      color:
                                          tx.selectedTxTerm.containsValue(true)
                                              ? Global.primary
                                              : Colors.black,
                                    ),
                                    style: Global.btn_controlSmall,
                                    textColor:
                                        tx.selectedTxTerm.containsValue(true)
                                            ? Global.primary
                                            : Colors.black,
                                    label: 'Transaksi',
                                    onpress: () {
                                      if (tx.selectedTxTerm.isEmpty) {
                                        tx.initSelectedTxTerm();
                                      }
                                      debugPrint("${tx.selectedTxTerm}");
                                      filternsort('term');
                                    }),
                                CustomButton(
                                    suffixIcon: Icon(
                                      FontAwesomeIcons.filter,
                                      size: 12,
                                      color: tx.selectedTxStatus
                                              .containsValue(true)
                                          ? Global.primary
                                          : Colors.black,
                                    ),
                                    style: Global.btn_controlSmall,
                                    label: 'Status',
                                    textColor:
                                        tx.selectedTxStatus.containsValue(true)
                                            ? Global.primary
                                            : Colors.black,
                                    onpress: () => filternsort('status')),
                              ]),
                        ),

                        const Divider(
                          height: 0,
                          endIndent: 0,
                          indent: 0,
                          thickness: 1,
                        ),
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
                        Expanded(
                          child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0),
                              child: useFilteredList && filteredList.isEmpty
                                  ? Center(
                                      child: Text(
                                        'Tidak Ada Transaksi',
                                        style: Global.headerText
                                            .apply(color: Global.primary),
                                      ),
                                    )
                                  : !useFilteredList && txList.isEmpty
                                      ? Center(
                                          child: Text(
                                            'Tidak Ada Transaksi',
                                            style: Global.headerText
                                                .apply(color: Global.primary),
                                          ),
                                        )
                                      : Scrollbar(
                                          controller: _trxSCr,
                                          child: ListView.separated(
                                            separatorBuilder:
                                                (BuildContext context,
                                                        int index) =>
                                                    const Divider(
                                              thickness: 1,
                                              endIndent: 12,
                                              indent: 12,
                                            ),
                                            controller: _trxSCr,
                                            shrinkWrap: true,
                                            itemCount: useFilteredList
                                                ? filteredList.length
                                                : txList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              Map<String, dynamic> blocc =
                                                  useFilteredList
                                                      ? filteredList[index]
                                                      : txList[index];
                                              String status = "";
                                              Color clStat = Colors.black;
                                              switch (blocc['status']) {
                                                case "0":
                                                  status = "Pending";
                                                  clStat = Global.warningText;
                                                  break;
                                                case "1":
                                                  status = "Lunas";
                                                  clStat = Global.succesText!;
                                                  break;
                                                default:
                                              }
                                              return GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                      maxHeight: 60),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.zero,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10.0,
                                                                  left: 10.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Langganan ${blocc['subscription_term']} bulan",
                                                                style: Global
                                                                    .headerText,
                                                              ),
                                                              Global
                                                                  .spacer_v5(),
                                                              Text(
                                                                datetime.format(
                                                                    DateTime.parse(
                                                                        blocc[
                                                                            'created_at'])),
                                                                style: Global
                                                                    .genericText,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.zero,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10.0,
                                                                  left: 10.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                formatter.format(
                                                                    int.parse(blocc[
                                                                        'order_amount'])),
                                                                style: Global
                                                                    .titleText,
                                                              ),
                                                              Global
                                                                  .spacer_v5(),
                                                              Text(
                                                                status,
                                                                style: Global
                                                                    .genericText
                                                                    .apply(
                                                                        color:
                                                                            clStat),
                                                              ),
                                                            ],
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
                        ),
                      ]),
                ),
              )
            ]),
          ),
        ),
      );
    });
  }

  Widget TxPanel(BuildContext context, TxProvider tx, Widget panelFace) {
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Divider(
            color: Global.disabledText,
            indent: Global.mqw(context) * 0.45,
            endIndent: Global.mqw(context) * 0.45,
            thickness: 4,
          ),
          Global.spacer_v10(),
          Expanded(child: panelFace),
        ],
      ),
    );
  }

  Widget FilterTxDate(BuildContext context, TxProvider tx) {
    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 10, left: 20, bottom: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                flex: 9,
                child: Text(
                  'Filter tanggal transaksi',
                  style: Global.h5Text.apply(color: Global.primary),
                ),
              ),
              Expanded(
                flex: 3,
                child: CustomButton(
                    textColor: tx.selectedDateRange.containsValue(true)
                        ? Global.errorText
                        : Colors.black,
                    style: Global.btn_ctaSmall,
                    label: 'Clear',
                    onpress: () {
                      tx.toggleHasSelectedFilter(false);
                      tx.resetSelectedDateRange();
                      filteredList.clear();
                      useFilteredList = false;
                    }),
              )
            ],
          ),
        ),
        Container(
          padding: Global.p_s(20, 'h'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '7 hari terakhir',
                      style: Global.titleText.apply(
                        color: Global.primary,
                      ),
                    ),
                    Text(
                      rr.format(getDate(Global.l7d)['end']!) +
                          " - " +
                          rr.format(getDate(Global.l7d)['start']!),
                      style: Global.genericText,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(
                    tx.selectedDateRange[Global.l7d]!
                        ? FontAwesomeIcons.solidCircleCheck
                        : FontAwesomeIcons.circle,
                    color: Global.primary,
                  ),
                  onPressed: () {
                    // if (tx.selectedDateRange[Global.l7d]!) {
                    //   tx.setSelectedDateRange(Global.l7d, false);
                    // } else {
                    tx.resetSelectedDateRange();
                    tx.setSelectedDateRange(Global.l7d, true);
                    //}
                  },
                ),
              )
            ],
          ),
        ),
        Container(
          padding: Global.p_s(20, 'h'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '30 hari terakhir',
                      style: Global.titleText.apply(
                        color: Global.primary,
                      ),
                    ),
                    Text(
                      rr.format(getDate(Global.l30d)['end']!) +
                          " - " +
                          rr.format(getDate(Global.l30d)['start']!),
                      style: Global.genericText,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(
                    tx.selectedDateRange[Global.l30d]!
                        ? FontAwesomeIcons.solidCircleCheck
                        : FontAwesomeIcons.circle,
                    color: Global.primary,
                  ),
                  onPressed: () {
                    // if (tx.selectedDateRange[Global.l30d]!) {
                    //   tx.setSelectedDateRange(Global.l30d, false);
                    // } else {
                    tx.resetSelectedDateRange();
                    tx.setSelectedDateRange(Global.l30d, true);
                    //}
                  },
                ),
              )
            ],
          ),
        ),
        Container(
          padding: Global.p_s(20, 'h'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '90 hari terakhir',
                      style: Global.titleText.apply(
                        color: Global.primary,
                      ),
                    ),
                    Text(
                      rr.format(getDate(Global.l90d)['end']!) +
                          " - " +
                          rr.format(getDate(Global.l90d)['start']!),
                      style: Global.genericText,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(
                    tx.selectedDateRange[Global.l90d]!
                        ? FontAwesomeIcons.solidCircleCheck
                        : FontAwesomeIcons.circle,
                    color: Global.primary,
                  ),
                  onPressed: () {
                    // if (tx.selectedDateRange[Global.l90d]!) {
                    //   tx.setSelectedDateRange(Global.l90d, false);
                    // } else {
                    tx.resetSelectedDateRange();
                    tx.setSelectedDateRange(Global.l90d, true);
                    //}
                  },
                ),
              ),
            ],
          ),
        ),
        Global.filler(),
        CustomButton(
            color: Global.ctaPrimary,
            label: 'Set Filter',
            onpress: () {
              tx.resetSelectedTxStatus();
              tx.resetSelectedTxTerm();
              tx.toggleHasSelectedFilter(true);
              pct.close().then((value) {
                String keys = tx.selectedDateRange.keys.firstWhere(
                  (element) {
                    return tx.selectedDateRange[element]!;
                  },
                  orElse: () => 'none',
                );
                debugPrint('keys: $keys');
                if (keys != 'none') {
                  _buildFilterList(getDate(keys));
                } else {
                  setState(() {
                    filteredList.clear();
                  });
                }
              });
            })
      ],
    );
  }

  Widget FilterStatus(BuildContext context, TxProvider tx) {
    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 10, left: 20, bottom: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                flex: 9,
                child: Text(
                  'Filter status transaksi',
                  style: Global.h5Text.apply(color: Global.primary),
                ),
              ),
              Expanded(
                flex: 3,
                child: CustomButton(
                    textColor: tx.selectedTxStatus.containsValue(true)
                        ? Global.errorText
                        : Colors.black,
                    style: Global.btn_ctaSmall,
                    label: 'Clear',
                    onpress: () {
                      tx.toggleHasSelectedFilter(false);
                      tx.resetSelectedTxStatus();
                      filteredList.clear();
                      useFilteredList = false;
                    }),
              )
            ],
          ),
        ),
        Container(
          padding: Global.p_s(20, 'h'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 9,
                child: Text('Pending', style: Global.titleText),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(
                    tx.selectedTxStatus['0']!
                        ? FontAwesomeIcons.solidSquareCheck
                        : FontAwesomeIcons.square,
                    color: Global.primary,
                  ),
                  onPressed: () {
                    // tx.resetSelectedTxStatus();
                    tx.toggleSelectedTxStatus('0');
                  },
                ),
              )
            ],
          ),
        ),
        Container(
          padding: Global.p_s(20, 'h'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 9,
                child: Text('Lunas', style: Global.titleText),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(
                    tx.selectedTxStatus['1']!
                        ? FontAwesomeIcons.solidSquareCheck
                        : FontAwesomeIcons.square,
                    color: Global.primary,
                  ),
                  onPressed: () {
                    // tx.resetSelectedTxStatus();
                    tx.toggleSelectedTxStatus('1');
                  },
                ),
              )
            ],
          ),
        ),
        Global.filler(),
        CustomButton(
            color: Global.ctaPrimary,
            label: 'Set Filter',
            onpress: () {
              tx.resetSelectedDateRange();
              tx.resetSelectedTxTerm();
              tx.toggleHasSelectedFilter(true);
              pct.close().then((value) {
                var keys = tx.selectedTxStatus.keys.where(
                  (element) {
                    return tx.selectedTxStatus[element]!;
                  },
                );
                debugPrint('keys: $keys');
                _buildFilterList({'status': keys});
              });
            })
      ],
    );
  }

  Widget FilterTerm(BuildContext context, TxProvider tx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 10, left: 20, bottom: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                flex: 9,
                child: Text(
                  'Filter jenis transaksi',
                  style: Global.h5Text.apply(color: Global.primary),
                ),
              ),
              Expanded(
                flex: 3,
                child: CustomButton(
                    textColor: tx.selectedTxTerm.containsValue(true)
                        ? Global.errorText
                        : Colors.black,
                    style: Global.btn_ctaSmall,
                    label: 'Clear',
                    onpress: () {
                      tx.toggleHasSelectedFilter(false);
                      tx.resetSelectedTxTerm();
                      filteredList.clear();
                      useFilteredList = false;
                    }),
              )
            ],
          ),
        ),
        ListView.builder(
            itemCount: tx.defaultTerm.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: Global.p_s(20, 'h'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 9,
                      child: Text('${tx.defaultTerm[index]} bulan',
                          style: Global.titleText),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(
                          tx.selectedTxTerm['${tx.defaultTerm[index]}'] ?? false
                              ? FontAwesomeIcons.solidSquareCheck
                              : FontAwesomeIcons.square,
                          color: Global.primary,
                        ),
                        onPressed: () {
                          // tx.resetSelectedTxStatus();
                          tx.toggleSelectedTxTerm('${tx.defaultTerm[index]}');
                        },
                      ),
                    )
                  ],
                ),
              );
            }),
        Global.filler(),
        CustomButton(
            color: Global.ctaPrimary,
            label: 'Set Filter',
            onpress: () {
              tx.resetSelectedTxStatus();
              tx.resetSelectedDateRange();
              tx.toggleHasSelectedFilter(true);
              pct.close().then((value) {
                var keys = tx.selectedTxTerm.keys.where(
                  (element) {
                    return tx.selectedTxTerm[element]!;
                  },
                );
                debugPrint('keys: $keys');
                _buildFilterList({'terms': keys});
              });
            })
      ],
    );
  }
}
