import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'js_value.dart';
import 'library.dart';
import 'typedef.dart';

class Common {
  Common._();

  // 转换为dart类型
  static T toDartValue<T>(JSObject value) {
    throw '';
  }

  // 转换为js类型
  static T toJSValue<T extends JSObject>(Object value) {
    throw '';
  }

  // 根据指针转换成js对象
  static JSObject fromJSValue(Pointer<JSContext> context, Pointer<JSValue> pointer) {
    switch (pointer.ref.tag) {
      case JSValueTag.number:
        return JSInt(context, pointer);
      case JSValueTag.float64:
        return JSFloat(context, pointer);
      case JSValueTag.bool:
        return JSBoolean(context, pointer);
      case JSValueTag.string:
        return JSString(context, pointer);
      case JSValueTag.undefined:
        return JSUndefined();
      case JSValueTag.nullptr:
        return JSNull();
    }

    if (library.isArray(context, pointer) == 1) {
      return JSArray(context, pointer);
    } else if (library.isFunction(context, pointer) == 1) {
      return JSFunction(context, pointer);
    } else if (library.isPromise(context, pointer) == 1) {
      return JSPromise(context, pointer);
    }

    return JSObject(context, pointer);
  }

  // 获取异常
  static String? getException(Pointer<JSContext> context) {
    final exception = library.getException(context);

    if (exception.ref.tag != JSValueTag.nullptr) {
      final pointer = library.jsToCString(context, exception);

      if (pointer.address != 0) {
        final message = pointer.cast<Utf8>().toDartString();
        library.freeCString(context, pointer);
        return message;
      }
    }

    return null;
  }

  // 转换参数
  static Pointer<JSValue> formatArgs(List<JSObject> args) {
    final size = args.length * jsValueSizeOf;
    final data = calloc<Pointer>(size).cast<JSValue>();

    for (int index = 0; index < args.length; index++) {
      library.setValueAt(data, index, args[index].pointer);
    }

    return data;
  }

  // 执行挂起任务
  static void executePendingJob(context) {
    final runtime = library.getRuntime(context);

    Future(() {
      while (true) {
        int err = library.executePendingJob(runtime);

        if (err <= 0) {
          if (err < 0) {
            final message = Common.getException(context);
            throw message ?? 'Dispatch Error';
          }

          break;
        }
      }
    });
  }
}
