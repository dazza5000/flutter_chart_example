import 'dart:math';
import 'dart:ui';

import 'package:flutter_chart_sample/ReportRepository.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;



class ChartUtil {

  static String dateValue;
  static String sensorValue;

  Future<charts.TimeSeriesChart> getChartData() async {

    var reports = await ReportRepository().getReports().then((reports) {

      List<VibrationData> vibrationData = [];

      reports.forEach((report) {
        vibrationData.add(new VibrationData(DateTime.parse(report.date), report.vibration));
      });

      vibrationData.sort((a, b) {
        return a.time.compareTo(b.time);
      });

      return _createChartData(vibrationData);
    });

    return reports;
  }

  static charts.TimeSeriesChart _createChartData(List<VibrationData> vibrationData) {

    var data = [
      new charts.Series<VibrationData, DateTime>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (VibrationData vibrationData, _) => vibrationData.time,
        measureFn: (VibrationData vibrationData, _) => vibrationData.vibrationReading,
        data: vibrationData,
      ),
    ];

    return charts.TimeSeriesChart(
      data,
      behaviors: [
        LinePointHighlighter(symbolRenderer: CustomCircleSymbolRenderer())
      ],
      selectionModels: [
        SelectionModelConfig(changedListener: (SelectionModel model) {
          if (model.hasDatumSelection) {
              sensorValue = dp(model.selectedSeries[0]
                  .measureFn(model.selectedDatum[0].index), 1)
                  .toString();
              dateValue = getDate(model.selectedSeries[0]
                  .domainFn(model.selectedDatum[0].index)
                  .toString());
          }
        })
      ],
      defaultRenderer: new charts.LineRendererConfig(
          includeArea: true, stacked: true),
      animate: false,
      domainAxis: new charts.DateTimeAxisSpec(renderSpec: charts.NoneRenderSpec()),);
  }
}

class VibrationData {
  final DateTime time;
  final double vibrationReading;

  VibrationData(this.time, this.vibrationReading);
}

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {

  @override
  void paint(ChartCanvas canvas, Rectangle bounds,
      {List dashPattern,
        Color fillColor,
        Color strokeColor,
        double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRRect(
        Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 100,
            bounds.height + 40),
        fill: Color.black,
        roundBottomLeft: true,
        roundBottomRight: true,
        roundTopLeft: true,
        roundTopRight: true,
        radius: 4.0);
    var textStyle = style.TextStyle();
    textStyle.color = Color.white;
    textStyle.fontSize = 15;
    canvas.drawText(
        TextElement(ChartUtil.dateValue, style: textStyle),
        (bounds.left).round(),
        (bounds.top - 24).round());

    canvas.drawText(
        TextElement(ChartUtil.sensorValue, style: textStyle),
        (bounds.left + 36).round(),
        (bounds.top - 4).round());
  }
}

double dp(double val, int places) {
  double mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}

getDate(String lastTrip) {
  final DateTime dateTime = DateTime.parse(lastTrip);
  return DateFormat("MMM d, yyyy").format(dateTime);
}