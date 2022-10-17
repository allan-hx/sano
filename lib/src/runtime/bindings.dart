import 'dart:ffi';

import 'typedef.dart';

class QuickjsLibrary {
  QuickjsLibrary(DynamicLibrary lib) : lookup = lib.lookup;

  final Pointer<T> Function<T extends NativeType>(String name) lookup;

  // 设置通道
  late final setChannel = _setChannel
      .asFunction<void Function(Pointer<JSRuntime>, Pointer<Channel>)>();
  late final _setChannel = lookup<
          NativeFunction<Void Function(Pointer<JSRuntime>, Pointer<Channel>)>>(
      'SetChannel');

  // 创建运行时
  late final newRuntime =
      _newRuntime.asFunction<Pointer<JSRuntime> Function()>();
  late final _newRuntime =
      lookup<NativeFunction<Pointer<JSRuntime> Function()>>('JS_NewRuntime');

  // 创建上下文
  late final newContext =
      _newContext.asFunction<Pointer<JSContext> Function(Pointer<JSRuntime>)>();
  late final _newContext =
      lookup<NativeFunction<Pointer<JSContext> Function(Pointer<JSRuntime>)>>(
          'JS_NewContext');

  // 更新栈顶部
  late final updateStackTop = _updateStackTop
      .asFunction<Pointer<JSContext> Function(Pointer<JSRuntime>)>();
  late final _updateStackTop =
      lookup<NativeFunction<Pointer<JSContext> Function(Pointer<JSRuntime>)>>(
          'JS_UpdateStackTop');

  // 获取全局对象
  late final getGlobalObject = _getGlobalObject
      .asFunction<Pointer<JSValue> Function(Pointer<JSContext>)>();
  late final _getGlobalObject =
      lookup<NativeFunction<Pointer<JSValue> Function(Pointer<JSContext>)>>(
          'GetGlobalObject');

  // 创建上下文
  late final getRuntime =
      _getRuntime.asFunction<Pointer<JSRuntime> Function(Pointer<JSContext>)>();
  late final _getRuntime =
      lookup<NativeFunction<Pointer<JSRuntime> Function(Pointer<JSContext>)>>(
          'JS_GetRuntime');

  // 设置栈大小 JS_SetMaxStackSize
  late final setMaxStackSize =
      _setMaxStackSize.asFunction<void Function(Pointer<JSRuntime>, int)>();
  late final _setMaxStackSize =
      lookup<NativeFunction<Void Function(Pointer<JSRuntime>, Int32)>>(
          'JS_SetMaxStackSize');

  // 运行js代码
  late final evaluateJavaScript = _evaluateJavaScript.asFunction<
      Pointer<JSValue> Function(
          Pointer<JSContext>, Pointer<Char>, Pointer<Char>, int)>();
  late final _evaluateJavaScript = lookup<
      NativeFunction<
          Pointer<JSValue> Function(Pointer<JSContext>, Pointer<Char>,
              Pointer<Char>, Int32)>>('EvaluateJavaScript');

  // 判断是否异常
  late final isException =
      _isException.asFunction<int Function(Pointer<JSValue>)>();
  late final _isException =
      lookup<NativeFunction<Int32 Function(Pointer<JSValue>)>>('IsException');

  // 获取异常
  late final getException =
      _getException.asFunction<Pointer<JSValue> Function(Pointer<JSContext>)>();
  late final _getException =
      lookup<NativeFunction<Pointer<JSValue> Function(Pointer<JSContext>)>>(
          'GetException');

  // 释放js value
  late final freeValue = _freeValue
      .asFunction<void Function(Pointer<JSContext>, Pointer<JSValue>)>();
  late final _freeValue = lookup<
          NativeFunction<Void Function(Pointer<JSContext>, Pointer<JSValue>)>>(
      'JSFreeValue');

  // 获取js value内存大小
  late final jsValueSizeOf = _jsValueSizeOf.asFunction<int Function()>();
  late final _jsValueSizeOf =
      lookup<NativeFunction<Uint32 Function()>>('JSValueSizeOf');

  // 设置数据索引
  late final setValueAt = _setValueAt
      .asFunction<void Function(Pointer<JSValue>, int, Pointer<JSValue>)>();
  late final _setValueAt = lookup<
      NativeFunction<
          Void Function(
              Pointer<JSValue>, Uint32, Pointer<JSValue>)>>('SetValueAt');

