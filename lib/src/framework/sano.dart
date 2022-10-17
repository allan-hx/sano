import 'package:flutter/widgets.dart';
import 'package:sano/src/plugins/index.dart';
import 'package:sano/src/runtime/index.dart' hide Plugin;

import 'bundle.dart';
import 'plugin.dart';

class Sano {
  Sano._({
    required this.bundle,
    required this.navigator,
    required this.bridge,
    required this.runtime,
  });

  // 单例
  static Sano? _instance;
  static Sano get instance => _instance!;

  // 初始化
  static Future<void> initInstance({
    // 资源包
    required Bundle bundle,
    // 构建上下文
    required BuildContext context,
    // 资源下载进度
    void Function(int, int)? onProgress,
    // 插件
    List<Plugin>? plugins,
    // js栈大小
    int stackSize = 1024 * 1024,
  }) async {
    assert(_instance == null, 'Sano: init重复调用');

    // 加载资源包
    await bundle.resolve();

    // 导航插件
    // ignore: use_build_context_synchronously
    final navigator = Navigate(context);
    // 通信
    final bridge = Bridge();
    // 合并内置插件
    plugins = [
      ...?plugins,
      // 导航插件
      navigator,
      // 通信
      bridge,
    ];
    // 创建单例
    _instance = Sano._(
      bundle: bundle,
      navigator: navigator,
      bridge: bridge,
      runtime: Runtime(maxStackSize: stackSize),
    );

    // 加载插件
    _instance!._loadPlugins(plugins);
    // 执行入口
    _instance!._runApp();
  }

  // 资源包
  final Bundle bundle;
  // 导航
  final Navigate navigator;
  // 通信
  final Bridge bridge;
  // js运行时
  final Runtime runtime;

  // 加载插件
  void _loadPlugins(List<Plugin> plugins) {
    for (var plugin in plugins) {
      use(plugin);
    }
  }

  // 运行app
  Future<void> _runApp() async {
    final Runtime runtime = _instance!.runtime;
    // 读取入口
    final script = await bundle.read('app.js');
    // 逻辑层入口
    runtime.evaluateJavaScript(script, 'app.js');
  }

  // 加载插件
  void use(Plugin plugin) {
    plugin.onCreate(this);
  }
}
