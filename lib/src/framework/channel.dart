import 'package:sano/sano.dart';
import 'package:sano/src/plugins/index.dart';

class Channel {
  Channel(String name): name = 'sano:channel:$name:';

  // 通道名称
  final String name;

  // 获取方法名称
  String _getMethod(String method) => '$name$method';

  // 调用js端
  T invoke<T extends JSObject>(String method, [JSObject? args]) {
    return Sano.instance.bridge.invoke(_getMethod(method), args);
  }

  // 监听js方法
  void on(String method, Handler handle) {
    Sano.instance.bridge.on(_getMethod(method), handle);
  }

  // 只执行一次
  void once(String method, Handler handle) {
    Sano.instance.bridge.once(_getMethod(method), handle);
  }

  // 销毁
  void dispose() {
    final listeners = Sano.instance.bridge.listeners;

    for (String item in listeners.keys.toList()) {
      if (item.indexOf(name) == 0) {
        listeners.remove(item);
      }
    }
  }
}
