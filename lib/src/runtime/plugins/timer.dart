/* 
 * @Author: Allan 
 * @Date: 2022-07-14 23:30:41 
 * @Describe: js定时器实现
 */

import 'dart:async';
import 'dart:ffi' as ffi;
import 'package:sano/src/runtime/index.dart';

// 解析时间
int _parseDuration(JSObject? time) {
  if (time is JSFloat) {
    return time.value.toInt();
  } else if (time is JSInt) {
    return time.value.toInt();
  } else {
    return 0;
  }
}

class Clock {
  const Clock({
    required this.timer,
    required this.callback,
  });

  // 计时器
  final Timer timer;
  // 回调
  final JSFunction callback;
}

abstract class Interval extends Plugin {
  // 回调函数
  final Map<int, Clock> clocks = {};
  // 上下文
  late ffi.Pointer<JSContext> context;

  // 创建
  JSInt createTimer(JSFunction callback, [JSObject? time]);

  // 清除
  void clear(JSObject? data) {
    // 获取id
    final id = _parseDuration(data);
    final clock = clocks[id];

    if (clock != null) {
      // 停止
      clock.timer.cancel();
      // 释放js函数
      clock.callback.free();
      // 移除
      clocks.remove(id);
    }
  }
}

// 定时器
class SetInterval extends Interval {
  late Runtime _runtime;

  @override
  void onCreate(Runtime runtime) {
    _runtime = runtime;
    final global = _runtime.global;
    context = _runtime.context;
    global.setPropertyStr(
        'setInterval', JSFunction.create(context, createTimer));
    global.setPropertyStr('clearInterval', JSFunction.create(context, clear));
  }

  @override
  JSInt createTimer(JSFunction callback, [JSObject? time]) {
    // 标记引用 - 需后续手动回收
    callback.dupValue();

    // 时间
    final duration = _parseDuration(time);
    // 定时器
    final timer = Timer.periodic(
      Duration(milliseconds: duration),
      (timer) {
        callback.call();
        _runtime.dispatch();
      },
    );
    // 定时器key - 唯一
    final int key = timer.hashCode;

    clocks[key] = Clock(timer: timer, callback: callback);

    return JSInt.create(context, key);
  }
}

// 计时器
class SetTimeout extends Interval {
  late Runtime _runtime;

  @override
  void onCreate(Runtime runtime) {
    _runtime = runtime;
    final global = _runtime.global;
    context = _runtime.context;
    global.setPropertyStr(
        'setTimeout', JSFunction.create(context, createTimer));
    global.setPropertyStr('clearTimeout', JSFunction.create(context, clear));
  }

  @override
  JSInt createTimer(JSFunction callback, [JSObject? time]) {
    // 标记引用 - 需后续手动回收
    callback.dupValue();
    // 定时器key - 唯一
    final int key = DateTime.now().microsecondsSinceEpoch;
    // 地址
    final JSInt id = JSInt.create(context, key);
    // 时间
    final duration = _parseDuration(time);
    // 定时器
    final timer = Timer(
      Duration(milliseconds: duration),
      () {
        callback.call();
        clearTimeout(id);
        _runtime.dispatch();
      },
    );

    clocks[key] = Clock(timer: timer, callback: callback);
    return id;
  }

  // 清除
  void clearTimeout(JSInt value) {
    clear(value);
  }
}
