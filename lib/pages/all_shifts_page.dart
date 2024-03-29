import 'package:flutter/material.dart';
import 'components/shift_card.dart';
import 'package:provider/provider.dart';
import '../../states/app_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../excel_exporter.dart';

class AllShiftsPage extends StatefulWidget {
  const AllShiftsPage({super.key});

  @override
  State<AllShiftsPage> createState() => _AllShiftsPageState();
}

class _AllShiftsPageState extends State<AllShiftsPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var groupedByYear =
        groupBy(appState.clockOutTimes, (DateTime date) => date.year);

    if (groupedByYear.isEmpty) {
      return NoData();
    } else {
      return Scaffold(
        backgroundColor: Color.fromRGBO(56, 56, 56, 1),
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.only(bottom: appState.selectionMode ? 85 : 0, top: 15),
                children: groupedByYear.entries.map((entry) {
                  int year = entry.key;
                  List<DateTime> dates = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: double.infinity,
                        child: Card(
                            color: Color.fromRGBO(43, 43, 43, 1),
                            child: Container(
                                margin: const EdgeInsets.all(10),
                                child: Text(
                                    "Total time worked: ${appState.totalTimeWorkedAsString()}",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)))),
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                          width: double.infinity,
                          child: ElevatedButton(
                            style: OutlinedButton.styleFrom(backgroundColor: Color.fromRGBO(77, 94, 80, 1)),
                            child: Text("Export as Excel spreadsheet",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white)),
                            onPressed: () async {
                              final snackBar = SnackBar(
                                  content: Text(
                                      "Exported to Downloads",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white)
                                          ),
                                  backgroundColor:
                                      Color.fromRGBO(26, 26, 26, 1));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              await exportDateTimesToExcel(appState.clockInTimes, appState.clockOutTimes, appState.totalTimeWorkedInSeconds());
                            },
                          )),
                      Container(
                        margin: EdgeInsets.only(left: 15, bottom: 7),
                        child: Text(
                          year.toString(),
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1),
                        ),
                      ),
                      for (int i = dates.length - 1; i >= 0; i--)
                        GestureDetector(
                          onLongPress: () {
                            appState.setSelectionMode(true);
                            appState.selectedClockInTimes.add(appState.clockInTimes[i]);
                            appState.selectedClockOutTimes.add(appState.clockOutTimes[i]);
                            setState(() {});
                          },
                          onTap: () {
                            if (appState.selectionMode && 
                            !appState.selectedClockInTimes.contains(appState.clockInTimes[i]) && 
                            !appState.selectedClockOutTimes.contains(appState.clockOutTimes[i])) {
                              appState.selectedClockInTimes.add(appState.clockInTimes[i]);
                              appState.selectedClockOutTimes.add(appState.clockOutTimes[i]);
                            } else if (appState.selectionMode && 
                            appState.selectedClockInTimes.contains(appState.clockInTimes[i]) && 
                            appState.selectedClockOutTimes.contains(appState.clockOutTimes[i])) {
                              appState.selectedClockInTimes.removeWhere((element) => element == appState.clockInTimes[i]);
                              appState.selectedClockOutTimes.removeWhere((element) => element == appState.clockOutTimes[i]);

                              if (appState.selectedClockInTimes.isEmpty || appState.selectedClockOutTimes.isEmpty) {
                                appState.setSelectionMode(false);
                              }
                            }
                            setState(() {});
                          },
                          child: ShiftCard(
                            id: i,
                            clockInTime: appState.clockInTimes[i],
                            clockOutTime: appState.clockOutTimes[i],
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
              if (appState.selectionMode)
                SelectionModeBar(appState: appState),
            ],
          ),
        ),
      );
    }
  }
}

class SelectionModeBar extends StatelessWidget {
  const SelectionModeBar({
    super.key,
    required this.appState,
  });

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [SlideEffect(begin: Offset(0, 1), duration: Duration(milliseconds: 70))],
      child: Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          color: Color.fromRGBO(31, 31, 31, 1),
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Card(
                color: Color.fromRGBO(17, 17, 17, 1),
                child: SizedBox(
                  width: 40,
                  child: Text(
                    "${appState.selectedClockInTimes.length}",
                    style: TextStyle(fontSize: 18, color: Colors.white,),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(width: 10,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 156, 43, 43)),
                onPressed: () {
                  // delete pressed
                  appState.deleteSelection();
                },
                child: Text("Delete", style: TextStyle(fontSize: 18, color: Colors.white,)),
              ),
              SizedBox(width: 10,),
              OutlinedButton(
                onPressed: () {
                  // cancel pressed
                  appState.setSelectionMode(false);
                },
                child: Text("Cancel", style: TextStyle(fontSize: 18, color: Colors.white,)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoData extends StatelessWidget {
  const NoData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(56, 56, 56, 1),
      body: SafeArea(
        child: Center(
          child: Text(
            "No data to display",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1),
          ),
        ),
      ),
    );
  }
}
