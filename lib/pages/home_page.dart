import 'package:clockin_clockout_flutter/pages/all_shifts_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../states/app_state.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(56, 56, 56, 1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: TopTimingCard()
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  width: double.infinity,
                    child: OutlinedButton(
                      child: Text("View all shifts",
                          style:
                              TextStyle(fontSize: 15, color: Colors.white)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllShiftsPage()),
                        );
                      },
                    )
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              child: ClockButton()
            ),
          ],
        ),
      ),
    );
  }
}

class TopTimingCard extends StatelessWidget {
  const TopTimingCard({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var clockInString = "Clock in to see stats";
    var clockOutString = "Clock out to see stats";
    
    var currentColor = Color.fromRGBO(43, 43, 43, 1);
    var defaultCardColor = Color.fromRGBO(43, 43, 43, 1);
    var clockedInColor = Color.fromRGBO(44, 35, 35, 1);

    if (appState.clockInTimes.isNotEmpty) {
      clockInString = "Start time: ${DateFormat('HH:mm').format(appState.clockInTimes.last)}";
    } else {
      clockInString = "Clock in to see stats";
    }

    if (appState.clockOutTimes.isNotEmpty) {
      clockOutString = "End time: ${DateFormat('HH:mm').format(appState.clockOutTimes.last)}";
    } else {
      clockOutString = "Clock out to see stats";
    }

    if (appState.clockedIn) {
      clockOutString = "Clock out to see end time";
      currentColor = clockedInColor;
    } else {
      currentColor = defaultCardColor;
    }

    Duration duration = Duration(seconds: appState.timeElapsed);
    var hours = duration.inHours.toString().padLeft(2, '0');
    var minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    var seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Card(
      color: currentColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Color.fromRGBO(34, 34, 34, 1),
            child: Container(margin: const EdgeInsets.all(10),child: Text("Current shift", style: TextStyle(fontSize: 20, color: Colors.white)))
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Text("Elapsed time: $hours:$minutes:$seconds", 
            style: TextStyle(fontSize: 20, color: Colors.white)),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Text(clockInString, style: TextStyle(fontSize: 20, color: Colors.white)),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Text(clockOutString, style: TextStyle(fontSize: 20, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class ClockButton extends StatelessWidget {
  const ClockButton({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return SizedBox(
      height: 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: appState.buttonColor,
          foregroundColor: Colors.white,
        ),
        child: Text(appState.buttonText, style: TextStyle(fontSize: 20)),
          onPressed: () {
            appState.toggleClock();
          },
      ),
    );
  }
}
