import 'package:ba_depression/services/firebase_db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphService {
  DatabaseService db = DatabaseService();
  String dateTime = DateTime.now().year.toString() +
      DateTime.now().month.toString() +
      DateTime.now().day.toString();
  String monthTime = '${DateTime.now().year}${DateTime.now().month}01';

  Future<List<FlSpot>?> getDurationsDay(String uid) async {
    Map<DateTime, int>? durations = await db.getSongDurations(
        uid, Timestamp.fromDate(DateTime.parse(dateTime)));

    // print(Timestamp.fromDate(DateTime.parse(dateTime)).toDate());
    if (durations == null) return null;

    Map<int, int> durationsDay = {};
    for (var element in durations.entries) {
      durationsDay.update(element.key.hour, (value) => value + element.value,
          ifAbsent: (() => element.value));
    }
    //default values 0
    List<FlSpot> ret = [];
    for (var i = 1; i < 25; i++) {
      ret.add(FlSpot(i.toDouble(), 0));
    }

    for (var element in durationsDay.entries) {
      //calculate duration to minutes
      double durationM = (element.value.toDouble() / (1000.0 * 60.0)) % 60.0;
      ret[element.key - 1] =
          FlSpot(element.key.toDouble(), durationM.roundToDouble());
    }
    return ret;
  }

  Future<List<FlSpot>?> getDurationsMonth(String uid) async {
    Map<DateTime, int>? durations = await db.getSongDurations(
        uid, Timestamp.fromDate(DateTime.parse(monthTime)));

    //print(Timestamp.fromDate(DateTime.parse(monthTime)).toDate());
    if (durations == null) return null;
    print(durations);
    Map<int, int> durationsMonth = {};
    var multipliers = [for (var i = 1; i <= 31; i++) 1.0];

    for (var element in durations.entries) {
      durationsMonth.update(element.key.day, (value) {
        multipliers[element.key.day]++;
        return value + element.value;
      }, ifAbsent: (() => element.value));
    }

    print(durationsMonth);
    //default values 0
    List<FlSpot> ret = [];
    for (var i = 1; i <= 31; i++) {
      ret.add(FlSpot(i.toDouble(), 0));
    }

    for (var element in durationsMonth.entries) {
      //calculate duration to minutes
      double durationM = ((element.value.toDouble() / (1000.0 * 60.0)) % 60.0);
      ret[element.key - 1] =
          FlSpot(element.key.toDouble(), durationM.roundToDouble());
    }
    return ret;
  }

  Future<List<FlSpot>?> getBPM(String uid) async {
    Map<DateTime, double>? tempos =
        await db.getBPM(uid, Timestamp.fromDate(DateTime.parse(dateTime)));

    // print(Timestamp.fromDate(DateTime.parse(dateTime)).toDate());
    if (tempos == null) return null;

    Map<int, double> temposDay = {};
    var multipliers = [for (var i = 1; i <= 24; i++) 1.0];

    for (var element in tempos.entries) {
      temposDay.update(element.key.hour, (value) {
        multipliers[element.key.hour]++;
        return value + element.value;
      }, ifAbsent: (() => element.value));
    }
    //default values 0
    List<FlSpot> ret = [];
    for (var i = 1; i < 25; i++) {
      ret.add(FlSpot(i.toDouble(), 0));
    }

    for (var element in temposDay.entries) {
      //calculate average bpm
      double tempoAvg = (element.value.toDouble()) / multipliers[element.key];
      ret[element.key - 1] = FlSpot(element.key.toDouble(), tempoAvg);
    }
    return ret;
  }

  Future<List<FlSpot>?> getBPMMonth(String uid) async {
    Map<DateTime, double>? tempos =
        await db.getBPM(uid, Timestamp.fromDate(DateTime.parse(monthTime)));

    // print(Timestamp.fromDate(DateTime.parse(dateTime)).toDate());
    if (tempos == null) return null;

    Map<int, double> temposMonth = {};
    var multipliers = [for (var i = 1; i <= 31; i++) 1.0];

    for (var element in tempos.entries) {
      temposMonth.update(element.key.day, (value) {
        multipliers[element.key.day]++;
        return value + element.value;
      }, ifAbsent: (() => element.value));
    }
    //default values 0
    List<FlSpot> ret = [];
    for (var i = 1; i <= 31; i++) {
      ret.add(FlSpot(i.toDouble(), 0));
    }

    for (var element in temposMonth.entries) {
      //calculate average bpm
      double tempoAvg = (element.value.toDouble()) / multipliers[element.key];
      ret[element.key - 1] = FlSpot(element.key.toDouble(), tempoAvg);
    }
    return ret;
  }

  Future<List<FlSpot>?> getValenceMonth(String uid) async {
    Map<DateTime, double>? moods =
        await db.getValence(uid, Timestamp.fromDate(DateTime.parse(monthTime)));

    // print(Timestamp.fromDate(DateTime.parse(dateTime)).toDate());
    if (moods == null) return null;

    Map<int, double> moodsMonth = {};
    var multipliers = [for (var i = 1; i <= 31; i++) 1.0];

    for (var element in moods.entries) {
      moodsMonth.update(element.key.day, (value) {
        multipliers[element.key.day]++;
        return value + element.value;
      }, ifAbsent: (() => element.value));
    }
    //default values 0
    List<FlSpot> ret = [];
    for (var i = 1; i <= 31; i++) {
      ret.add(FlSpot(i.toDouble(), 0));
    }

    for (var element in moodsMonth.entries) {
      //calculate average bpm
      double tempoAvg = (element.value.toDouble()) / multipliers[element.key];
      ret[element.key - 1] = FlSpot(element.key.toDouble(), tempoAvg);
    }
    return ret;
  }

  Future<List<FlSpot>?> getValence(String uid) async {
    Map<DateTime, double>? moods =
        await db.getValence(uid, Timestamp.fromDate(DateTime.parse(dateTime)));

    // print(Timestamp.fromDate(DateTime.parse(dateTime)).toDate());
    if (moods == null) return null;

    Map<int, double> moodsDay = {};
    var multipliers = [for (var i = 1; i <= 24; i++) 1.0];

    for (var element in moods.entries) {
      moodsDay.update(element.key.hour, (value) {
        multipliers[element.key.hour]++;
        return value + element.value;
      }, ifAbsent: (() => element.value));
    }
    //default values 0
    List<FlSpot> ret = [];
    for (var i = 1; i < 25; i++) {
      ret.add(FlSpot(i.toDouble(), 0));
    }

    for (var element in moodsDay.entries) {
      //calculate average bpm
      double tempoAvg = (element.value.toDouble()) / multipliers[element.key];
      ret[element.key - 1] = FlSpot(element.key.toDouble(), tempoAvg);
    }
    return ret;
  }
}
