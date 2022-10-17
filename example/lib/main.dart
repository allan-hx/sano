import 'package:flutter/material.dart' hide AssetBundle;
import 'package:sano/sano.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    final bundle = NetworkBundle(
      // url: 'http://192.168.3.54:8080/assets.zip',
      url: 'http://192.168.5.110:8082/assets.zip',
      version: '1.0.0',
    );

    Sano.initInstance(
      bundle: bundle,
      context: context,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: const Center(
        child: Text('Running on\n'),
      ),
    );
  }
}
