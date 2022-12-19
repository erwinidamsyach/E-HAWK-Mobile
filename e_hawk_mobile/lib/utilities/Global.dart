import 'package:flutter/material.dart';

class Global {
  //LIPSUMS
  static String lipsum([String length = 'S']) {
    String word = "";
    switch (length) {
      case 'S':
        word +=
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        break;
      case 'M':
        word +=
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        word +=
            "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
        break;
      case 'L':
        word +=
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        word +=
            "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
        word +=
            "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.";
        break;
      case 'XL':
        word +=
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        word +=
            "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
        word +=
            "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.";
        word +=
            "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
        break;
      default:
    }
    return word;
  }

  //COLORS
  static const color = Colors.white;
  static const primary = Colors.indigo;
  static const accent = Colors.lightBlue;

  static const grey = Colors.blueGrey;
  static final cardDefault = Colors.grey[100];
  static final succesText = Colors.greenAccent[400];
  static final disabledText = Colors.grey[350];
  static final warningText = Colors.amber;
  static const errorText = Color(0xffed1111);
  static const hyperlink = Colors.blue;
  static const ctaPrimary = Colors.orange;
  static const ctaSecondary = Colors.purple;

  //PATHS
  static const String bgImage = "asset/icon/logo_eagle.jpg";

  ///STRING IDENTIFIERS///
  //SCREEN
  static const screen_temp = 'SCR_TMP';
  static const screen_login = 'SCR_LOG';
  static const screen_register = 'SCR_REG';
  static const screen_transactions = "SCR_TRX";
  static const screen_home = 'SCR_HOME';
  static const screen_webview = "SCR_WEB";
  static const screen_settings = "SCR_STG";

  //BUTTONS
  static const String btn_small = 'BUTTON_SMALL';
  static const String btn_medium = 'BUTTON_MEDIUM';
  static const String btn_ctaSmall = 'BUTTON_CTASM';
  static const String btn_controlSmall = 'BUTTON_CTRSM';

  //TEXTBOX
  static const String tbox_style_pill = 'TBOX_PILL';
  static const String tbox_style_ulined = 'TBOX_UNDERLINED';
  static const String tbox_style_tarea = 'TBOX_TEXTAREA';

  //DROPDOWN
  static const String ddown_style_ulined = 'DDOWN_UNDERLINED';
  static const String ddown_style_pill = 'DDOWN_PILL';

  static const String gridtype_generic = "GRID_GENERIC";

  //MENU TILE
  static const String menutile_horizontal = "MT_HZ";
  static const String menutile_vertical = "MT_VT";

  //GETDATE RANGES

  static const String l7d = "LAST_7";
  static const String l30d = "LAST_30";
  static const String l90d = "LAST_90";

  //TEXT STYLES
  static const h5Text =
      TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold);

  static const headerText =
      TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);

  static const titleText =
      TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);

  static const genericText = TextStyle(
      color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal);

  static const bannerText =
      TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600);

  //LAYOUTING PRESET
  static double mqw(BuildContext ctx) => MediaQuery.of(ctx).size.width;
  static double mqh(BuildContext ctx) => MediaQuery.of(ctx).size.height;
  static EdgeInsets p_a(double a) => EdgeInsets.all(a);
  static EdgeInsets p_s(double a, String i) {
    if (i == 'h') {
      return EdgeInsets.symmetric(horizontal: a);
    } else {
      return EdgeInsets.symmetric(vertical: a);
    }
  }

  static Widget dvd() {
    return Divider(
      indent: 2,
      endIndent: 2,
      thickness: 1,
      color: Global.disabledText,
    );
  }

  static Widget sectionBreak() {
    return const Divider(
      indent: 0,
      endIndent: 0,
      thickness: 1,
      color: Global.grey,
    );
  }

  static Widget filler() {
    return Expanded(child: Container());
  }

  static Widget spacer_v5({double val = 1}) {
    return SizedBox(
      height: 5 * val,
    );
  }

  static Widget spacer_v10({double val = 1}) {
    return SizedBox(
      height: 10 * val,
    );
  }

  static Widget spacer_v15({double val = 1}) {
    return SizedBox(
      height: 15 * val,
    );
  }

  static Widget spacer_v20({double val = 1}) {
    return SizedBox(
      height: 20 * val,
    );
  }

  static Widget spacer_v(double h, {double val = 1}) {
    return SizedBox(
      height: h * val,
    );
  }

  static Widget spacer_h5({double val = 1}) {
    return SizedBox(
      width: 5 * val,
    );
  }

  static Widget spacer_h10({double val = 1}) {
    return SizedBox(
      width: 10 * val,
    );
  }

  static Widget spacer_h15({double val = 1}) {
    return SizedBox(
      width: 15 * val,
    );
  }

  static Widget spacer_h20({double val = 1}) {
    return SizedBox(
      width: 20 * val,
    );
  }

  static Widget spacer_h(double v, {double val = 1}) {
    return SizedBox(
      width: v * val,
    );
  }
}
