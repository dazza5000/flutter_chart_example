import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';

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
  List<Series> vibrationData;

  @override
  Widget build(BuildContext context) {

    ChartUtil().getChartData().then((vibrationData) {
      setState(() {
        this.vibrationData = vibrationData;
      });
    });

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: vibrationData != null
                ? FractionallySizedBox(
                    child: TimeSeriesChart(
                      vibrationData,
                      defaultRenderer: new LineRendererConfig(
                          includeArea: true, stacked: true),
                      animate: false,
                      domainAxis:
                          new DateTimeAxisSpec(renderSpec: NoneRenderSpec()),
                    ),
                    heightFactor: .5,
                  )
                : CircularProgressIndicator()));
  }
}
