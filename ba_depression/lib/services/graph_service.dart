import 'package:ba_depression/services/firebase_db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphService {
  DatabaseService db = DatabaseService();
  String dateTime = DateTime.now().year.toString() +
      DateTime.now().month.toString() +
      DateTime.now().day.toString();
  String monthTime = '${DateTime.now().year}${DateTime.now().month}01';
  String mostRecentMonday = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day - (DateTime.now().weekday - 1))
      .toString();

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
    for (var i = 0; i < 24; i++) {
      ret.add(FlSpot(i.toDouble(), 0));
    }

    for (var element in durationsDay.entries) {
      //calculate duration to minutes
      double durationM =
          Duration(milliseconds: element.value).inMinutes.toDouble();
      ret[element.key] =
          FlSpot(element.key.toDouble(), durationM.roundToDouble());
    }

    return ret;
  }

  Future<List<FlSpot>?> getDurationsMonth(String uid) async {
    Map<DateTime, int>? durations = await db.getSongDurations(
        uid, Timestamp.fromDate(DateTime.parse(monthTime)));

    //print(Timestamp.fromDate(DateTime.parse(monthTime)).toDate());
    if (durations == null) return null;

    Map<int, int> durationsMonth = {};
    var multipliers = [for (var i = 1; i <= 31; i++) 1.0];

    for (var element in durations.entries) {
      durationsMonth.update(element.key.day, (value) {
        multipliers[element.key.day]++;
        return value + element.value;
      }, ifAbsent: (() => element.value));
    }
    //default values 0
    List<FlSpot> ret = [];
    for (var i = 1; i <= 31; i++) {
      ret.add(FlSpot(i.toDouble(), 0));
    }

    for (var element in durationsMonth.entries) {
      //calculate duration to minutes
      double durationM =
          Duration(milliseconds: element.value).inMinutes.toDouble();
      ret[element.key - 1] =
          FlSpot(element.key.toDouble(), durationM.roundToDouble());
    }
    return ret;
  }

  Future<List<FlSpot>?> getDurationsWeek(String uid) async {
    Map<DateTime, int>? durations = await db.getSongDurations(
        uid, Timestamp.fromDate(DateTime.parse(mostRecentMonday)));

    //print(Timestamp.fromDate(DateTime.parse(monthTime)).toDate());
    if (durations == null) return null;
    Map<int, int> durationsWeek = {};

    for (var element in durations.entries) {
      durationsWeek.update(element.key.weekday, (value) {
        return value + element.value;
      }, ifAbsent: (() => element.value));
    }
    //default values 0
    List<FlSpot> ret = [];
    for (var i = 1; i <= 7; i++) {
      ret.add(FlSpot(i.toDouble(), 0));
    }

    for (var element in durationsWeek.entries) {
      //calculate duration to minutes
      int durationM = Duration(milliseconds: element.value).inMinutes;
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
    for (var i = 0; i < 24; i++) {
      ret.add(FlSpot(i.toDouble(), 0));
    }

    for (var element in temposDay.entries) {
      //calculate average bpm
      double tempoAvg = (element.value.toDouble()) / multipliers[element.key];
      ret[element.key] = FlSpot(element.key.toDouble(), tempoAvg);
    }

    return ret;
  }

  Future<List<FlSpot>?> getBPMWeek(String uid) async {
    Map<DateTime, double>? tempos = await db.getBPM(
        uid, Timestamp.fromDate(DateTime.parse(mostRecentMonday)));

    // print(Timestamp.fromDate(DateTime.parse(dateTime)).toDate());
    if (tempos == null) return null;

    Map<int, double> temposWeek = {};
    var multipliers = [for (var i = 1; i <= 7; i++) 1.0];

    for (var element in tempos.entries) {
      temposWeek.update(element.key.weekday, (value) {
        multipliers[element.key.weekday - 1]++;
        return value + element.value;
      }, ifAbsent: (() => element.value));
    }
    //default values 0
    List<FlSpot> ret = [];
    for (var i = 1; i <= 7; i++) {
      ret.add(FlSpot(i.toDouble(), 0));
    }

    for (var element in temposWeek.entries) {
      //calculate average bpm
      double tempoAvg =
          (element.value.toDouble()) / multipliers[element.key - 1];
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
        multipliers[element.key.day - 1]++;
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
      double tempoAvg =
          (element.value.toDouble()) / multipliers[element.key - 1];
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
        multipliers[element.key.day - 1]++;
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
      double tempoAvg =
          (element.value.toDouble()) / multipliers[element.key - 1];
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
    for (var i = 0; i < 24; i++) {
      ret.add(FlSpot(i.toDouble(), 0));
    }

    for (var element in moodsDay.entries) {
      //calculate average bpm
      double tempoAvg = (element.value.toDouble()) / multipliers[element.key];
      ret[element.key] = FlSpot(element.key.toDouble(), tempoAvg);
    }
    return ret;
  }

  Future<List<FlSpot>?> getValenceWeek(String uid) async {
    Map<DateTime, double>? moods = await db.getValence(
        uid, Timestamp.fromDate(DateTime.parse(mostRecentMonday)));

    // print(Timestamp.fromDate(DateTime.parse(dateTime)).toDate());
    if (moods == null) return null;
    Map<int, double> moodsWeek = {};
    var multipliers = [for (var i = 1; i <= 7; i++) 1.0];

    for (var element in moods.entries) {
      moodsWeek.update(element.key.weekday, (value) {
        multipliers[element.key.weekday - 1]++;
        return value + element.value;
      }, ifAbsent: (() => element.value));
    }
    //default values 0
    List<FlSpot> ret = [];
    for (var i = 1; i <= 7; i++) {
      ret.add(FlSpot(i.toDouble(), 0));
    }

    for (var element in moodsWeek.entries) {
      //calculate average bpm
      double tempoAvg =
          (element.value.toDouble()) / multipliers[element.key - 1];
      ret[element.key - 1] = FlSpot(element.key.toDouble(), tempoAvg);
    }
    return ret;
  }

  //Average mood per day in a month
  Future<List<FlSpot>?> getMoods(String uid) async {
    Map<DateTime, double>? moods =
        await db.getMoods(uid, Timestamp.fromDate(DateTime.parse(monthTime)));
    //print(moods);
    // print(Timestamp.fromDate(DateTime.parse(dateTime)).toDate());
    if (moods == null) return null;

    Map<int, double> moodsDay = {};
    var multipliers = [for (var i = 1; i <= 31; i++) 1.0];

    for (var element in moods.entries) {
      moodsDay.update(element.key.day, (value) {
        multipliers[element.key.day - 1]++;
        return value + element.value;
      }, ifAbsent: (() => element.value));
    }
    //default values 0
    List<FlSpot> ret = [];
    for (var i = 1; i <= 31; i++) {
      ret.add(FlSpot(i.toDouble(), 0));
    }
    for (var element in moodsDay.entries) {
      //calculate average bpm
      double tempoAvg =
          (element.value.toDouble()) / multipliers[element.key - 1];
      ret[element.key - 1] = FlSpot(element.key.toDouble(), tempoAvg);
    }

    return ret;
  }

  Future<double?> getAvgMood(String uid) async {
    Map<DateTime, double>? moods = await db.getMoods(
        uid, Timestamp.fromDate(DateTime.parse(mostRecentMonday)));
    var multiplier = 0;
    double ret = 0;

    if (moods == null) {
      return null;
    }

    for (var mood in moods.entries) {
      multiplier++;
      ret += mood.value;
    }

    return ret / multiplier;
  }
}
