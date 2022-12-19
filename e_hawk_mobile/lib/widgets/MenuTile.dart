import 'package:e_hawk_mobile/utilities/Global.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuTile extends StatefulWidget {
  const MenuTile(
      {Key? key,
      this.title,
      this.icon,
      this.color,
      this.ontap,
      this.alignment = Global.menutile_vertical})
      : super(key: key); //change all occurence for new class

  final String? alignment;
  final String? title;
  final IconData? icon;
  final Color? color;
  final VoidCallback? ontap;

  @override
  _MenuTileState createState() => _MenuTileState();
}

class _MenuTileState extends State<MenuTile> {
  BuildContext? _ctx;
  bool isLoading = true;
  Color? cardColor;

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

  @override
  Widget build(BuildContext context) {
    double cardSize = widget.alignment == Global.menutile_vertical
        ? (MediaQuery.of(context).size.height - kToolbarHeight) / 3.0
        : 60;
    return GestureDetector(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              height: cardSize,
              decoration: BoxDecoration(
                  color: widget.color ?? Global.cardDefault,
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: widget.alignment == Global.menutile_vertical
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: Icon(
                            widget.icon ?? FontAwesomeIcons.check,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Divider(
                            indent: 4,
                            endIndent: 4,
                            thickness: 2,
                            color: Color(0xFFF6F4F4),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Center(
                              child: Text(
                                widget.title ?? '_placeholder',
                                style: Global.headerText
                                    .apply(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 15),
                          child: Icon(
                            widget.icon ?? FontAwesomeIcons.check,
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
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              widget.title ?? '_placeholder',
                              style:
                                  Global.headerText.apply(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
        onTap: widget.ontap);
  }
}
