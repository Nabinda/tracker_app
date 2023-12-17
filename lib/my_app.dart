import 'package:flutter/material.dart';
import 'package:tracker_app/features/home_screen/view/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tracker App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
              centerTitle: true, backgroundColor: Colors.amber)),
      home: const HomeScreen(),
    );
  }
}
