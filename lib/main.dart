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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _getChart("Vibration", vibrationData,
                    (MediaQuery.of(context).size.width * .40)),
                _getChart("Trips", tripData,
                    (MediaQuery.of(context).size.width * .40))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getChart(String title,
      charts.TimeSeriesChart lineChartData, double dimension) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          height: dimension,
          width: dimension,
          child: lineChartData,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text("Last 30 days"),
        )
      ],
    );
  }
}
