import 'package:flutter/cupertino.dart';
import 'package:sano/sano.dart';

class Navigate extends Plugin {
  Navigate(BuildContext context)
      : navigator = Navigator.of(context, rootNavigator: true),
        channel = Channel('navigate');

  // 导航
  final NavigatorState navigator;
  // 通道
  final Channel channel;

  @override
  void onCreate(Sano sano) {
    // 打开页面
    channel.on('push', _push);
  }

  // 打开页面
  JSObject? _push(JSObject? args, JSFunction? callback) {
    final id = (args as JSString).value;
    final page = CupertinoPageRoute(
      builder: (BuildContext context) => SanoView(id: id),
    );

    navigator.push(page);
    return null;
  }
}