  // 标记引用
  late final dupValue = _dupValue.asFunction<
      Pointer<JSValue> Function(Pointer<JSContext>, Pointer<JSValue>)>();
  late final _dupValue = lookup<
      NativeFunction<
          Pointer<JSValue> Function(
              Pointer<JSContext>, Pointer<JSValue>)>>('JSDupValue');

  // 释放c字符串
  late final freeCString = _freeCString
      .asFunction<void Function(Pointer<JSContext>, Pointer<Char>)>();
  late final _freeCString =
      lookup<NativeFunction<Void Function(Pointer<JSContext>, Pointer<Char>)>>(
          'JS_FreeCString');

  // 创建js对象
  late final newObject =
      _newObject.asFunction<Pointer<JSValue> Function(Pointer<JSContext>)>();
  late final _newObject =
      lookup<NativeFunction<Pointer<JSValue> Function(Pointer<JSContext>)>>(
          'NewObject');

  // 创建js string
  late final newString = _newString.asFunction<
      Pointer<JSValue> Function(Pointer<JSContext>, Pointer<Char>)>();
  late final _newString = lookup<
      NativeFunction<
          Pointer<JSValue> Function(
              Pointer<JSContext>, Pointer<Char>)>>('NewString');

  // 创建js int64
  late final newInt64 = _newInt64
      .asFunction<Pointer<JSValue> Function(Pointer<JSContext>, int)>();
  late final _newInt64 = lookup<
          NativeFunction<Pointer<JSValue> Function(Pointer<JSContext>, Int64)>>(
      'NewInt64');

  // 创建js float 64
  late final newFloat64 = _newFloat64
      .asFunction<Pointer<JSValue> Function(Pointer<JSContext>, double)>();
  late final _newFloat64 = lookup<
      NativeFunction<
          Pointer<JSValue> Function(Pointer<JSContext>, Double)>>('NewFloat64');

  // 创建js boolean
  late final newBool =
      _newBool.asFunction<Pointer<JSValue> Function(Pointer<JSContext>, int)>();
  late final _newBool = lookup<
          NativeFunction<Pointer<JSValue> Function(Pointer<JSContext>, Int32)>>(
      'NewBool');

  // 创建数组
  late final newArray =
      _newArray.asFunction<Pointer<JSValue> Function(Pointer<JSContext>)>();
  late final _newArray =
      lookup<NativeFunction<Pointer<JSValue> Function(Pointer<JSContext>)>>(
          'NewArray');

  // 创建js方法
  late final newCFunctionData = _newCFunctionData.asFunction<
      Pointer<JSValue> Function(Pointer<JSContext>, Pointer<Char>)>();
  late final _newCFunctionData = lookup<
      NativeFunction<
          Pointer<JSValue> Function(
              Pointer<JSContext>, Pointer<Char>)>>('NewCFunctionData');

  // 创建js undefined
  late final newUndefined =
      _newUndefined.asFunction<Pointer<JSValue> Function()>();
  late final _newUndefined =
      lookup<NativeFunction<Pointer<JSValue> Function()>>('NewUndefined');

  // 创建promise
  late final newPromiseCapability = _newPromiseCapability.asFunction<
      Pointer<JSValue> Function(Pointer<JSContext>, Pointer<JSValue>)>();
  late final _newPromiseCapability = lookup<
      NativeFunction<
          Pointer<JSValue> Function(
              Pointer<JSContext>, Pointer<JSValue>)>>('NewPromiseCapability');

  // js value转 string
  late final jsToCString = _jsToCString.asFunction<
      Pointer<Char> Function(Pointer<JSContext>, Pointer<JSValue>)>();
  late final _jsToCString = lookup<
      NativeFunction<
          Pointer<Char> Function(
              Pointer<JSContext>, Pointer<JSValue>)>>('JSToCString');

  // js转int
  late final toInt64 =
      _toInt64.asFunction<int Function(Pointer<JSContext>, Pointer<JSValue>)>();
  late final _toInt64 = lookup<
          NativeFunction<Int64 Function(Pointer<JSContext>, Pointer<JSValue>)>>(
      'JSToInt64');

  // js转double
  late final toFloat64 = _toFloat64
      .asFunction<double Function(Pointer<JSContext>, Pointer<JSValue>)>();
  late final _toFloat64 = lookup<
      NativeFunction<
          Double Function(
              Pointer<JSContext>, Pointer<JSValue>)>>('JSToFloat64');

