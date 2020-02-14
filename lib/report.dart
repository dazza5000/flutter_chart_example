class Report {
  final String date;
  final int trips;
  final double vibration;


  Report({this.date, this.trips, this.vibration});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
        date: json['date'] as String,
        trips: json['trips'] as int,
        vibration: json['vibration'] as double
    );
  }
}