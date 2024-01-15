import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var clockedIn = false;
  var clockInTimes = <DateTime>[];
  var clockOutTimes = <DateTime>[];

  void toggleClock() {
    if (!clockedIn) {
      clockInTimes.add(DateTime.now());
    } else {
      clockOutTimes.add(DateTime.now());
    }
    clockedIn = !clockedIn;
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("Clock In"),
                onPressed: () {
                  print("pressed");
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
