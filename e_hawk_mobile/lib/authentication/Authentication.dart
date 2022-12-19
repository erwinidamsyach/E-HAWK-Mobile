import 'dart:developer';
import 'dart:io';

import 'package:e_hawk_mobile/layouts/CustomScaffold.dart';
import 'package:e_hawk_mobile/pages/Home.dart';
import 'package:e_hawk_mobile/utilities/routes.dart';
import 'package:e_hawk_mobile/widgets/CustomDialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:e_hawk_mobile/utilities/Global.dart';
import 'package:e_hawk_mobile/utilities/popUps.dart';
import 'package:e_hawk_mobile/webservices/api.dart';
import 'package:e_hawk_mobile/widgets/CustomButton.dart';
import 'package:e_hawk_mobile/widgets/CustomTextFormField.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key, this.isRegister = false})
      : super(key: key); //change all occurence for new class

  final bool isRegister;

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  BuildContext? _ctx;
  bool isLoading = true;

  bool isRegister = false;

  bool warningUsn = false;
  bool warningPwd = false;

  bool warningUnm = false;
  bool warningNik = false;
  bool warningPhn = false;
  bool warningKTP = false;

  SharedPreferences? prefs;

  TextEditingController pwd = TextEditingController();
  TextEditingController usn = TextEditingController();

  TextEditingController unm = TextEditingController();
  TextEditingController phn = TextEditingController();
  TextEditingController nik = TextEditingController();

  File? file;
  String? filenameKTP;

  final formatter = NumberFormat.simpleCurrency(
      locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    fillform(); //debugging only
    checkLoading();
  }

  void fillform() {
    if (kDebugMode) {
      setState(() {
        usn.text = "081384800864";
        pwd.text = "00864";

        // unm.text = "test register";
        // phn.text = "081235456789";
        // nik.text = "1234567890123456";
      });
    }
  }

  // Map<String, dynamic> getDebugMap() {
  //   Map<String, dynamic> map = {};
  //   if (kDebugMode) {
  //     map = {
  //       'id_user': 34,
  //       'no_hp': 00864,
  //       'subscription_base_price': 100000,
  //       'payment_fee': 10000,
  //       'subs_term': [1, 3]
  //     };
  //   }
  //   return map;
  // }

  void checkLoading() async {
    if (!isLoading) isLoading = true;
    debugPrint('checking loading state...');
    List<bool> states = await Future.wait([
      //add futures here to check
      //mostly api-loading functions
    ]);

    if (states.every((element) => element)) {
      isLoading = false;
      debugPrint('states loaded');
      isRegister = widget.isRegister;
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

  void selectAmoutn(Map<String, dynamic> tx) {}

  void do_login(BuildContext ctx) {
    if (usn.text.isEmpty) {
      setState(() {
        warningUsn = true;
      });
    } else {
      setState(() {
        warningUsn = false;
      });
    }
    if (pwd.text.isEmpty) {
      setState(() {
        warningPwd = true;
      });
    } else {
      setState(() {
        warningPwd = false;
      });
    }

    if (pwd.text.isNotEmpty && usn.text.isNotEmpty) {
      var data = {
        'email': usn.text.toString().trim(),
        'password': pwd.text.toString().trim()
      };
      Api.login(data).then((response) async {
        if (response['status'] == 'SUCCESS') {
          debugPrint('data: ${response['data']}');
          Map<String, dynamic> dataBloc = response['data'];
          prefs = await SharedPreferences.getInstance().then((prefs) {
            prefs.setString('sess_id', dataBloc['sess_id']);
            prefs.setString('sess_phone_no', dataBloc['sess_phone_no']);
            prefs.setString('sess_cust_name', dataBloc['sess_cust_name']);
            prefs.setString('sess_active_start', dataBloc['sess_active_start']);
            prefs.setString('sess_active_end', dataBloc['sess_active_end']);
            prefs.setString('sess_id_role', dataBloc['sess_id_role']);
            prefs.setString('sess_role_name', dataBloc['sess_role_name']);
            prefs.setString('sess_status', dataBloc['sess_status']);
            return prefs;
          });
          // SnackBar snackBar = SnackBar(
          //   backgroundColor: Global.succesText,
          //   content: Text('Logged in as ${prefs!.getString('sess_cust_name')}'),
          // );
          // ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
          Navigator.of(ctx).push(transitionWrapper(const Home()));
          //.push(MaterialPageRoute(builder: (context) => const Home()));
        } else {
          const snackBar = SnackBar(
            backgroundColor: Global.errorText,
            content: Text('Authentication failed'),
          );
          ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
        }
      });
    }
  }

  void do_register(BuildContext context) async {
    if (unm.text.isEmpty) {
      setState(() {
        warningUnm = true;
      });
    } else {
      setState(() {
        warningUnm = false;
      });
    }
    if (phn.text.isEmpty) {
      setState(() {
        warningPhn = true;
      });
    } else {
      setState(() {
        warningPhn = false;
      });
    }
    if (nik.text.isEmpty) {
      setState(() {
        warningNik = true;
      });
    } else {
      setState(() {
        warningNik = false;
      });
    }
    if (filenameKTP == null) {
      setState(() {
        warningKTP = true;
      });
    } else {
      setState(() {
        warningKTP = false;
      });
    }

    if (unm.text.isNotEmpty &&
        phn.text.isNotEmpty &&
        nik.text.isNotEmpty &&
        file != null) {
      //String phnum = phn.text.toString().trim();
      //phnum = phnum.substring(phnum.length - 5);
      var data = {
        'nama': unm.text.toString().trim(),
        'no_hp': phn.text.toString().trim(),
        'no_ktp': nik.text.toString().trim(),
        'file_ktp': file
      };
      Api.register(data).then((response) async {
        if (response['status'] == 'SUCCESS') {
          debugPrint('data: ${response['data']}');
          Map<String, dynamic> dataBloc = response['data'];
          popUps.paymentSelect(context, dataBloc);
        } else {
          var snackBar = SnackBar(
            backgroundColor: Global.errorText,
            content: Text('Authentication failed. ${response['message']}'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    }
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
        filenameKTP = basename(file!.path);
      });
    }
  }

  Future<bool> _exit(BuildContext context) async {
    return await showDialog(
            context: context,
            builder: (context) => CustomDialog(
                  label: 'Keluar',
                  content: "Keluar dari Aplikasi?",
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('Tidak')),
                    TextButton(
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        child: const Text('Ya'))
                  ],
                )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exit = false;
        if (isRegister) {
          setState(() {
            isRegister = false;
          });
          exit = false;
        } else {
          exit = await _exit(context);
        }
        return exit;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: CustomScaffold(
          screen: Global.screen_login,
          useAppBar: false,
          context: context,
          child: Column(children: [
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Global.filler(),
                      TweenAnimationBuilder(
                          curve: Curves.fastOutSlowIn,
                          tween: Tween<double>(
                              begin: !isRegister ? 0.0 : 1.0,
                              end: !isRegister ? 1.0 : 0.0),
                          duration: const Duration(milliseconds: 500),
                          builder: (BuildContext context, double _val,
                              Widget? child) {
                            return Card(
                              margin: Global.p_a(20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              // color: Global.cardDefault,
                              child: Container(
                                padding: Global.p_a(20),
                                constraints:
                                    const BoxConstraints(maxWidth: 600),
                                child: _val == 0.0
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 10.0),
                                              child: Text(
                                                'Daftar Akun E-HAWK Mobile',
                                                style: Global.headerText,
                                              ),
                                            ),
                                            CustomTextFormField(
                                              label: 'Nama sesuai KTP',
                                              controller: unm,
                                              style: Global.tbox_style_pill,
                                            ),
                                            warningUnm
                                                ? Text(
                                                    'Nama tidak boleh kosong',
                                                    style: Global.genericText
                                                        .apply(
                                                            color: Global
                                                                .errorText),
                                                  )
                                                : Container(),
                                            CustomTextFormField(
                                              isNumber: true,
                                              label: 'No. HP',
                                              controller: phn,
                                              style: Global.tbox_style_pill,
                                            ),
                                            warningPhn
                                                ? Text(
                                                    'No. HP tidak boleh kosong',
                                                    style: Global.genericText
                                                        .apply(
                                                            color: Global
                                                                .errorText),
                                                  )
                                                : Container(),
                                            CustomTextFormField(
                                              isNumber: true,
                                              label: 'No. KTP',
                                              controller: nik,
                                              style: Global.tbox_style_pill,
                                            ),
                                            warningNik
                                                ? Padding(
                                                    padding:
                                                        Global.p_s(15, 'h'),
                                                    child: Text(
                                                      'No. KTP tidak boleh kosong',
                                                      style: Global.genericText
                                                          .apply(
                                                              color: Global
                                                                  .errorText),
                                                    ),
                                                  )
                                                : Container(),
                                            file != null
                                                ? const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15,
                                                            vertical: 5),
                                                    child: Text(
                                                      'Foto KTP',
                                                      style: Global.titleText,
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                            file == null
                                                ? CustomTextFormField(
                                                    label: 'Foto KTP',
                                                    controller:
                                                        TextEditingController(),
                                                    style:
                                                        Global.tbox_style_pill,
                                                    onPressed: () {
                                                      pickFile();
                                                    },
                                                  )
                                                : Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    alignment: Alignment.center,
                                                    constraints: BoxConstraints(
                                                        maxHeight: Global.mqh(
                                                                context) *
                                                            0.15),
                                                    child: Image.file(
                                                      file!,
                                                      fit: BoxFit.contain,
                                                    )),
                                            warningKTP
                                                ? Padding(
                                                    padding:
                                                        Global.p_s(15, 'h'),
                                                    child: Text(
                                                      'Wajib meng-upload gambar KTP',
                                                      style: Global.genericText
                                                          .apply(
                                                              color: Global
                                                                  .errorText),
                                                    ),
                                                  )
                                                : Container(),
                                            Padding(
                                              padding: Global.p_a(15),
                                              child: const Text(
                                                'Ketentuan',
                                                style: Global.titleText,
                                              ),
                                            ),
                                            Padding(
                                              padding: Global.p_s(15, 'h'),
                                              child: Text(
                                                Global.lipsum(),
                                                style: Global.genericText,
                                              ),
                                            ),
                                            Global.spacer_v15(),
                                            Center(
                                              child: CustomButton(
                                                  style: Global.btn_small,
                                                  margin: EdgeInsets.zero,
                                                  color: Global.ctaSecondary,
                                                  label: 'Daftar',
                                                  onpress: () {
                                                    do_register(context);
                                                    // _paymentSelect(
                                                    //     context, getDebugMap());
                                                  }),
                                            ),
                                          ]) //register form
                                    : Opacity(
                                        opacity: _val,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 10.0),
                                                child: Text(
                                                  'Welcome to E-HAWK Mobile',
                                                  style: Global.headerText,
                                                ),
                                              ),
                                              CustomTextFormField(
                                                //fieldColor: Global.cardDefault,
                                                isNumber: true,
                                                label: 'No. HP',
                                                controller: usn,
                                                style: Global.tbox_style_pill,
                                              ),
                                              warningUsn
                                                  ? Text(
                                                      'No. hp tidak boleh kosong',
                                                      style: Global.genericText
                                                          .apply(
                                                              color: Global
                                                                  .errorText),
                                                    )
                                                  : Container(),
                                              CustomTextFormField(
                                                //fieldColor: Global.cardDefault,
                                                isPassword: true,
                                                label: 'Password',
                                                controller: pwd,
                                                style: Global.tbox_style_pill,
                                              ),
                                              warningPwd
                                                  ? Text(
                                                      'Password tidak boleh kosong',
                                                      style: Global.genericText
                                                          .apply(
                                                              color: Global
                                                                  .errorText),
                                                    )
                                                  : Container(),
                                              CustomButton(
                                                  style: Global.btn_small,
                                                  margin: EdgeInsets.zero,
                                                  color: Global.ctaPrimary,
                                                  label: 'Masuk',
                                                  onpress: () {
                                                    do_login(context);
                                                  }),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: RichText(
                                                  text: TextSpan(
                                                      text:
                                                          'Belum memiliki akun?',
                                                      style: Global.genericText,
                                                      children: [
                                                        TextSpan(
                                                            text: " Daftar",
                                                            recognizer:
                                                                TapGestureRecognizer()
                                                                  ..onTap = () {
                                                                    setState(
                                                                        () {
                                                                      isRegister =
                                                                          true;
                                                                    });
                                                                  },
                                                            style: Global
                                                                .genericText
                                                                .apply(
                                                                    color: Global
                                                                        .hyperlink)),
                                                      ]),
                                                ),
                                              ),
                                            ]),
                                      ),
                              ),
                            );
                          }),
                      Global.filler()
                    ]),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
