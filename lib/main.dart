import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_state_management/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BreadCrumbProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
        routes: {
          "/new": (context) => const NewBreadCrumbWidget(),
        },
      ),
    );
  }
}
