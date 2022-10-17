import 'package:flutter/cupertino.dart';
import 'package:sano/sano.dart';

class Navigate extends Plugin {
  Navigate(BuildContext context)
      : navigator = Navigator.of(context, rootNavigator: true);

  // 导航
  final NavigatorState navigator;

  @override
  void onCreate(Sano sano) {
    sano.bridge.on('navigate:reLaunch', _reLaunch);
    sano.bridge.on('navigate:redirectTo', _redirectTo);
    sano.bridge.on('navigate:navigateTo', _navigateTo);
    sano.bridge.on('navigate:navigateBack', _navigateBack);
  }

  // 关闭所有页面, 并跳转到新页面
  JSObject? _reLaunch(JSObject? options, JSFunction? callback) {
    final url = options!['url'] as JSString;
    reLaunch(url.value);
    return null;
  }

  // 跳转新页面并且销毁当前页面
  JSObject? _redirectTo(JSObject? options, JSFunction? callback) {
    final url = options!['url'] as JSString;
    redirectTo(url.value);
    return null;
  }

  // 跳转新页面
  JSObject? _navigateTo(JSObject? options, JSFunction? callback) {
    final url = options!['url'] as JSString;
    navigateTo(url.value);
    return null;
  }

  // 关闭当前页面，或返回上一页面或多级页面
  JSObject? _navigateBack(JSObject? options, JSFunction? callback) {
    final delta = options!['url'] as JSInt;
    navigateBack(delta.value);
    return null;
  }

  void reLaunch(String url) {}

  void redirectTo(String url) {}

  void navigateTo(String url) {
    final page = CupertinoPageRoute(
      builder: (BuildContext context) => SanoView(url: url),
    );

    navigator.push(page);
  }

  void navigateBack(int delta) {}
}
