import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'common.dart';
import 'library.dart';
import 'observer.dart';
import 'typedef.dart';

class JSObject {
  JSObject(this.context, this._pointer);

  factory JSObject.create(Pointer<JSContext> context) {
    final pointer = library.newObject(context);
    return JSObject(context, pointer);
  }

  // 上下文
  final Pointer<JSContext> context;

  // 引用
  Pointer<JSValue> _pointer;
  Pointer<JSValue> get pointer => _pointer;

  // 获取类型tag
  int get tag => _pointer.ref.tag;

  // 获取dart数据
  Object? get value => toString();

  // 添加属性 - key为js value
  bool setProperty(JSObject key, JSObject value) {
    final state = library.setProperty(
      context,
      pointer,
      key.pointer,
      value.pointer,
      JSProp.cast,
    );

    return state == 1;
  }

  // 添加属性 - key为string
  bool setPropertyStr(String key, JSObject value) {
    final keyPointer = key.toNativeUtf8().cast<Char>();

    final state = library.setPropertyStr(
      context,
      pointer,
      keyPointer,
      value.pointer,
    );

    malloc.free(keyPointer);

    if (state == 1 && value is JSFunction) {
      final String symbol = value.callback.hashCode.toString();
      Observer.instance.on(symbol, value.callback!);
      return true;
    }

    return false;
  }

  // 读取属性操作符
  JSObject? operator [](Object key) {
    if (key is JSObject) {
      return getProperty(key);
    }

    return getPropertyStr(key.toString());
  }

  // 获取属性 - key为string
  T getPropertyStr<T extends JSObject>(String key) {
    final keyPointer = key.toNativeUtf8().cast<Char>();
    final data = library.getPropertyStr(context, pointer, keyPointer);
    malloc.free(keyPointer);
    return Common.fromJSValue(context, data) as T;
  }

  // 获取属性 - key为js value
  T getProperty<T extends JSObject>(JSObject key) {
    final data = library.getProperty(context, pointer, key.pointer);
    return Common.fromJSValue(context, data) as T;
  }

  // 释放
  void free() {
    Future(() {
      library.freeValue(context, pointer);
    });
  }

  // 引用标记
  void dupValue() {
    _pointer = library.dupValue(context, pointer);
  }

  @override
  String toString() {
    final value = library.jsToCString(context, pointer);
    final data = value.cast<Utf8>().toDartString();

    library.freeCString(context, value);

    return data;
  }
}

class JSString extends JSObject {
  JSString(super.context, super.pointer);

  factory JSString.create(Pointer<JSContext> context, String value) {
    final pointer = value.toNativeUtf8().cast<Char>();
    final data = library.newString(context, pointer);

    malloc.free(pointer);

    return JSString(context, data);
  }

  @override
  String get value => super.toString();
}

class JSInt extends JSObject {
  JSInt(super.context, super.pointer);

  factory JSInt.create(Pointer<JSContext> context, int value) {
    final pointer = library.newInt64(context, value);
    return JSInt(context, pointer);
  }

  @override
  int get value => library.toInt64(context, pointer);
}

class JSFloat extends JSObject {
  JSFloat(super.context, super.pointer);

  factory JSFloat.create(Pointer<JSContext> context, double value) {
    final pointer = library.newFloat64(context, value);
    return JSFloat(context, pointer);
  }

  @override
  double get value => library.toFloat64(context, pointer);
}

class JSBoolean extends JSObject {
  JSBoolean(super.context, super.pointer);

  factory JSBoolean.create(Pointer<JSContext> context, bool value) {
    final pointer = library.newBool(context, value ? 1 : 0);
    return JSBoolean(context, pointer);
  }

  @override
  bool get value => library.toBool(context, pointer) == 1;
}

class JSArray extends JSObject {
  JSArray(super.context, super.pointer);

  factory JSArray.create(Pointer<JSContext> context) {
    final pointer = library.newArray(context);
    return JSArray(context, pointer);
  }

  @override
  List<JSObject> get value {
    return List.generate(length, (int value) => index(value));
  }

  // 数组长度
  int get length {
    final data = getPropertyStr<JSInt>('length');
    return data.value;
  }

  // 根据下标获取
  T index<T extends JSObject>(int index) {
    final key = JSInt.create(context, index);
    key.free();
    return getProperty<T>(key);
  }

  // 添加
  bool push(JSObject value) => set(length, value);

  // 设置和修改
  bool set(int index, JSObject value) {
    final state = library.definePropertyValueUint32(
      context,
      pointer,
      index,
      value.pointer,
      JSProp.cwe,
    );

    return state == 1;
  }
}

class JSFunction extends JSObject {
  JSFunction(
    super.context,
    super.pointer, {
    this.callback,
  });

  factory JSFunction.create(Pointer<JSContext> context, Function callback) {
    final symbol = callback.hashCode.toString().toNativeUtf8().cast<Char>();
    final pointer = library.newCFunctionData(context, symbol);

    // 释放
    malloc.free(symbol);

    return JSFunction(context, pointer, callback: callback);
  }

  // 回调
  final Function? callback;

  JSObject call([List<JSObject>? args, JSObject? self]) {
    final value = library.callFuncton(
      context,
      pointer,
      self?.pointer ?? undefined,
      args?.length ?? 0,
      args == null ? undefined : Common.formatArgs(args),
    );

    if (library.isException(value) == 0) {
      return Common.fromJSValue(context, value);
    }

    final message = Common.getException(context);

    throw '函数调用执行异常:$message';
  }

  @override
  void free() {
    if (callback != null) {
      final symbol = callback.hashCode.toString();
      Observer.instance.off(symbol);
    }

    super.free();
  }
}

class JSUndefined extends JSObject {
  JSUndefined() : super(nullptr, undefined);

  @override
  dynamic get value => null;

  @override
  String toString() => 'undefined';
}

class JSNull extends JSObject {
  JSNull() : super(nullptr, nullptr);

  @override
  dynamic get value => null;

  @override
  String toString() => 'null';
}

class JSPromise extends JSObject {
  JSPromise(
    super.context,
    super.pointer, {
    this.resolvePointer,
    this.rejectPointer,
  });

  factory JSPromise.create(Pointer<JSContext> context) {
    final resolve = malloc<Uint8>(jsValueSizeOf * 2).cast<JSValue>();
    final resject =
        Pointer<JSValue>.fromAddress(resolve.address + jsValueSizeOf);
    final pointer = library.newPromiseCapability(context, resolve);

    return JSPromise(
      context,
      pointer,
      resolvePointer: resolve,
      rejectPointer: resject,
    );
  }

  // js resolve方法
  final Pointer<JSValue>? resolvePointer;
  // js reject方法
  final Pointer<JSValue>? rejectPointer;

  void resolve([JSObject? value]) {
    final func = JSFunction(context, resolvePointer!);
    func.call(value == null ? null : [value]).free();
    Common.executePendingJob(context);
  }

  void reject([JSObject? value]) {
    final func = JSFunction(context, rejectPointer!);
    func.call(value == null ? null : [value]).free();
    Common.executePendingJob(context);
  }
}
