// ignore_for_file: unused_local_variable, unused_field

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sano/src/proto/node_ast.pb.dart';
import 'package:sano/src/runtime/index.dart';

import 'channel.dart';
import 'sano.dart';

class SanoView extends StatefulWidget {
  const SanoView({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  State<SanoView> createState() => _SanoViewState();
}

class _SanoViewState extends State<SanoView> {
  // 通信通道
  late Channel _channel = Channel('$hashCode');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.url),
      ),
    );
  }
}
