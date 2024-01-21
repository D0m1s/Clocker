import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/states/app_state.dart';
import '/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    return ChangeNotifierProvider(
      create: (context) => appState,
      child: MaterialApp(
        title: 'Clocker',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: FutureBuilder<AppState>(
          future: Future.value(
              appState),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ColoredBox(color: Color.fromRGBO(56, 56, 56, 1));
            } else {
              return const HomePage();
            }
          },
        ),
      ),
    );
  }
}
