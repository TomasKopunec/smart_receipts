import 'package:flutter/material.dart';

void main() {
  runApp(Main());
}

/// The starting point of the app
class Main extends StatelessWidget {
  Main() : super(key: UniqueKey());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text("Smart receipts"),
          ),
          body: const Center(
            child: Text("Welcome"),
          )),
    );
  }
}
