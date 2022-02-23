import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:covid_info/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import './constants.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CovidInfo()),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MainPage(),
    );
  }
}

class CovidInfo with ChangeNotifier, DiagnosticableTreeMixin {
  dynamic _targetData;
  dynamic _targetDataYesterday;
  dynamic get targetdata => _targetData;
  dynamic get targetdataYesterday => _targetDataYesterday;
  void setTargetData(newData) {
    _targetData = newData;
  }
  void setTargetDataYesterday(newData) {
    _targetDataYesterday = newData;
  }

}
