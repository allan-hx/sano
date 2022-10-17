import 'dart:ffi';
import 'bindings.dart';

final library = QuickjsLibrary(DynamicLibrary.open('libquickjs.so'));
