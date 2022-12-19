import 'package:e_hawk_mobile/pages/Webview.dart';
import 'package:e_hawk_mobile/provider/txProvider.dart';
import 'package:e_hawk_mobile/utilities/Alert.dart';
import 'package:e_hawk_mobile/utilities/Global.dart';
import 'package:e_hawk_mobile/utilities/routes.dart';
import 'package:e_hawk_mobile/webservices/api.dart';
import 'package:e_hawk_mobile/widgets/CustomButton.dart';
import 'package:e_hawk_mobile/widgets/CustomDialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class popUps {
  static final formatter = NumberFormat.simpleCurrency(
      locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);

  static Future<bool> paymentSelect(
      BuildContext context, Map<String, dynamic> payment,
      [bool isReg = true]) async {
    ScrollController _payScrl = ScrollController();
    int base = payment['subscription_base_price'];
    int fee = payment['payment_fee'];
    List<int>? subsTerm = [];
    for (var element in payment['subs_term']) {
      subsTerm.add(int.parse(element));
    }
    return await showDialog(
            context: context,
            builder: (context) {
              return Consumer<TxProvider>(builder: (context, tx, __) {
                tx.initDefaultTerm(subsTerm);
                tx.initIsSelected();
                List<int> defterm = tx.defaultTerm;
                List<bool> isSelected = tx.isSelectedTxAmt;
                return CustomDialog(
                  label: isReg ? 'Registrasi Sukses' : 'Perpanjang Langganan',
                  content: Container(
                    constraints:
                        BoxConstraints(maxHeight: Global.mqh(context) * 0.4),
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isReg
                            ? SizedBox(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Akun anda berhasil terdaftar sebagai berikut:',
                                      style: Global.genericText,
                                    ),
                                    Global.spacer_v10(),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: RichText(
                                        text: TextSpan(
                                            text: 'Username: ',
                                            style: Global.genericText
                                                .apply(fontWeightDelta: 2),
                                            children: [
                                              TextSpan(
                                                  text: "${payment['no_hp']}",
                                                  style: Global.genericText),
                                            ]),
                                      ),
                                    ),
                                    Global.spacer_v5(),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: RichText(
                                        text: TextSpan(
                                            text: 'Password: ',
                                            style: Global.genericText
                                                .apply(fontWeightDelta: 2),
                                            children: const [
                                              TextSpan(
                                                  text:
                                                      "(5 digit terakhir nomor HP anda)",
                                                  style: Global.genericText),
                                            ]),
                                      ),
                                    ),
                                    Global.spacer_v10(),
                                    const Text(
                                      "Silahkan lanjutkan pembayaran untuk mulai menggunakan layanan E-HAWK.",
                                      style: Global.genericText,
                                    ),
                                  ],
                                ),
                              )
                            : const Text(
                                "Silakan pilih paket berlangganan: ",
                                style: Global.genericText,
                              ),
                        Global.spacer_v10(),
                        Global.dvd(),
                        Global.spacer_v10(),
                        const Center(
                          child: Text(
                            "Pilihan Pembayaran",
                            style: Global.headerText,
                          ),
                        ),
                        Global.spacer_v15(),
                        Expanded(
                          child: Scrollbar(
                            thumbVisibility: true,
                            controller: _payScrl,
                            child: ListView.builder(
                              controller: _payScrl,
                              shrinkWrap: true,
                              itemCount: defterm.length,
                              itemBuilder: (BuildContext context, int index) {
                                num convAmt = 0;
                                Map<String, dynamic> txBloc = {};
                                //if (index > 0) {
                                convAmt = (base * defterm[index]) + fee;
                                txBloc = {
                                  'id_user': payment['id_user'].toString(),
                                  'term': defterm[index].toString(),
                                  'price': convAmt.toString(),
                                };
                                //}
                                return GestureDetector(
                                  onTap: () {
                                    if (!isSelected[index]) {
                                      tx.resetIsSelected();
                                    }
                                    tx.setIsSelectedTxAmt(
                                        index, !isSelected[index]);
                                    if (isSelected.contains(true)) {
                                      tx.setSelectedTx(txBloc);
                                    } else {
                                      tx.setSelectedTx({});
                                    }
                                    //debugPrint("txBloc: $txBloc");
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    color: isSelected[index]
                                        ? Global.succesText
                                        : Global.cardDefault,
                                    child: Container(
                                      height: 60,
                                      padding: Global.p_s(15, 'h'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${subsTerm[index]} bulan",
                                            style: !isSelected[index]
                                                ? Global.headerText
                                                : Global.headerText
                                                    .apply(color: Colors.white),
                                          ),
                                          Text(
                                            formatter.format(convAmt),
                                            style: !isSelected[index]
                                                ? Global.genericText
                                                : Global.genericText
                                                    .apply(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Center(
                      child: CustomButton(
                          enabled: tx.selectedTX.isNotEmpty,
                          margin: EdgeInsets.zero,
                          width: 100,
                          style: Global.btn_small,
                          color: Global.ctaSecondary,
                          label: 'Bayar',
                          onpress: () {
                            tx.resetIsSelected();
                            beginTransaction(tx.selectedTX, context, false);
                          }),
                    )
                  ],
                );
              });
            }) ??
        false;
  }

  static Future<bool> beginTransaction(
      Map<String, dynamic> data, BuildContext context,
      [bool isReg = true]) async {
    return Api.createTransaction(data).then((response) async {
      if (response['status'] == 'SUCCESS') {
        debugPrint('data: ${response['data']}');
        Map<String, dynamic> dataBloc = response['data'];
        String endpoint = response['data']['payment_url'].toString();
        //endpoint = endpoint.substring(0, endpoint.length - 4);
        String orderNo = response['data']['order_no'];
        var price = response['data']['price'];
        String url = "$endpoint?order_id=$orderNo&total=$price";
        debugPrint('url: $url');
        Navigator.of(context).pop();
        Navigator.of(context).push(
          transitionWrapper(
            Webview(
              origin:
                  isReg ? Global.screen_register : Global.screen_transactions,
              useAppBar: true,
              bottomPadding: 60,
              url: url,
            ),
          ),
        );
        return true;
      } else {
        Alert.alert(context, "Error", response['message']);
        return true;
      }
    });
  }
}
