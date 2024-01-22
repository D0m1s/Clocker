import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../states/app_state.dart';

class ShiftCard extends StatelessWidget {
    final DateTime? clockInTime;
    final DateTime? clockOutTime;
    final int? id;

    ShiftCard({
    this.clockInTime,
    this.clockOutTime,
    this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var clockInTimeText = "Start time: ${DateFormat('HH:mm').format(clockInTime!)}";
    var clockOutTimeText = "End time: ${DateFormat('HH:mm').format(clockOutTime!)}";
    var headerText = DateFormat('MMMM d').format(clockOutTime!).toString();

    var elapsed = clockOutTime!.difference(clockInTime!);
    var hours = elapsed.inHours.toString().padLeft(2, '0');
    var minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    var seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    var elapsedText = "Shift duration: $hours:$minutes:$seconds";

    var selected = appState.selectedClockInTimes.contains(clockInTime);

    var currentColor = Color.fromRGBO(34, 34, 34, 1);
    var color = Color.fromRGBO(43, 43, 43, 1);

    if (selected) {
      currentColor = Color.fromRGBO(26, 26, 26, 1);
      color = Color.fromARGB(255, 31, 31, 31);
    }

    return Container(
      margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
      width: double.infinity,
      child: Card(
        color: color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: currentColor,
              child: Container(margin: const EdgeInsets.all(10),child: Text(headerText, style: TextStyle(fontSize: 20, color: Colors.white)))
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(elapsedText, 
              style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(clockInTimeText, style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(clockOutTimeText, style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}