import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: "Hello World",
      theme: ThemeData(primarySwatch: Colors.orange),
      home: Home(),
      /*(home: Scaffold(
          appBar: AppBar(
            title: const Text("Hello Nur Rachmat"),
          ),
          body: const Center(
              //child: Text("Hallo Nur Rachmat"),
              //child: Image.asset("images/connected.png", width: 200, height: 200,)
              // child: Image.network("https://i0.wp.com/popeye.com/wp-content/uploads/2021/11/Popeye-Flex-e1637717888907.png"),
              child: Home(),
              ),
        ));*/
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late bool isConnected;

  final Connectivity _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult>? _connectivitySubscrition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isConnected = true;

    _initConnectionStatus().then((_) {
      _connectivitySubscrition =
          _connectivity.onConnectivityChanged.listen((result) {
        setState(() {
          isConnected = result != ConnectivityResult.none;
        });
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscrition?.cancel();
    super.dispose();
  }

  Future<void> _initConnectionStatus() async {
    final result = await _connectivity.checkConnectivity();
    setState(() {
      isConnected = result != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Internet Connection"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(microseconds: 1000),
          child: Image.asset(
            isConnected ? 'images/connected.png' : 'images/disconnected.png',
            key: ValueKey<bool>(isConnected),
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
