import 'package:covid_info/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CovidInfoGraph extends StatefulWidget {
  const CovidInfoGraph({ Key? key }) : super(key: key);

  @override
  _CovidInfoGraphState createState() => _CovidInfoGraphState();
}

class _CovidInfoGraphState extends State<CovidInfoGraph> {
  final Color dark = const Color(0xff3b8c75);
  final Color normal = const Color(0xff64caad);
  final Color light = const Color(0xff73e8c9);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.watch<CovidInfo>().targetdata != null ? context.watch<CovidInfo>().targetdata[0].toString() : ""),
    );
  }
}