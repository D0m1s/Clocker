import 'package:flutter/material.dart';
import 'components/shift_card.dart';
import 'package:provider/provider.dart';
import '../../states/app_state.dart';
import 'package:collection/collection.dart';

class AllShiftsPage extends StatelessWidget {
  const AllShiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var groupedByYear = groupBy(appState.clockOutTimes, (DateTime date) => date.year);

    if (groupedByYear.isEmpty) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(56, 56, 56, 1),
        body: SafeArea(
          child: Center(
            child: Text(
              "No data to display",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
          backgroundColor: Color.fromRGBO(56, 56, 56, 1),
          body: SafeArea(
            child: ListView(
              children: groupedByYear.entries.map((entry) {
                int year = entry.key;
                List<DateTime> dates = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15, top: 10, bottom: 5),
                      child: Text(
                        year.toString(),
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
                      ),
                    ),
                    for (int i = dates.length - 1; i >= 0; i--)
                      ShiftCard(
                        clockInTime: appState.clockInTimes[i],
                        clockOutTime: appState.clockOutTimes[i],
                      ),
                  ],
                );
              }).toList(),
              ),
          )
      );
    }
  }
}