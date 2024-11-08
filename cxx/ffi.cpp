#include "quickjs/quickjs.h"
#include <string.h>
#include "ffi.h"

// 通道
static JSValue _channel(JSContext *ctx, JSValueConst this_val, int32_t argc, JSValueConst *argv, int32_t magic, JSValue *method){
  JSRuntime *runtime = JS_GetRuntime(ctx);
  CHANNEL *channel = (CHANNEL *)JS_GetRuntimeOpaque(runtime);
  return *channel(ctx, method, argc, argv);
}

extern "C" {
  DART_EXPORT void SetChannel(JSRuntime *runtime, CHANNEL channel) {
    JS_SetRuntimeOpaque(runtime, (void *)channel);
  }

  DART_EXPORT JSValue *GetGlobalObject(JSContext *ctx) {
    return new JSValue(JS_GetGlobalObject(ctx));
  }

  DART_EXPORT JSValue *EvaluateJavaScript(JSContext *ctx, const char *script, const char *fileName, int32_t flags) {
    JSRuntime *runtime = JS_GetRuntime(ctx);
    JS_UpdateStackTop(runtime);
    JSValue value = JS_Eval(ctx, script, strlen(script), fileName, flags);
    return new JSValue(value);
  }

  DART_EXPORT int32_t IsException(JSValueConst *value) {
    return JS_IsException(*value);
  }

  DART_EXPORT JSValue *GetException(JSContext *ctx) {
    return new JSValue(JS_GetException(ctx));
  }

  DART_EXPORT void JSFreeValue(JSContext *ctx, JSValue *value) {
    JS_FreeValue(ctx, *value);
  }

  DART_EXPORT uint32_t JSValueSizeOf() {
    return sizeof(JSValue);
  }

  DART_EXPORT void SetValueAt(JSValue *data, uint32_t index, JSValue *value) {
    data[index] = *value;
  }

  DART_EXPORT JSValue *JSDupValue(JSContext *ctx, JSValueConst *value) {
    return new JSValue(JS_DupValue(ctx, *value));
  }

  DART_EXPORT JSValue *NewObject(JSContext  *ctx) {
    return new JSValue(JS_NewObject(ctx));
  }

  DART_EXPORT JSValue *NewString(JSContext *ctx, const char *data) {
    return new JSValue(JS_NewString(ctx, data));
  }

  DART_EXPORT JSValue *NewInt64(JSContext *ctx, int64_t value) {
    return new JSValue(JS_NewInt64(ctx, value));
  }

  DART_EXPORT JSValue *NewFloat64(JSContext *ctx, double value) {
    return new JSValue(JS_NewFloat64(ctx, value));
  }

  DART_EXPORT JSValue *NewBool(JSContext *ctx, int32_t value) {
    return new JSValue(JS_NewBool(ctx, value));
  }

  DART_EXPORT JSValue *NewArray(JSContext *ctx) {
    return new JSValue(JS_NewArray(ctx));
  }

  DART_EXPORT JSValue *NewCFunctionData(JSContext *ctx, const char *symbol) {
    JSValue value = JS_NewCFunctionData(ctx, _channel, 0, 0, 1, new JSValue(JS_NewString(ctx, symbol)));
    return new JSValue(value);
  }

  DART_EXPORT JSValue *NewUndefined() {
    return new JSValue(JS_UNDEFINED);
  }

  DART_EXPORT JSValue *NewPromiseCapability(JSContext *ctx, JSValue *resolving_funcs) {
    return new JSValue(JS_NewPromiseCapability(ctx, resolving_funcs));
  }

  DART_EXPORT const char *JSToCString(JSContext *ctx, JSValueConst *value) {
    JSRuntime *runtime = JS_GetRuntime(ctx);
    JS_UpdateStackTop(runtime);
    return JS_ToCString(ctx, *value);
  }

  DART_EXPORT JSValue *JSToString(JSContext *ctx, JSValueConst *value) {
    return new JSValue(JS_ToString(ctx, *value));
  }

  DART_EXPORT int64_t JSToInt64(JSContext *ctx, JSValueConst *value) {
    int64_t data;
    JS_ToInt64(ctx, &data, *value);
    return data;
  }

  DART_EXPORT double JSToFloat64(JSContext *ctx, JSValueConst *value) {
    double data;
    JS_ToFloat64(ctx, &data, *value);
    return data;
  }

  DART_EXPORT int32_t JSToBool(JSContext *ctx, JSValueConst *value) {
    return JS_ToBool(ctx, *value);
  }

  DART_EXPORT int32_t SetPropertyStr(JSContext *ctx, JSValueConst *obj, const char *key, JSValue *value) {
    return JS_SetPropertyStr(ctx, *obj, key, *value);
  }

  DART_EXPORT int32_t SetProperty(JSContext *ctx, JSValueConst *obj, JSValueConst *key, JSValueConst *value, int flags) {
    JSAtom atom = JS_ValueToAtom(ctx, *key);
    JSValue extra_prop_value = JS_DupValue(ctx, *value);
    int32_t ret = JS_SetPropertyInternal(ctx, *obj, atom, extra_prop_value, flags);
    JS_FreeAtom(ctx, atom);
    return ret;
  }

  DART_EXPORT int DefinePropertyValueUint32(JSContext *ctx, JSValueConst *obj, uint32_t index, JSValue *value, int32_t flags) {
    return JS_DefinePropertyValueUint32(ctx, *obj, index, *value, flags);
  }

  DART_EXPORT JSValue *GetProperty(JSContext *ctx, JSValueConst *obj, JSValueConst *key) {
    JSAtom atom = JS_ValueToAtom(ctx, *key);
    JSValue *value = new JSValue(JS_GetProperty(ctx, *obj, atom));
    JS_FreeAtom(ctx, atom);
    return value;
  }

  JSValue *GetPropertyStr(JSContext *ctx, JSValueConst *obj, const char *prop) {
    return new JSValue(JS_GetPropertyStr(ctx, *obj, prop));
  }

  DART_EXPORT int32_t IsArray(JSContext *ctx, JSValueConst *value) {
    return JS_IsArray(ctx, *value);
  }

  DART_EXPORT int32_t IsFunction(JSContext *ctx, JSValueConst *value) {
    return JS_IsFunction(ctx, *value);
  }

  DART_EXPORT int32_t IsPromise(JSContext *ctx, JSValueConst *value) {
    return JS_IsPromise(ctx, *value);
  }

  DART_EXPORT JSValue *CallFuncton(JSContext *ctx, JSValueConst *func_obj, JSValueConst *this_obj, int32_t argc, JSValueConst *argv) {
    return new JSValue(JS_Call(ctx, *func_obj, *this_obj, argc, argv));
  }

  DART_EXPORT int32_t ExecutePendingJob(JSRuntime *runtime) {
    JSContext *ctx;
    int ret = JS_ExecutePendingJob(runtime, &ctx);
    return ret;
  }
}
