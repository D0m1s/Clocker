import 'package:flutter/material.dart';
import 'dart:async';
import '../file_manager.dart';

class AppState extends ChangeNotifier {
  // clock variables
  var clockedIn = false;
  var clockInTimes = <DateTime>[];
  var clockOutTimes = <DateTime>[];

  // stopwatch
  var timeElapsed = 0;
  var timeDuration = Duration();
  Timer? timer;

  // button variables
  var buttonColor = Colors.green;
  var buttonText = "CLOCK IN";

  AppState() {
    loadAppState();
  }

  Future<AppState> loadAppState() async {
    clockInTimes = await loadClockInTimes();
    clockOutTimes = await loadClockOutTimes();

    DateTime? latestClockInTime = await loadAppStateLastClockIn();

    if (latestClockInTime == null) {
      clockOut();
      notifyListeners();
      return this;
    }

    if (clockInTimes.isEmpty || !clockInTimes.last.isAtSameMomentAs(latestClockInTime)) {
      clockInTimes.add(latestClockInTime);
      clockIn();
    } 
    else if (clockInTimes.last.isAtSameMomentAs(latestClockInTime)) {
      timeElapsed = clockOutTimes.last.difference(latestClockInTime).inSeconds;
      clockOut();
    }

    notifyListeners();
    return this;
  }

  void toggleClock() {
    if (!clockedIn) {
      timeElapsed = 0;
      clockInTimes.add(DateTime.now());
      clockIn();
    } else {
      clockOutTimes.add(DateTime.now());
      timer!.cancel();
      saveShiftData(clockInTimes, clockOutTimes);
      timeElapsed = DateTime.now().difference(clockInTimes.last).inSeconds;
      clockOut();
    }
    notifyListeners();
    saveAppState(clockInTimes.last);
  }

  void clockIn() {
    clockedIn = true;
    buttonText = "CLOCK OUT";
    buttonColor = Colors.red;
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      timeElapsed = DateTime.now().difference(clockInTimes.last).inSeconds;
      notifyListeners();
    });
  }

  void clockOut() {
    clockedIn = false;
    buttonText = "CLOCK IN";
    buttonColor = Colors.green;
  }
}