  // js转bool
  late final toBool =
      _toBool.asFunction<int Function(Pointer<JSContext>, Pointer<JSValue>)>();
  late final _toBool = lookup<
          NativeFunction<Int32 Function(Pointer<JSContext>, Pointer<JSValue>)>>(
      'JSToBool');

  // 添加属性 - key为string
  late final setPropertyStr = _setPropertyStr.asFunction<
      int Function(Pointer<JSContext>, Pointer<JSValue>, Pointer<Char>,
          Pointer<JSValue>)>();
  late final _setPropertyStr = lookup<
      NativeFunction<
          Int32 Function(Pointer<JSContext>, Pointer<JSValue>, Pointer<Char>,
              Pointer<JSValue>)>>('SetPropertyStr');

  // 添加属性 - key为js value
  late final setProperty = _setProperty.asFunction<
      int Function(Pointer<JSContext>, Pointer<JSValue>, Pointer<JSValue>,
          Pointer<JSValue>, int)>();
  late final _setProperty = lookup<
      NativeFunction<
          Int32 Function(Pointer<JSContext>, Pointer<JSValue>, Pointer<JSValue>,
              Pointer<JSValue>, Int)>>('SetProperty');

  // 数组设置属性
  late final definePropertyValueUint32 = _definePropertyValueUint32.asFunction<
      int Function(
          Pointer<JSContext>, Pointer<JSValue>, int, Pointer<JSValue>, int)>();
  late final _definePropertyValueUint32 = lookup<
      NativeFunction<
          Int Function(Pointer<JSContext>, Pointer<JSValue>, Uint32,
              Pointer<JSValue>, Int32)>>('DefinePropertyValueUint32');

  // 读取属性 - key为js value
  late final getProperty = _getProperty.asFunction<
      Pointer<JSValue> Function(
          Pointer<JSContext>, Pointer<JSValue>, Pointer<JSValue>)>();
  late final _getProperty = lookup<
      NativeFunction<
          Pointer<JSValue> Function(Pointer<JSContext>, Pointer<JSValue>,
              Pointer<JSValue>)>>('GetProperty');

  // 读取属性 - key为string
  late final getPropertyStr = _getPropertyStr.asFunction<
      Pointer<JSValue> Function(
          Pointer<JSContext>, Pointer<JSValue>, Pointer<Char>)>();
  late final _getPropertyStr = lookup<
      NativeFunction<
          Pointer<JSValue> Function(Pointer<JSContext>, Pointer<JSValue>,
              Pointer<Char>)>>('GetPropertyStr');

  // 是否是数组
  late final isArray =
      _isArray.asFunction<int Function(Pointer<JSContext>, Pointer<JSValue>)>();
  late final _isArray = lookup<
          NativeFunction<Int32 Function(Pointer<JSContext>, Pointer<JSValue>)>>(
      'IsArray');

  // 是否是函数
  late final isFunction = _isFunction
      .asFunction<int Function(Pointer<JSContext>, Pointer<JSValue>)>();
  late final _isFunction = lookup<
          NativeFunction<Int32 Function(Pointer<JSContext>, Pointer<JSValue>)>>(
      'IsFunction');

  // 是否是函数
  late final isPromise = _isPromise
      .asFunction<int Function(Pointer<JSContext>, Pointer<JSValue>)>();
  late final _isPromise = lookup<
          NativeFunction<Int32 Function(Pointer<JSContext>, Pointer<JSValue>)>>(
      'IsPromise');

  // 执行js方法
  late final callFuncton = _callFuncton.asFunction<
      Pointer<JSValue> Function(Pointer<JSContext>, Pointer<JSValue>,
          Pointer<JSValue>, int, Pointer<JSValue>)>();
  late final _callFuncton = lookup<
      NativeFunction<
          Pointer<JSValue> Function(Pointer<JSContext>, Pointer<JSValue>,
              Pointer<JSValue>, Int32, Pointer<JSValue>)>>('CallFuncton');

  // 执行挂起任务
  late final executePendingJob =
      _executePendingJob.asFunction<int Function(Pointer<JSRuntime>)>();
  late final _executePendingJob =
      lookup<NativeFunction<Int32 Function(Pointer<JSRuntime>)>>(
          'ExecutePendingJob');
}
