import 'package:e_hawk_mobile/utilities/Global.dart';
import 'package:e_hawk_mobile/widgets/CustomButton.dart';
import 'package:e_hawk_mobile/widgets/CustomDialog.dart';
import 'package:flutter/material.dart';

class Alert {
  static Future<void> alert(
      BuildContext context, String title, String content) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: CustomDialog(
            label: title,
            content: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(content,
                  style: Global.genericText, textAlign: TextAlign.center),
            ),
            actions: [
              Center(
                child: CustomButton(
                  style: Global.btn_small,
                  textColor: Colors.white,
                  color: Global.ctaPrimary,
                  label: 'Ok',
                  onpress: () async {
                    Navigator.of(context).pop(true);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
