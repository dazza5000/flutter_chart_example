import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_chart_sample/report.dart';


class ReportRepository {

  static Map<String, List<Report>> reportCache = {};
  static DateTime cacheTime = DateTime.now();

  Future<List<Report>> getReports() async {

    String jsonString = await _loadFromAsset();
    final jsonResponse = jsonDecode(jsonString);

    return parseReports(jsonResponse);
  }

  List<Report> parseReports(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Report>((json) => Report.fromJson(json)).toList();
  }

  Future<String>_loadFromAsset() async {
    return await rootBundle.loadString("assets/chart_data.json");
  }

}

