import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sano/src/framework/index.dart';
import 'package:sano/src/runtime/index.dart';
import 'package:sano/src/render/index.dart';

class SanoView extends StatefulWidget {
  const SanoView({
    Key? key,
    required this.id,
  }) : super(key: key);

  // 页面id
  final String id;

  @override
  State<SanoView> createState() => _SanoViewState();
}

class _SanoViewState extends State<SanoView> {
  // 通信通道88
  late final Channel _channel = Channel(widget.id);
  // 根节点
  RootElement? _root;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _channel
      ..invoke('unmount')
      ..dispose();

    super.dispose();
  }

  // 初始化
  void _init() {
    // 挂载页面
    _channel
      ..once('mount', _mount)
      ..on('update', _update)
      ..invoke('mount');
  }

  // 挂载
  JSObject? _mount(JSObject? args, JSFunction? callback) {
    final children = jsonDecode((args as JSString).value);
    // 创建根节点
    _root = RootElement(children, _channel);
    setState(() {});
    return null;
  }

  // 更新
  JSObject? _update(JSObject? args, JSFunction? callback) {
    final data = jsonDecode((args as JSString).value);

    for (String id in (data as Map).keys) {
      _root!.emit(id, data[id]);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _root?.widget,
    );
  }
}
