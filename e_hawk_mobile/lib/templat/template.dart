import 'package:e_hawk_mobile/layouts/CustomScaffold.dart';
import 'package:flutter/material.dart';

class temp extends StatefulWidget {
  const temp({Key? key}) : super(key: key); //change all occurence for new class

  @override
  _tempState createState() => _tempState();
}

class _tempState extends State<temp> {
  BuildContext? _ctx;
  bool isLoading = true;

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
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(true);
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: CustomScaffold(
          screen: "SCR_TEMP", //put in global
          context: context,
          child: Column(children: [
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height),
                child: Column(
                    mainAxisSize: MainAxisSize.max, children: <Widget>[]),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
