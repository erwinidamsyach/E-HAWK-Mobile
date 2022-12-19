import 'package:e_hawk_mobile/layouts/CustomScaffold.dart';
import 'package:e_hawk_mobile/utilities/Alert.dart';
import 'package:e_hawk_mobile/utilities/Global.dart';
import 'package:e_hawk_mobile/webservices/api.dart';
import 'package:e_hawk_mobile/widgets/CustomButton.dart';
import 'package:e_hawk_mobile/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({Key? key})
      : super(key: key); //change all occurence for new class

  @override
  _UserSettingState createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  BuildContext? _ctx;
  bool isLoading = true;
  bool? validate;

  SharedPreferences? prefs;

  TextEditingController oldPwd = TextEditingController();
  TextEditingController newPwd = TextEditingController();
  TextEditingController newPwdRe = TextEditingController();

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

  void _changePassword() {
    if (newPwd.text != newPwdRe.text) {
      validate = false;
    } else {
      validate = true;
    }
    if (validate ?? false) {
      Map<String, dynamic> data = {
        'old': oldPwd.text,
        'new': newPwd.text,
        're_new': newPwdRe.text,
        'user_id': prefs!.getString('sess_id')
      };
      Api.changePassword(data).then((response) {
        if (response['status'] == 'SUCCESS') {
          debugPrint("resp: $response");
          Alert.alert(context, "Berhasil!", "Password anda berhasil diganti.");
        } else {
          Alert.alert(context, "Gagal!", "Ganti password gagal.");
        }
      });
    }
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
          title: "Pengaturan",
          screen: Global.screen_settings, //put in global
          context: context,
          child: Column(children: [
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Ganti Password', style: Global.headerText),
                        Global.dvd(),
                        CustomTextFormField(
                          style: Global.tbox_style_pill,
                          label: 'Password Lama',
                          controller: oldPwd,
                          isPassword: true,
                        ),
                        CustomTextFormField(
                          textColor: validate ?? true
                              ? Colors.black
                              : Global.errorText,
                          borderColor: validate ?? true
                              ? Colors.black
                              : Global.errorText,
                          style: Global.tbox_style_pill,
                          label: 'Password Baru',
                          controller: newPwd,
                          isPassword: true,
                        ),
                        CustomTextFormField(
                          textColor: validate ?? true
                              ? Colors.black
                              : Global.errorText,
                          borderColor: validate ?? true
                              ? Colors.black
                              : Global.errorText,
                          style: Global.tbox_style_pill,
                          label: 'Ketik Ulang Password Baru',
                          controller: newPwdRe,
                          isPassword: true,
                        ),
                        Global.spacer_h10(),
                        CustomButton(
                            margin: EdgeInsets.only(left: 20, top: 10),
                            style: Global.btn_small,
                            color: Global.ctaPrimary,
                            label: 'Simpan',
                            onpress: () {
                              _changePassword();
                            }),
                        Global.filler()
                      ]),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
