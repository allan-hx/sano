import 'dart:ffi';
import 'library.dart';

// js undefined指针
final undefined = library.newUndefined();

// js value size
final int jsValueSizeOf = library.jsValueSizeOf();

// 通道回调
typedef ChannelCallback = Pointer<JSValue> Function(
  Pointer<JSContext>,
  Pointer<JSValue>,
  Int32,
  Pointer<JSValue>,
);

// 通道方法
typedef Channel = NativeFunction<ChannelCallback>;

// 运行时
class JSRuntime extends Opaque {}

// 上下文
class JSContext extends Opaque {}

// js对象
class JSValue extends Struct {
  external JSValueUnion u;

  @Int64()
  external int tag;
}

class JSValueUnion extends Union {
  @Int32()
  external int int32;

  @Double()
  external double float64;

  external Pointer<Void> ptr;
}

// 执行模式
class JSEvalType {
  static const global = 0;

  static const module = 1;

  static const direct = 2;

  static const indirect = 3;

  static const mask = 3;
}

// js类型标签
class JSValueTag {
  static const first = -11;

  static const decimal = -11;

  static const bigInt = -10;

  static const bigFloat = -9;

  static const symbol = -8;

  static const string = -7;

  static const module = -3;

  static const bytecode = -2;

  static const object = -1;

  static const number = 0;

  static const bool = 1;

  static const nullptr = 2;

  static const undefined = 3;

  static const uninitialized = 4;

  static const catchOffset = 5;

  static const exception = 6;

  static const float64 = 7;
}

// js添加属性
class JSProp {
  static const configurable = 1;

  static const writable = 2;

  static const enumerable = 4;

  static const cwe = 7;

  static const length = 8;

  static const tmask = 48;

  static const normal = 0;

  static const getset = 16;

  static const varref = 32;

  static const autoinit = 48;

  static const hasShift = 8;

  static const hasConfigurable = 256;

  static const hasWritable = 512;

  static const hasEnumerable = 1024;

  static const hasGet = 2048;

  static const hasSet = 4096;

  static const hasValue = 8192;

  static const cast = 16384;

  static const throwStrict = 32768;

  static const noAdd = 65536;

  static const noExotic = 131072;
}
