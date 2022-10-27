import 'package:flutter/foundation.dart';

import 'js_value.dart';

class Observer {
  Observer._();

  static final instance = Observer._();

  final Map<String, Function> _listeners = {};

  // 订阅
  void on(String symbol, Function handle) {
    _listeners[symbol] = handle;
  }

  // 发布
  JSObject emit(String symbol, [List<JSObject>? args]) {
    if (_listeners.containsKey(symbol)) {
      final handle = _listeners[symbol]!;
      return Function.apply(handle, args ?? []) ?? JSUndefined();
    }

    return JSUndefined();
  }

  // 取消订阅
  void off(String symbol) {
    if (_listeners.containsKey(symbol)) {
      _listeners.remove(symbol);
    }
  }
}
