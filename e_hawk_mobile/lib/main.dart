import 'package:e_hawk_mobile/authentication/Authentication.dart';
import 'package:e_hawk_mobile/provider/txProvider.dart';
import 'package:e_hawk_mobile/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('id_ID', null).then((_) => runApp(const MyApp()));
}

//RouteObserver for route aware
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TxProvider>.value(value: TxProvider()),
      ],
      child: MaterialApp(
        home: const Authentication(),
        navigatorObservers: [routeObserver],
        routes: routes,
      ),
    );
  }
}
