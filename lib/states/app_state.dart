import 'package:flutter/material.dart';
import 'dart:async';

class AppState extends ChangeNotifier {
  // clock variables
  var clockedIn = false;
  var clockInTimes = <DateTime>[];
  var clockOutTimes = <DateTime>[];
  
  // stopwatch
  var stopwatch = Stopwatch();
  var timeElapsed = Duration();
  Timer? timer;

  // button variables
  var buttonColor = Colors.green;
  var buttonText = "CLOCK IN";

  void toggleClock() {
    if (!clockedIn) {
      timeElapsed = Duration();
      clockInTimes.add(DateTime.now());
      buttonText = "CLOCK OUT";
      buttonColor = Colors.red;
      stopwatch.start();
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
        timeElapsed = stopwatch.elapsed;
        notifyListeners();
      });
    } else {
      clockOutTimes.add(DateTime.now());
      buttonText = "CLOCK IN";
      buttonColor = Colors.green;
      stopwatch.stop();
      stopwatch.reset();
      timer!.cancel();
    }
    clockedIn = !clockedIn;
    notifyListeners();
  }
}