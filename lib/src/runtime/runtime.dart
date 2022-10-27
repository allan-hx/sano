import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'common.dart';
import 'js_value.dart';
import 'library.dart';
import 'observer.dart';
import 'plugin.dart';
import 'plugins/println.dart';
import 'plugins/timer.dart';
import 'typedef.dart';

class Runtime {
  Runtime({
    int? maxStackSize,
    List<Plugin>? plugins,
  }) {
    _init(
      maxStackSize: maxStackSize,
      plugins: plugins,
    );
  }

  // 运行环境
  final Pointer<JSRuntime> runtime = library.newRuntime();

  // 上下文
  late Pointer<JSContext> _context;
  Pointer<JSContext> get context => _context;

  // js全局对象
  late JSObject _global;
  JSObject get global => _global;

  static Pointer<JSValue> _channel(
    Pointer<JSContext> context,
    Pointer<JSValue> symbol,
    int argc,
    Pointer<JSValue> argv,
  ) {
    // 方法标识
    final name = JSString(context, symbol);
    // 参数
    final List<JSObject> args = List.generate(argc, (index) {
      final ptr = argv.address + (jsValueSizeOf * index);
      final value = Pointer.fromAddress(ptr);
      return Common.fromJSValue(context, value.cast<JSValue>());
    });

    Observer.instance.emit(name.value, args);

    return undefined;
  }

  // 初始化
  void _init({
    int? maxStackSize,
    List<Plugin>? plugins,
  }) {
    // 设置执行栈大小
    if (maxStackSize != null) {
      setStackSize(maxStackSize);
    }

    library.updateStackTop(runtime);
    // 创建上下文
    _context = library.newContext(runtime);
    // 获取全局对象
    _global = JSObject(_context, library.getGlobalObject(_context));
    // 设置通道方法
    library.setChannel(
      runtime,
      Pointer.fromFunction<ChannelCallback>(_channel),
    );

    // 加载插件
    loadPlugins(plugins);
  }

  // 执行js
  JSObject evaluateJavaScript(
    // js code
    String script,
    // 文件名
    String fileName, [
    // 运行模式
    int mode = JSEvalType.global,
  ]) {
    final scriptPointer = script.toNativeUtf8().cast<Char>();
    final namePointer = fileName.toNativeUtf8().cast<Char>();
    // 运行code
    final value = library.evaluateJavaScript(
      _context,
      scriptPointer,
      namePointer,
      mode,
    );

    // 释放
    malloc.free(scriptPointer);
    malloc.free(namePointer);

    if (library.isException(value) == 0) {
      dispatch();
      return Common.fromJSValue(context, value);
    }

    final message = Common.getException(_context);

    throw '$fileName执行异常:$message';
  }

  // 开启事件循环
  void dispatch() {
    Common.executePendingJob(context);
  }

  // 设置最大执行栈
  void setStackSize(int stackSize) {
    library.setMaxStackSize(runtime, stackSize);
  }

  // 加载插件列表
  void loadPlugins(List<Plugin>? plugins) {
    plugins = [...?plugins, Println(), SetInterval(), SetTimeout()];

    for (Plugin item in plugins) {
      use(item);
    }
  }

  // 加载插件
  void use(Plugin plugin) {
    plugin.onCreate(this);
  }
}
