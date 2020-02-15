import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'chart_util.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chart Exploration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Vibration Data'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  charts.TimeSeriesChart vibrationData;
  charts.TimeSeriesChart tripData;

  @override
  Widget build(BuildContext context) {

    ChartUtil().getChartData().then((vibrationData)  {
      setState(() {
        this.vibrationData = vibrationData;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FractionallySizedBox(child: vibrationData, heightFactor: .5,)
    );
  }
}
