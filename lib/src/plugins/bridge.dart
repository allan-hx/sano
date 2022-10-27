import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:sano/sano.dart';

typedef Handler = JSObject? Function(JSObject? args, JSFunction? callback);

class Bridge extends Plugin {
  final Map<String, Handler> listeners = {};
  // js运行时上下文
  late Pointer<JSContext> context;
  // js通道函数
  late JSFunction channel;

  @override
  void onCreate(Sano sano) {
    context = sano.runtime.context;
    final callback = JSFunction.create(context, _channel);
    sano.runtime.global.setPropertyStr('__bridge__', callback);
  }

  // 通道函数
  JSObject _channel(JSString method, [JSObject? args, JSFunction? callback]) {
    final name = method.value;

    debugPrint('[bridge -> dart] $name');

    if (name == '__initialize__') {
      channel = callback as JSFunction;
      channel.dupValue();
      return JSUndefined();
    } else if (args is JSFunction && callback == null) {
      callback = args;
      args = null;
    }

    return _emit(name, args, callback);
  }

  // 调用dart方法
  JSObject _emit(String method, JSObject? args, JSFunction? callback) {
    if (listeners.containsKey(method)) {
      final handle = listeners[method]!;
      return handle(args, callback) ?? JSUndefined();
    }

    return JSUndefined();
  }

  // 调用js端
  T invoke<T extends JSObject>(String method, [JSObject? args]) {
    args ??= JSUndefined();

    // 调用js方法
    final name = JSString.create(context, method);
    final value = channel.call([name, args]) as T;

    if (library.isException(value.pointer) == 0) {
      return value;
    }

    // 获取异常
    final exception = library.getException(context);
    final exceptionData = library.jsToCString(context, exception);
    final message = exceptionData.cast<Utf8>().toDartString();

    library.freeCString(context, exceptionData);

    throw ('JS Runtime: $message');
  }

  // 监听
  void on(String method, Handler handle) {
    listeners[method] = handle;
  }

  // 移除监听
  void off(String method) {
    listeners.remove(method);
  }

  // 只执行一次
  void once(String method, Handler handle) {
    listeners[method] = (JSObject? args, JSFunction? callback) {
      listeners.remove(method);
      return handle(args, callback);
    };
  }
}
