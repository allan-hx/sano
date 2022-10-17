import 'package:flutter/foundation.dart';
import 'package:sano/src/runtime/index.dart';

class Println extends Plugin {
  @override
  void onCreate(Runtime runtime) {
    final value = JSFunction.create(runtime.context, println);
    runtime.global.setPropertyStr('_println_', value);
  }

  void println(JSString type, JSArray args) {
    if (args.length > 0) {
      final tag = type.toString();
      final message = args.toString();

      if (kDebugMode) {
        print("console/$tag: $message");
      }
    }
  }
}
